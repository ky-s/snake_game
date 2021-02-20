require 'io/console'

class SnakeGame
  module KeyPrompt
    module_function

    def loop
      input = nil
      until input == "\C-c"
        input = STDIN.getch

        if input == "\e"
          second_input = STDIN.getch

          if second_input == "["
            third_input = STDIN.getch

            input = case third_input
            when 'A'
              :ARROW_UP
            when 'B'
              :ARROW_DOWN
            when 'C'
              :ARROW_RIGHT
            when 'D'
              :ARROW_LEFT
            else
              "\e[#{third_input}"
            end
          else
            input = "\e#{second_input}"
          end
        end

        yield input
      end
    end
  end
end
