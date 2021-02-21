require_relative 'snake_game/board'
require_relative 'snake_game/renderer'
require_relative 'snake_game/key_prompt'

# SnakeGame を司るクラス
# ---
#   Board クラスにゲーム盤のサイズや Snake,
#   餌などのオブジェクトをまかせて、
#   Renderer モジュールで board を定期的に render します。
#   ユーザのキー入力は sub-thread にして、
#   KeyPrompt モジュールを使用して受け取ります。
#
#   CAUTION 何故か、改行コードが \r\n でないと改行後の列が先頭に戻らない。
#
# 仕様
# ---
# 一般的な SnakeGame です。
#
# ２次元平面上の Snake が一定間隔で進行方向に移動していきます。
# Snake の進行方向は、 矢印キーか、 h,j,k,l キーで操作できます。
#
# ボード上には Snake の他に餌が常に一つあります。
# Snake が餌を取るたびに、ボード上に新しい餌がランダムで出現します。
# Snake が餌を取ると、その餌の位置を、
# Snake の尻尾が通り過ぎるときに、 Snake が成長します。
#
# Snake の頭が自分自身の体に激突したり、
# ボードからはみ出したらゲームオーバー。
# Control+c を入力されてもゲームオーバーになります。
#
# Score は Snake のサイズ(ブロック数) とほぼ等価です。
# ただし、 Snake が餌を取ったタイミングで増加します。
#
class SnakeGame
  #
  # rows, cols ボードの縦、横のサイズを指定します。
  #            Board クラスにそのまま渡します。
  #
  # speed      Snake の移動速度、実際には sleep 時間を秒で指定します。
  #
  # skin       ゲームの見た目を指定します。文字列で、
  #            空きブロック, Snakeブロック、餌ブロックの順に
  #            Charactor を指定します。
  #            e.g. '⬜⬛🔶'
  #            NOTE: GUI でのプレイも考えると、
  #            Renderer クラス自体をカスタムして渡すほうがよさそう。
  #
  def initialize(rows = 10, cols = 10, speed: 0.3, skin: nil)
    @board     = Board.new(rows, cols)
    @speed     = speed
    @skin      = skin
    @game_over = false
    @pause     = false
  end

  def run
    inkey_thread

    until @game_over
      Renderer::render_board(@board, pause: @pause, skin: @skin)

      sleep @speed

      unless @pause
        # snake が動けなくなるか、clear したら game over
        @game_over = !@board.snake_move || stage_clear?
      end
    end

    # 最終局面を表示
    Renderer::render_board(@board, skin: @skin)

    inkey_thread.kill

    puts stage_clear? ? "\r\n Stage Clear ! \r\n" :
      "\r\ngame over!!!\r\n"
  end

  private

  INKEYS_TO_DIRECTIONS = {
    "k" => :UP,
    "j" => :DOWN,
    "l" => :RIGHT,
    "h" => :LEFT,
    :ARROW_UP    => :UP,
    :ARROW_DOWN  => :DOWN,
    :ARROW_RIGHT => :RIGHT,
    :ARROW_LEFT  => :LEFT,
  }

  # キー入力を受付するスレッド
  # Control+c が押されたら終了します
  def inkey_thread
    @_inkey_thread ||= Thread.new do
      KeyPrompt.loop do |input|
        if input == ' '
          @pause = !@pause
        end

        direction = INKEYS_TO_DIRECTIONS[input]
        @board.set_snake_direction(direction) if direction
      end

      @game_over = true
    end
  end

  def game_over?
    @game_over
  end

  # snake が 全体の 1/4 を埋めたら clear
  def stage_clear?
    @board.score >= (@board.rows * @board.cols / 4)
  end
end
