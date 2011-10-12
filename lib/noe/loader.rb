begin
  require "wlang"
  require "quickl"
  require "highline"
rescue LoadError
  require 'rubygems'
  retry
end
