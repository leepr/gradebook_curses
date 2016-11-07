require 'singleton'
class PropertyModel
  include Singleton
  def initialize
    unless File.exist? File.expand_path PROPERTY_FILE_PATH
      create_properties_file_and_populate
    end
    load_properties
  end

  private
  def create_properties_file_and_populate
     LoggerModel.instance.log "#{self.class} - Creating properties file at #{PROPERTY_FILE_PATH}"
  end
  
  def load_properties
     LoggerModel.instance.log "#{self.class} - Loading properties from #{PROPERTY_FILE_PATH}"
  end
end
