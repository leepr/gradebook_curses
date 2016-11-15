require 'byebug'
require 'singleton'

class ContextModel
  include Singleton
  # options: :courses, :students, :records?

  CONTEXT_COURSES = :courses
  CONTEXT_STUDENTS = :students

  attr_reader :context
  def initialize
    @context=:courses
  end

end
