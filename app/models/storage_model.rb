require 'json'
require './app/models/logger_model'

class StorageModel
  attr_reader :data
  def initialize properties
    @properties = properties
  end

  def load
    load_data @properties
  end

  def save data
    save_data data
  end

  private
  def load_data properties
    LoggerModel.instance.log "#{self.class} - Initiating load data"
    if File.exist? properties.data_uri
      file = File.read(properties.data_uri)
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
