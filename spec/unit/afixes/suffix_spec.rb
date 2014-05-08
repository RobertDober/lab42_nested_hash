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
      .push_suffix 'b.c' 
  end

  it "can access normally" do
    expect( subject.get('a.b.c') ).to eq( 'abc' )
  end

  it "or with a suffix" do
    expect( subject.get( 'a.' ) ).to eq( 'abc' )
    expect( subject.get( 'x.' ) ).to eq( 'xbc' )
  end
end # describe NHash
