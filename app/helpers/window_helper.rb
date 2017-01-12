module WindowHelper
  WINDOW_BOTTOM_MARGIN = 1
  WINDOW_LEFT_MARGIN = 4
  WINDOW_VERTICAL_OFFSET = 1
  WINDOW_BOTTOM_BUFFER = 2

  def init_window
    @position = 0
    @window_offset = 0
  end

  def close
    window.close
  end

  def create_window
    new_window ||= Window.new(Curses.lines - WINDOW_BOTTOM_MARGIN, Curses.cols, 0, 0)
    new_window.clear
    setup_window new_window
    new_window
  end

  def display_entries
    # collect data to search through 
    # aggregate into a list where each element represents a line
    return @display_entries unless @display_entries.nil?
    @display_entries = []
    entries = display_data
    entries.each {|entry| 
      @display_entries << entry["display_name"]
    }
    @display_entries
  end


  def display_entry(index, entry_name)
    search_term = ContextModel.instance.search_term
    if search_term.nil?
      window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
      window.addstr "#{index+1}: #{entry_name}"
    else
      # highlight matching strings
      reg_pattern = /#{Regexp.quote(search_term)}/
      matches = entry_name.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      unless matches.empty?
        # match
        window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
        window.addstr "#{index+1}: "
        entry_name.split("").each_with_index do |letter, j|
          if in_matches(matches, j)
            window.attrset(color_pair(COLOR_PAIR_HIGHLIGHT))
          else
            window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
          end
          window.addch(letter)
        end
      else
        # no match
        window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
        window.addstr "#{index+1}: #{entry_name}"
      end
    end
  end

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
  
  def max_display_lines
    return window.maxy-WINDOW_VERTICAL_OFFSET-WINDOW_BOTTOM_BUFFER
  end

  def scroll_window_down
    @position += 1
    if((@position >= max_display_lines+@window_offset))
      @window_offset += 1 
    end
  end

  def scroll_window_up
    @position -= 1
    @window_offset -= 1 if(@position < @window_offset)
  end

  def set_window(new_window)
    @window=new_window
  end

  def window
    @window
  end
end
