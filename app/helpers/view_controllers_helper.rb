module ViewControllersHelper
  EVENT_COLON_PRESSED = :event_colon

  def send_notification(event, message_object)
    changed
    notify_observers(event, message_object)
  end
end
