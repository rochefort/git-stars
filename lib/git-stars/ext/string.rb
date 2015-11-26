require 'unicode/display_width'
class String
  def mb_slice(width)
    return '' if empty?

    max_size = width - 3 # 3 is '...' size.
    size = 0
    slice = ''
    each_char do |c|
      char_size = c.display_width
      if size + char_size > max_size
        slice << '...'
        break
      end
      size += char_size
      slice << c
    end
    slice
  end
end
