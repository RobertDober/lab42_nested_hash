module Lab42
  class NHash
    module Fallbacks
      def again
        raise IllegalStateError, "must not call again unless inside a fallback" if @fallbacks.empty?
        raise IllegalStateError, "must not call again before a failed get/fetch" if @fallback_params.empty?
        get @fallback_params.last
      end

      def fallback keyexpr, k
        raise k if @fallbacks.empty?
        raise KeyError, "#{@fallback_params.last.inspect} loop in again" if @fallback_invocations[@fallbacks.last][keyexpr]
        @fallback_params.push keyexpr
        @fallback_invocations[@fallbacks.last][keyexpr] = true
        _invoke @fallbacks.last, self
      ensure
        @fallback_invocations[@fallbacks.last].delete @fallback_params.pop
      end

      def pop_fallback
        @fallbacks.pop
        self
      end

      def push_fallback fb=nil, &blk
        raise ArgumentError, "need to provide a lambda or a block" unless fb || blk
        @fallbacks.push( fb || blk )
        self
      end

      def with_fallback fb, &blk
        push_fallback fb
        blk.( self )
      ensure
        pop_fallback
      end

    end # module Fallbacks

    include Fallbacks
  end # class NHash
end # module Lab42
