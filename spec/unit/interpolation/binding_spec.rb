require 'spec_helper'

describe NHash do 

  # get for local binding
  def get *args; 1 end

  subject do
    NHash.new( 
              a: 1,
              b: 42,
              sum: %{<%= get(:a) + get(:b) %>} )
      .with_indifferent_access
  end

  it "evaluates in the instance's binding" do
    expect( subject.get! :sum ).to eq "43"
  end

  it 'can be evaluated in the current binding' do
    subject.push_binding binding
    expect( subject.get! :sum ).to eq '2'
  end
end # describe NHash
