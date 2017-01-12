require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/helpers/search_helper'
require './app/helpers/window_helper'
require './app/errors/case_break_error'
require './app/errors/case_next_error'

class ViewControllerWindowBase
  include EventHelper
  include InputHelper
  include KeyboardHelper
  include SearchHelper
  include WindowHelper

  WINDOW_BOTTOM_MARGIN = 1
  WINDOW_LEFT_MARGIN = 4
  WINDOW_VERTICAL_OFFSET = 1
  WINDOW_BOTTOM_BUFFER = 2

  def initialize
    init_window
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

  def display_entries(refresh=false)
    LoggerModel.instance.log "refreshing entries:#{refresh}"
    # collect data to search through 
    # aggregate into a list where each element represents a line
    return @display_entries if (!@display_entries.nil? && !refresh)
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

  def init_window
    @position = 0
    @window_offset = 0
  end
  
  def max_display_lines
    return window.maxy-WINDOW_VERTICAL_OFFSET-WINDOW_BOTTOM_BUFFER
  end

  def refresh_data
    display_entries(true)
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

  def draw
    set_window create_window
    window.refresh

    draw_menu 
    while ch = window.getch
      case ch
      when KEY_C_LOWER
        begin 
          on_pressed_c_lower
        rescue CaseBreakError
          break
        rescue CaseNextError
          next
        end
      when KEY_D_LOWER
        begin 
          on_pressed_d_lower
        rescue CaseBreakError
          break
        rescue CaseNextError
          next
        end
      when KEY_K_LOWER
        scroll_window_up
      when KEY_J_LOWER
        scroll_window_down
      when KEY_N_LOWER
        next if no_matches?
        jump_to_match(true)
      when KEY_N_UPPER
        next if no_matches?
        jump_to_match(false)
      when KEY_COLON
        event_object = {:event => EVENT_COLON_PRESSED}
        send_notification(event_object)
        break
      when KEY_FORWARD_SLASH
        event_object = {:event => EVENT_FORWARD_SLASH}
        send_notification(event_object)
        break
      when KEY_QUESTION_MARK
        event_object = {:event => EVENT_QUESTION_MARK}
        send_notification(event_object)
        break
      end

      # wrap
      if @position < 0
        @position = (display_entries.size-1)
        @window_offset = display_entries.size - max_display_lines unless display_entries.size < max_display_lines
      end
      if @position > (display_entries.size-1) 
        @position = 0
        @window_offset = 0
      end
      draw_menu 
    end
  end

  def on_pressed_c_lower
  end

  def on_pressed_d_lower
  end

  def on_pressed_k_lower
  end

  def on_pressed_j_lower
  end

  def on_pressed_n_lower
  end

  def on_pressed_n_upper
  end

end
