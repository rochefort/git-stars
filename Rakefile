require 'bundler/gem_tasks'

require 'tmpdir'
require 'api_cache'
require 'moneta'
require 'octokit'

desc 'Clear API Cache'
task :clear_cache do
  APICache.store = Moneta.new(:File, dir: Dir.tmpdir)
  APICache.delete('git-stars_true')
  APICache.delete('git-stars_false')
end
