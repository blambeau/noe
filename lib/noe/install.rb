module Noe
  class Main
    #
    # Install default configuration and template (not required).
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [--force] [FOLDER]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command will install Noe's default configuration under FOLDER/.noerc 
    #   and a default ruby template under FOLDER/.noe. Unless stated otherwise, 
    #   FOLDER is user's home.
    #
    #   If FOLDER/.noerc already exists, the comand safely fails. Use --force to 
    #   override existing configuration. 
    #
    # TIP
    #   Installing default templates and configuration is NOT required. Noe uses
    #   their internal representation by default. Use 'noe install' only if you
    #   plan to create your own templates or want to tune default ones.
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
        
        # copy default templates
        tdir = Path.relative '../../templates'
        tdir.each_child do |tpl|
          target = noe_folder/tpl.basename
          if target.exists?
            if force
              target.rm_rf
            else
              puts "#{target} already exists, use --force to override"
              next
            end
          end
          tpl.cp_r(noe_folder)
        end
        
        # say something!
        puts "Noe successfully installed !"
        puts 
        puts "What's next?"
        puts " * cat #{noerc_file}"
        puts " * ls -lA #{noe_folder}"
        puts " * noe list"
        puts " * noe prepare hello_world"
        puts
        puts "Thank you for using Noe (v#{Noe::VERSION}), enjoy!"
      end

    end # class Install
  end # class Main
end # module Noe