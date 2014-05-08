require_relative './exceptions'
module Lab42
  class NHash
    module Afixes

      def pop_prefix; @prefix_stack.pop; self end
      def pop_suffix; @suffix_stack.pop; self end
      def push_prefix pfx; @prefix_stack.push pfx; self end
      def push_suffix sfx; @suffix_stack.push sfx; self end

      def current_prefix
        @prefix_stack
        .fetch( -1 ){ raise IllegalStateError, "prefix stack is empty" }
        .split( '.' )
      end

      def current_suffix
        @suffix_stack
        .fetch( -1 ){ raise IllegalStateError, "suffix stack is empty" }
        .split( '.' )
      end

      def with_affixes pfx, sfx, &blk
        push_prefix pfx
        push_suffix sfx
        blk.( self )
      ensure
        pop_prefix
        pop_suffix
      end

      def with_prefix pfx, &blk
        push_prefix pfx
        blk.( self )
      ensure
        pop_prefix
      end

      def with_suffix sfx, &blk
        push_suffix sfx
        blk.( self )
      ensure
        pop_suffix
      end
    end # module Afixes
    include Afixes
  end # class NHash
end # module Lab42
