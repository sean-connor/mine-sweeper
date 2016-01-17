load './cell.rb'
require 'byebug'
class Array
  def enqueue(value)
    push(value)
  end
  def dequeue
    shift
  end
end

class Board

  def initialize(size = 3, mines = 2)
    @grid = Array.new(size){Array.new(size){Cell.new}}
    @size = size
    populate(mines)
  end

  def [](pos)
    row = pos[0]
    col = pos[1]
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def populate(mines)
    while mines > 0
      new_mine = @grid[(0...@size).to_a.sample][(0...@size).to_a.sample]
      unless new_mine.is_bomb
        new_mine.set_bomb
        mines -= 1
      end
    end
  end

  def render
    @grid.each do |row|
      row.each do |node|
        node.render
        print "\t"
      end
      print "\n"
    end
  end

  def generate_neighbors(pos)
    possible_reveals = { #Class Constant
      TL:[-1,1],
      TC:[0,1],
      TR:[1,1],
      ML:[-1,0],
      MR:[1,0],
      BL:[-1,-1],
      BC:[0,-1],
      BR:[1,-1]
    }
    neighbors = []
    possible_reveals.each do |k,v|
      neighbors << resolve_pos(pos, v)
    end
    neighbors
  end

  def reveal(guess_pos) # Break into smaller methods
    #debugger
    flip_flag(guess_pos) if @grid[guess_pos[0]][guess_pos[1]].is_flag
    if @grid[guess_pos[0]][guess_pos[1]].is_bomb
      self[guess_pos].reveal
      return self[guess_pos].value
    end
    queue = []
    queue.enqueue(guess_pos)
    until queue.empty?
      current_pos = queue.dequeue
      neighbors = generate_neighbors(current_pos)
      bomb_count = count_bombs(current_pos)
      if bomb_count == 0
        neighbors.each do |neigh|
          queue.enqueue(neigh) if valid_reveal?(neigh)
        end
      end
      @grid[current_pos[0]][current_pos[1]].set_value(bomb_count)
      @grid[current_pos[0]][current_pos[1]].reveal
    end
  end

  def count_bombs(pos)
    bombs = 0
    neighbors = generate_neighbors(pos)
    neighbors.each do |neigh|
      if in_bounds?(neigh)
        bombs += 1 if @grid[neigh[0]][neigh[1]].is_bomb
      end
    end
    bombs
  end


  def flip_flag(pos)
    @grid[pos[0]][pos[1]].flip_flag
  end

  def resolve_pos(pos1, pos2)
    [pos1[0]+pos2[0],pos1[1]+pos2[1]]
  end

  def valid_reveal?(pos)
    if in_bounds?(pos)
      unless @grid[pos[0]][pos[1]].is_bomb
        unless @grid[pos[0]][pos[1]].is_revealed
          unless @grid[pos[0]][pos[1]].is_flag
            return true
          end
        end
      end
    end
    false
  end

  def in_bounds?(pos)
    pos[0].between?(0,@size-1) && pos[1].between?(0,@size-1)
  end

  def won?
    @grid.each_with_index do |row,ridx|
      row.each_with_index do |col,cidx|
        return false unless @grid[ridx][cidx].is_revealed || @grid[ridx][cidx].is_bomb
      end
    end
  end

end
