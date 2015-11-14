require 'git-stars/cli'
require 'git-stars/client'
require 'git-stars/util'
require 'git-stars/formatter'
require 'git-stars/project'
require 'git-stars/version'
require 'git-stars/ext/string'

class GitStars
  class AuthenticationError < StandardError; end
  class NoResultError < StandardError; end
  class << self
    def run
      CLI.start
    end

    def list(args)
      formatter = generate_formatter(args)
      client = Client.new(args, formatter)
      client.list
    rescue AuthenticationError => e
      puts "#{e.class} error occured."
      if ENV['DEBUG']
        puts e.message
        puts e.backtrace
      end
    rescue NoResultError => _e
      puts 'No results.'
    end

    private

    def generate_formatter(args)
      return SimpleFormatter.new(args) if args[:format] == 'simple'
      TerminalTableFormatter.new(args)
    end
  end
end
