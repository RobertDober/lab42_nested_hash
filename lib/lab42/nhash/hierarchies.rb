module Lab42
  class NHash
    module Hierarchy
      def add_hierarchy a_hierarchy={}
        a_hierarchy = self.class.new a_hierarchy if Hash === a_hierarchy
        raise ArgumentError, 'not an NHash instance' unless self.class === a_hierarchy
        @hierarchies << a_hierarchy
        self
      end
      def add_hierarchies *some_hierarchies
        some_hierarchies.each do | a_hierarchy |
          add_hierarchy a_hierarchy
        end
        self
      end

      def get_from_hierarchies keyexpr, keyexc
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
