require 'spec_helper'
module Noe
  describe "Template::Entry#rename_one" do
    
    let(:template){ 
      Template.new(Path.relative('../../../../templates/ruby'))
    }
    let(:vars){ 
      {"lower" => "project"} 
    }
    subject{ 
      entry.rename_one(vars) 
    }
    
    describe "when nothing has to change" do
      let(:entry){ template.entry("project") }
      it { should == Path("project") }
    end
    
    describe "when exactly a replacement" do
      let(:entry){ template.entry("__lower__") }
      it { should == Path("project") }
    end
    
    describe "when a replacement inside something else" do
      let(:entry){ template.entry("__lower___spec.rb") }
      it { should == Path("project_spec.rb") }
    end
    
  end
end # module Noe