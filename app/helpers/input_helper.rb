module InputHelper
  def setup_one_line_input
    Curses.echo
    Curses.cbreak
    Curses.nonl
  end

  def cleanup_one_line_input
    Curses.nl
    Curses.nocbreak
    Curses.noecho
  end
end
