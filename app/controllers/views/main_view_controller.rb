require 'singleton'
require './app/controllers/views/menu_controller'
require './app/models/context_model'
require './app/models/courses_model'

class MainViewController
  include Singleton

  def initialize
    @context = ContextModel.instance
    @position = 0
  end

  def draw
    @window = Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.box('|', '-')
    @window.refresh

    #p "context:#{@context.context} constant:#{ContextModel::CONTEXT_COURSES}"
    draw_menu
  end

  def draw_menu
    CoursesModel.instance.courses.each_with_index do |course, i|
      @window.setpos(i+1, 4)
      @window.attrset(i==@position ? A_STANDOUT : A_NORMAL)
      @window.addstr "#{i+1}: #{course}"
    end

    while ch = @window.getch
      case ch
      when 'k'
        @position -= 1
      when 'j'
        @position += 1
        draw_menu 
        p "#else: {ch}"
      end
      @position = 1 if @position < 0
      @position = 0 if @position > 1
      draw_menu 
    end

=begin
    if @context.context == ContextModel::CONTEXT_COURSES
      draw_menu_window
    else
      LoggerModel.instance.log("does this work?")
    end
=end
    @window.refresh
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end
end
