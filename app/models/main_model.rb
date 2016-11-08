require "./app/models/logger_model"
require "./app/models/property_model"

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
      StorageModel.new @properties.data_uri
    rescue Exception => error
      LoggerModel.instance.log("#{self.class} - Unable to load data using: #{error}.")
    end
  end
end
