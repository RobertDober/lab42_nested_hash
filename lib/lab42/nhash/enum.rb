require 'forwarder'

module Lab42
  class NHash
    class Enum
      extend Forwarder
      forward :each, to: :@enum
      forward :first, to_object: :self, as: :[], with: 0
      forward :last, to_object: :self, as: :[], with: -1 
      
      include Enumerable

      def [] idx
        Lab42::NHash.from_value @enum[idx], @options
      end

      private
      def initialize enum, options
        @enum  = enum
        @options = options
      end

    end # class Enum
  end # class NHash
end # module Lab42
