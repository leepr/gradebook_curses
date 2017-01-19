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

  def on_pressed_c_lower
    event_object = {:event => EVENT_CREATE_COURSE}
    send_notification(event_object)
    raise CaseBreakError
  end

  def on_pressed_d_lower
    event_object = {:event => EVENT_DELETE_COURSE,
      :course_index => @cursor_pos_y
    }
    send_notification(event_object)
    raise CaseBreakError
  end

  def display_data
    CoursesModel.instance.courses
  end
end
