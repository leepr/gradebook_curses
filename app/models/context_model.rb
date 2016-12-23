require 'byebug'
require 'singleton'

class ContextModel
  include Singleton

  attr_accessor :course_index, :message, :search_context, :search_term

  CONTEXT_CONFIG = :config
  CONTEXT_COURSES = :courses
  CONTEXT_CREATE_COURSE = :create_course
  CONTEXT_DELETE_COURSE = :delete_course
  CONTEXT_ERROR = :error
  CONTEXT_STUDENTS = :students
  CONTEXT_SEARCH_FORWARD = :search_forward
  CONTEXT_SEARCH_BACKWARD = :search_backward

  def add_context new_context
    @context << new_context
  end

  def initialize
    @context = []
    @context << CONTEXT_COURSES
  end

  def context
    # primary context
    @context.last
  end

  def remove_context
    @context.pop
  end

  def secondary_context
    @context[-2]
  end
end
