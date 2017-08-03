require_relative 'board.rb'

class Game
  attr_reader :board

  def initialize(board = Board.new(size = 9))
    @board = board
  end

  def play(num)
    @board.populate_grid(num)
    until @board.over?
      @board.render
      action,pos = get_input
      if action == "r"
        @board[pos].reveal
      elsif action == "f"
        @board[pos].flag
      end
    end
    @board.render
    end_game
  end

  def get_input
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter an action and a position on the board (e.g., 'r3,4' to reveal 3,4 or 'f3,4' to flag 3,4)"
      print "> "

      begin
        input = gets.chomp
        pos = parse_pos(input)
        action = parse_action(input)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    [action,pos]
  end


  def parse_pos(string)
    string = string.chars[1..-1].join("")
    string.split(",").map { |char| Integer(char) }
  end

  def parse_action(string)
    action = string.chars[0]
  end

  def valid_pos?(pos)
    pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| x.between?(0, @board.size - 1) }
  end

  def end_game
    if @board.won?
      puts "Congratulations you won!!"
    else
      @board.grid.flatten.each{|el| el.reveal if el.val == 9}
      @board.render
      puts "Sorry you lost"
    end
  end
end

new_game = Game.new(Board.new(3))
new_game.play(1)
