require 'io/console'

class SnakeGame
  module KeyPrompt
    module_function

    # 入力受付ループをします。
    # block を渡して使用します。
    #
    # KeyPrompt.loop do |input|
    #   ...
    # end
    #
    # block には、入力されたキー情報が与えられます。
    #
    # 特殊入力対応
    # - Control+c が入力されたらループをやめて停止
    # - Arrow Key の入力を変換して返却
    #   '\e[A' => :ARROW_UP
    #   '\e[B' => :ARROW_DOWN
    #   '\e[C' => :ARROW_RIGHT
    #   '\e[D' => :ARROW_LEFT
    #     
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
