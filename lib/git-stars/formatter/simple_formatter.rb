class GitStars
  class SimpleFormatter < GitStars::Formatter
    HEADER_COLUMNS = %w(name language stars description)
    DEFAULT_COLUMNS_SIZES = [40, 10, 6, 20]

    def output(result)
      fail NoResultError if result.empty?
      rule_columns_sizes(result)
      render_header
      render_body(result)
    end

    private

    def rule_columns_sizes(projects)
      @columns_sizes = DEFAULT_COLUMNS_SIZES.dup
      rule_max_column_size(projects, :name)
      rule_max_column_size(projects, :language)
      rule_max_description_size
    end

    def render_header
      f = @columns_sizes
      fmt = "%-#{f[0]}s %-#{f[1]}s %#{f[2]}s %-#{f[3]}s"
      puts fmt % HEADER_COLUMNS.map(&:capitalize)
      puts fmt % @columns_sizes.map { |col| '-' * col }
    end

    def render_body(projects)
      f = @columns_sizes
      projects.each do |project|
        result = ''
        HEADER_COLUMNS[0..-2].each_with_index do |column, i|
          val = project.send(column)
          color = column_color(val, column)
          fmt = (val == val.to_s.to_i) ? "%#{f[i]}s " : "%-#{f[i]}s "
          formatted_val = fmt % val
          formatted_val = formatted_val.send(color) if color
          result << formatted_val
        end
        result << project.description.mb_truncate(f.last)
        puts result
      end
    end

    def rule_max_column_size(projects, attr)
      index = HEADER_COLUMNS.index(attr.to_s)
      max_size = max_size_of(projects, attr)
      @columns_sizes[index] = max_size if max_size > @columns_sizes[index]
    end

    def max_size_of(projects, attr)
      projects.max_by { |project| project.send(attr).size }.send(attr).size
    end

    def rule_max_description_size
      terminal_width, _terminal_height = Util.detect_terminal_size
      if terminal_width
        description_width = terminal_width - @columns_sizes[0..-2].inject(&:+) - (@columns_sizes.size - 1)
        @columns_sizes[-1] = description_width if description_width >= DEFAULT_COLUMNS_SIZES.last
      end
    end
  end
end
