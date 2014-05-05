module Lab42
  class NHash
    attr_reader :hashy
    def get keyexpr
      keys = keyexpr.to_s.split( '.' )
      found = @indifferent_access ? _get_indiff( keys ) : _get( keys )
      case found
      when Hash
        self.class.new( found ).import_options export_options
      else
        found
      end
    end

    def import_options options
      @indifferent_access = options[:indifferent_access]
      self
    end

    def with_indifferent_access
      self.class.new( @hashy ).import_options indifferent_access: true
    end
    private
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
