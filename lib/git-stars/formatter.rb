require 'colorize'
require 'yaml'

class GitStars
  class Formatter
    def initialize(options)
      if options[:columns_yml]
        columns_yml = options[:columns_yml]
      else
        columns_yml = File.expand_path(File.dirname(__FILE__) + '/../config/columns.yml')
      end
      fail "Specified yml is not existed #{columns_yml}" unless File.exist?(columns_yml)
      # TODO: yml parse error
      @columns = YAML.load_file(columns_yml)['columns'] || {}
      @enable_color = options[:color]
    end

    def output(_result)
      fail 'Called abstract method!!'
    end

    private

    def column_color(val, column)
      return nil unless @enable_color
      return nil if val.empty?

      color = nil
      if column == 'language'
        color = @columns[column][val.downcase] if @columns[column]
      else
        color = @columns[column]
      end
      color
    end
  end
end

require 'git-stars/formatter/terminal_table_formatter'
require 'git-stars/formatter/list_formatter'
