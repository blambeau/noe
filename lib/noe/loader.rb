module Noe
  #
  # This module provides tools to load stdlib and gem dependencies.
  #
  module Loader
    
    #
    # This method allows requiring dependencies with some flexibility.
    #
    # If ALWAYS attempt a simple <code>Kernel.require(name)</code> before 
    # anything else. If this require fails with a LoadError then it falls
    # back requiring the gem with specified version (defaults to >= 0) then
    # retrying the require. Making so allows you to twist the load path 
    # during development, therefore bypassing version requirement to test 
    # your lib under new versions of some gems.
    #
    # Examples:
    #
    #   # Require something from the standard library
    #   Noe::Loader.require('fileutils')
    #
    #   # Require a gem without specifing any particular version
    #   Noe::Loader.require('highline')
    #
    #   # Require a gem, specifing a particular version
    #   Noe::Loader.require('highline', "~> 1.6")
    #
    #   # Twist the load path to use version of highline you've recently 
    #   # forked (this bypass the version requirement)
    #   $LOAD_PATH.unshift ...   # or ruby -I...
    #   Noe::Loader.require('highline', "~> 1.6")
    #
    # Learn more about this:
    # - http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices
    # - https://gist.github.com/54177
    #
    def require(name, version = nil)
      Kernel.require name.to_s
    rescue LoadError
      begin
        gem name.to_s, version || ">= 0"
        Kernel.require name.to_s
      rescue NameError
        if $VERBOSE
          Kernel.warn "#{__FILE__}:#{__LINE__}: warning: requiring rubygems myself, "\
                      " you should use 'ruby -rubygems' instead. "\
                      "See https://gist.github.com/54177"
        end
        require "rubygems"
        gem name.to_s, version || ">= 0"
        Kernel.require name.to_s
      end
    end
    module_function :require
    
  end # module Loader
end # module Noe
Noe::Loader.require("wlang", "~> 0.10.0")
Noe::Loader.require("quickl", "~> 0.2.0")
Noe::Loader.require("highline", "~> 1.6.0")