require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/models/courses_model'

class ViewControllerCourses
  include Observable
  include Singleton
  include EventHelper
  include InputHelper
  include KeyboardHelper
  WINDOW_LEFT_MARGIN = 4
  WINDOW_BOTTOM_MARGIN = 1

  def initialize
    @position = 0
    @courses = CoursesModel.instance.courses
  end

  def close
    @window.close
  end

  def create_window
    @window ||= Window.new(Curses.lines - WINDOW_BOTTOM_MARGIN, Curses.cols, 0, 0)
    @window.clear
    setup_window @window
    @window
  end

  def draw
    @window = create_window
    @window.refresh

    draw_menu 
    while ch = @window.getch
      case ch
      when KEY_C
        event_object = {:event => EVENT_CREATE_COURSE}
        send_notification(event_object)
        break
      when KEY_K
        @position -= 1
      when KEY_J
        @position += 1
      when KEY_COLON
        event_object = {:event => EVENT_COLON_PRESSED}
        send_notification(event_object)
        break
      end
      @position = (@courses.size) if @position < 0
      @position = 0 if @position > (@courses.size) 
      draw_menu 
    end
  end

  def draw_menu
    # draw courses
    @courses = CoursesModel.instance.courses
    @courses.each_with_index do |course, i|
      @window.setpos(i+1, WINDOW_LEFT_MARGIN)
      @window.attrset(i==@position ? A_STANDOUT : A_NORMAL)
      @window.addstr "#{i+1}: #{course}"
    end

    # draw menu
    @window.setpos(@courses.size+1, WINDOW_LEFT_MARGIN)
    @window.attrset(@courses.size==@position ? A_STANDOUT : A_NORMAL)
    @window.addstr("(c) create course; (d) delete course; (r) rename course")
  end
end
