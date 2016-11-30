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
  WINDOW_PROMPT = "Enter new course name:"

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
    @window.keypad = true
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
      when KEY_BACKSPACE
        # remove previous character
        saved_xpos = @window.curx
        inputpos = saved_xpos-WINDOW_PROMPT.size
        c_input = c_input[0..(inputpos-2)] + c_input[(inputpos)..-1]
        @window.clear
        @window.addstr(WINDOW_PROMPT + c_input)
        @window.refresh
        @window.setpos(@window.cury, saved_xpos-1)
      when KEY_LEFT
        xpos = @window.curx
        # if cursor is located to the right of the prompt 
        if(xpos > (WINDOW_PROMPT.size))
          @window.setpos(@window.cury, @window.curx-1)
          @window.refresh
        end
      when KEY_RIGHT
        xpos = @window.curx
        # if cursor is located to the right of the prompt 
        if(xpos < (WINDOW_PROMPT.size+c_input.size-1))
          @window.setpos(@window.cury, @window.curx+1)
          @window.refresh
        end
      when KEY_DELETE
        @window.delch
        @window.refresh
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
