require 'spec_helper'

describe NHash::Enum do

  subject do
    NHash.new(
      entries: [
        {a: 1},
        {b: 2}
      ]
    ).with_indifferent_access
  end
  let(:entries){ subject.get :entries }
  

  context 'get with keys' do 
    it 'finds a key' do
      expect( entries.get :a ).to eq 1
      expect( entries.get :b ).to eq 2
    end
    
    it '... or not' do
      expect( ->{ entries.get :c } ).to raise_error KeyError
    end
  end # context 'get with keys'

  context 'get with blox' do 
    it 'finds a key and returns the bloxs return value' do
      expect( entries.get{ |e| e.get(:b) * 2 } ).to eq 4
      expect( entries.get(->(e){ e.get(:b) * 2 }) ).to eq 4
    end
    it 'can instance exec the behavior' do
      expect( entries.get{ get(:b) + 1 } ).to eq 3
      expect( entries.get(->{ get(:b) + 1 }) ).to eq 3
    end
  end # context 'get with blox'
  
end
