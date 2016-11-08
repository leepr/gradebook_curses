require "./app/models/logger_model"
require "./app/models/property_model"
require "./app/models/storage_model"

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

      # load data
      @storage = StorageModel.new @properties
      p "Loaded data:#{@storage.data}"

      # TODO - create class to store data
      data = {
        "classes" => "Patrick"
      }

      @storage.save data
      @storage.load
      p "After saving data:#{@storage.data}"
      
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
