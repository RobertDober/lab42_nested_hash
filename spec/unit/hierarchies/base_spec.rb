require 'spec_helper'

describe NHash do 
  context :hierarchies do 
    subject do
      described_class.new( a: 1 )
        .with_indifferent_access
        .add_hierarchy(
          described_class.new( b: 2 )
          .with_indifferent_access
        )
    end
    it 'finds key in base instance' do
      expect( subject.get :a ).to eq 1
    end
    it 'finds key in first hierarchy' do
      expect( subject.get :b ).to eq 2
    end
    it 'still raises KeyError or returns default values if key is not in any hierarchy' do
      expect( ->{
        subject.get :c
      } ).to raise_error KeyError
      expect( subject.get :c, 42 ).to eq 42
      expect( subject.get( :c ){ 42 } ).to eq 42
    end

    context 'implicit' do 
      it 'convertion of hashes in add_hierarchy' do
        n = NHash.new().add_hierarchy
        expect( n.instance_variable_get( :@hierarchies ).first ).to be_instance_of described_class
      end
    end # context 'implicit creation'
  end # context :hierarchies
end # describe NHash
