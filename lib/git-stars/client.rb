require 'tmpdir'
require 'api_cache'
require 'moneta'
require 'octokit'

class GitStars
  class Client
    def initialize(args, formatter)
      @client = setup_client(args)
      @client.auto_paginate = true if args[:all]
      @keyword ||= args[:keyword]
      @sort ||= args[:sort]
      @formatter = formatter
      APICache.store = Moneta.new(:File, dir: Dir.tmpdir)
    end

    def list
      options = { fail: [], timeout: 20, cache: 360000 }
      result = APICache.get("git-stars1_#{@client.auto_paginate}", options) { @client.starred }.map { |gem| Gem.new(gem) }
      result = result.find_all { |gem| gem.include?(@keyword) } if @keyword
      @formatter.output(result)
    end

    private

    def setup_client(args)
      return Octokit::Client.new(access_token: args[:token]) if args[:token]

      if args[:user] || args[:password]
        # TODO: exception
        fail ArgumentError unless args[:user] && args[:password]
        return Octokit::Client.new(login: args[:user], password: args[:password])
      end

      # TODO: netrc error
      Octokit::Client.new(netrc: true)
    end
  end
end
