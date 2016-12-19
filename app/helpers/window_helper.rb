module WindowHelper
  WINDOW_BOTTOM_MARGIN = 1

  def create_window
    new_window ||= Window.new(Curses.lines - WINDOW_BOTTOM_MARGIN, Curses.cols, 0, 0)
    new_window.clear
    setup_window new_window
    new_window
  end

  def window
    @window
  end

  def set_window(new_window)
    @window=new_window
  end
end
