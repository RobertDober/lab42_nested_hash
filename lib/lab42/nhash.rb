require 'forwarder'

require_relative './nhash/class_methods'

require_relative './nhash/exceptions'
require_relative './nhash/invocation'
require_relative './nhash/affixes'
require_relative './nhash/fallbacks'
require_relative './nhash/lookup_chains'
require_relative './nhash/interpolation'
require_relative './nhash/enum'
require_relative './nhash/hierarchies'

module Lab42
  class NHash

    extend Forwarder
    forward :pop_binding, to: :@binding_stack, as: :pop
    forward :push_binding, to: :@binding_stack, as: :push

    attr_reader :hashy, :parent

    def export_options
      { indifferent_access: @indifferent_access,
        binding_stack: @binding_stack.dup,
        parent: @parent
      }
    end

    def get keyexpr, *default, &defblock
      keys = keyexpr.to_s.split( '.' )
      keys = complete_keys keys.reject(&:empty?), use_prefix: keys.first.empty?, use_suffix: keyexpr[-1] == '.'
      found = @indifferent_access ? _get_indiff( keys ) : _get( keys )
      self.class.from_value found, export_options
    rescue KeyError => k
      return fallback_or_hierarchy keyexpr, k if default.empty? && defblock.nil?
      default.empty? ? defblock.(keyexpr) : default.first
    end
    alias_method :fetch, :get

    def fallback_or_hierarchy keyexpr, keyexc
      fallback keyexpr, keyexc
    rescue KeyError => k
      get_form_hierarchies keyexpr, k
    end

    def import_options options
      @indifferent_access = options[:indifferent_access]
      @binding_stack      = options[:binding_stack] || []
      @parent             = options[:parent]
      self
    end

    def with_indifferent_access
      self.class.new( @hashy ).tap do |rv|
        rv.instance_variable_set :@indifferent_access, true
      end
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

    def initialize hashy={}
      @hashy  = hashy
      init_options
    end

    def init_options
      @parent = self

      @indifferent_access       = false
      @suffix_stack             = []
      @prefix_stack             = []
      @binding_stack            = []

      @fallbacks                = []
      @current_fallback_pointer = 0

      @hierarchies              = []
    end
  end # class NHash
end # module Lab42
