require 'tmpdir'
require 'api_cache'
require 'moneta'
require 'octokit'

class GitStars
  class Client
    REQUEST_TIMEOUT = 20
    CACHE_TTL = 3600

    def initialize(args, formatter)
      @client = setup_client(args)
      @client.auto_paginate = !!args[:all]
      @keyword ||= args[:keyword]
      @sort ||= args[:sort]
      @formatter = formatter
      APICache.store = Moneta.new(:File, dir: Dir.tmpdir)
    end

    def list
      options = { fail: [], timeout: REQUEST_TIMEOUT, cache: CACHE_TTL }
      result = APICache.get("git-stars_#{@client.auto_paginate}", options) { @client.starred }.map { |prj| Project.new(prj) }
      result = result.find_all { |prj| prj.include?(@keyword) } if @keyword
      @formatter.output(result)
    rescue Octokit::Unauthorized => e
      raise(AuthenticationError, e)
    end

    private

    def setup_client(args)
      return Octokit::Client.new(access_token: args[:token]) if args[:token]

      if args[:user] && args[:password]
        return Octokit::Client.new(login: args[:user], password: args[:password])
      end

      Octokit::Client.new(netrc: true)
    end
  end
end
