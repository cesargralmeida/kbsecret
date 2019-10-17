# frozen_string_literal: true

module KBSecret
  class CLI
    module Command
      # The implementation of `kbsecret help`.
      class Help < Abstract
        def initialize(argv)
          super(argv) do |cli|
            cli.slop do |o|
              o.banner = I18n.t(:HELP)
            end

            cli.dreck errors: false do
              string :command
            end
          end
        end

        # @return [String] the top-level "help" string for `kbsecret`
        def toplevel_help
          I18n.t(:KBSECRET_HELP, available_commands: Command.all_command_names.join(", "))
        end

        # @see Command::Abstract#run!
        def run!
          command = cli.args[:command]

          if command.empty?
            puts toplevel_help
          elsif Command.internal?(command)
            Command.run! command, "--help"
          elsif Command.external?(command)
            cli.die "Help is not available for external commands."
          else
            cli.die "Unknown command: #{command}."
          end
        end
      end
    end
  end
end
