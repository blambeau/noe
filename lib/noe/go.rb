module Noe
  class Main
    #
    # Instantiate a project template using a .noespec file.
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] [SPEC_FILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command instantiate a project template using a .noespec file 
    #   given as first argument. If no spec file is specified, Noe expects 
    #   one .noespec file to be present in the current directory and uses it.
    # 
    #   This command is generally used immediately after invoking 'create',
    #   on an almost empty directory. By default it safely fails if any file
    #   or directory would be overriden by the instantiation process. This
    #   safe behavior can be bypassed through the --force option.
    #
    class Go < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons

      # Dry-run mode ?
      attr_reader :dry_run
      
      # Force mode ?
      attr_reader :force

      # Install options
      options do |opt|
        @dry_run = false
        opt.on('--dry-run',
               "Say what would be done but don't do it"){ 
          @dry_run = true
        }
        @force = false
        opt.on('--force',
               "Force overriding on all existing files"){ 
          @force = true
        }
      end
      
      def do_check!(entry, variables)
        relocated = entry.relocate(variables)
        if File.exists?(relocated) and not(force)
          raise Noe::Error, "Noe aborted: file #{relocated} already exists.\n"\
                            " Use --force to override."
        end
      end
      
      def do_dry!(entry, variables)
        relocated = entry.relocate(variables)
        if entry.file?
          # remove any existing file
          if File.exists?(relocated)
            puts "rm -rf #{relocated}"
          end
          # instantiate it now
          puts "wlang #{entry.path} > #{relocated}"
        elsif entry.directory?
          if File.exists?(relocated) 
            if File.file?(relocated)
              puts "rm -rf #{relocated}"
              puts "mkdir #{relocated}"
            end
          else
            puts "mkdir #{relocated}"
          end
        end
      end
      
      def do_real!(entry, variables)
        relocated = entry.relocate(variables)
        if entry.file?
          # remove any existing file
          if File.exists?(relocated)
            FileUtils.rm_rf(relocated)
          end
          # instantiate it now
          File.open(relocated, 'w') do |out|
            dialect = "wlang/active-string"
            out << WLang::file_instantiate(entry.realpath, variables, dialect)
          end
        elsif entry.directory? 
          if File.exists?(relocated) 
            if File.file?(relocated)
              FileUtils.rm_rf(relocated)
              FileUtils.mkdir(relocated)
            end
          else
            FileUtils.mkdir(relocated)
          end
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
        
        # Check that everything is ok
        template.visit do |entry|
          do_check!(entry, variables)
        end
        
        # Dry-run process
        if self.dry_run
          template.visit do |entry|
            do_dry!(entry, variables)
          end
        end
        
        # Instantiate the template now
        unless self.dry_run
          template.visit do |entry|
            do_real!(entry, variables)
          end
        end
      end

    end # class Go
  end # class Main
end # module Noe
