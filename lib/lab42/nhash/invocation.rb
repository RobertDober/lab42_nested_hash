module Lab42
  class NHash
    module Invocation
      private
      def _invoke a_proc, *args
        if a_proc.arity < 0 || a_proc.arity == args.size
          a_proc.( *args )
        else
          args.first.instance_exec(&a_proc)
        end
      end
    end # module Invocation

    include Invocation
  end # class NHash
end # module Lab42
