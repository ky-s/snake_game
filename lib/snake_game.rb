require_relative 'snake_game/board'
require 'io/console'

class SnakeGame
  def initialize
    @board     = Board.new(20, 20)
    @game_over = false
    @speed     = 0.3
  end

  def run
    [inkey_thread, renderer_thread].map(&:join)
  end

  private

  # 定期的にボードを描画するスレッド
  # game_over? になったら終了します
  def renderer_thread
    @_renderer_thread ||= Thread.new do
      until game_over?
        sleep @speed
        render_board
        @game_over = !@board.snake_move
      end

      puts "\r\ngame over!!!\r\n"
      sleep 1
      refreash_screen

      inkey_thread.kill
    end
  end

  def render_board
    refreash_screen

    puts @board.display + "\r\n"
  end

  def refreash_screen
    system('clear')
  end

  INKEYS_TO_DIRECTIONS = {
    "k" => :UP,
    "j" => :DOWN,
    "l" => :RIGHT,
    "h" => :LEFT,
  }

  # キー入力を受付するスレッド
  # Control+c が押されたら終了します
  def inkey_thread
    @_inkey_thread ||= Thread.new do
      input = nil
      until input == "\C-c" || game_over?
        input = STDIN.getch

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
