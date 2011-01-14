module !{upper}
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
    #   !{upper}::Loader.require('fileutils')
    #
    #   # Require a gem without specifing any particular version
    #   !{upper}::Loader.require('highline')
    #
    #   # Require a gem, specifing a particular version
    #   !{upper}::Loader.require('highline', "~> 1.6")
    #
    #   # Twist the load path to use version of highline you've recently 
    #   # forked (this bypass the version requirement)
    #   $LOAD_PATH.unshift ...   # or ruby -I...
    #   !{upper}::Loader.require('highline', "~> 1.6")
    #
    def require(name, version = nil)
      Kernel.require name.to_s
    rescue LoadError
      require "rubygems"
      gem name.to_s, version || ">= 0"
      Kernel.require name.to_s
    end
    module_function :require
    
  end # module Loader
end # module !{upper}
*{dependencies.select{|dep| dep.groups.include?('runtime')} as dep}{!{upper}::Loader.require(+{dep.name}, +{dep.version})}{!{"\n"}}