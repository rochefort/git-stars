require 'git-stars/cli'
require 'git-stars/client'
require 'git-stars/formatter'
require 'git-stars/gem'
require 'git-stars/version'

class GitStars
  class << self
    def run
      CLI.start
    end

    def list(args)
      # TODO: formatterをparameterで指定
      formatter = TerminalTableFormatter.new(args)
      client = Client.new(args, formatter)
      client.list
    end
  end
end
