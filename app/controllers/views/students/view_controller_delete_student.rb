require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/models/students_model'

class ViewControllerDeleteStudent
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
    @window.addstr("This operation will delete all data under that student.")
    @window.setpos(1, WINDOW_LEFT_MARGIN)
    @window.addstr("Are you sure you want to delete the student?(only 'Y' will delete student):")
    @window.refresh

    c_input = ""

    while(input = @window.getch)
      case input
      when "Y"
        # delete student
        close

        StudentsModel.instance.delete_student ContextModel.instance.student_index

        event_object = {
          :event => EVENT_STUDENT_DELETED
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
