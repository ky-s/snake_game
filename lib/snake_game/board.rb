require_relative 'snake'

# ゲームの盤面を表すクラスです。
# 縦横サイズと Snake, 餌オブジェクトの位置管理を担当。
# また、餌 (bait) を自動で出現させたり、 Snake を移動させる制御も行います。
class SnakeGame
  class Board
    attr_reader :rows, :cols

    def initialize(rows, cols)
      @rows = rows
      @cols = cols

      @snake = initial_snake

      put_bait
    end

    def set_snake_direction(direction)
      @snake.set_direction(direction)
    end

    # Snake を進行方向へ移動させます。
    # Board からはみ出すかどうかは Board の役割としてチェックします。
    # ただし、 Snake が自身の体に激突するかどうかは snake 自身に判断してもらいます。
    # 移動できなかった場合(= game over) は false を返します。
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

    # 画面上の情報を2次元配列にして返します。
    # 空きブロックは '.'
    # Snake ブロックは '*'
    # 餌ブロックは '@'
    # で返却します。
    def field
      Array.new(@rows) { Array.new(@cols, '.') }.tap do |board|
        @snake.coordinates.each do |i, j|
          board[i][j] = '*'
        end

        i, j = *@bait_coordinate
        board[i][j] = '@'
      end
    end

    # score は、蛇の現在の体のサイズと、取得済み餌の成長分を加算した値です。
    def score
      @snake.coordinates.size +
        @snake.reserved_growth_coordinates.size
    end

    private

    # 餌をランダムで出現させます。
    # Snake の体の上には出現させません。
    def put_bait
      generated = false

      until generated
        new_bait_coordinate =
          @rows.times.zip(@cols.times).sample

        generated = !@snake.coordinates.include?(new_bait_coordinate)
      end

      @bait_coordinate = new_bait_coordinate
    end


    # Snake の初期位置を決めて、 Snake オブジェクトを生成して返します。
    # 画面中央列の後方に、行数の 1/4 のサイズで出現します。
    def initial_snake
      j = (@cols - 1) / 2
      first_size = @rows / 4

      coordinates =
        ( @rows - (first_size + 2) ).upto(@rows - 2).map { |i| [i, j] }

      Snake.new(coordinates, :UP)
    end
  end
end
