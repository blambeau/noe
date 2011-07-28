module Noe
  #
  # Noe - A simple and extensible project generator
  #
  # SYNOPSIS
  #   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # COMMANDS
  # #{summarized_subcommands}
  #
  # DESCRIPTION
  #   Noe is a tool that generates projects from predefined skeletons (aka project 
  #   templates). Skeletons are designed for building specific products (a ruby 
  #   library, a static or dynamic web site, ...). Noe instantiates them and helps 
  #   you maintaining your product via meta-information provided by a .noespec yaml 
  #   file. See https://github.com/blambeau/noe for more information.
  #
  # See '#{program_name} help COMMAND' for more information on a specific command.
  #
  class Main < Quickl::Delegate(__FILE__, __LINE__)
    
    # Configuration instance
    attr_reader :config_file
    
    # Show backtrace on error?
    attr_reader :backtrace
    
    # Returns Noe's configuration, loading it if required
    def config
      @config ||= begin
        @config_file ||= find_config_file
        Config.new(@config_file)
      end
    end

    # Finds the configuration file and loads automatically
    def find_config_file
      in_home = File.join(ENV['HOME'], '.noerc')
      File.file?(in_home) ? in_home : nil
    end
    
    # Install options
    options do |opt|
      # Set a specific configuration file to use
      opt.on('--config=FILE',
             'Use a specific config file (defaults to ~/.noerc)') do |f|
        @config_file = Quickl.valid_read_file!(f)
      end
      # Show backtrace on error
      opt.on_tail("--backtrace", 
                  "Show backtrace on error") do
        @backtrace = true
      end
      Commons.add_common_options(opt)
    end
    
    # Runs the command
    def run(argv, requester = nil)
      super
    rescue WLang::Error => ex
      puts "#{ex.class}: #{ex.message}"
      back = ex.wlang_backtrace || ex.backtrace
      puts back.join("\n")
      puts ex.backtrace.join("\n") if @backtrace
    rescue Quickl::Error => ex
      raise
    rescue Noe::Error => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace.join("\n") if backtrace
    rescue StandardError => ex
      puts "Oups, Noe encountered a serious problem! Please report if a bug."
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace.join("\n")
    end

  end # class Main
end # module Noe
