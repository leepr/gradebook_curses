require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/models/courses_model'

class ViewControllerCourses
  include Observable
  include Singleton
  include EventHelper
  include InputHelper
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
    setup_window @window
    @window
  end

  def draw
    @window = create_window
    @window.refresh

    draw_menu 
    while ch = @window.getch
      p "courses:#{ch}"
      case ch
      when 'k'
        @position -= 1
      when 'j'
        @position += 1
      when ':'
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
    @courses.each_with_index do |course, i|
      @window.setpos(i+1, WINDOW_LEFT_MARGIN)
      @window.attrset(i==@position ? A_STANDOUT : A_NORMAL)
      @window.addstr "#{i+1}: #{course}"
    end

    # draw menu
    @window.setpos(@courses.size+1, WINDOW_LEFT_MARGIN)
    @window.attrset(@courses.size==@position ? A_STANDOUT : A_NORMAL)
    @window.addstr("(c): create course; (d): delete course; (r): rename course; (x) exit")

    @window.setpos(10, WINDOW_LEFT_MARGIN)
    @window.addstr "pos:#{@position}"
  end
end
