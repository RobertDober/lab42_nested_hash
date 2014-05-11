module Lab42
  class NHash
    module LookupChains
      def push_prefix_lookup *prefixes
        prefixes.reverse.each do | prefix |
          push_fallback do
            with_prefix prefix do
              again
            end
          end
        end
      end
      
      def push_suffix_lookup *suffixes
        suffixes.reverse.each do | suffix |
          push_fallback do
            with_suffix suffix do
              again
            end
          end
        end
      end
    end # module LookupChains
    include LookupChains
  end # class NHash
end # module Lab42
