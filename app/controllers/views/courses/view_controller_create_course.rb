require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/models/courses_model'

class ViewControllerCreateCourse
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
    @window.addstr("Enter new course name:")
    @window.refresh

    c_input = ""

    while(input = @window.getch)
      case input
      when KEY_ENTER
        # process input
        if valid_course_name c_input
          close

          CoursesModel.instance.add_course c_input

          event_object = {
            :event => EVENT_CREATED_COURSE,
            :course_name => c_input
          }
          send_notification(event_object)
          break
        else
          # TODO: add cases for valid commands in this case block
          # input not valid, show error and close window
          close
          event_object = {
            :event => EVENT_ERROR,
            :message => "\'#{c_input}\' is not a valid course name."
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
        # append input to current input
        @window.addstr("#{input}")
        @window.refresh
        c_input << input
      end
    end
  end

  private
  def valid_course_name course_name
    if course_name.size == 0
      return false
    end
    true
  end
end
