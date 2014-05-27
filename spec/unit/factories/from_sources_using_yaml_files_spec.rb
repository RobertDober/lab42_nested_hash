require 'spec_helper'

describe NHash do 
  context :factories do 
    context  'from yaml files' do
      
      given_a_file named: 'one.yml', with: <<-EOF
        a: 1
      EOF
      given_a_file named: 'two.yml', with: <<-EOF
        a: 2
        b: 2
      EOF
      subject do
        described_class.from_sources 'one.yml', 'two.yml'
      end

      it "finds a's value in the first file" do
        expect( subject.get :a ).to eq 1
      end

      it "finds b's value in the first file" do
        expect( subject.get :b ).to eq 2
      end

      it "does not find c's value anywhere" do
        expect( ->{ subject.get :c } ).to raise_error KeyError
      end
    end # context  'from yaml files'
  end # context :factories
end # describe NHash
