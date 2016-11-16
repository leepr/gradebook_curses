require 'observer'
require 'singleton'
require './app/helpers/view_controllers_helper'

class ViewControllerConfig
  include ViewControllersHelper
  include Observable
  include Singleton

  WINDOW_LEFT_MARGIN = 2

  def initialize
    @position = 0
  end

  def draw
    @window = Window.new(3, Curses.cols, 0, 0)
    @window.box('x', 'o')
    @window.refresh

    draw_menu 
    while ch = @window.getch
      case ch
      when 'k'
        @position -= 1
      when 'j'
        @position += 1
      when ':'
        event_object = {:event => EVENT_COLON_PRESSED}
        send_notification(EVENT_COLON_PRESSED)
      end
      @position = (@courses.size) if @position < 0
      @position = 0 if @position > (@courses.size) 
      draw_menu 
    end
    @window.refresh
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
