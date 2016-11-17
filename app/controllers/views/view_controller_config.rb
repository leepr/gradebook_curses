require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'

class ViewControllerConfig
  include InputHelper
  include EventHelper
  include Observable
  include Singleton

  WINDOW_LEFT_MARGIN = 2
  WINDOW_HEIGHT = 1

  def initialize
    @position = 0
  end

  def draw
    @window = Window.new(WINDOW_HEIGHT, Curses.cols, Curses.lines-WINDOW_HEIGHT, 0)
    @window.attrset(A_NORMAL)
    @window.addstr(":")
    @window.refresh

    setup_one_line_input

    c_input = ""

    while(input = @window.getch)
      case input
      when 13
        case c_input
        when 'q'
          @window.close
          event_object = {:event => EVENT_QUIT}
          send_notification(event_object)
          break
        end
      else
        c_input << input
      end
    end

    cleanup_one_line_input
  end
end
