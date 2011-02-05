module Noe
  class Config
    
    # Path to the default configuration file
    DEFAULT_CONFIG_FILE = File.expand_path('../default.yaml', __FILE__)
    
    # Default configuration hash
    DEFAULT_CONFIG = YAML::load(File.read(DEFAULT_CONFIG_FILE)).merge('version' => Noe::VERSION)
    
    # Path to the configuration file
    attr_reader :file
    
    # Loaded configuration hash
    attr_reader :config
    
    # Creates a config instance from some .noerc file
    def initialize(file = DEFAULT_CONFIG_FILE)
      @config = DEFAULT_CONFIG
      @file = File.expand_path(file)
      __load unless file.nil?
    end
    
    # Loads configuration from YAML file
    def __load
      unless File.file?(file) and File.readable?(file)
        raise Noe::Error, "Not a file or not readable: #{file}"
      end

      loaded = YAML::load(File.read(file))
      unless loaded.is_a?(Hash)
        raise Noe::Error, "Corrupted or invalid config file: #{file}"
      end

      @config.merge!(loaded)
      unless File.directory?(templates_dir) and File.readable?(templates_dir)
        raise Noe::Error, "Invalid noe config, not a directory or unreadable: #{templates_dir}"
      end
    end
    
    # Returns folder where templates are located. Always returns an 
    # absolute path.
    def templates_dir
      @templates_dir ||= File.expand_path(config['templates-dir'], File.dirname(file))
    end
    
    # Returns expected noe's version
    def noe_version
      config['version']
    end
    
    # Returns the name of the default template to use
    def default
      config['default']
    end
    
    # Sets the name of the default template to use
    def default=(name)
      config['default'] = name
    end
     
    private :__load
  end # class Config
end # module Noe