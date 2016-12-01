require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'

class ViewControllerSearch
  include Singleton
  include Observable
  include InputHelper
  include EventHelper
  include KeyboardHelper

  WINDOW_LEFT_MARGIN = 2
  WINDOW_HEIGHT = 1
  WINDOW_PROMPT = "Search:"

  def close
    @window.clear
    @window.refresh
    @window.close
    @window = nil
  end

  def initialize
    @position = 0
  end

  def create_window
    @window ||= Window.new(WINDOW_HEIGHT, Curses.cols, Curses.lines-WINDOW_HEIGHT, 0)
    setup_input_config
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
        close
        event_object = {
          :event => EVENT_SEARCH_FINISHED,
          :term => c_input
        }
        send_notification(event_object)
        break
      when KEY_ESCAPE
        close
        event_object = {:event => EVENT_ESCAPE}
        send_notification(event_object)
        break
      else
        @window.addstr("#{input}")
        @window.refresh
        # append input to current input
        c_input << input
        event_object = {
          :event => EVENT_SEARCH_INCREMENT,
          :term => c_input
        }
        send_notification(event_object)
      end
    end
  end
end
