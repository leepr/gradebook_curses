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

  def initialize
    init_window
  end

  def on_pressed_c_lower
    event_object = {:event => EVENT_CREATE_COURSE}
    send_notification(event_object)
    raise CaseBreakError
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
        event_object = {:event => EVENT_DELETE_COURSE,
          :course_index => @position
        }
        send_notification(event_object)
        break
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
end
