require 'erb'

module Lab42
  class NHash
    module Interpolation
      def get! *args, &blk
        result = get( *args, &blk )
        _expand_result result
      end
      alias_method :fetch!, :get!

      def get_with_binding key, a_binding, *rst, &blk
        with_binding a_binding do
          get!( key, *rst, &blk )
        end
      end

      def get_with_current &blk
        with_binding blk.binding do
          get! blk.()
        end
      end

      def with_binding a_binding, &blk
        push_binding a_binding
        _invoke blk, self
      ensure
        pop_binding
      end

      def current_binding
        @binding_stack.last || ( root? ? binding : parent.current_binding )
      end

      def root?
        parent == self || parent.nil?
      end
      private
      def _expand_result value
        ERB.new( value ).result( current_binding )
      end
      
    end # module Interpolation
    include Interpolation
  end # class NHash
end # module Lab42
