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
    
    context 'when a relative path is used' do
      let(:file)  { File.expand_path("../config1.yaml", __FILE__) }
      let(:config){ Config.new(file)                              }
      
      it "should be an absolute path" do
        subject.should == File.expand_path("../templates", __FILE__)
      end
      
    end # relative path
    
    context 'when an absolute path is used' do
      let(:file) { File.expand_path("../config1.yaml", __FILE__) }
      let(:tdir) { File.expand_path("../templates", __FILE__)    }
      let(:hash) { { "config_file" => file, "templates-dir" => tdir } }
      let(:config){ Config.new(hash) }
      
      it "should stay an absolute path" do
        subject.should == tdir
      end
      
    end
    
  end # Config#templates_dir
end # module Noe