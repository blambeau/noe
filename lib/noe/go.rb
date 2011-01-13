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
    #   safe behavior can be bypassed through the --force and --add-only 
    #   options.
    #
    # TYPICAL USAGE
    #
    #   When a fresh new project is created, this command is typically used
    #   with the following scenario
    #
    #     noe create --ruby hello_world
    #     cd hello_world
    #     edit hello_world.noespec
    #     noe go
    #
    #   If you modify your .noespec file and want to force overriding of all 
    #   files:
    #     
    #     noe go --force
    #
    #   If you want to regenerate some files only (README and gemspec, for 
    #   example):
    #
    #     rm README.md hello_world.gemspec
    #     noe go --add-only
    #
    class Go < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons

      # Dry-run mode ?
      attr_reader :dry_run
      
      # Force mode ?
      attr_reader :force
      alias :force? :force

      # Only make additions ?
      attr_reader :adds_only
      alias :adds_only? :adds_only

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
        @interactive = false
        opt.on('--interactive', '-i',
               "Request the user to take a decision on existing files"){ 
          begin
            require "highline"
          rescue LoadError
            raise Noe::Error, "Interactive mode requires highline, try 'gem install highline'"
          end
          @interactive = true
          @highline = HighLine.new
        }
        @adds_only = false
        opt.on('--add-only', '-a',
               "Only make additions, do not override any existing file"){ 
          @adds_only = true
        }
      end
      
      # Checks if the interactive mode is enabled. If yes, highline is prepared
      # as a side effect.
      def interactive?
        if @interactive and not(@highline)
          begin
            require "highline"
            @highline = HighLine.new
          rescue LoadError
            raise Quickl::Exit.new(1), "Highline is required for interactive mode, try 'gem install highline'"
          end
        else
          @interactive
        end
      end
      
      def say(what, color)
        if @highline
          @highline.say(@highline.color(what, color))
        else
          puts what
        end
      end
      
      def choose(&block)
        @highline.choose(&block)
      end
      
      # Checks if one is a file and the other a directory or the inverse
      def kind_clash?(entry, relocated)
        (entry.file? and File.directory?(relocated)) or
        (entry.directory? and File.file?(relocated))
      end
      
      def build_one_directory(entry, variables)
        relocated = entry.relocate(variables)
        todo = []
        
        skipped = false
        if File.exists?(relocated) 
          # file exists already exists, check what can be done!
          if kind_clash?(entry, relocated)
            if interactive?
              say("File #{relocated} conflicts with directory to create", :red)
              choose do |menu|
                menu.prompt = "What do we do?"
                menu.index = :letter
                menu.choice(:abord) { raise Quickl::Exit.new(1), "Noe aborted!" }
                menu.choice(:remove){ todo << Rm.new(entry, variables)          }
              end 
            elsif force?
              todo << Rm.new(entry, variables)
            else
              raise Quickl::Exit.new(2), "Noe aborted: file #{relocated} already exists.\n"\
                                         "Use --force to override or --interactive for more options."
            end
          else
            # file exists and is already a folder; we simply do nothing 
            # because there is no dangerous action here
            skipped = true
          end
        end 
        
        # Create the directory unless it has been explicitely skipped
        unless skipped
          todo << MkDir.new(entry, variables)
        end
        
        todo
      end

      def build_one_file(entry, variables)
        relocated = entry.relocate(variables)
        todo = []
        
        skipped = false
        if File.exists?(relocated)
          # name clash, the file exists
          if adds_only?
            # file exists and we are only allowed to add new things
            # we just do nothing
            skipped = true
          elsif interactive? and kind_clash?(entry, relocated)
            say("Directory #{relocated} conflicts with file to create", :red)
            choose do |menu|
              menu.prompt = "What do we do?"
              menu.index = :letter
              menu.choice(:abord) { raise Quickl::Exit.new(1), "Noe aborted!" }
              menu.choice(:remove){ todo << Rm.new(entry, variables)          }
              menu.choice(:skip)  { skipped = true                            }
            end 
          elsif interactive?
            say("File #{relocated} already exists", :red)
            choose do |menu|
              menu.prompt = "What do we do?"
              menu.index = :letter
              menu.choice(:abord)   { raise Quickl::Exit.new(1), "Noe aborted!" }
              menu.choice(:override){ todo << Rm.new(entry, variables)          }
              menu.choice(:skip)    { skipped = true                            }
            end 
          elsif force?
            todo << Rm.new(entry, variables)
          else
            raise Quickl::Exit.new(2), "Noe aborted: file #{relocated} already exists.\n"\
                                       "Use --force to override or --interactive for more options."
          end
        end
        
        # Add file instantiation unless skipped
        unless skipped
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
          if entry.file?
            build_one_file(entry, variables)
          elsif entry.directory?
            build_one_directory(entry, variables)
          end
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
        
        def template
          entry.template
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
            dialect = template.wlang_dialect_for(entry.realpath)
            variables.methodize!
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
