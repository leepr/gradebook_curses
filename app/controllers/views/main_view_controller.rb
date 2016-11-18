require 'byebug'
require 'singleton'
require './app/controllers/views/menu_controller'
require './app/controllers/views/view_controller_courses'
require './app/controllers/views/view_controller_config'
require './app/controllers/views/view_controller_error'
require './app/helpers/event_helper'
require './app/models/context_model'
require './app/models/courses_model'

class MainViewController
  include Singleton
  include EventHelper

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
      #byebug
    if event_obj[:event]==EVENT_COLON_PRESSED
      @context.add_context ContextModel::CONTEXT_CONFIG
      draw
    elsif event_obj[:event]==EVENT_ERROR
      # remove context
      @context.remove_context 

      # remove main window
      @context.message=event_obj[:message]
      @context.add_context ContextModel::CONTEXT_ERROR
      draw
    elsif event_obj[:event]==EVENT_FINISHED_DISPLAYING_STATUS
      @context.remove_context 
      draw
    elsif event_obj[:event]==EVENT_QUIT
      @context.remove_context 

      # remove main window
      close_window
    end
  end

  private
  def close_window
    if @context.context == ContextModel::CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
    end
    @controller.close
  end

  def draw
    if @context.context == ContextModel::CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
      @controller.add_observer(self)
    elsif @context.context == ContextModel::CONTEXT_CONFIG
      @controller = ViewControllerConfig.instance
      @controller.add_observer(self)
    elsif @context.context == ContextModel::CONTEXT_ERROR
      @controller = ViewControllerError.instance
      @controller.add_observer(self)
    end
    @controller.draw
  end
end
