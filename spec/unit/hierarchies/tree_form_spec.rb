require 'spec_helper'

describe NHash do 
  describe :hierarchies do 
    context 'tree form', :wip do 
      let(:ints){
        described_class.new(
          one: 'i1', two: 'i2', three: 'i3', four: 'i4', five: 'i5',
          six: 'i6', seven: 'i7', eight: 'i8', nine: 'i9', ten: 'i10')
        .with_indifferent_access
      }
      let(:odds){
        described_class.new(
          one: 'o1', three: 'o3', five: 'o5', seven: 'o7', nine: 'o9')
        .with_indifferent_access
      }
      let(:evens){
        described_class.new(
           two: 'e2', four: 'e4', six: 'e6', eight: 'e8', ten: 'e10')
        .with_indifferent_access
      }
      let(:fizzes){
        described_class.new(
          three: 'f3', six: 'f6', nine: 'f9' )
        .with_indifferent_access
      }
      before do
        odds.add_hierarchy ints
        fizzes.add_hierarchy evens
        subject.add_hierarchies odds, fizzes
      end
      subject do
        described_class.new( zero: '0' )
          .with_indifferent_access
      end
    end # context 'tree form'
  end # describe :hierarchies
end # describe NHash
