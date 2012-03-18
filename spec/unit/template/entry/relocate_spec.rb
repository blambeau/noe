require File.expand_path('../../../spec_helper', __FILE__)
module Noe
  describe "Template::Entry#relocate" do
    
    let(:template){ 
      Template.new(Path.relative('../../../../templates/ruby'))
    }
    let(:vars){ 
      {"lower" => "project"} 
    }
    subject{ 
      entry.relocate(vars) 
    }
    
    describe "when nothing has to change" do
      let(:entry){ template.entry('.gitignore') }
      it{ should == Path(".gitignore") }
    end

    describe "when exactly a replacement" do
      let(:entry){ template.entry("__lower__") }
      it { should == Path("project") }
    end
    
    describe "when a replacement inside something else" do
      let(:entry){ template.entry("__lower___spec.rb") }
      it { should == Path("project_spec.rb") }
    end
    
    describe "when no replace and sub file" do
      let(:entry){ template.entry("lib", "README.md") }
      it { should == Path("lib/README.md")  }
    end
    
    describe "when no replace and sub file with replacement" do
      let(:entry){ template.entry("lib", "__lower__.rb") }
      it { should == Path("lib/project.rb")  }
    end

  end 
end # module Noe