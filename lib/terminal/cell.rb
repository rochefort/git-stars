module Terminal
  class Table
    class Cell
      def wrap(width)
        # @value.gsub!(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n") if @value

        return unless @value
        str = ''
        line_size = 0
        @value.each_char do |c|
          char_size = c.display_width
          if line_size + char_size > width + 3 # FIXME: remove magic number
            str << "\n"
            line_size = 0
          end
          str << c
          line_size += char_size
        end
        @value = str
      end
    end
  end
end
