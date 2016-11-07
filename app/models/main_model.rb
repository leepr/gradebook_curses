require "./app/models/logger_model"
require "./app/models/property_model"

require 'singleton'

class MainModel
  include Singleton

  def initialize
  end

  def init_load 
    #@storage = storage
    LoggerModel.instance.log("Starting to load storage")
    begin
      @properties = PropertyModel.instance
      #@storage.load
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
