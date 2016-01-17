load './player.rb'
load './board.rb'

class Minesweeper

  def initialize(size = 9, mines = 9, name = "no name")
    @grid = Board.new(size, mines)
    @player = Player.new(name)
  end

  def play
    value = nil
    until won?
      system ("clear")
      @grid.render
      response = @player.prompt
      position = [response[0].to_i, response[1].to_i]
      flag = response[2]
      if flag.nil?
        value = @grid.reveal(position)
        break if value == "M"
      else
        @grid.flip_flag(position)
      end
    end
    system("clear")
    @grid.render
    value == "M" ? (puts "You LOST!") : (puts "YOU WIN!")
  end

  def won?
    @grid.won?
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new(5,4,"HAH")
  game.play
end
