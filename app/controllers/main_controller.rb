require 'singleton'
require './app/controllers/views/main_view_controller'
require './app/models/main_model'

class MainController
  include Singleton
  attr_reader :window

  def initialize
    MainModel.instance.init_load 
    
    @main_view = MainViewController.instance
    @main_view.draw
  end
end
