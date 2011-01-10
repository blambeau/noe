module Noe
  class Main
    #
    # Instantiate a project template
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] [SPEC_FILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   Instantiate the template from a .noespec file
    #
    class Go < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons

      # Dry-run mode?
      attr_accessor :dry_run

      # Install options
      options do |opt|
        opt.on('--dry-run', "-d",
            "Say what would be done but don't do it"){ 
          self.dry_run = true
        }
      end
      
      def do_dry!(entry, variables)
        relocated = entry.relocate(variables)
        if entry.file?
          puts "#{entry.path} -> #{relocated}"
        elsif entry.directory?
          puts "mkdir #{relocated}"
        end
      end
      
      def do_real!(entry, variables)
        relocated = entry.relocate(variables)
        if entry.file?
          File.open(relocated, 'w') do |out|
            dialect = "wlang/active-string"
            out << WLang::file_instantiate(entry.realpath, variables, dialect)
          end
        elsif entry.directory?
          FileUtils.mkdir(relocated)
        end
      end
      
      def execute(args)
        raise Quickl::Help if args.size > 1
        
        # Find spec file
        spec_file = if args.size == 1
          valid_read_file!(args.first)
        else
          spec_files = Dir['*.noespec']
          if spec_files.size > 1
            raise Noe::Error, "Ambiguous request, multiple specs: #{spec_files.join(', ')}"
          end
          spec_files.first
        end
        
        # Load spec now
        spec = YAML::load(File.read(spec_file))
        template = template(spec['template-info']['name'])
        variables = spec['variables']

        # instantiate the template now
        template.visit do |entry|
          if dry_run
            do_dry!(entry, variables)
          else
            do_real!(entry, variables)
          end
        end
      end

    end # class Go
  end # class Main
end # module Noe
