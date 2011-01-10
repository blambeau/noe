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

      # Only make additions ?
      attr_reader :adds_only

      # Install options
      options do |opt|
        @dry_run = false
        opt.on('--dry-run', '-d',
               "Say what would be done but don't do it"){ 
          @dry_run = true
        }
        @force = false
        opt.on('--force', '-f',
               "Force overriding on all existing files"){ 
          @force = true
        }
        @adds_only = false
        opt.on('--add-only', '-a',
               "Only make additions, do not override any existing file"){ 
          @adds_only = true
        }
      end
      
      def build_one(entry, variables)
        relocated = entry.relocate(variables)
        todo = []
        
        # The file already exists, we should maybe do something
        if File.exists?(relocated)
          if force
            unless entry.directory? and File.directory?(relocated)
              todo << Rm.new(entry, variables)
            end
          elsif adds_only
            return todo
          else
            raise Noe::Error, "Noe aborted: file #{relocated} already exists.\n"\
                              "Use --force to override."
          end
        end
        
        # Create directories
        if entry.directory? and not(File.exists?(relocated))
          todo << MkDir.new(entry, variables)
          
        # Create files  
        elsif entry.file?
          todo << FileInstantiate.new(entry, variables)

        end
        todo
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
        
        # Build what has to be done
        commands = template.collect{|entry|
          build_one(entry, variables)
        }.flatten
        
        # let's go now
        if dry_run
          commands.each{|c| puts c}
        else
          commands.each{|c| c.run}
        end
        
      end
      
      class DoSomething

        attr_reader :entry
        attr_reader :variables

        def initialize(entry, variables)
          @entry, @variables = entry, variables
        end
        
        def relocated
          entry.relocate(variables)
        end

      end
        
      class MkDir < DoSomething

        def run
          FileUtils.mkdir relocated
        end
        
        def to_s
          "mkdir #{relocated}"
        end
        
      end # class MkDir
      
      class Rm < DoSomething

        def run
          FileUtils.rm_rf relocated
        end
        
        def to_s
          "rm -rf #{relocated}"
        end
        
      end # class Rm
      
      class FileInstantiate < DoSomething
        
        def run
          File.open(relocated, 'w') do |out|
            dialect = "wlang/active-string"
            out << WLang::file_instantiate(entry.realpath, variables, dialect)
          end
        end
        
        def to_s
          "wlang #{entry.path} > #{relocated}"
        end
        
      end

    end # class Go
  end # class Main
end # module Noe
