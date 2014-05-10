require 'spec_helper'

describe NHash do 
  context :simple do 
    subject do
      NHash.new({
        '1' => { 'en' => 'one', 'de' => 'eins' }
      })
      .push_fallback do |h|
        h.with_suffix 'en' do
          h.again
        end
      end
    end
    it 'accesses values correctly' do
      expect( subject.with_suffix('de'){ |h| h.get('1.') } ).to eq('eins')
    end
    it 'falls back to en' do
      expect( subject.with_suffix('it'){ |h| h.get('1.') } ).to eq('one')
    end
  end # context :simple

end # describe NHash
