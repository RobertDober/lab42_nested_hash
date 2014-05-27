
module FileMocks

  def given_a_file named: required, with: required
    before do
      expect( File ).to receive( :readable? ).with( named ).and_return( true ).ordered
      expect( File ).to receive( :read ).with( named ).and_return( with ).ordered
    end 
  end
  
end # module FileMocks

RSpec.configure do | c |
  c.extend FileMocks
end
