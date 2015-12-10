require 'mb_string'
require 'unicode/display_width'
require 'git-stars/cli'
require 'git-stars/client'
require 'git-stars/util'
require 'git-stars/formatter'
require 'git-stars/project'
require 'git-stars/version'

class GitStars
  class AuthenticationError < StandardError; end
  class NoResultError < StandardError; end
  class YmlLoadError < StandardError; end
  class YmlParseError < StandardError; end
  class YmlColorError < StandardError; end
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
      puts 'See https://github.com/rochefort/git-stars#usage'
      if ENV['DEBUG']
        puts e.message
        puts e.backtrace
      end
    rescue NoResultError => _e
      puts 'No results.'
    rescue YmlLoadError => e
      puts "Specified yml is not existed: #{e.message}"
    rescue YmlParseError => e
      puts 'can not parse yml'
      puts e.message
    rescue YmlColorError => _e
      puts 'specified a disallowed color in yml'
    end

    private

    def generate_formatter(args)
      return SimpleFormatter.new(args) if args[:format] == 'simple'
      TerminalTableFormatter.new(args)
    end
  end
end
