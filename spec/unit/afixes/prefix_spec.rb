require 'spec_helper'

describe NHash do 
  subject do
    described_class.new({ "a" => { 
      "b" => 
      { "c" => 'abc',
        "d" => 'abd' } },
        "x" => {
          "b" =>
          { "c" => 'xbc' } } })
      .push_prefix 'a.b' 
  end

  it "can access normally" do
    expect( subject.get('a.b.c') ).to eq( 'abc' )
  end

  it "or with a prefix" do
    expect( subject.get( '.c' ) ).to eq( 'abc' )
  end
end # describe NHash
