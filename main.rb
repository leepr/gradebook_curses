require 'curses'
require 'byebug'

Curses.init_screen

# no echo
Curses.noecho

# init colors
Curses.start_color

begin
  nb_lines = Curses.lines
  nb_cols = Curses.cols
  win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
  win.setpos(0,0)
  win.refresh

  win.setpos(nb_cols, nb_lines)
  win.addstr("Hello World!")
  #win.refresh
  #Curses.getch
  exit = FALSE
  while !exit 
    win.keypad = true
    input = win.getch
    win.addstr "input:#{input} left:#{Curses::Key::LEFT}"
    win.refresh
    if input == Curses::Key::LEFT 
      win.addstr("Left Key")
      win.refresh
    else
      exit = TRUE
    end
  end
ensure
  sleep 2.0
  Curses.close_screen
end
