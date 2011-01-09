module Noe
  class Config
    
    # Default configuration hash
    DEFAULT_CONFIG = {}
    
    # Path to the configuration file
    attr_reader :file
    
    # Loaded configuration hash
    attr_reader :config
    
    # Creates a config instance from some .noerc file
    def initialize(file = nil)
      @config = DEFAULT_CONFIG
      @file = file
      __load unless file.nil?
    end
    
    # Finds the configuration file and loads automatically
    def self.find
      in_home = File.join(ENV['HOME'], '.noerc')
      if File.file?(in_home)
        Config.new(in_home)
      else
        Config.new(nil)
      end
    end
    
    # Loads configuration from YAML file
    def __load
      if File.file?(file) and File.readable?(file)
        @config.merge YAML::load(File.read(file))
      else
        raise Noe::Error, "Not a file or not readable: #{file}"
      end
    end
     
    private :__load
  end # class Config
end # module Noe