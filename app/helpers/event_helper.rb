module EventHelper
  EVENT_COLON_PRESSED = :event_colon
  EVENT_QUIT = :event_quit

  def send_notification(event_object)
    changed
    notify_observers(event_object)
  end
end
