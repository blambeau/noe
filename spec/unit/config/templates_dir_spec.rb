require File.expand_path('../../spec_helper', __FILE__)
module Noe
  describe "Config#templates_dir" do
    
    subject{ config.templates_dir }
    
    context 'on default config' do
      let(:config){ Config.new }
      
      it "should be Noe's template dir" do
        subject.should == File.join($noe_root, "templates")
      end
      
    end # on default config
    
  end # Config#templates_dir
end # module Noe