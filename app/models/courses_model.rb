require './app/models/logger_model'
require './app/helpers/event_helper'
require './app/helpers/digest_helper'
require 'observer'
require 'singleton'

class CoursesModel
  include Singleton
  include Observable
  include EventHelper
  include DigestHelper

  attr_reader :courses

  def initialize
    @courses = []
  end

  def add_course course_name
    @courses << create_course_object(course_name)
    save_data
  end

  def delete_course course_index
    @courses.delete_at course_index
    save_data
  end

  def init courses_data
    init_courses courses_data
  end

  private
    def create_course_object course_name
      course_obj = {}
      course_obj["display_name"] = course_name
      course_obj["hash"] = create_digest course_name
      course_obj
    end

    def init_courses courses_data
      courses_data.each do |course|
        @courses << course
      end
    end

    def save_data
      # notify that data needs to be saved
      event_object = {:event => EVENT_AUTO_SAVE_DATA}
      send_notification(event_object)
    end
end
