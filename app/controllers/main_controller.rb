require 'singleton'
require './app/controllers/views/view_controller_main'
require './app/helpers/context_helper'
require './app/helpers/input_helper'
require './app/helpers/event_helper'
require './app/models/context_primary_model'
require './app/models/context_secondary_model'
require './app/models/courses_model'
require "./app/models/logger_model"
require "./app/models/property_model"
require "./app/models/storage_model"
require 'byebug'


class MainController
  include Singleton
  include EventHelper

  attr_reader :window

  def initialize
    
    # main window
    @primary_context = ContextPrimaryModel.instance
    @primary_context.add_observer self

    # footer 
    @secondary_context = ContextSecondaryModel.instance
    @secondary_context.add_observer self

    # intialize first view
    @main_view = ViewControllerMain.instance
    @main_view.init

    # start with courses
    pc.add_context ContextHelper::CONTEXT_COURSES

    load_data
  end

  def primary_context
    @primary_context
  end

  def secondary_context
    @secondary_context
  end

  def main_view
    @main_view
  end

  def update(event_obj)
    case event_obj[:event] 
    when EVENT_COLON_PRESSED
      LoggerModel.instance.log("colon pressed.")
    when EVENT_CONFIRM_DELETE_COURSE
      course = CoursesModel.instance.get_course ContextModel.instance.course_index
      CoursesModel.instance.delete_course ContextModel.instance.course_index

      sc.message = "The course #{course[:display_name]} and its data has been deleted."
      sc.replace_context ContextHelper::CONTEXT_MESSAGE
    when EVENT_FINISHED_LOADING_DATA
      mv.draw_primary
    else
      LoggerModel.instance.log("event: #{event_obj[:event]} class:#{event_obj[:source]}")
    end
  end

  alias_method :pc, :primary_context
  alias_method :sc, :secondary_context
  alias_method :mv, :main_view

  private

  def load_data
    LoggerModel.instance.log("Starting to load storage")
    begin
      @properties = PropertyModel.instance
      @storage = StorageModel.instance
      @courses = CoursesModel.instance

      # load data
      @storage.init @properties
      @storage.add_observer(self)
      @storage.load
      @courses.init @storage.data["courses"]
      
      # finished - loading data - start views
      mv.draw_primary
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
