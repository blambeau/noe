require 'fileutils'
module Noe
  class Main
    #
    # Install default configuration and template
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [--force] [FOLDER]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command will install Noe's default configuration under 
    #   FOLDER/.noerc and a default ruby template under FOLDER/.noe.
    #   Unless stated otherwise, FOLDER is user's home.
    #
    #   If FOLDER/.noerc already exists, the comand safely fails. 
    #   Use --force to override existing configuration. 
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
      end

      def execute(args)
        if args.size > 1
          raise Quickl::InvalidArgument, "Needless arguments: #{args[1..-1].join(' ')}"
        end
        folder = args.first || ENV['HOME']
        
        noerc_file = File.join(folder, '.noerc')
        noe_folder = File.join(folder, '.noe')

        # generate .noerc
        if File.exists?(noerc_file) and not(force)
          raise Noe::Error, "#{noerc_file} already exists, use --force to override"
        end
        File.open(noerc_file, 'w') do |out|
          def_config = File.join(File.dirname(__FILE__), 'config.yaml')
          context = { :templates_dir => noe_folder}
          out << WLang::file_instantiate(def_config, context, 'wlang/active-string')
        end
        
        # generate .noe folder
        unless File.exists?(noe_folder)
          FileUtils.mkdir(noe_folder)
        end
        
        # copy default templates
        tdir = File.expand_path('../../../templates', __FILE__)
        Dir[File.join(tdir, '*')].each do |tpl|
          target = File.join(noe_folder, File.basename(tpl))
          if File.exists?(target)
            if force 
              FileUtils.rm_rf target
            else
              puts "#{target} already exists, use --force to override"
              next
            end
          end
          FileUtils.cp_r tpl, noe_folder
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