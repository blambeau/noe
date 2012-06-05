$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'noe'
$noe_root = Path.dir.parent

module Helpers

  def fixtures_path
    Path.dir/:fixtures
  end

end
RSpec.configure do |c|
  c.include Helpers
end
