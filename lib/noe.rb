module Noe
  
  VERSION = "1.0.0".freeze
  
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

end
Noe.require('quickl')
Noe.require('wlang', ">= 0.9")
require 'yaml'
require 'fileutils'
require 'noe/main'
require 'noe/help'
require 'noe/create'

