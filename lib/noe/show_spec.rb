module Noe
  class Main
    #
    # Show the actual noe specification that would be used by 'noe go'
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [SPEC_FILE]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command merges the .noespec file given as first parameter (or found in 
    #   the current folder) with the noespec.yaml file of the template and prints 
    #   the result on the standard output.
    #
    #   When 'noe go' is invoked, the actual specification it works with is the 
    #   merging of what you specify in your .noespec file with default values 
    #   provided by the template specification itself. In other words, your .noespec
    #   file simply overrides the default values provided in the template itself.
    #
    #   Therefore, you can always keep your .noespec files simple by not specifying
    #   entries for which the default value is ok. However, making so could lead you
    #   to forget about some template options and this command is useful is such 
    #   situations.
    #
    class ShowSpec < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons
      
      options do |opt|
        Commons.add_common_options(opt)
      end
      
      def execute(args)
        raise Quickl::Help if args.size > 1
        spec_file = find_noespec_file(args)
        spec = YAML::load(File.read(spec_file))
        template = template(spec['template-info']['name'])
        template.merge_spec(spec)
        puts template.to_yaml
      end

    end # class ShowSpec
  end # class Main
end # module Noe
