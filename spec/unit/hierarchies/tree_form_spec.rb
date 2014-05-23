require 'spec_helper'

describe NHash do 
  describe :hierarchies do 
    context 'tree form' do 

      let(:ints){
        described_class.new( twelve: 'i12' )
        .with_indifferent_access
      }

      let(:odds){
        described_class.new(
          one: 'o1', three: 'o3')
        .with_indifferent_access
      }

      let(:evens){
        described_class.new( four: 'e4' )
        .with_indifferent_access
      }

      let(:fizzes){
        described_class.new( three: 'f3' )
        .with_indifferent_access
      }

      before do
        odds.add_hierarchy ints
        fizzes.add_hierarchy evens
        subject.add_hierarchies fizzes, odds
      end

      subject do
        described_class
          .new( zero: '0' )
          .with_indifferent_access
      end

      context 'no impact at root level' do 
        it 'for root' do
          expect( subject.get(:zero) ).to eq '0'
        end
        it 'for hierarchies accessed as root' do
          expect( odds.get :three ).to eq 'o3'
        end
      end # context 'no impact at root level'

      context 'hierarchy chains' do 
        it 'finds them at the next level' do
          expect( subject.get( :one ) ).to eq( 'o1' )
        end
        it 'according to the the FIFO principle' do
          expect( subject.get( :three ) ).to eq( 'f3' )
        end
        it 'or on later levels' do
          expect( subject.get( :four ) ).to eq( 'e4' )
          expect( subject.get( :twelve ) ).to eq( 'i12' )
        end
      end # context 'hierarchy chains'

      context 'eventually we still might' do 
        it 'convert to default values' do
          expect( subject.get( :hundred, 100 ) ).to eq 100
          expect( subject.get( :hundred ){ 100 } ).to eq 100
        end
        it 'or even raise a KeyError' do
          expect( ->{ subject.get :hundred } ).to raise_error KeyError
        end
      end # context 'eventually we still might'
    end # context 'tree form'
  end # describe :hierarchies
end # describe NHash
