begin
  *{dependencies.select{|dep| dep.groups.include?('runtime')} as dep}{require +{dep.name}}{!{"\n  "}}
rescue LoadError
  require 'rubygems'
  retry
end
