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

    # Install options
    options do |opt|
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
