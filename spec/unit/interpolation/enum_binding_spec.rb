require 'spec_helper'

describe NHash do 
  context :Interpolation do 
    context :enum_binding do 
      subject do
        NHash.new(
          a: 31,
          entries:
            [ 'a: <%= get(:a) %>',
              { b: '<%= get(:a) + 11 %>' }])
        .with_indifferent_access
      end 
      
      it 'retains the binding from the parent in subhashes' do
        expect( subject.get( :entries ).last!.get!(:b) ).to eq "42"
        expect( subject.get( :entries ).fetch!(1).get!(:b) ).to eq "42"
      end

      it 'even in flat enum entries' do
        expect( subject.get( :entries ).first! ).to eq 'a: 31'
        expect( subject.get( :entries ).fetch!(0) ).to eq 'a: 31'
      end
    end # context :enum_binding
  end # context :Interpolation
end # describe NHash

