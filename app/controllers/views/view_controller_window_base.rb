# VERTICAL DIMENSIONS
# ------------------------
# @window_offset_top (hidden data
# ------------------------ (Screen)
# WINDOW_TOP_MARGIN
# data
# data
# data
# .
# .
# .
#
# WINDOW_BOTTOM_BUFFER
# ------------------------ (End of screen)
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
  WINDOW_TOP_MARGIN = 1
  WINDOW_BOTTOM_BUFFER = 2
  ENTRY_INDEX_SIZE = 3
  ENTRY_INDEX_CHARS = ": "

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
    # adding this line stops everything
    search_term = ContextModel.instance.search_term
    if search_term.nil?
      window.attrset(index==@cursor_pos_y ? A_STANDOUT : A_NORMAL)
      window.addstr "#{entry_str(index, entry_name)}"
    else
      # highlight matching strings
      reg_pattern = /#{Regexp.quote(search_term)}/
      matches = entry_name.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      unless matches.empty?
        # match
        window.attrset(index==@cursor_pos_y ? A_STANDOUT : A_NORMAL)
        index_str = "%-#{ENTRY_INDEX_SIZE}s" % (index+1).to_s
        window.addstr("#{index_str}" + ENTRY_INDEX_CHARS)
        entry_name.split("").each_with_index do |letter, j|
          if in_matches(matches, j)
            if(j == window.curx)
              # different color if cursor is at position
              window.attrset(color_pair(COLOR_PAIR_HIGHLIGHT_CURSOR))
            else
              window.attrset(color_pair(COLOR_PAIR_HIGHLIGHT))
            end
          else
            window.attrset(index==@cursor_pos_y ? A_STANDOUT : A_NORMAL)
          end
          window.addch(letter)
        end
      else
        # no match
        window.attrset(index==@cursor_pos_y ? A_STANDOUT : A_NORMAL)
        window.addstr "#{entry_str(index, entry_name)}"
      end
    end
  end

  def entry_str(index, entry_name)
    formatted_index = "%-#{ENTRY_INDEX_SIZE}s" % (index+1).to_s
    "#{formatted_index}#{ENTRY_INDEX_CHARS}#{entry_name}"
  end

  def update_window_offset_top
    # update @window_offset_top base on @cursor_pos_y and # of display entries
    # do nothing if everything is being shown
    return if(max_display_lines > display_entries.size)
    # do nothing if @cursor_pos_y is being displayed
    return if((@cursor_pos_y > @window_offset_top) && 
              (@cursor_pos_y < (@window_offset_top+max_display_lines)))
    if(@cursor_pos_y < @window_offset_top)
      # jump screen to position
      @window_offset_top = @cursor_pos_y
    elsif(@cursor_pos_y > (@window_offset_top+max_display_lines))
      # jump screen to show position
      if(@cursor_pos_y > (display_entries.size-max_display_lines))
        # show the last entries 
        @window_offset_top = display_entries.size-max_display_lines
      else
        # center selection in the middle of window
        @window_offset_top = @cursor_pos_y - (max_display_lines/2)
      end
    end
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
        move_cursor_up
      when KEY_J_LOWER
        move_cursor_down
      when KEY_N_LOWER
        next if no_matches?
        on_pressed_n_lower
      when KEY_N_UPPER
        next if no_matches?
        on_pressed_n_upper
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
      if @cursor_pos_y < 0
        @cursor_pos_y = (display_entries.size-1)
        @window_offset_top = display_entries.size - max_display_lines unless display_entries.size < max_display_lines
      end
      if @cursor_pos_y > (display_entries.size-1) 
        @cursor_pos_y = 0
        @window_offset_top = 0
      end
      draw_menu 
    end
  end


  def draw_menu
    window.clear
    display_entries.each_with_index do |entry, i|
      if(i<@window_offset_top || i>(@window_offset_top+@window.maxy+WINDOW_TOP_MARGIN))
        # skip if doesn't fit on screen
        next
      end
      if(i>=(@window_offset_top+max_display_lines))
        # skip if beyond screen
        next
      end
      window.setpos(i+WINDOW_TOP_MARGIN-@window_offset_top, WINDOW_LEFT_MARGIN)
      display_entry(i, entry)
    end

    # draw menu
    window.setpos(max_display_lines+WINDOW_BOTTOM_BUFFER, WINDOW_LEFT_MARGIN)
    window.attrset(display_entries.size==@cursor_pos_y ? A_STANDOUT : A_NORMAL)
    window.addstr(menu_to_s)

    # set cursor position
    window.setpos(WINDOW_TOP_MARGIN+@cursor_pos_y, 
      WINDOW_LEFT_MARGIN+@cursor_pos_x+ENTRY_INDEX_SIZE+ENTRY_INDEX_CHARS.size)
    window.refresh
  end

  def init_window
    @cursor_pos_y = 0
    @cursor_pos_x = 0
    @window_offset_top = 0
  end
  
  def max_display_lines
    return window.maxy-WINDOW_TOP_MARGIN-WINDOW_BOTTOM_BUFFER
  end

  def refresh_data
    display_entries(true)
  end

  def move_cursor_down
    @cursor_pos_y += 1
    if((@cursor_pos_y >= max_display_lines+@window_offset_top))
      @window_offset_top += 1 
    end
  end

  def move_cursor_up
    @cursor_pos_y -= 1
    @window_offset_top -= 1 if(@cursor_pos_y < @window_offset_top)
  end

  def set_window(new_window)
    @window=new_window
  end

  def window
    @window
  end

  def on_pressed_c_lower
  end

  def on_pressed_d_lower
  end

  def on_pressed_k_lower
    move_cursor_up
  end

  def on_pressed_j_lower
    move_cursor_down
  end

  def on_pressed_n_lower
    jump_to_match(true)
  end

  def on_pressed_n_upper
    jump_to_match(false)
  end

end
