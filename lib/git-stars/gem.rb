require 'active_support'
require 'active_support/core_ext'
require 'action_view'
require 'action_view/helpers'

class GitStars
  class Gem
    include ActionView::Helpers::DateHelper

    attr_accessor :name, :description, :language, :author, :stars, :last_updated
    def initialize(gem)
      @name = gem.name || ''
      @description = gem.description || ''
      @language = gem.language || ''
      @stars = gem.stargazers_count.to_s || ''
      @author = gem.owner.login || ''
      @last_updated = actionview_time_ago_inwords(gem.updated_at) || ''
    end

    def include?(keyword)
      [@name, @description, @language, @author].any? do |c|
        c.downcase.include?(keyword.downcase)
      end
    end

    private

    def actionview_time_ago_inwords(time)
      time_ago_in_words(time) + ' ago'
    end
  end
end
