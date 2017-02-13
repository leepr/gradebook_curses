require 'byebug'
require 'singleton'
require 'observer'
require './app/helpers/event_helper'

class ContextPrimaryModel
  include Singleton
  include Observable
  include EventHelper
  attr_accessor :message, :search_context, :search_term

  def add_context new_context
    @context << new_context
    send_notification({:event => "something"})
=begin
    send_notification({:event => "something",
                       :source => self.class})
=end
  end

  def initialize
    @context = []
    #@context << CONTEXT_COURSES
  end

  def context
    # primary context
    @context.last
  end

  def remove_context
    @context.pop
  end
end
