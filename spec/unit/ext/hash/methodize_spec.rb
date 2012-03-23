require 'spec_helper'
module Noe
  describe "Hash#methodize!" do
    
    let(:thehash){ 
      { 'name'     => "Noe", 
        :version   => Noe::VERSION,
        'subhash'  => { 'entry' => 12 },
        'subarray' => [ { 'entry' => 12 } ]
      }
    }
    
    it "should be recursive by default" do
      thehash.methodize!
      thehash.name.should == "Noe"
      thehash.version.should == Noe::VERSION
      thehash.subhash.entry.should == 12
      thehash.subarray[0].entry.should == 12
    end
    
    it "should not be recursive if explicitely said" do
      thehash.methodize!(false)
      thehash.name.should == "Noe"
      thehash.version.should == Noe::VERSION
      thehash.subhash.should == {'entry' => 12}
      lambda{ thehash.subhash.entry }.should raise_error
    end
    
  end
end # module Noe