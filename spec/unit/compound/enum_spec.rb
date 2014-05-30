require 'spec_helper'

describe NHash::Enum do

  context 'Enumerable behavior' do
    context 'Hashes' do 
      subject do
        NHash.new( entries: [{a: 1}] ).with_indifferent_access
      end
      let(:entries){ subject.get :entries }

      it 'are yielded as NHash instances' do
        entries.each do | entry |
          expect( entry ).to be_kind_of NHash
        end
      end
    end # context 'yields NHashes'

    context 'Arrays' do 
      subject do
        NHash.new( entries: [[{a:1}]] ).with_indifferent_access
      end
      let(:entries){ subject.get :entries }
      it 'are yielded as NHash::Enum instances' do 
        entries.each do | entry |
          expect( entry ).to be_kind_of described_class
        end
      end

    end # context 'yields NHash::Enum instances'
  end # context 'Enumerable behavior'

end
