module !{upper}
  module Loader
    
    def require(name, version = nil)
      require name
    rescue LoadError
      retried = true
      require "rubygems"
      gem name, version || ">= 0"
      require name
    end
    module_function :require
    
  end # module Loader
end # module !{upper}
*{dependencies.select{|dep| dep.groups.include?(:runtime)} as dep}{!{upper}::Loader.require(+{dep.name}, +{dep.version})}{!"\n"}