require 'observer'
require 'singleton'
require './app/helpers/view_controllers_helper'
require './app/models/courses_model'

class ViewControllerCourses
  include ViewControllersHelper
  include Observable
  include Singleton

  WINDOW_LEFT_MARGIN = 4

  def initialize
    @position = 0
    @courses = CoursesModel.instance.courses
  end

  def draw
    @window = Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.box('|', '-')
    @window.refresh

    draw_menu 
    while ch = @window.getch
      case ch
      when 'k'
        @position -= 1
      when 'j'
        @position += 1
      when ':'
        p "colon\n\n"
        event_object = {:msg => "hello"}
        send_notification(EVENT_COLON_PRESSED, event_object)
      end
      @position = (@courses.size) if @position < 0
      @position = 0 if @position > (@courses.size) 
      draw_menu 
    end
    @window.refresh
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
