require 'spec_helper'
module Noe
  describe "Config#templates_dir" do
    
    subject{ config.templates_dir }
    
    context 'on default config' do
      let(:config){ Config.new }
      
      it "should be Noe's template dir" do
        subject.should == $noe_root/"templates"
      end
      
    end # on default config
    
    context 'when a relative path is used' do
      let(:file)  { Path.relative("config1.yaml") }
      let(:config){ Config.new(file)                              }
      
      it "should be an absolute path" do
        subject.should == Path.relative("templates")
      end
      
    end # relative path
    
    context 'when an absolute path is used' do
      let(:file) { Path.relative("config1.yaml") }
      let(:tdir) { Path.relative("templates")    }
      let(:hash) { { "config_file" => file, "templates-dir" => tdir } }
      let(:config){ Config.new(hash) }
      
      it "should stay an absolute path" do
        subject.should == tdir
      end
      
    end
    
  end # Config#templates_dir
end # module Noe