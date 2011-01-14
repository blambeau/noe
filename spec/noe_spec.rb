require File.expand_path('../spec_helper', __FILE__)
describe Noe do
  
  it "should have a version number" do
    Noe.const_defined?(:VERSION).should be_true
  end
  
  it "should rely on Kernel.warn, that should exists" do
    Kernel.respond_to?(:warn).should be_true
  end
  
end
