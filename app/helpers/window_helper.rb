module WindowHelper
  WINDOW_BOTTOM_MARGIN = 1
  WINDOW_LEFT_MARGIN = 4
  WINDOW_VERTICAL_OFFSET = 1
  WINDOW_BOTTOM_BUFFER = 2

  def draw_menu
    window.clear
    display_entries.each_with_index do |entry, i|
      if(i<@window_offset || i>(@window_offset+@window.maxy+WINDOW_VERTICAL_OFFSET))
        # skip if doesn't fit on screen
        next
      end
      if(i>=(@window_offset+max_display_lines))
        # skip if beyond screen
        next
      end
      window.setpos(i+WINDOW_VERTICAL_OFFSET-@window_offset, WINDOW_LEFT_MARGIN)
      display_entry(i, entry)
    end

    # draw menu
    window.setpos(max_display_lines+WINDOW_BOTTOM_BUFFER, WINDOW_LEFT_MARGIN)
    window.attrset(display_entries.size==@position ? A_STANDOUT : A_NORMAL)
    window.addstr(menu_to_s)
    window.refresh
  end

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
