require_relative 'snake_game/board'
require_relative 'snake_game/renderer'
require_relative 'snake_game/key_prompt'

class SnakeGame
  def initialize(rows = 10, cols = 10, speed: 0.3)
    @board     = Board.new(rows, cols)
    @speed     = speed
    @game_over = false
    @pause     = false
  end

  def run
    inkey_thread

    until @game_over
      Renderer::render_board(@board, pause: @pause)

      sleep @speed

      unless @pause
        # snake が動けなくなるか、clear したら game over
        @game_over = !@board.snake_move || stage_clear?
      end
    end

    # 最終局面を表示
    Renderer::render_board(@board)

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
