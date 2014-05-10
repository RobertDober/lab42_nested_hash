require 'spec_helper'

describe NHash do 
  subject do
    described_class.new( "a" => { 
      "b" => 
      { "c" => 'abc' } })
  end

  it "can access with affixes" do
    expect( subject.with_affixes( 'a', 'c') do
             get '.b.'
           end
          ).to eq( 'abc' )
  end

end # describe NHash
