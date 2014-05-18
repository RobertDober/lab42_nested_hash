require 'forwarder'

require_relative './nhash/class_methods'

require_relative './nhash/exceptions'
require_relative './nhash/invocation'
require_relative './nhash/affixes'
require_relative './nhash/fallbacks'
require_relative './nhash/lookup_chains'
require_relative './nhash/interpolation'
require_relative './nhash/enum'

module Lab42
  class NHash

    extend Forwarder
    forward :pop_binding, to: :@binding_stack, as: :pop
    forward :push_binding, to: :@binding_stack, as: :push

    attr_reader :hashy

    def export_options
      { indifferent_access: @indifferent_access,
        binding_stack: @binding_stack.dup,
        default_binding: @default_binding
      }
    end

    def get keyexpr, *default, &defblock
      keys = keyexpr.to_s.split( '.' )
      keys = complete_keys keys.reject(&:empty?), use_prefix: keys.first.empty?, use_suffix: keyexpr[-1] == '.'
      found = @indifferent_access ? _get_indiff( keys ) : _get( keys )
      self.class.from_value found, export_options
    rescue KeyError => k
      return fallback keyexpr, k if default.empty? && defblock.nil?
      default.empty? ? defblock.(keyexpr) : default.first
    end
    alias_method :fetch, :get

    def import_options options
      @indifferent_access = options[:indifferent_access]
      @binding_stack      = options[:binding_stack] || []
      @default_binding    = options[:default_binding] # if options[:default_binding]
      self
    end

    def with_indifferent_access
      self.class.new( @hashy ).import_options indifferent_access: true
    end

    private
    def complete_keys keys, use_prefix: false, use_suffix: false
      keys =  current_prefix + keys if use_prefix
      keys += current_suffix if use_suffix
      keys
    end

    # TODO: This is inefficent, either cache it or split on pushing onto stack
    def _get keys
      keys.inject hashy do | partial_hash, key_element |
        raise KeyError, keys.join('.') unless Hash === partial_hash
        partial_hash.fetch key_element
      end
    end

    def _get_indiff keys
      keys.inject hashy do | partial_hash, key_element |
        raise KeyError, keys.join('.') unless Hash === partial_hash
        partial_hash.fetch( key_element ){ partial_hash.fetch key_element.to_sym }
      end
    end

    def initialize hashy
      @hashy = hashy
      init_options
    end

    def init_options
      @indifferent_access       = false
      @suffix_stack             = []
      @prefix_stack             = []
      @binding_stack            = []

      @fallbacks                = []
      @current_fallback_pointer = 0
      @default_binding          = nil
    end
  end # class NHash
end # module Lab42
