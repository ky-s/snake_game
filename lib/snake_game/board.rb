require_relative 'snake'

class SnakeGame
  class Board
    def initialize(rows, cols)
      @rows = rows
      @cols = cols

      @snake = initial_snake

      put_bait
    end

    def set_snake_direction(direction)
      @snake.set_direction(direction)
    end

    def snake_move
      Range.new(0, @rows-1).include?(@snake.next_head_coordinate[0]) or
        return false

      Range.new(0, @cols-1).include?(@snake.next_head_coordinate[1]) or
        return false

      @snake.move or
        return false

      # snake eat bait
      if @snake.coordinates.first == @bait_coordinate
        @snake.set_growth_coordinate(@bait_coordinate)
        put_bait
      end

      true
    end

    def put_bait
      generated = false

      until generated
        new_bait_coordinate =
          @rows.times.zip(@cols.times).sample

        generated = !@snake.coordinates.include?(new_bait_coordinate)
      end

      @bait_coordinate = new_bait_coordinate
    end

    def display
      merge_objects.map(&:join).join("\r\n")
    end

    private

    def merge_objects
      Array.new(@rows) { Array.new(@cols, '.') }.tap do |board|
        @snake.coordinates.each do |i, j|
          board[i][j] = '*'
        end

        i, j = *@bait_coordinate
        board[i][j] = '@'
      end
    end

    def initial_snake
      j = (@cols - 1) / 2

      coordinates =
        ((@rows - 8)..(@rows - 2)).each.with_index(1).map { |i| [i, j] }

      Snake.new(coordinates, :UP)
    end
  end
end
