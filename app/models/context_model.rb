require 'singleton'
require './app/controllers/views/view_controller_courses'

class ContextModel
  include Singleton
  # options: :courses, :students, :records?

  CONTEXT_COURSES = :courses
  CONTEXT_STUDENTS = :students

  attr_reader :context, :controller

  def initialize
    @context=:courses
    @controller = ViewControllerCourses.instance
  end

  def context=(new_context)
    @context=new_context
    case new_context
    when CONTEXT_COURSES
      @controller = ViewControllerCourses.instance
    end
  end
end
