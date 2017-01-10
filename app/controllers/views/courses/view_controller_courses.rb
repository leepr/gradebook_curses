require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/helpers/search_helper'
require './app/helpers/window_helper'
require './app/models/courses_model'

class ViewControllerCourses
  include Observable
  include Singleton
  include EventHelper
  include InputHelper
  include KeyboardHelper
  include SearchHelper
  include WindowHelper

  def initialize
    @position = 0
    @window_offset = 0
    @courses = CoursesModel.instance.courses
  end

  def close
    window.close
  end

  def draw
    set_window create_window
    window.refresh

    draw_menu 
    while ch = window.getch
      case ch
      when KEY_C_LOWER
        event_object = {:event => EVENT_CREATE_COURSE}
        send_notification(event_object)
        break
      when KEY_D_LOWER
        event_object = {:event => EVENT_DELETE_COURSE,
          :course_index => @position
        }
        send_notification(event_object)
        break
      when KEY_K_LOWER
        @position -= 1
        @window_offset -= 1 if(@position < @window_offset)
      when KEY_J_LOWER
        @position += 1
        if((@position >= max_display_lines+@window_offset))
          @window_offset += 1 
        end
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
        @position = (@courses.size-1)
        @window_offset = @courses.size - max_display_lines unless @courses.size < max_display_lines
      end
      if @position > (@courses.size-1) 
        @position = 0
        @window_offset = 0
      end
      draw_menu 
    end
  end

  private
  def menu_to_s
    "(c) create course; (d) delete course; (r) rename course"
  end

  def max_display_lines
    return window.maxy-WINDOW_VERTICAL_OFFSET-WINDOW_BOTTOM_BUFFER
  end

  def display_entries
    # collect data to search through 
    # aggregate into a list where each element represents a line
    return @display_entries unless @display_entries.nil?
    @display_entries = []
    courses = CoursesModel.instance.courses
    courses.each {|course| 
      @display_entries << course["display_name"]
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
end
