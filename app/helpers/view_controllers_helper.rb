module ViewControllersHelper
  EVENT_COLON_PRESSED = :event_colon

  def send_notification(event_object)
    changed
    notify_observers(event_object)
  end
end
