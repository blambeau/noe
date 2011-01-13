# The following lines load your dependencies.
require 'rubygems'
gem "bundler", "~> 1.0"
require "bundler"
Bundler.require(:default)

module Noe
  
  # Noe's version
  VERSION = "1.1.0".freeze
  
  # Requires some gem
  def self.require(gem_name, version = nil, retried = false)
    begin
      Kernel.require gem_name
    rescue LoadError
      if retried
        raise
      else
        retried = true
        require 'rubygems'
        gem gem_name, version
        retry
      end
    end
  end
  
  class Error < StandardError; end

end # module Noe

require 'yaml'
require 'fileutils'
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

