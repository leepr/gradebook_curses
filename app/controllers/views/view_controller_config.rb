require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'

class ViewControllerConfig
  include Singleton
  include Observable
  include InputHelper
  include EventHelper
  include KeyboardHelper

  WINDOW_LEFT_MARGIN = 2
  WINDOW_HEIGHT = 1
  WINDOW_PROMPT = ":"

  def close
    unless @window.nil?
      @window.clear
      @window.refresh
      @window.close
      @window = nil
    end
  end

  def initialize
    @position = 0
  end

  def create_window
    @window ||= Window.new(WINDOW_HEIGHT, Curses.cols, Curses.lines-WINDOW_HEIGHT, 0)
    setup_input_config
    setup_window @window
    @window
  end

  def draw
    @window = create_window
    @window.attrset(A_NORMAL)
    @window.addstr(WINDOW_PROMPT)
    @window.refresh

    c_input = ""

    while(input = @window.getch)
      case input
      when KEY_ENTER
        # process input
        case c_input
        when KEY_S_LOWER
          close
          event_object = {:event => EVENT_STUDENT_MENU}
          send_notification(event_object)
          break
        when KEY_Q_LOWER
          close
          event_object = {:event => EVENT_QUIT}
          send_notification(event_object)
          break
        else
          # input not valid, show error and close window
          # if number then jump to line
          if c_input =~ /^\d+$/
            line_num = c_input.to_i
            close
            event_object = {
              :event => EVENT_JUMP_TO_LINE_NUMBER,
              :line_num => line_num-1
            }
            send_notification(event_object)
          else
            close
            event_object = {
              :event => EVENT_ERROR,
              :message => "\'#{c_input}\' is not a valid command."
            }
            send_notification(event_object)
          end
          break
        end
      when KEY_ESCAPE
        close
        event_object = {:event => EVENT_ESCAPE}
        send_notification(event_object)
        break
      when KEY_BACKSPACE
        # remove previous character
        saved_xpos = @window.curx
        inputpos = saved_xpos-WINDOW_PROMPT.size
        c_input = c_input[0..(inputpos-2)] + c_input[(inputpos)..-1]
        @window.clear
        @window.addstr(WINDOW_PROMPT + c_input)
        @window.refresh
        @window.setpos(@window.cury, saved_xpos-1)
      else
        @window.addstr("#{input}")
        @window.refresh
        # append input to current input
        c_input << input
      end
    end
  end
end
