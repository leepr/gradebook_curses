require 'byebug'
require 'singleton'
require './app/controllers/views/menu_controller'
require './app/controllers/views/courses/view_controller_create_course'
require './app/controllers/views/courses/view_controller_courses'
require './app/controllers/views/view_controller_config'
require './app/controllers/views/view_controller_error'
require './app/helpers/input_helper'
require './app/helpers/event_helper'
require './app/models/context_model'
require './app/models/courses_model'

class MainViewController
  include Singleton
  include EventHelper
  include InputHelper

  def initialize
    @context = ContextModel.instance
  end

  def init
    setup_input
    draw
  end

  def draw_menu_window
    @menu_controller = MenuController.new @window
  end

  def update(event_obj)
      #byebug
    case event_obj[:event] 
    when EVENT_COLON_PRESSED
      @context.add_context ContextModel::CONTEXT_CONFIG
      draw
    when EVENT_CREATE_COURSE
      @context.add_context ContextModel::CONTEXT_CREATE_COURSE
      draw
    when EVENT_CREATED_COURSE
      @context.remove_context 
      draw
    when EVENT_ERROR
      # remove context
      @context.remove_context 

      # remove main window
      @context.message=event_obj[:message]
      @context.add_context ContextModel::CONTEXT_ERROR
      draw
    when EVENT_ESCAPE
      @context.remove_context 
      draw
    when EVENT_FINISHED_DISPLAYING_STATUS
      @context.remove_context 
      draw
    when EVENT_QUIT
      @context.remove_context 

      # remove main window
      close_window
    end
  end

  private
  def close_window
    if(@context.context == ContextModel::CONTEXT_COURSES)
      @controller = ViewControllerCourses.instance
    end
    @controller.close
  end

  def draw
    case @context.context
    when ContextModel::CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
      @controller.add_observer(self)
    when ContextModel::CONTEXT_CREATE_COURSE
      @controller = ViewControllerCreateCourse.instance
      @controller.add_observer(self)
    when ContextModel::CONTEXT_CONFIG
      @controller = ViewControllerConfig.instance
      @controller.add_observer(self)
    when ContextModel::CONTEXT_ERROR
      @controller = ViewControllerError.instance
      @controller.add_observer(self)
    end
    @controller.draw
  end
end
