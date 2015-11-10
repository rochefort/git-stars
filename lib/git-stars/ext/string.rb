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

  def mb_ljust(desired_width)
    padding = desired_width - display_width
    padding > 0 ? self + ' ' * padding : self
  end

  def mb_rjust(desired_width)
    padding = desired_width - display_width
    padding > 0 ? ' ' * padding + self : self
  end

  def mb_center(desired_width)
    padding = desired_width - display_width
    if padding > 0
      right_padding = pdding / 2
      left_padding  = padding - right_padding
      left_padding + self + right
    else
      self
    end
  end
end
