module Noe
  module Commons
    
    # Returns configuration to use
    def config
      requester.config 
    end
    
    def templates_dir
      config.templates_dir
    end
    
    def template(name = config.default)
      Template.new(File.join(templates_dir, name))
    end

  end # module Commons
end # module Noe