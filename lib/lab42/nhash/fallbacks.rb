module Lab42
  class NHash
    module Fallbacks
      def again
        raise IllegalStateError, "must not call again before a failed get/fetch" unless @inside_fallback
        get( *@fallback_params )
      end

      def clear_fallbacks!
        @fallbacks = []
      end

      def pop_fallback
        raise IllegalStateError, "must not tamper with the fallback stack inside fallbacks" if @inside_fallback

        @fallbacks.pop

        self
      end

      def push_fallback fb=nil, &blk
        raise ArgumentError, "need to provide a lambda or a block" unless fb || blk
        assure_not_inside_fallback
        
        @current_fallback_pointer = @fallbacks.size
        @fallbacks.push( fb || blk )

        self
      end

      def with_fallback b=nil, &blk
        assure_not_inside_fallback
        save_fallback_pointer = @current_fallback_pointer
        _invoke (b||blk), self
      ensure
        @current_fallback_pointer = save_fallback_pointer
      end

      private
      def assure_not_inside_fallback
        raise IllegalStateError, "must not tamper with the fallback stack inside fallbacks" if @inside_fallback
      end
      def current_fallback
        @fallbacks[ @current_fallback_pointer ]
      end
      # Contract: Invoked only after a KeyError raising get/fetch
      def fallback keyexpr, k
        raise k unless current_fallback
        @inside_fallback = true # according to contract, setting the flag allowing the invocation of again
        @fallback_params = keyexpr
        invoke_current_fallback
      ensure
        @inside_fallback = false # forbid @again invocation again (pun intended)
      end

      def invoke_current_fallback
        fb = current_fallback
        @current_fallback_pointer -= 1
        @current_fallback_pointer = @fallbacks.size if @current_fallback_pointer < 0
        _invoke( fb, self ).tap do
          # Make sure to reset if nothing was raised inside the invocation
          @current_fallback_pointer = @fallbacks.size - 1
        end
      end

    end # module Fallbacks

    include Fallbacks
  end # class NHash
end # module Lab42
