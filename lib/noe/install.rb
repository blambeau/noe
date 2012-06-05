module Noe
  class Main
    #
    # Install default configuration.
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [--force] [FOLDER]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command will install Noe's default configuration under FOLDER/.noerc
    #   Unless stated otherwise, FOLDER is user's home.
    #
    #   If FOLDER/.noerc already exists, the comand safely fails. Use --force to
    #   override existing configuration. 
    #
    class Install < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons
      
      # Force mode ?
      attr_reader :force

      # Install options
      options do |opt|
        @force = false
        opt.on('--force', '-f',
               "Force overriding on all existing files"){ 
          @force = true
        }
        Commons.add_common_options(opt)
      end

      def execute(args)
        if args.size > 1
          raise Quickl::InvalidArgument, "Needless arguments: #{args[1..-1].join(' ')}"
        end
        folder = Path(args.first || Path.home)
        
        noerc_file = folder/'.noerc'
        noe_folder = folder/'.noe'

        # generate .noerc
        if noerc_file.exists? and not(force)
          raise Noe::Error, "#{noerc_file} already exists, use --force to override"
        end
        noerc_file.open('w') do |out|
          def_config = Path.relative('config.yaml').to_s
          context = { :templates_dir => noe_folder.to_s }
          out << WLang::file_instantiate(def_config, context, 'wlang/active-string')
        end
        
        # generate .noe folder
        noe_folder.mkdir unless noe_folder.exists?
        
        # say something!
        puts "Noe successfully installed !"
        puts 
        puts "What's next?"
        puts " * Add templates in #{noe_folder} (look on github)"
        puts " * edit #{noerc_file}, especially the default template name"
        puts
        puts "Thank you for using Noe (v#{Noe::VERSION}), enjoy!"
      end

    end # class Install
  end # class Main
end # module Noe
