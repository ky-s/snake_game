require 'io/console'

class SnakeGame
  module KeyPrompt
    module_function

    def loop
      input = nil
      until input == "\C-c"
        input = STDIN.getch

        yield input
      end
    end
  end
end
