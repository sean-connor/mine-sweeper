

class Cell
  attr_reader :is_bomb, :value, :is_revealed, :is_flag


  def initialize
    @is_bomb = false
    @is_revealed = false
    @value = 0
    @is_flag = false
  end

  def set_bomb
    @is_bomb = true
    @value = "M"
    #@is_revealed = true
  end

  def flip_flag
    @is_flag = !@is_flag
  end

  def set_value(value)
    @value = value
  end

  def reveal
    @is_revealed = true unless @is_flag
  end

  def render
    if is_revealed
      if is_bomb
        print "M"
      else
        print value.to_s
      end
    elsif is_flag
      print "F"
    else
      print "_"
    end
  end

end
