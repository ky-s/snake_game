# Snake を表します。
# Board の子クラスでもよかったかも？
class SnakeGame
  class Snake
    attr_reader :coordinates
    attr_reader :reserved_growth_coordinates

    #
    # coordinates  Snake の位置する座標の配列を表します。
    #              先頭が頭の位置、終端が尻尾の位置です。
    # direction    Snake の進行方向を表します。
    #              :TOP, :BOTTOM, :LEFT, :RIGHT
    #              で指定します。
    def initialize(coordinates, direction)
      @coordinates  = coordinates
      @direction    = direction
      @reserved_growth_coordinates = []
    end

      # 餌を取得したとき、tail が通り越したら成長する位置を覚えておく
    def set_growth_coordinate(coordinate)
      @reserved_growth_coordinates << coordinate
    end

    def set_direction(direction)
      @direction = direction
    end

    # 現在の進行方向で一つ移動した時に頭がくる座標を返します。
    def next_head_coordinate
      @coordinates.first.
        zip(direction_diff).map(&:sum)
    end

    # Snake を進行方向へ移動させます。
    def move
      growth =
        @coordinates[-1] == @reserved_growth_coordinates.first

      next_body_coordinates = if growth
                                # 今回成長するので reserved から外す
                                @reserved_growth_coordinates.shift

                                # 成長する時は tail の位置が消えずに残る
                                @coordinates
                              else
                                # tail の座標は含めない
                                @coordinates[0..-2]
                              end

      # 次回の頭の位置に、次回の体の位置があるかどうかの判定
      # (ぶつかり判定)
      next_body_coordinates.include?(next_head_coordinate) and
        return false

      # update coordinates
      @coordinates = [next_head_coordinate, *next_body_coordinates]

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
end
