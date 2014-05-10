require 'spec_helper'

describe NHash do 

  context :affix_helpers do 
    let(:nouns) do
      NHash.new(
        en: {
          person: {
            many: 'people',
            one: 'person',
            none: 'nobody'
          },
          sheep: {
            one: 'sheep'
          },
          dog: {
            many: 'dogs',
            one: 'dog'
          }
        },
        fr: {
          person: {
            many: 'gens',
            one: 'personne'
          }
        } 
      )
      .with_indifferent_access
    end

    # We implement the following strategy
    # Try fr prefix
    #    Try suffixes in order :none, :one
    # Try en prefix
    #    Try suffixes in order :none, :one
    context :strategy do 
      before do
        nouns.push_fallback do
          with_prefix :fr do
            push_fallback do
              with_suffix :none do
                push_fallback do
                  with_suffix :one do
                    push_fallback do
                      with_prefix :en do
                        push_fallback do
                          with_suffix :none do
                            push_fallback do
                              with_suffix :one do
                                again
                              end
                            end
                            again
                          end # prefix: en suffix: none
                        end
                        again
                      end # prefix: en
                    end
                    again
                  end # prefix: fr suffix: one
                end
                again
              end # prefix: fr suffix: none
            end
            again
          end # prefix :fr
        end
      end
      it 'worx without the fallbax' do
        expect( 
               nouns.with_affixes( :en, :many ) do
                 get '.person.'
               end
              ).to eq 'people'
      end

      it "only one fallback's needed" do
        expect( 
               nouns.with_affixes( :fr, :none ) do
                 get '.person.'
               end
              ).to  eq 'personne'
      end

      it "needs two fallbacks" do
        expect( 
               nouns.with_affixes( :de, :none ) do
                 get '.person.'
               end
              ).to  eq 'personne'
      end

      it 'uses the longest path in the fallback tree' do
        expect( 
               nouns.with_affixes( :de, :many ) do
                 get '.sheep.'
               end
              ).to  eq 'sheep'
      end
    end # context :strategy
  end # context :affix_helpers

end # describe NHash
