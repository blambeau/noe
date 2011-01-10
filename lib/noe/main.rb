module Noe
  #
  # Noe - Probably the simplest project generator from templates
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
  #   Noe is a project generator from templates.
  #
  # See '#{program_name} help COMMAND' for more information on a specific command.
  #
  class Main < Quickl::Delegate(__FILE__, __LINE__)
    
    # Configuration instance
    attr_reader :config_file
    
    # Returns Noe's configuration, loading it if required
    def config
      @config_file ||= find_config_file
      Config.new(@config_file)
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
             'Sets a particular config file (defaults to ~/.noerc)') do |f|
        @config_file = valid_read_file!(f)
      end
      # Show the help and exit
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      # Show version and exit
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{Noe::VERSION} (c) 2011, Bernard Lambeau"
      end
    end

  end # class Main
end # module Noe
