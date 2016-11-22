module InputHelper
  def setup_window window
    window.keypad=true
  end

  def setup_input 
    Curses.nonl
    Curses.noecho
    Curses.cbreak
  end

  def setup_input_config 
    Curses.echo
  end

  def clean_input_config 
    Curses.noecho
  end
end
