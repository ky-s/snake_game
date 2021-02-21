# 画面描画を司ります。
# board オブジェクトの状態を
# skin で変換して画面表示します。
class SnakeGame
  module Renderer

    module_function

    DEFAULT_SKIN = '□■◆'

    def render_board(board, skin: nil, pause: false)
      skin ||= DEFAULT_SKIN

      refreash_screen

      puts board.field.
        map { |row| row.join.tr('.*@', skin) }.join("\r\n")

      puts "\r\nScore: #{board.score}\r\n"
      puts "     [Pause]    " if pause
    end

    def refreash_screen
      system('clear')
    end
  end
end
