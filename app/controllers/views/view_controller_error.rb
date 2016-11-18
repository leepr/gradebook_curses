require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/models/context_model'

class ViewControllerError
  include InputHelper
  include EventHelper
  include Observable
  include Singleton

  WINDOW_HEIGHT = 1

  def initialize
    @position = 0
  end

  def draw
    @window = Window.new(WINDOW_HEIGHT, Curses.cols, Curses.lines-WINDOW_HEIGHT, 0)
    @window.attrset(A_NORMAL)
    @window.addstr("#{ContextModel.instance.message}")
    @window.refresh

    event_object = {:event => EVENT_FINISHED_DISPLAYING_STATUS}
    send_notification(event_object)
  end
end
