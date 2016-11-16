require 'byebug'
require 'singleton'
require './app/controllers/views/menu_controller'
require './app/controllers/views/view_controller_courses'
require './app/controllers/views/view_controller_config'
require './app/helpers/view_controllers_helper'
require './app/models/context_model'
require './app/models/courses_model'

class MainViewController
  include ViewControllersHelper
  include Singleton

  def initialize
    @context = ContextModel.instance
  end

  def init
    draw
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end

  def update(event_obj)
    if event_obj[:event]==EVENT_COLON_PRESSED
      @context.add_context ContextModel::CONTEXT_CONFIG
    end
    draw
  end

  private
  def draw
    if @context.context == ContextModel::CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
      @controller.add_observer(self)
    elsif @context.context == ContextModel::CONTEXT_CONFIG
      @controller = ViewControllerConfig.instance
      @controller.add_observer(self)
    end
    @controller.draw
  end
end
