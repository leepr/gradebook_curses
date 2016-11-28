require 'byebug'
require 'singleton'

class ContextModel
  include Singleton

  attr_accessor :message

  CONTEXT_CONFIG = :config
  CONTEXT_COURSES = :courses
  CONTEXT_CREATE_COURSE = :create_course
  CONTEXT_STUDENTS = :students
  CONTEXT_ERROR = :error

  def initialize
    @context = []
    @context << CONTEXT_COURSES
  end

  def add_context new_context
    @context << new_context
  end

  def remove_context
    @context.pop
  end

  def context
    @context.last
  end


end
