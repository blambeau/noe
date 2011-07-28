module Noe
  module Commons
    
    # Install options
    def self.add_common_options(opt)
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{File.basename($0 || 'noe')} #{Noe::VERSION} (c) 2011, Bernard Lambeau"
      end
      opt.on_tail('--help', "Show detailed help") do 
        raise Quickl::Help
      end
    end
      
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
    
    def find_noespec_file(args)
      # Find spec file
      spec_file = if args.size == 1
        Quickl.valid_read_file!(args.first)
      else
        spec_files = Dir['*.noespec']
        if spec_files.size > 1
          raise Noe::Error, "Ambiguous request, multiple specs: #{spec_files.join(', ')}"
        end
        spec_files.first
      end
    end

  end # module Commons
end # module Noe
