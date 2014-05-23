require 'spec_helper'

describe NHash do
  context 'Hierarchy and Lookup' do 

    let :level2 do
      described_class.new(
        en: { '2' => :two },
        fr: { '1' => :un, '3' => :trois })
      .with_indifferent_access
    end 

    subject do
      described_class.new(
        en: { '1' => :one }
      )
      .with_indifferent_access
    end

    before do
      subject.push_prefix_lookup :en
      level2.push_prefix_lookup :fr, :en
      subject.add_hierarchy level2
    end

    it 'finds with prefix lookup in the root' do
      subject.with_prefix :fr do | s |
        expect( s.get '.1' ).to eq :one
      end
    end
    it 'finds in the hierarchy' do
      expect( subject.get 'fr.3' ).to eq :trois
    end
    it 'finds it in the hierarchy if local lookup fails' do
      subject.with_prefix :fr do | s |
        expect( s.get '.3' ).to eq :trois
      end
      
    end
    it 'finds in the hierarchy with lookup' do
      subject.with_prefix :fr do | s |
        expect( s.get '.2' ).to eq :two
      end
    end

  end # context 'Hierarchy and Lookup'
end # describe NHash
