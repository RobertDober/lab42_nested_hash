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

      def push_affix_lookup( prefixes: required, suffixes: required, suffixes_first: false )
        if suffixes_first
          suffixes.product( prefixes ).reverse.each do | suff, pref |
            push_fallback do
              with_suffix suff do
                with_prefix pref do
                  again
                end
              end
            end
          end
        else
          prefixes.product( suffixes ).reverse.each do | pref, suff |
            push_fallback do
              with_suffix suff do
                with_prefix pref do
                  again
                end
              end
            end
          end
        end
      end
    end # module LookupChains
    include LookupChains
  end # class NHash
end # module Lab42
