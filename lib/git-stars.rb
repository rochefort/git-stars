require 'git-stars/cli'
require 'git-stars/client'
require 'git-stars/formatter'
require 'git-stars/gem'
require 'git-stars/version'

class GitStars
  class AuthenticationError < StandardError; end
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
    end

    private

    def generate_formatter(args)
      # return SomeFormatter.new() if args[:format] == 'some-format'
      TerminalTableFormatter.new(args)
    end
  end
end
