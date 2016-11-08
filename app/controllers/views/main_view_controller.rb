require 'singleton'
require './app/controllers/views/menu_controller'

class MainViewController
  include Singleton

  def draw
    @window = Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.box('|', '-')
    @window.refresh

    draw_menu_window
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end
end
