module InputHelper
  COLOR_PAIR_HIGHLIGHT = 1
  COLOR_PAIR_HIGHLIGHT_CURSOR = 2

  def setup_window window
    window.keypad=true
  end

  def setup_input 
    Curses.nonl
    Curses.noecho
    Curses.cbreak
    Curses.init_pair(COLOR_PAIR_HIGHLIGHT, COLOR_YELLOW, COLOR_RED)
    Curses.init_pair(COLOR_PAIR_HIGHLIGHT_CURSOR, COLOR_RED, COLOR_YELLOW)
  end

  def setup_input_config 
    #Curses.echo
  end

  def clean_input_config 
    #Curses.noecho
  end
end
