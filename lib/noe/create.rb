module Noe
  class Main
    #
    # Instantiate a project template
    #
    # SYNOPSIS
    #   #{command_name} [options] TEMPLATE INFO
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #   This command instantiates a template whose folder is given as first
    #   argument using the .yaml info file given as second argument
    #
    class Create < Quickl::Command(__FILE__, __LINE__)

      # Dry-run mode?
      attr_accessor :dry_run

      def templates_dir
        @templates_dir ||= find_templates_dir
      end

      def find_templates_dir
        if File.directory?(File.join(ENV['HOME'], '.noe')) 
          File.join(ENV['HOME'], '.noe')
        else
          File.expand_path('../../../templates', __FILE__)
        end
      end
      
      def find_template(name)
        dir = File.join(find_templates_dir, name)
        Template.new(dir)
      end

      # Install options
      options do |opt|
        opt.on('--dry-run', "-d",
            "Say what would be done but don't do it"){ 
          self.dry_run = true
        }
      end

      def newname(file, user_info)
        newname = File.basename(file)
        if newname =~ /__([a-z]+)__/
          varname = $1
          if x = user_info['variables'][varname]
            newname.gsub(/__([a-z]+)__/, x)
          else
            raise "Missing variable #{varname}"
          end
        else
          newname
        end
      end

      # Instantiates a file
      def instantiate(file, user_info, where)
        return if ['.', '..'].include?(File.basename(file))
        newname = newname(file, user_info)
        newfile  = File.join(where, newname)
        if File.directory?(file)
          if dry_run
            puts "mkdir #{newfile}"
          else
            FileUtils.mkdir(newfile)
          end
          Dir.foreach(file) do |child|
            instantiate(File.join(file, child), user_info, newfile)
          end
        elsif File.file?(file)
          if dry_run
            puts "#{file} -> #{newfile}"
          else
            File.open(newfile, 'w') do |out|
              context = user_info['variables']
              dialect = "wlang/active-string"
              out << WLang::file_instantiate(file, context, dialect)
            end
          end
        end
      end
      
      # Run the command
      def execute(args)
        raise Quickl::Help unless args.size == 2
        template_name, info_file = args
        template = find_template(template_name)
        user_info = YAML::load(File.read(info_file))
        Dir.foreach(template.src_folder) do |root|
          instantiate(File.join(template.src_folder, root), user_info, '.')
        end
      end

    end # class Create
  end # class Main
end # module Noe
