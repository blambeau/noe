#
# This file loads all gem dependencies of your library. It relies on the 
# [bundler gem](http://gembundler.com/) and information included in Gemfile
# to know which gems are required in which version.
#
# Note that changing the directory here is important because Bundler will
# look for a Gemfile upstream of the current process directory. Not changing
# this could lead to subtle bugs if executables depending on your library are
# execute on another ruby projects!
#
Dir.chdir(File.dirname(__FILE__)) do
  require 'rubygems'
  gem "bundler", "~> 1.0"
  require "bundler"
  Bundler.require(:default)
end
