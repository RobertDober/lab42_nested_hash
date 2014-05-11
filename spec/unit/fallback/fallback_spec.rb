require 'spec_helper'

describe NHash do
  subject do
    NHash.new(
      en: { '1' => 'one', '2' => 'two', '3' => 'three' },
      fr: { '1' => 'un',  '2' => 'deux' },
      it: { '1' => 'uno' } )
    .with_indifferent_access
  end

  context 'non regression if no fallbacks are declared' do 
    it 'accesses correctly' do
      expect( subject.get('it.1' ) ).to eq 'uno'
    end
    it 'raises KeyError correctly' do
      expect( 
             ->{
               subject.get 'it.2'
             }
            ).to raise_error KeyError
    end

  end # context 'non regression if no fallbacks are declared'

  context :fallbacks do 
    before do
      subject.push_fallback do
        # let us use English as the last ressort
        with_prefix(:en){again}
      end
    end

    context :one_level_fallback do 
      it 'still works' do
        subject.with_prefix( :it ) do | n |
          expect( n.get( '.1' ) ).to eq 'uno'
        end
      end

      it 'finds the english value else' do
        subject.with_prefix( :it ) do | n |
          expect( n.get( '.2' )).to eq 'two'
        end
      end

      context :second_level_fallback do 
        before do
          subject.push_fallback do |s|
            s.with_prefix(:fr){ 
              again
            }
          end
        end
        it 'still works' do
          subject.with_prefix( :it ) do | n |
            expect( n.get( '.1' ) ).to eq 'uno'
          end
        end

        it 'finds the french value if present' do
          subject.with_prefix( :it ) do | n |
            expect( n.get( '.2' )).to eq 'deux'
          end
        end

        it 'otherwise finds the english value' do
          subject.with_prefix( :it ) do | n |
            expect( n.get( '.3' )).to eq 'three'
          end
        end
      end # context :second_level_fallback

      context :clear_fallbacks do 
        before do
          subject.clear_fallbacks!
        end

        it 'raises a KeyError now' do
          subject.with_prefix( :it ) do | n |
            expect( 
                   ->{
                     n.get( '.2' )
                   }
                  ).to raise_error KeyError
          end
        end
      end # context :clear_fallbacks
    end # context :normal_access
  end # context :fallbacks
end # describe NHash
