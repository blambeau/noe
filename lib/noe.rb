module Noe
  
  class Error < StandardError; end

end # module Noe
require 'noe/version'
require 'noe/loader'
require 'yaml'
require 'noe/ext/array'
require 'noe/ext/hash'
require 'noe/config'
require 'noe/template'

require 'noe/main'
require 'noe/commons'
require 'noe/install'
require 'noe/help'
require 'noe/list'
require 'noe/prepare'
require 'noe/go'
require 'noe/show_spec'

