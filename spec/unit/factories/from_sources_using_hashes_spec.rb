require 'spec_helper'

describe NHash do 
  context :factories do 
    context :with_hashes do
      let(:h){{ 'a' => 1, 'c' => 1 }}
      let(:nh){described_class.new( 'a' => 2, 'b' => 2 )}
      subject do
        described_class.from_sources( h, nh )
      end

      it 'is a NHash instance' do
        expect( subject ).to be_kind_of described_class
      end

      it 'finds elements in root' do
        expect( subject.get( 'a' )  ).to eq 1
      end

      it 'finds element at 2nd level now' do
        expect( subject.get( 'b' ) ).to eq 2
      end

      context 'longer chains' do 
        let(:first){ described_class.new( 'a' => 0) }
        let(:root){
          described_class.from_sources first, h, nh
        }

        it 'finds a at root level' do
          expect( root.get 'a' ).to eq 0
        end

        it 'finds c at second level' do
          expect( root.get 'c' ).to eq 1
        end

        it 'finds b at last level' do
          expect( root.get 'b' ).to eq 2
        end

        it 'does not find d at all' do
          expect( ->{root.get 'd'} ).to raise_error KeyError
        end
        
      end # context 'longer chains'
    end # context :with_hashes

  end # context :factories
end # describe NHash
