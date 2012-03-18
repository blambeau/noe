require 'spec_helper'
describe !{upper} do

  it "should have a version number" do
    !{upper}.const_defined?(:VERSION).should be_true
  end

end
