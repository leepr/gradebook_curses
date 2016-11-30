class ViewControllerMenu
  def initialize window
    @window=window 
    @position=0
    
    # create menu window
    menu = @window.subwin(@window.maxy/3, @window.maxx, @window.maxy-@window.maxy/3, 0)
    draw_menu menu
    menu.box('o', 'p')
    menu.refresh

    while ch = menu.getch
      case ch
      when 'w'
        draw_info menu, 'move up'
        @position -= 1
      when 's'
        draw_info menu, 'move down'
        @position += 1
      when 'h'
        menu.close
      when 'g'
        menu.refresh
      when 'x'
        exit
      end
      @position = 3 if @position < 0
      @position = 0 if @position > 3
      draw_menu(menu, @position)
    end
  end

  def draw_menu(menu, active_index=nil)
    4.times do |i|
      menu.setpos(i+1, 8)
      menu.attrset(i==active_index ? A_STANDOUT : A_NORMAL)
      menu.addstr "item_#{i}"
    end
  end

  def draw_info(menu, text)
    menu.setpos(1, 10)
    menu.attrset(A_NORMAL)
    menu.addstr text
  end
end
