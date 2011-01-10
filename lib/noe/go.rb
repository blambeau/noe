module Noe
  class Main
    #
    # Instantiate a project template
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] TEMPLATE INFO
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command instantiates a template whose folder is given as first
    #   argument using the .yaml info file given as second argument
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
        raise Quickl::Help unless args.size == 2
        template_name, info_file = args

        # load template and user infos
        template = template(template_name)
        user_info = YAML::load(File.read(info_file))
        variables = user_info['variables']
        
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
