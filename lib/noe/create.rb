require 'fileutils'
module Noe
  class Main
    #
    # Create a fresh new project
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [options] pname
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command guides you with the creation of a new project.
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
        config = {
          'template'          => {'name'    => tpl.name, 
                                  'version' => tpl.version},
          'variables'         => tpl.spec['variables']
        }
        
        # create .noespec file
        File.open(File.join(pname, "#{pname}.noespec"), 'w') do |out|
          out << YAML::dump(config)
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
