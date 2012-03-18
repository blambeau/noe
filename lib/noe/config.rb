module Noe
  class Config
    
    # Path to the default configuration file
    DEFAULT_CONFIG_FILE = Path.relative('default.yaml')
    
    # Default configuration hash
    DEFAULT_CONFIG = DEFAULT_CONFIG_FILE.load.merge(
      'config_file' => DEFAULT_CONFIG_FILE,
      'version'     => Noe::VERSION)
    
    # Loaded configuration hash
    attr_reader :config
    
    # Creates a config instance with a loaded Hash
    def initialize(config)
      @config = DEFAULT_CONFIG.merge(config)
    end
    
    # Creates a config instance from some .noerc file
    def self.new(arg = DEFAULT_CONFIG)
      case arg
      when Hash
        super
      when Path
        __load_from_file(arg)
      when NilClass
        super(DEFAULT_CONFIG)
      else
        raise ArgumentError, "Unable to load config from #{arg}"
      end
    end
    
    # Loads configuration from YAML file
    def self.__load_from_file(file)
      # check loaded file
      file = file.expand
      unless file.file? and file.readable?
        raise Noe::Error, "Not a file or not readable: #{file}"
      end

      # load YAML
      loaded = YAML::load(file.read)
      unless loaded.is_a?(Hash)
        raise Noe::Error, "Corrupted or invalid config file: #{file}"
      end

      # Build the config
      config_hash = loaded.merge('config_file' => file)
      config = Config.new(config_hash)
      
      # Some sanity check
      templates_dir = Path(config.templates_dir)
      unless templates_dir.dir? and templates_dir.readable?
        raise Noe::Error, "Invalid noe config, not a directory or unreadable: #{templates_dir}"
      end
      
      config
    end
    
    # Returns the path of the config file itself
    def file
      config['config_file']
    end
    
    # Returns folder where templates are located. Always returns an 
    # absolute path.
    def templates_dir
      @templates_dir ||= Path(config['templates-dir']).expand(file.dir)
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
     
  end # class Config
end # module Noe
