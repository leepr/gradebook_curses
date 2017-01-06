require 'singleton'
require './app/controllers/views/view_controller_main'
require "./app/models/logger_model"
require "./app/models/property_model"
require "./app/models/storage_model"
require "./app/models/courses_model"
require 'byebug'


class MainController
  include Singleton
  attr_reader :window

  def initialize
    load_data
    
    @main_view = ViewControllerMain.instance
    @main_view.init
  end

  private

  def load_data
    LoggerModel.instance.log("Starting to load storage")
    begin
      @properties = PropertyModel.instance
      @storage = StorageModel.instance
      @courses = CoursesModel.instance

      # load data
      @storage.init @properties
      @storage.load

      @courses.init @storage.data["courses"]
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
