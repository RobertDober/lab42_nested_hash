require 'spec_helper'

describe NHash do 
  context :compound do
    subject do
      NHash.new( 
                a: 42,
                b: { a: 41 })
        .with_indifferent_access
    end
    it 'gets scalars' do
      expect( subject.get :a ).to eq 42
    end
    it '... or not' do
      expect( subject.get :b ).to be_instance_of described_class
    end
  end # context :compound
end # describe NHash
