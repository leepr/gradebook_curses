require 'singleton'
require 'observer'
require './app/helpers/event_helper'

class ContextSecondaryModel
  include EventHelper
  include Observable
  include Singleton
  attr_accessor :course_index, :message

  def add_context new_context
    @context << new_context
    event_obj = { :event => EVENT_CONTEXT_ADDED,
      :context => new_context
    }
    send_notification event_obj
  end

  def replace_context new_context
    remove_context
    add_context new_context
  end

  def initialize
    @context = []
  end

  def context
    @context.last
  end

  def remove_context
    @context.pop
    event_obj = { 
      :event => EVENT_CONTEXT_REMOVED,
      :context => event_obj
    }
    send_notification event_obj
  end
end
