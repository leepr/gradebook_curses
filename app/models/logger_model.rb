require 'singleton'
require 'date'

class LoggerModel
  include Singleton
  LOG_FILE_PATH = "./logs"

  def initialize
   @date = DateTime.now
   p Dir.pwd
   @log_path = File.join(LOG_FILE_PATH, "#{@date.strftime('%Y-%m-%d')}.log") 
  end

  def log log_msg
    File.open(@log_path, 'a') do |file|
      file.write("#{@date.strftime('%Y-%m-%d::%H:%M:%S')} - #{log_msg}\n")
    end
  end
end
