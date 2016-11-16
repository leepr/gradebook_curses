require 'observer'
require 'singleton'
require './app/helpers/view_controllers_helper'
require './app/helpers/input_helper'

class ViewControllerConfig
  include InputHelper
  include ViewControllersHelper
  include Observable
  include Singleton

  WINDOW_LEFT_MARGIN = 2
  WINDOW_HEIGHT = 1

  def initialize
    @position = 0
  end

  def draw
    @window = Window.new(WINDOW_HEIGHT, Curses.cols, Curses.lines-WINDOW_HEIGHT, 0)
    @window.attrset(A_NORMAL)
    @window.addstr(":")
    @window.refresh

    setup_one_line_input

    draw_menu 
    while(input = @window.getch)
      case input
      when 'q'
        @window.close_screen
        event_object = {:event => EVENT_COLON_PRESSED}
        send_notification(EVENT_COLON_PRESSED)
      when 13
        p "enter pressed"
      else
        c_input ||= input
      end
    end
    @window.addstr(cinput)
    @window.refresh

    cleanup_one_line_input
  end

  def draw_menu
=begin
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
=end
  end
end
