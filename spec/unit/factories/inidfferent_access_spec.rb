require 'spec_helper'

describe NHash do 
  
  context :factories do
    context 'without indifferent access' do 
      subject do
        described_class.from_sources( {a: 1}, {'a' => 2, b: 2} )
      end
      it 'finds only the stringy "a"' do
        expect( subject.get( :a ) ).to eq 2
      end
      it 'and string "b" is not found at all' do
        expect( ->{ subject.get :b } ).to raise_error KeyError
      end
    end # context :indifferent_access

    context 'however, with indifferent access' do 
      subject do
        described_class.from_sources_with_indifferent_access( {a: 1}, {'a' => 2, b: 2} )
      end
      it 'finds also the symbol :a' do
        expect( subject.get( :a ) ).to eq 1
      end
      it 'as well as the symbol :b' do
        expect( subject.get( :b ) ).to eq 2
      end
      
    end # context 'however, with indifferent access'
  end # context :factories

end # describe NHash
