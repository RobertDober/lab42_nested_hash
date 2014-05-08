require 'forwarder'
require_relative './nhash/exceptions'

module Lab42
  class NHash

    extend Forwarder
    forward :pop_prefix, to: :@prefix_stack, as: :pop
    forward :pop_suffix, to: :@suffix_stack, as: :pop
    forward :push_prefix, to: :@prefix_stack, as: :push
    forward :push_suffix, to: :@suffix_stack, as: :push

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
    rescue KeyError
      raise if default.empty? && defblock.nil?
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

    def with_prefix pfx, &blk
      push_prefix pfx
      blk.( self )
    ensure
      pop_prefix
    end

    private
    def complete_keys keys, use_prefix: false, use_suffix: false
      keys =  current_prefix + keys.drop( 1 ) if use_prefix
      keys += current_suffix if use_suffix
      keys
    end

    # TODO: This is inefficent, either cache it or split on pushing onto stack
    def current_prefix
      @prefix_stack
        .fetch( -1 ){ raise IllegalStateError, "prefix stack is empty" }
        .split( '.' )
    end
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
      @indifferent_access = false
      @suffix_stack       = []
      @prefix_stack       = []
      @failure_handlers   = []
    end
  end # class NHash
end # module Lab42
