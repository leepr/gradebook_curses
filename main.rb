require "curses"
require "./app/controllers/main_controller"
include Curses

init_screen
start_color
noecho

main_controller = MainController.instance
main_window = main_controller.window
