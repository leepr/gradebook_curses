require 'singleton'
require './app/controllers/views/menu_controller'
require './app/controllers/views/view_controller_courses'
require './app/models/context_model'
require './app/models/courses_model'

class MainViewController
  include Singleton

  def initialize
    @context = ContextModel.instance
    @position = 0
  end

  def init
    if @context.context == ContextModel::CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
      @controller.add_observer(self)
    end
    @controller.draw
    #p "context:#{@context.context} constant:#{ContextModel::CONTEXT_COURSES}"
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end

  def update(event)
    p "message received by context:#{event}"
  end
end
