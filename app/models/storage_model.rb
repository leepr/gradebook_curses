require 'singleton'
require 'json'
require './app/helpers/event_helper'
require './app/models/logger_model'
require './app/models/courses_model'

class StorageModel
  include Singleton
  include EventHelper
  attr_reader :data

  def init properties
    @properties = properties
    @courses_model = CoursesModel.instance
    @courses_model.add_observer(self)

    load_data 
  end

  def load
    load_data
  end

  def save data
    save_data data
  end

  def update(event_obj)
    case event_obj[:event]
    when EVENT_AUTO_SAVE_DATA
      # need to save data
      data = {
        "courses" => @courses_model.courses
      }

      save_data data
    end
  end

  private
  def load_data 
    LoggerModel.instance.log "#{self.class} - Initiating load data"
    if File.exist? @properties.data_uri
      file = File.read(@properties.data_uri)
      @data = JSON.parse(file)
    else
      # empty data
      @data = {}
    end
  end

  def save_data data
    # TODO - abstract persistence to file, DB, memcache, etc.
    # write opens file, append will create file if necessary
    write_option = File.exist?(@properties.data_uri) ? "w" : "a"

    File.open(@properties.data_uri, write_option) do |f|
      f.write(data.to_json)
    end
  end
end
