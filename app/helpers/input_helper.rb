module InputHelper
  COLOR_PAIR_HIGHLIGHT = 1

  def setup_window window
    window.keypad=true
  end

  def setup_input 
    Curses.nonl
    Curses.noecho
    Curses.cbreak
    Curses.init_pair(COLOR_PAIR_HIGHLIGHT, COLOR_YELLOW, COLOR_RED)
  end

  def setup_input_config 
    #Curses.echo
  end

  def clean_input_config 
    #Curses.noecho
  end
end
