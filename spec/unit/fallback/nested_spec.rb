require 'spec_helper'

describe NHash do
  context :nested_fallbacks do
    let(:nhash){
      NHash.new(
          en: { 
            '1' => 'one'
          },
          defaults: {
            '0' => '*'
          }
      ).with_indifferent_access
    }
    before do
      nhash.push_fallback do
        with_prefix :en do
          push_fallback do
            with_prefix :defaults do
              again
            end
          end
          again
        end
      end
    end
    
    it 'finds the english value if defined' do
      nhash.with_prefix :de do |h|
        expect( h.get '.1' ).to eq( 'one' )
      end
    end

    it 'otherwise it finds the default value' do
      nhash.with_prefix :de do | h |
        expect( h.get '.0' ).to eq( '*' )
      end
    end

    it 'and if everything fails...' do
      nhash.with_prefix :de do | h |
        expect( ->{ h.get '.2' } ).to raise_error( KeyError )
      end
    end
    
  end # context :nested_fallbacks
end
