require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/models/courses_model'

class ViewControllerDeleteCourse
  include Singleton
  include Observable
  include InputHelper
  include EventHelper
  include KeyboardHelper

  WINDOW_LEFT_MARGIN = 2
  WINDOW_HEIGHT = 2

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

    @window.setpos(0, WINDOW_LEFT_MARGIN)
    @window.addstr("This operation will delete all data under that course.")
    @window.setpos(1, WINDOW_LEFT_MARGIN)
    @window.addstr("Are you sure you want to delete the course?(only 'Y' will delete course):")
    @window.refresh

    c_input = ""

    while(input = @window.getch)
      case input
      when "Y"
        # delete course
        close

        CoursesModel.instance.delete_course ContextModel.instance.course_index

        event_object = {
          :event => EVENT_DELETED_COURSE
        }
        send_notification(event_object)
        break
      else
        # cancel delete
        close
        event_object = {:event => EVENT_ESCAPE}
        send_notification(event_object)
        break
      end
    end
  end
end
