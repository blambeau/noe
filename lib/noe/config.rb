module Noe
  class Config
    
    # Default configuration hash
    DEFAULT_CONFIG = {
      'version'       => Noe::VERSION,
      'templates-dir' => File.expand_path('../../../templates', __FILE__),
      'default'       => 'ruby'
    }
    
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
    
    # Loads configuration from YAML file
    def __load
      if File.file?(file) and File.readable?(file)
        loaded = YAML::load(File.read(file))
        if loaded.is_a?(Hash)
          @config.merge!(loaded)
        else
          raise Noe::Error, "Corrupted or invalid config file: #{file}"
        end
      else
        raise Noe::Error, "Not a file or not readable: #{file}"
      end
    end
    
    # Returns folder where templates are located
    def templates_dir
      dir = config['templates-dir']
      if File.directory?(dir) and File.readable?(dir)
        dir
      else
        raise Noe::Error, "Invalid noe config, not a directory or unreadable: #{dir}"
      end
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