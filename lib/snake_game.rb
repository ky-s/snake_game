require_relative 'snake_game/board'
require_relative 'snake_game/renderer'
require_relative 'snake_game/key_prompt'

class SnakeGame
  def initialize
    @board     = Board.new(20, 20)
    @game_over = false
    @speed     = 0.3
  end

  def run
    inkey_thread

    until @game_over
      Renderer::render_board(@board)

      sleep @speed

      @game_over = !@board.snake_move
    end

    inkey_thread.kill

    puts "\r\ngame over!!!\r\n"
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
        direction = INKEYS_TO_DIRECTIONS[input]
        @board.set_snake_direction(direction) if direction
      end

      @game_over = true
    end
  end

  def game_over?
    @game_over
  end
end
