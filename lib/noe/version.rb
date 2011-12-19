module Noe
  module Version

    MAJOR = 1
    MINOR = 6
    TINY  = 1

    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end

  end
  VERSION = Version.to_s
end
