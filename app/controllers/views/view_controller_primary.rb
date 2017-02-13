require 'byebug'
require 'singleton'
Dir['./app/controllers/views/*.rb'].each{|file| require file}
Dir['./app/controllers/views/courses/*.rb'].each{|file| require file}
Dir['./app/controllers/views/students/*.rb'].each{|file| require file}
require './app/helpers/input_helper'
require './app/helpers/event_helper'
#require './app/models/context_model'
require './app/models/courses_model'

class ViewControllerPrimary
  include Singleton
  include EventHelper
  include InputHelper

=begin
  alias_method :pc, :primary_context

  def initialize
    # main window
    @primary_context = ContextModel.new
  end

  def primary_context
    @primary_context
  end

  def secondary_context
    @secondary_context
  end

  def init
    setup_input
    draw
  end

  def draw_menu_window
    @menu_controller = ViewControllerMenu.new @window
  end

  def update(event_obj)
    case event_obj[:event] 
    when EVENT_COLON_PRESSED
      @context.add_context ContextHelper::CONTEXT_CONFIG
      draw
    when EVENT_CREATE_COURSE
      @context.add_context ContextHelper::CONTEXT_CREATE_COURSE
      draw
    when EVENT_DELETE_COURSE
      @context.course_index = event_obj[:course_index]
      @context.add_context ContextHelper::CONTEXT_DELETE_COURSE
      draw
    when EVENT_DELETED_COURSE
      @context.remove_context 
      refresh_data
    when EVENT_CREATED_COURSE
      @context.remove_context 
      refresh_data
    when EVENT_ERROR
      # remove context
      @context.remove_context 

      # remove main window
      @context.message=event_obj[:message]
      @context.add_context ContextHelper::CONTEXT_ERROR
      draw
    when EVENT_ESCAPE
      @context.remove_context 
      draw
    when EVENT_FINISHED_DISPLAYING_STATUS
      @context.remove_context
      draw
    when EVENT_FORWARD_SLASH
      @context.add_context ContextHelper::CONTEXT_SEARCH_FORWARD
      @context.search_context = ContextHelper::CONTEXT_SEARCH_FORWARD
      draw
    when EVENT_JUMP_TO_LINE_NUMBER
      @context.remove_context 
      jump_to_line(@context.context, event_obj[:line_num])
    when EVENT_QUESTION_MARK
      @context.add_context ContextHelper::CONTEXT_SEARCH_BACKWARD
      @context.search_context = ContextHelper::CONTEXT_SEARCH_BACKWARD
      draw
    when EVENT_QUIT
      @context.remove_context 

      # remove main window
      close_window
    when EVENT_SEARCH_FINISHED
      @context.search_term=event_obj[:term]
      @context.remove_context 
      search_context(@context.context, true)
    when EVENT_SEARCH_INCREMENT
      @context.search_term=event_obj[:term]
      search_context(@context.secondary_context)
    when EVENT_STUDENT_CREATE
      @context.add_context ContextHelper::CONTEXT_STUDENT_CREATE
      draw
    when EVENT_STUDENT_CREATE
      @context.add_context ContextHelper::CONTEXT_STUDENT_DELETE
      draw
    when EVENT_STUDENT_CREATED
      @context.remove_context 
      draw
    when EVENT_STUDENT_DELETED
      @context.remove_context 
      draw
    when EVENT_STUDENT_MENU
      @context.remove_context
      @context.add_context ContextHelper::CONTEXT_STUDENTS
      draw
    end
  end

  private
  def close_window
    if(pc.context == ContextHelper::CONTEXT_COURSES)
      controller = ViewControllerCourses.instance
    end
    controller.close
  end

  def get_controller context
    case context
    when ContextHelper::CONTEXT_COURSES
      controller = ViewControllerCourses.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_CREATE_COURSE
      controller = ViewControllerCreateCourse.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_DELETE_COURSE
      controller = ViewControllerDeleteCourse.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_CONFIG
      controller = ViewControllerConfig.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_ERROR
      controller = ViewControllerError.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_SEARCH_FORWARD, ContextHelper::CONTEXT_SEARCH_BACKWARD
      controller = ViewControllerSearch.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_STUDENTS
      controller = ViewControllerStudents.instance
      controller.add_observer(self)
    when ContextHelper::CONTEXT_STUDENT_CREATE
      controller = ViewControllerCreateStudent.instance
      controller.add_observer(self)
    end
    controller
  end

  def refresh_data
    controller = get_controller @context.context
    controller.refresh_data
    controller.draw
  end

  def draw
    controller = get_controller pc.context
    controller.draw
  end

  def search_context(context, search_finished=false)
    controller = get_controller context
    controller.search(search_finished)
  end

  def jump_to_line(context, line_number)
    controller = get_controller context
    controller.jump_to_line(line_number)
  end
=end
end
