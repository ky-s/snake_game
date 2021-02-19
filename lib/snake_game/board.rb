require_relative 'snake'
class Board
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @snake = initial_snake
  end

  def set_snake_direction(direction)
    @snake.set_direction(direction)
  end

  def snake_move
    Range.new(0, @rows-1).include?(@snake.next_head_position[0]) or
      return false

    Range.new(0, @cols-1).include?(@snake.next_head_position[1]) or
      return false

    @snake.move
  end

  def display
    merge_snake.map(&:join).join("\r\n")
  end

  private

  def merge_snake
    Array.new(@rows) { Array.new(@cols, '.') }.tap do |board|
      @snake.coordinates.each do |i, j|
        board[i][j] = '*'
      end
    end
  end

  def initial_snake
    j = (@cols - 1) / 2

    coordinates =
      ((@rows - 5)..(@rows - 2)).each.with_index(1).map { |i| [i, j] }

    Snake.new(coordinates, :UP)
  end
end
