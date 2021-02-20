class SnakeGame
  module Renderer

    module_function

    def render_board(board)
      refreash_screen

      puts board.display + "\r\n"
    end

    def refreash_screen
      system('clear')
    end
  end
end
