require 'thor'

class GitStars
  class CLI < Thor
    class << self
      # override
      def command_help(shell, command_name)
        meth = normalize_command_name(command_name)
        command = all_commands[meth]
        handle_no_command_error(meth) unless command

        unless command.name == @default_command
          shell.say 'Usage:'
          shell.say "  #{banner(command)}"
          shell.say
        end
        class_options_help(shell, nil => command.options.map { |_, o| o })
        if command.long_description
          shell.say 'Description:'
          shell.print_wrapped(command.long_description, indent: 2)
        else
          shell.say command.description
        end
      end
    end

    map '-v'        => :version,
        '--version' => :version

    default_command :list

    desc :version, 'Show version'
    def version
      say "git-stars version: #{VERSION}", :green
    end

    # override
    def help(command = nil, subcommand = false)
      if command
        if self.class.subcommands.include? command
          self.class.subcommand_classes[command].help(shell, true)
        else
          self.class.command_help(shell, command)
        end
      else
        self.class.help(shell, subcommand)
        self.class.command_help(shell, @default_command)
      end
    end

    # TODO: verbose option
    # desc :list, "\033[32m(DEFAULT COMMAND)\e[0m Listing github stars", hide: true
    desc :list, '', hide: true
    option :token,       aliases: '-t', required: false, desc: 'Access token to use when connecting to the Github'
    option :user,        aliases: '-u', required: false, desc: 'User to use when connecting to the Github'
    option :password,    aliases: '-p', required: false, desc: "Password to use when connecting to the Github\n\n"

    option :all,         aliases: '-a', required: false, desc: 'Get all gems (default: 30 gems)'
    option :color,       aliases: '-c', required: false, default: true, type: :boolean, desc: 'Enable color in the output.'
    option :format,      aliases: '-f', required: false, desc: 'Specific formatter. table(default) or simple'
    option :keyword,     aliases: '-k', required: false, desc: 'Filter result by the keyword'
    option :sort,        aliases: '-s', required: false, desc: 'Sort by columns, default column is starred_at. [n]ame, [l]anuguage, [s]tars, [l]ast updated'
    option :columns_yml, aliases: '-y', required: false, desc: 'Specific columns.yml'
    option :refresh,     aliases: '-r', required: false, desc: 'Call API after removing cache'

    def list
      GitStars.list(options)
    end
  end
end
