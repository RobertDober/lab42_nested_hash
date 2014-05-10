require_relative './nhash/exceptions'
require_relative './nhash/invocation'
require_relative './nhash/affixes'
require_relative './nhash/fallbacks'

module Lab42
  class NHash

    attr_reader :hashy

    def get keyexpr, *default, &defblock
      keys = keyexpr.to_s.split( '.' )
      keys = complete_keys keys.reject(&:empty?), use_prefix: keys.first.empty?, use_suffix: keyexpr[-1] == '.'
      found = @indifferent_access ? _get_indiff( keys ) : _get( keys )
      case found
      when Hash
        self.class.new( found ).import_options export_options
      else
        found
      end
    rescue KeyError => k
      return fallback keyexpr, k if default.empty? && defblock.nil?
      default.empty? ? defblock.(keyexpr) : default.first
    end
    alias_method :fetch, :get

    def import_options options
      @indifferent_access = options[:indifferent_access]
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
    def export_options
      { indifferent_access: @indifferent_access }
    end

    def initialize hashy
      @hashy = hashy
      init_options
    end

    def init_options
      @indifferent_access   = false
      @suffix_stack         = []
      @prefix_stack         = []
      @fallbacks            = []
      @fallback_params      = []
      @fallback_invocations = Hash.new{ |h, k| h[k] = {} }
    end
  end # class NHash
end # module Lab42
