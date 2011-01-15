require File.expand_path('../../../spec_helper', __FILE__)
module Noe
  describe "Template::Entry#infer_wlang_dialect" do
    
    subject{ Template::Entry.infer_wlang_dialect(uri, default) }
    let(:default){ nil }
    
    context "when invoked on explicit wlang dialects extensions" do
      let(:uri){ "test.wtpl" }
      it{ should == "wlang/xhtml" }
    end
    
    context "when invoked on implicit wlang dialects extensions" do
      let(:uri){ "test.rb" }
      it{ should == "wlang/ruby" }
    end
    
    context "when invoked on something else and a default value" do
      let(:uri){ "test.notanextension" }
      let(:default){ "hello" }
      it{ should == "hello" }
    end
    
    context "when invoked on something else and no default value" do
      let(:uri){ "test.notanextension" }
      let(:default){ nil }
      it{ should == "wlang/active-text" }
    end
    
  end 
end