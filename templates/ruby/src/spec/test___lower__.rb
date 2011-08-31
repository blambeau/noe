require File.expand_path('../spec_helper', __FILE__)
describe !{upper} do

  it "should have a version number" do
    !{upper}.const_defined?(:VERSION).should be_true
  end

end
