module Noe
  #
  # This module provides tools to load stdlib and gem dependencies.
  #
  module Loader
    
    #
    # This method allows requiring dependencies with some flexibility.
    #
    # Implemented algorithm makes greedy choices about the environment:
    # 1. It first attempts a simple <code>Kernel.require(name)</code> before 
    #    anything else (even bypassing version requirement)
    # 2. If step 1 fails with a LoadError then it falls back requiring the 
    #    gem with specified version (defaults to >= 0) and retries step 1.
    # 3. If step 2 fails with a NameError, 'rubygems' are required and step 
    #    2 is retried.
    # 4. If step 3. fails, the initial LoadError is reraised.
    #
    # Doing so ensures flexibility for the users of the library by not making
    # wrong assumptions about their environment. Testing the library is also
    # made easier, as illustrated in the examples below. Please note that this
    # method is useful to load external dependencies of your code only, not 
    # .rb files of your own library.
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
    #   Noe::Loader.require('foo', "~> 1.6")
    #
    #   # Twist the load path to use version of foo you've recently 
    #   # forked (bypass the version requirement)
    #   $LOAD_PATH.unshift ...   # or ruby -I...
    #   Noe::Loader.require('highline', "~> 1.6")
    #
    # Learn more about this pattern:
    # - http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices
    # - https://gist.github.com/54177
    #
    def require(name, version = nil)
      Kernel.require name.to_s
    rescue LoadError
      begin
        gem name.to_s, version || ">= 0"
      rescue NameError
        if $VERBOSE
          Kernel.warn "#{__FILE__}:#{__LINE__}: warning: requiring rubygems myself, "\
                      " you should use 'ruby -rubygems' instead. "\
                      "See https://gist.github.com/54177"
        end
        require "rubygems"
        gem name.to_s, version || ">= 0"
      end
      Kernel.require name.to_s
    end
    module_function :require
    
  end # module Loader
end # module Noe
Noe::Loader.require("wlang", "~> 0.10.0")
Noe::Loader.require("quickl", "~> 0.2.0")
Noe::Loader.require("highline", "~> 1.6.0")