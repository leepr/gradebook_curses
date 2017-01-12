require 'byebug'
require 'observer'
require 'singleton'
require './app/models/courses_model'
require './app/controllers/views/view_controller_window_base'

class ViewControllerCourses < ViewControllerWindowBase
  include Observable
  include Singleton

  def menu_to_s
    "(c) create course; (d) delete course; (r) rename course"
  end

  def display_data
    CoursesModel.instance.courses
  end
end
