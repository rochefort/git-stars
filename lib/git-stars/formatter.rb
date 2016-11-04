require "colorize"
require "yaml"

class GitStars
  class Formatter
    def initialize(options)
      if options[:columns_yml]
        columns_yml = options[:columns_yml]
      else
        columns_yml = File.expand_path(File.dirname(__FILE__) + "/../config/columns.yml")
      end
      @columns = setup_colors(columns_yml) || {}
      @enable_color = options[:color]
    end

    def output(_result)
      fail "Called abstract method!!"
    end

    private

      def column_color(val, column)
        return nil unless @enable_color
        return nil unless val || !val.empty?

        color = nil
        if column == "language"
          color = @columns[column][val.downcase] if @columns[column]
        else
          color = @columns[column]
        end
        color
      end

      def setup_colors(yml_file)
        fail YmlLoadError, yml_file unless File.exist?(yml_file)
        columns = YAML.load_file(yml_file)["columns"]
        fail YmlColorError unless allowed_colors?(columns)
        columns
      rescue Psych::SyntaxError => e
        raise YmlParseError, e
      end

      def allowed_colors?(columns)
        allowed_colors = String.colors.map(&:to_s)
        columns_values = extract_values(columns)
        columns_values.all? { |color| allowed_colors.include?(color) }
      end

      def extract_values(columns)
        ret = []
        columns.each do |_k, col|
          if col.class == Hash
            ret += extract_values(col)
          else
            ret << col
          end
        end
        ret
      end
  end
end

require "git-stars/formatter/simple_formatter"
require "git-stars/formatter/terminal_table_formatter"
