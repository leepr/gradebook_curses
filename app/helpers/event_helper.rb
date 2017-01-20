module EventHelper
  EVENT_AUTO_SAVE_DATA = :auto_save_data
  EVENT_COLON_PRESSED = :event_colon
  EVENT_CREATE_COURSE = :event_create_course
  EVENT_CREATED_COURSE = :event_created_course
  EVENT_DELETE_COURSE = :event_delete_course
  EVENT_DELETED_COURSE = :event_deleted_course
  EVENT_ERROR = :event_error
  EVENT_ESCAPE = :event_escape
  EVENT_FINISHED_DISPLAYING_STATUS = :event_finished_displaying_status
  EVENT_FORWARD_SLASH = :event_forward_slash
  EVENT_JUMP_TO_LINE_NUMBER = :event_jump_to_line_number
  EVENT_QUESTION_MARK = :event_question_mark
  EVENT_QUIT = :event_quit
  EVENT_SEARCH_FINISHED = :event_search_finished
  EVENT_SEARCH_INCREMENT = :event_search_increment
  EVENT_STUDENT_MENU = :event_student_menu
  EVENT_STUDENT_CREATE = :event_create_student
  EVENT_STUDENT_CREATED = :event_created_student
  EVENT_STUDENT_DELETE = :event_delete_student
  EVENT_STUDENT_DELETED = :event_deleted_student

  def send_notification(event_object)
    changed
    notify_observers(event_object)
  end
end
