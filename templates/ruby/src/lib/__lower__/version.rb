module !{upper}
  module Version
  
    MAJOR = +{version.split('.')[0].to_i}
    MINOR = +{version.split('.')[1].to_i}
    TINY  = +{version.split('.')[2].to_i}
  
    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end
  
  end 
  VERSION = Version.to_s
end
