require "tmpdir"
require "api_cache"
require "moneta"
require "octokit"

class GitStars
  class Client
    REQUEST_TIMEOUT = 20
    CACHE_TTL = 3600

    def initialize(args, formatter)
      @client = setup_client(args)
      @client.auto_paginate = !!args[:all]
      @keyword ||= args[:keyword]
      @sort ||= setup_sort(args[:sort])
      @formatter = formatter
      @refresh = !!args[:refresh]
      APICache.store = Moneta.new(:File, dir: Dir.tmpdir)
    end

    def list
      options = { fail: [], timeout: REQUEST_TIMEOUT, cache: CACHE_TTL, period: 0 }
      cache_key = "git-stars_#{@client.auto_paginate}"
      APICache.delete(cache_key) if @refresh
      result = APICache.get(cache_key, options) { @client.starred }.map { |prj| Project.new(prj) }
      result = result.find_all { |prj| prj.include?(@keyword) } if @keyword
      sort_by_val(result) if @sort
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

        client = Octokit::Client.new(netrc: true)
        fail AuthenticationError unless correct_netrc?
        client
      end

      def setup_sort(sort)
        case sort
        when "n", "name"         then "name"
        when "l", "language"     then "language"
        when "s", "stars"        then "stars"
        when "u", "last_updated" then "raw_last_updated"
        end
      end

      def correct_netrc?
        n = Netrc.read
        !!n["api.github.com"]
      end

      def sort_by_val(result)
        result.sort! do |x, y|
          x_val = x.send(@sort)
          y_val = y.send(@sort)
          case x_val
          when Fixnum, Time then y_val <=> x_val
          when String then x_val.downcase <=> y_val.downcase
          else x_val <=> y_val
          end
        end
      end
  end
end
