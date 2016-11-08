require "./app/models/logger_model"
require "./app/models/property_model"
require "./app/models/storage_model"
require "./app/models/courses_model"

require 'singleton'

class MainModel
  include Singleton

  def initialize
  end

  def init_load 
    LoggerModel.instance.log("Starting to load storage")
    begin
      # get properties
      @properties = PropertyModel.instance
      @courses = CoursesModel.instance

      # load data
      @storage = StorageModel.new @properties
      

      # TODO - create course to store data
=begin
      data = {
        "courses" => ["Patrick", "Todd"]
      }

      @storage.save data
=end

      @storage.load

      #p "Loaded data:#{@storage.data["courses"]}"
      @courses.init_data @storage.data["courses"]
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
