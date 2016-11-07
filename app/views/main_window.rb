require "curses"

class MainWindow
  attr_reader :window

  def initialize
    @window = Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.box('|', '-')
    @window.refresh
  end
end
