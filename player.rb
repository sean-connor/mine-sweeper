class Player

  def initialize(name="No Name")
    @name = name
  end

  def prompt
    puts "Make a move (X,Y,F)"
    input = gets.chomp.split(',')
  end

end
