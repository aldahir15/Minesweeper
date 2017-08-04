require_relative 'tile.rb'


class Board
  attr_reader :grid, :size

  # def self.empty_grid(size = 9)
  #   Array.new(size) do
  #     Array.new(size) { Tile.new(0) }
  #   end
  # end

  def initialize(size = 9)
    grid =
    Array.new(size) do
      Array.new(size) { Tile.new(0) }
    end
    @grid = grid
    @size = size
  end

  def render
    puts "  #{(0...size).to_a.join(" ")}"
    grid.each_with_index do |row, i|
      puts "#{i} #{row.map do |x|
        if x.visible
          if x.val == 9 # 9 IS THE BOMB!!
            "💣"
          else
            x.val.to_s
          end
        else
          if x.flagged
            '🚩'
          else
           '▢'
         end
        end
      end.join(" ")}"
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def populate_grid(num_bombs)
    random_bombs(num_bombs)
    place_num
  end

  def random_bombs(num)
    return false if num > @size ** 2
    num.times do
      pos = [rand(@size), rand(@size)]
      until empty?(pos)
        pos = [rand(@size),rand(@size)]
      end
      self[pos].change_val(9)
    end
  end

  def place_num
    grid.each_with_index do |row, i|
      row.each_index do |j|
        pos = [i,j]
        self[pos].change_val(bombs_nearby(pos)) if self[pos].val != 9
      end
    end
  end

  def bombs_nearby(pos)
    row, col = pos
    count = 0
    count += 1 if row+1 < @size && @grid[row+1][col].val == 9
    count += 1 if row+1 < @size && col-1 >= 0 && @grid[row+1][col-1].val == 9
    count += 1 if row+1 < @size && col+1 < @size && @grid[row+1][col+1].val == 9
    count += 1 if col-1 >= 0 && @grid[row][col-1].val == 9
    count += 1 if col+1 < @size && @grid[row][col+1].val == 9
    count += 1 if row-1 >= 0 && @grid[row-1][col].val == 9
    count += 1 if row-1 >= 0 && col-1 >= 0 && @grid[row-1][col-1].val == 9
    count += 1 if row-1 >= 0 && col+1 < @size && @grid[row-1][col+1].val == 9
    count
  end

  def empty?(pos)
    self[pos].val != 9
  end

  def won?
    # num_of_bombs = @grid.flatten.select{|el| el.val == 9 }.size
    num_of_invisible = @grid.flatten.select{|el| el.visible == false && el.val != 9 }.empty?
    # num_of_bombs == num_of_invisible
  end

  def lost?
    @grid.flatten.any?{|el| el.visible && el.val == 9}
  end

  def over?
    won? || lost?
  end

end

# new_board = Board.new
# new_board.render
# # pos = [3,3]
# # new_board[pos].change_val(1)
# # new_board[pos].reveal
# new_board.populate_grid(20)
# # new_board.grid
# new_board.render
