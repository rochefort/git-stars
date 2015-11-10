class Util
  class << self
    # https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
    def detect_terminal_size
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exists?('tput')
        [`tput cols`.to_i, `tput lines`.to_i]
      elsif STDIN.tty? && command_exists?('stty')
        `stty size`.scan(/\d+/).map(&:to_i).reverse
      else
        nil
      end
    rescue
      nil
    end

    private

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |d| File.exist? File.join(d, command) }
    end
  end
end
