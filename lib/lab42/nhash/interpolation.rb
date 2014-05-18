require 'erb'

module Lab42
  class NHash
    module Interpolation
      def get! *args, &blk
        result = get( *args, &blk )
        _expand_result result
      end
      alias_method :fetch!, :get!

      private

      def current_binding
        @binding_stack.last || binding
      end

      def _expand_result result
        
        ERB.new( result ).result( current_binding )
      end
      
    end # module Interpolation
    include Interpolation
  end # class NHash
end # module Lab42
