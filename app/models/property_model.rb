require 'singleton'
require 'yaml'

class PropertyModel
  include Singleton
  PROPERTY_FILE_PATH = './data/conf.yaml'
  DEFAULT_PROPERTIES = {
    "data_file":"./data/data.json"
  }
  attr_reader :data_uri

  def initialize
    unless File.exist? File.expand_path PROPERTY_FILE_PATH
      create_properties_file_and_populate
    end
    load_properties
  end

  private
  def create_properties_file_and_populate
     LoggerModel.instance.log "#{self.class} - Creating properties file at #{PROPERTY_FILE_PATH}"
     File.open(PROPERTY_FILE_PATH, 'w'){|f| f.write DEFAULT_PROPERTIES.to_yaml}
  end
  
  def load_properties
     LoggerModel.instance.log "#{self.class} - Loading properties from #{PROPERTY_FILE_PATH}"
     @properties = YAML::load_file PROPERTY_FILE_PATH
     @data_uri = @properties[:data_file]
  end
end
