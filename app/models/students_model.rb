require './app/models/logger_model'
require './app/helpers/event_helper'
require './app/helpers/digest_helper'
require 'observer'
require 'singleton'

class StudentsModel
  include Singleton
  include Observable
  include EventHelper
  include DigestHelper

  attr_reader :students

  def initialize
    @students = []
  end

  def add_student student_name
    @students << create_student_object(student_name)
    save_data
  end

  def delete_student student_index
    @students.delete_at student_index
    save_data
  end

  def init students_data
    init_students students_data
  end

  private
    def create_student_object student_name
      student_obj = {}
      student_obj["name"] = student_name
      student_obj["hash"] = create_digest student_name
      student_obj
    end

    def init_students students_data
      students_data.each do |student|
        @students << student
      end
    end

    def save_data
      # notify that data needs to be saved
      event_object = {:event => EVENT_AUTO_SAVE_DATA}
      send_notification(event_object)
    end
end
