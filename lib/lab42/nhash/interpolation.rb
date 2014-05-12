require 'erb'

module Lab42
  class NHash
    module Interpolation
      def get! *args, &blk
        result = get( *args, &blk )
        return result unless String === result
        _expand_result result
      end
      alias_method :fetch!, :get!

      private
      def _expand_result result
        ERB.new( result ).result( binding )
      end
      
    end # module Interpolation
    include Interpolation
  end # class NHash
end # module Lab42
