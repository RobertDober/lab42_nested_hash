require 'forwarder'

require_relative 'invocation'

module Lab42
  class NHash
    class Enum
      extend Forwarder
      forward :each, to: :@enum
      forward :first, to_object: :self, as: :[], with: 0
      forward :first!, to_object: :self, as: :fetch!, with: 0
      forward :last, to_object: :self, as: :[], with: -1 
      forward :last!, to_object: :self, as: :fetch!, with: -1 
      
      include Enumerable
      include Invocation

      attr_reader :parent

      def [] idx
        Lab42::NHash.from_value @enum[idx], @options
      end
      
      def each blk=nil, &block
        behavior = blk || block
        @enum.each do | ele |
          behavior.( Lab42::NHash.from_value ele, @options )
        end
      end

      def fetch! idx
        result = self[ idx ]
        return result unless String === result

        ERB.new( result ).result @parent.current_binding
      end
      
      def get keyexp=nil, &block
        behavior = block || keyexp
        raise ArgumentError, 'need key or behavior' unless behavior
        Proc === behavior ? _get_with_behavior( behavior ) : _get_with_key( keyexp )
      end

      private
      def initialize enum, options
        @enum    = enum
        @parent  = options[:parent]
        @options = options
      end

      def _get_with_key keyexp
        each do |ele, sentinel|
          begin
            return ele.get keyexp
          rescue KeyError
          end
        end
        raise KeyError, "key not found: #{keyexp.inspect}"
      end

      def _get_with_behavior behavior
        each do |ele, sentinel|
          begin
            return _invoke behavior, ele
          rescue KeyError
          end
        end
        raise KeyError, "key not found: #{keyexp.inspect}"
        
      end
    end # class Enum
  end # class NHash
end # module Lab42
