require File.expand_path('../spec_helper', __FILE__)
describe Noe do
  
  it "should have a version number" do
    Noe.const_defined?(:VERSION).should be_true
  end
  
end
