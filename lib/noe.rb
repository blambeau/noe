module Noe
  
  # Noe's version
  VERSION = "1.0.0".freeze
  
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

Noe.require('quickl', ">= 0.2.0")
Noe.require('wlang', ">= 0.9")
require 'yaml'
require 'fileutils'
require 'noe/config'
require 'noe/template'
require 'noe/main'
require 'noe/commons'
require 'noe/help'
require 'noe/list'
require 'noe/create'
require 'noe/go'

