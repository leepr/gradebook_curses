require './app/models/logger_model'
require 'singleton'

class CoursesModel
  include Singleton
  attr_reader :courses

  def initialize
    @courses = []
  end

  def init courses_data
    init_courses courses_data
  end

  private
    def init_courses courses_data
      courses_data.each do |course|
        @courses << course
      end
    end
end
