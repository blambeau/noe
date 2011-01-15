module Noe
  class Main
    #
    # List available templates
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
      
      options do |opt|
        Commons.add_common_options(opt)
      end
      
      def max(i,j)
        i > j ? i : j
      end
      
      def execute(args)
        unless args.empty?
          raise Quickl::InvalidArgument, "Needless argument: #{args.join(', ')}"
        end

        tpls = Dir[File.join(templates_dir, '**')].collect{|tpldir| Template.new(tpldir)}
        columns = [:name, :version, :layouts, :summary]
        data = [ columns ] + tpls.collect{|tpl|
          begin
            columns.collect{|col| 
              if col == :layouts
                (tpl.send(col) - ["noespec"]).to_a.join(',')
              else
                tpl.send(col).to_s.strip
              end
            }
          rescue Exception => ex
            [ tpl.name, "", "", "Template error: #{ex.message}" ]
          end
        }
        lengths = data.inject([0,0,0,0]){|memo,columns|
          (0..3).collect{|i| max(memo[i], columns[i].to_s.length)}
        }
        puts "Templates available in #{templates_dir}"
        data.each_with_index do |line,i|
          current = (config.default == line[0])
          puts (current ? " -> " : "    ") +
               "%-#{lengths[0]}s   %-#{lengths[1]}s   %-#{lengths[2]}s   %-#{lengths[3]}s" % line
          if i==0
            puts "-"*lengths.inject(0){|memo,i| memo+i+3}
          end
        end
      end

    end # class List
  end # class Main
end # module Noe
