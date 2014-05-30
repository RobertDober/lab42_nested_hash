require 'spec_helper'

describe NHash::Enum do
  subject do
    nh = NHash.new(
      a: 42,
      entries: [
        { val: '<%= get :a %>' },
        '<%= get(:a) * 2 %>',
        21
      ] )
      .with_indifferent_access
  end
  let(:enum){ subject.get :entries }

  it 'is returned for arrays' do
    expect( subject.get :entries ).to be_instance_of described_class
  end

  context 'behaves like an array' do
    it 'for #[]' do
      expect( enum[2] ).to eq 21
    end
    it 'for #first' do
      expect( enum.first.get :val ).to eq '<%= get :a %>'
    end
    it 'for #last' do
      expect( enum.last ).to eq 21
    end
  end # context :behaves

  context 'behaves like an Enumerable' do 
    it 'via Lab42::NHash::Enum' do
      expect( enum ).to be_kind_of described_class
      expect( described_class ).to be < Enumerable
    end
    
  end # context 'behaves like an Enumerable'

  context 'preservers the context' do
    it 'evaluates with indifferent access' do
      expect( enum.first.get('val') ).to eq '<%= get :a %>'
    end

    it 'interpolates in the context of the original object' do
      expect( enum.first.get!('val') ).to eq '42'
    end
  end # context 'preservers the context'
end
