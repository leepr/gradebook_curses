require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/models/courses_model'

class ViewControllerCourses
  include Observable
  include Singleton
  include EventHelper
  include InputHelper
  include KeyboardHelper
  WINDOW_LEFT_MARGIN = 4
  WINDOW_BOTTOM_MARGIN = 1

  def initialize
    @position = 0
    @courses = CoursesModel.instance.courses
  end

  def close
    @window.close
  end

  def create_window
    @window ||= Window.new(Curses.lines - WINDOW_BOTTOM_MARGIN, Curses.cols, 0, 0)
    @window.clear
    setup_window @window
    @window
  end

  def draw
    @window = create_window
    @window.refresh

    draw_menu nil
    while ch = @window.getch
      case ch
      when KEY_C
        event_object = {:event => EVENT_CREATE_COURSE}
        send_notification(event_object)
        break
      when KEY_D
        event_object = {:event => EVENT_DELETE_COURSE,
          :course_index => @position
        }
        send_notification(event_object)
        break
      when KEY_K
        @position -= 1
      when KEY_J
        @position += 1
      when KEY_COLON
        event_object = {:event => EVENT_COLON_PRESSED}
        send_notification(event_object)
        break
      when KEY_FORWARD_SLASH
        event_object = {:event => EVENT_FORWARD_SLASH}
        send_notification(event_object)
        break
      end
      @position = (@courses.size-1) if @position < 0
      @position = 0 if @position > (@courses.size-1) 
      draw_menu nil
    end
  end

  def draw_menu(search_finished=false)
    # draw courses
    first_match = true
    @courses = CoursesModel.instance.courses
    @courses.each_with_index do |course, i|
      @window.setpos(i+1, WINDOW_LEFT_MARGIN)
      display_course(i, course["name"], first_match && search_finished)
    end

    # draw menu
    @window.setpos(@courses.size+1, WINDOW_LEFT_MARGIN)
    @window.attrset(@courses.size==@position ? A_STANDOUT : A_NORMAL)
    @window.addstr("(c) create course; (d) delete course; (r) rename course")
    @window.refresh
  end

  def search(finished)
    draw_menu(finished)
  end

  private
  def display_course(index, course_name, jump_to_first_match)
    search_term = ContextModel.instance.search_term
    if search_term.nil?
      @window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
      @window.addstr "#{index+1}: #{course_name}"
    else
      # highlight matching strings
      reg_pattern = /#{Regexp.quote(search_term)}/
      matches = course_name.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      unless matches.empty?
        if jump_to_first_match
          #byebug
          p "jumping to first match"
          # if first match then jump to it
          @position = @window.cury
          jump_to_first_match = false
        end
        # match
        @window.addstr "#{index+1}: "
        course_name.split("").each_with_index do |letter, j|
          if in_matches(matches, j)
            @window.attrset(color_pair(COLOR_PAIR_HIGHLIGHT))
          else
            @window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
          end
          @window.addch(letter)
        end
      else
        # no match
        @window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
        @window.addstr "#{index+1}: #{course_name}"
      end
    end
    return !jump_to_first_match
  end

  def in_matches(matches, j)
    matches.each do |match|
      return true if((j >= match.offset(0)[0]) && (j < match.offset(0)[1]))
    end
    false
  end
end
