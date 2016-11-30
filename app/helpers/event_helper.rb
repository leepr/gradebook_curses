module EventHelper
  EVENT_AUTO_SAVE_DATA = :auto_save_data
  EVENT_COLON_PRESSED = :event_colon
  EVENT_CREATE_COURSE = :event_create_course
  EVENT_CREATED_COURSE = :event_created_course
  EVENT_DELETE_COURSE = :event_delete_course
  EVENT_DELETED_COURSE = :event_deleted_course
  EVENT_ERROR = :event_error
  EVENT_ESCAPE = :event_escape
  EVENT_FORWARD_SLASH = :event_forward_slash
  EVENT_QUIT = :event_quit
  EVENT_FINISHED_DISPLAYING_STATUS = :event_finished_displaying_status

  def send_notification(event_object)
    changed
    notify_observers(event_object)
  end
end
