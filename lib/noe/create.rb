require 'fileutils'
module Noe
  class Main
    #
    # Create a fresh new project
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] PROJECT_NAME
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command guides you with the creation of a new project whose
    #   name is given as first argument. A new folder is created and a .noespec
    #   file is generated in it. The template specified in ~/.noerc under :default 
    #   is used by default. Use --template to override this. 
    #
    #   After creation, you'll have to edit the generated .noespec file then run
    #   'noe go' in the new directory.
    #
    # TYPICAL USAGE
    #
    #   # start creation of a ruby project
    #   noe create --ruby hello_world
    #   cd hello_world
    #  
    #   # edit the configuration
    #   edit hello_world.noespec
    #
    #   # launch template generation
    #   noe go
    #
    class Create < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons
      
      # Install options
      options do |opt|
        opt.on('--template=TPLNAME',
               'Set the template to use') do |name|
          config.default = name
        end
      end
      
      def execute(args)
        raise Quickl::Help unless args.size == 1

        # get project name and check folder and template
        pname = args.first
        if File.exists?(pname)
          raise Noe::Error, "File #{pname} already exists, remove it first."
        end
        tpl = template
        
        # create folder now
        FileUtils.mkdir(pname)
        
        # instantiate the configuration
        File.open(File.join(pname, "#{pname}.noespec"), 'w') do |out|
          context = {'template_name' => tpl.name}
          out << WLang::file_instantiate(tpl.spec_file, context, "wlang/active-string")
        end 
        
        # what's next
        puts "Project successfully started !"
        puts 
        puts "What's next?"
        puts " * cd #{pname}"
        puts " * vim #{pname}.noespec"
        puts " * noe go"
        puts
        puts "Thank you for using Noe (v#{Noe::VERSION}), enjoy!"
      end

    end # class Create
  end # class Main
end # module Noe
