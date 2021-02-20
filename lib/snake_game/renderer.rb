class SnakeGame
  module Renderer

    module_function

    # SKIN = '□■◆'
    SKIN = '⬜⬛🔶'

    def render_board(board, skin: SKIN, pause: false)
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
