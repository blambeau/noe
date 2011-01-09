module Noe
  class Template
    
    # Main folder of the template
    attr_reader :folder
    
    # Loaded specification
    attr_reader :spec
    
    # Creates a template instance
    def initialize(folder)
      @folder = folder
      __load
    end
    
    # Returns path to the sources folder
    def src_folder
      File.join(folder, "src")
    end
    
    # Loads the template from its folder
    def __load
      specfile = File.join(folder, "noespec.yaml")
      if File.file?(specfile)
        @spec = YAML::load(File.read(specfile))
      else
        raise IOError, "Unable to find Noe spec: #{specfile}"
      end
    end
    
    private :__load
  end # class Template
end # module Noe