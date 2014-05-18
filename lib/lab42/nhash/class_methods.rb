require_relative 'enum'
module Lab42
  class NHash
    module ClassMethods

      def from_value value, options={}
        case value
        when Hash
          Lab42::NHash.new( value ).import_options options
        when Enumerable
          Lab42::NHash::Enum.new value, options
        else
          value
        end
      end
    end # module ClassMethods
    extend ClassMethods
  end # class NHash
end # module Lab42
