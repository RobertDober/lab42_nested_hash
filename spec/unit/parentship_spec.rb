require 'spec_helper'

describe NHash do 
  context :parentship, :wip do
    subject do
      NHash.new(
        a: 42,
        b: { c: 43 },
        d: [ 1, {e: 44} ]
      )
      .with_indifferent_access
    end

    it 'new instance is its own parent' do
      expect( subject.parent ).to eq subject
    end

    it 'a subhashes parent is the whole nhash instance' do
      expect( subject.get( :b ).parent ).to eq subject
    end

    it "an enum's parent too" do
      expect( subject.get( :d ).parent ).to eq subject
    end

    it "and an enum's subhash also" do
      expect( subject.get( :d )[1].parent ).to eq subject
    end
  end # context :parentship
end # describe NHash
