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
    @window.addstr(":")
    @window.refresh

    c_input = ""

    while(input = @window.getch)
      case input
      when KEY_ENTER
        # process input
        case c_input
        when 'q'
          close
          event_object = {:event => EVENT_QUIT}
          send_notification(event_object)
          break
        else
          # TODO: add cases for valid commands in this case block
          # input not valid, show error and close window
          close
          event_object = {
            :event => EVENT_ERROR,
            :message => "\'#{c_input}\' is not a valid command."
          }
          send_notification(event_object)
          break
        end
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
      end
    end
  end
end
