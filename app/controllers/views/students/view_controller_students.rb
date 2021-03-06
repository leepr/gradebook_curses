require 'byebug'
require 'observer'
require 'singleton'
require './app/helpers/event_helper'
require './app/helpers/input_helper'
require './app/helpers/keyboard_helper'
require './app/helpers/search_helper'
require './app/helpers/window_helper'
require './app/models/students_model'

class ViewControllerStudents
  include Observable
  include Singleton
  include EventHelper
  include InputHelper
  include KeyboardHelper
  include SearchHelper
  include WindowHelper
  WINDOW_LEFT_MARGIN = 4
  WINDOW_VERTICAL_OFFSET = 1

  def initialize
    @position = 0
    @students = StudentsModel.instance.students
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
        event_object = {:event => EVENT_STUDENT_CREATE}
        send_notification(event_object)
        break
      when KEY_D_LOWER
        event_object = {:event => EVENT_STUDENT_DELETE,
          :student_index => @position
        }
        send_notification(event_object)
        break
      when KEY_K_LOWER
        @position -= 1
      when KEY_J_LOWER
        @position += 1
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
      @position = (@students.size-1) if @position < 0
      @position = 0 if @position > (@students.size-1) 
      draw_menu 
    end
  end

  def draw_menu
    @students = StudentsModel.instance.students

    @students.each_with_index do |student, i|
      window.setpos(i+WINDOW_VERTICAL_OFFSET, WINDOW_LEFT_MARGIN)
      display_student(i, student["name"])
    end

    # draw menu
    window.setpos(@students.size+1, WINDOW_LEFT_MARGIN)
    window.attrset(@students.size==@position ? A_STANDOUT : A_NORMAL)
    window.addstr("(c) create student; (d) delete student; (r) rename student")
    window.refresh
  end

  def search(finished)
    #set_jump finished
    populate_matches 
    if finished == true
      jump_to_first_match
      draw
    else
      draw_menu
    end
  end

  private
  def display_data
    # collect data to search through 
    # aggregate into a list where each element represents a line
    data = []
    students = StudentsModel.instance.students
    students.each {|student|data << student["name"]}
    data
  end

  def display_student(index, student_name)
    search_term = ContextModel.instance.search_term
    if search_term.nil?
      window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
      window.addstr "#{index+1}: #{student_name}"
    else
      # highlight matching strings
      reg_pattern = /#{Regexp.quote(search_term)}/
      matches = student_name.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      unless matches.empty?
        # match
        window.attrset(index==@position ? A_STANDOUT : A_NORMAL)
        window.addstr "#{index+1}: "
        student_name.split("").each_with_index do |letter, j|
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
        window.addstr "#{index+1}: #{student_name}"
      end
    end
  end
end
