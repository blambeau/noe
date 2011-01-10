require File.expand_path('../../../spec_helper', __FILE__)
module Noe
  describe "Template::Entry#rename_one" do
    
    let(:template){ 
      Template.new(File.expand_path('../../../../templates/ruby', __FILE__)) 
    }
    let(:vars){ 
      {"lower" => "project"} 
    }
    subject{ 
      entry.rename_one(vars) 
    }
    
    describe "when nothing has to change" do
      let(:entry){ template.entry("project") }
      it { should == "project" }
    end
    
    describe "when exactly a replacement" do
      let(:entry){ template.entry("__lower__") }
      it { should == "project" }
    end
    
    describe "when a replacement inside something else" do
      let(:entry){ template.entry("__lower___spec.rb") }
      it { should == "project_spec.rb" }
    end
    
  end
end # module Noe