require 'spec_helper'

describe NHash do 

  context :Interpolation do 
    context :binding do 

      # get for local binding
      def get *args; 1 end

      let(:b){
        Class.new do
          def get *args; 2 end
          def b; binding end
        end.new
      }

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

      it 'can be evaluated in any binding' do
        subject.push_binding b.b
        expect( subject.get! :sum ).to eq '4'
      end

      context :with_binding do 
        it 'is temporary' do
          outside = subject.get! :sum
          inside  = subject.with_binding binding do
            get! :sum
          end
          outside += subject.get! :sum

          expect( outside + inside ).to eq '43432'
        end
      end # context :with_binding

      context :get_with_binding do 
        it 'is also temporary' do
          outside = subject.get! :sum
          inside  = subject.get_with_binding :sum, binding
          outside += subject.get! :sum
          expect( outside + inside ).to eq '43432'
        end
      end # context :get_with_binding

      context :get_with_current do 
        it 'evaluates with the current binding' do
          expect( subject.get_with_current{ :sum } ).to eq '2'
        end
      end # context :get_with_current

    end # context :binding
  end # context :Interpolation

end # describe NHash
