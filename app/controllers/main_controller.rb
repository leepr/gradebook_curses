require 'singleton'
require './app/controllers/menu_controller'
require './app/models/main_model'

class MainController
  include Singleton
  attr_reader :window

  def initialize
    MainModel.instance.init_load 
    
    @window = Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.box('|', '-')
    @window.refresh
    draw_menu_window
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end
end
