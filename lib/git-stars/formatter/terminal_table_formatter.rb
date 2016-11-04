require "terminal-table-unicode"
require "terminal/table"
require "terminal/cell"
require "terminal/row"
require "terminal/style"

class GitStars
  class TerminalTableFormatter < GitStars::Formatter
    HEADER_COLUMNS = %w(name description language stars last_updated)
    def output(result)
      fail NoResultError if result.empty?
      puts generate_table(result)
      puts "Result count: #{result.count}"
    end

    private

      def generate_table(result)
        display_header = HEADER_COLUMNS.map { |h| h.split("_").map(&:capitalize).join(" ") }
        table = Terminal::Table.new { |t| t << display_header }
        table.style = { width: `/usr/bin/env tput cols`.to_i }

        result.each do |gem|
          table.add_separator
          table.add_row(generate_row(gem))
        end

        stars_index = HEADER_COLUMNS.index("stars")
        table.align_column(stars_index, :right) if stars_index
        table
      end

      def generate_row(gem)
        HEADER_COLUMNS.inject([]) do |row, column|
          val = gem.send(column).to_s
          color = column_color(val, column) unless val.empty?
          row << (color ? val.send(color) : val)
        end
      end
  end
end
