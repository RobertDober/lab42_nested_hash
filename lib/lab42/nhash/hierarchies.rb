module Lab42
  class NHash
    module Hierarchy
      def add_hierarchy a_hierarchy
        raise ArgumentError, 'not an NHash instance' unless self.class === a_hierarchy
        @hierarchies << a_hierarchy
        self
      end

      def get_form_hierarchies keyexpr, keyexc
        @hierarchies.each do | h |
          begin
            return h.get keyexpr
          rescue KeyError
          end
        end
        raise KeyError, keyexc
      end
    end # module Hierarchy

    include Hierarchy
  end # class NHash
end # module Lab42
