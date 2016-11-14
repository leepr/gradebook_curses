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
    @context.controller.draw
    #p "context:#{@context.context} constant:#{ContextModel::CONTEXT_COURSES}"
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end
end
