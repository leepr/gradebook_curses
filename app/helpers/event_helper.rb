module EventHelper
  EVENT_COLON_PRESSED = :event_colon
  EVENT_ERROR = :event_error
  EVENT_QUIT = :event_quit
  EVENT_FINISHED_DISPLAYING_STATUS = :event_finished_displaying_status

  def send_notification(event_object)
    changed
    notify_observers(event_object)
  end
end
