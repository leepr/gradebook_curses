require './app/models/logger_model'
require './app/helpers/event_helper'
require 'observer'
require 'singleton'

class CoursesModel
  include Singleton
  include Observable
  include EventHelper
  attr_reader :courses

  def initialize
    @courses = []
  end

  def add_course course_name
    @courses << course_name
    #save_data

    # notify that data needs to be saved
    event_object = {:event => EVENT_AUTO_SAVE_DATA}
    send_notification(event_object)
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
