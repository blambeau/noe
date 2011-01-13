module Noe
  class Main
    #
    # List available templates.
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} 
    #
    # DESCRIPTION
    #   This command lists project templates found in the templates folder. 
    #   The later is checked as a side effect. 
    #
    # TIP
    #   Run this command to know where templates are located!
    #
    class List < Quickl::Command(__FILE__, __LINE__)
      include Noe::Commons
      
      def execute(args)
        unless args.empty?
          raise Quickl::InvalidArgument, "Needless argument: #{args.join(', ')}"
        end

        puts "Templates located in: #{templates_dir}"
        Dir[File.join(templates_dir, '**')].collect do |tpl_dir|
          begin
            tpl = Template.new(tpl_dir)
            puts "  * %-#{25}s    %s" % [ "#{tpl.name} (v#{tpl.version})" , tpl.description ]
            tpl
          rescue => ex
            puts "  * %-#{25}s    %s" % [File.basename(tpl_dir), ex.message]
            nil
          end
        end
      end

    end # class List
  end # class Main
end # module Noe
