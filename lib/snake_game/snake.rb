class Snake
  attr_reader :coordinates

  def initialize(coordinates, direction)
    @coordinates  = coordinates
    @direction    = direction
  end

  def set_direction(direction)
    @direction = direction
  end

  def next_head_position
    @coordinates.first.
      zip(direction_diff).map(&:sum)
  end

  def move
    @coordinates[1..-2].include?(next_head_position) and
      return false

    @coordinates =
      [next_head_position, *@coordinates[0..-2]]

    true
  end

  private

  DIRECTIONS_AND_DIFFS = {
    UP:    [-1, 0],
    DOWN:  [+1, 0],
    LEFT:  [0, -1],
    RIGHT: [0, +1]
  }

  def direction_diff
    DIRECTIONS_AND_DIFFS[@direction]
  end
end
