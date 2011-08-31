require 'fileutils'
module Noe
  class Main
    #
    # Prepare the generation of a new project
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] [PROJECT_NAME]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command prepares the generation of a fresh new project according to 
    #   its first argument:
    #
    #   - With a project name given as first argument, a new folder is created and 
    #     a .noespec file is generated in it for the selected template (see below). 
    #
    #   - Without project name, Noe assumes that you want the current folder to
    #     be upgraded to follow the template conventions. In that case, a fresh 
    #     new .noespec file is simply generated in the current folder.
    #
    #   The template specified in ~/.noerc under :default is used by default. 
    #   Use --template=xxx to override this. 
    #
    #   After creation, you'll have to edit the generated .noespec file then run
    #   'noe go'.
    #
    # TYPICAL USAGE
    #
    #   To create a fresh new project for a given template (ruby here), play the 
    #   following scenario:
    #
    #     # start creation of a fresh new ruby project
    #     noe prepare [--template=ruby] [--layout=short] foo
    #     cd foo
    #  
    #     # edit the configuration
    #     edit foo.noespec
    #
    #     # launch template generation
    #     noe go
    #
    #   To upgrade an existing project to follow a template (ruby here), the following 
    #   scenario is worth considering:
    #
    #     # generate a .noespec file in the current folder (let assume 'foo')
    #     noe prepare [--template=ruby] [--layout=short]
    #  
    #     # edit the configuration
    #     edit foo.noespec
    #
    #     # launch template generation in interactive mode
    #     noe go --interactive
    #
    class Prepare < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons
      
      # Force mode?
      attr_reader :force
      
      # Install options
      options do |opt|
        opt.on('--template=TEMPLATE_NAME',
               "Set the template to use (try 'noe list' to see what exists)") do |name|
          config.default = name
        end
        @layout = "noespec"
        opt.on('--layout=LAYOUT',
               "Set the specification layout to use (idem)") do |l|
          @layout = l
        end
        @silent = false
        opt.on('--silent',
               "Avoid unnecessary messages"){ 
          @silent = true
        }
        @force = false
        opt.on('--force', '-f',
               "Force overriding of existing .noespec file"){ 
          @force = true
        }
        Commons.add_common_options(opt)
      end
      
      def generate_noespec_file(where)
        if File.exists?(where) and not(force)
          raise Noe::Error, "File #{where} already exists, remove it first or set --force."
        else
          tpl = template
          File.open(where, 'w') do |out|
            context = {'template_name' => tpl.name}
            out << WLang::file_instantiate(tpl.spec_layout_file(@layout), context, "wlang/active-text")
          end 
        end
        where
      end
      
      def execute(args)
        pname, where = nil, nil
        case args.size
        when 0
          pname = File.basename(File.expand_path('.'))
          where = generate_noespec_file("#{pname}.noespec")
        when 1
          pname = args.first
          FileUtils.mkdir(pname) unless File.exists?(pname)
          where = generate_noespec_file(File.join(pname, "#{pname}.noespec"))
        else
          raise Quickl::Help unless args.size > 1
        end

        # what's next
        unless @silent
          puts "Project successfully started !"
          puts 
          puts "What's next?"
          puts " * edit #{where}"
          puts " * noe go"
          puts
          puts "Thank you for using Noe (v#{Noe::VERSION}), enjoy!"
        end
      end

    end # class Create
  end # class Main
end # module Noe
