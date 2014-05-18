require 'spec_helper'

describe NHash, :regression do 
  subject do
    NHash.new( 
                 sum: '<%= get("a")+get("b") %>',
                 a: 41,
                 b: 1,
                 result: 'the sum is <%= get! :sum %>'
                )
  .with_indifferent_access
  end

  it 'works (debugging)' do
    expect( subject.fetch! :result ).to eq 'the sum is 42'
  end

end # describe NHash
