require 'singleton'

class ContextModel
  include Singleton
  # options: :courses, :students, :records?

  CONTEXT_COURSES = :courses
  CONTEXT_STUDENTS = :students

  attr_accessor :context

  def initialize
    @context = :courses
  end
end
