module SearchHelper
  def set_match_index new_match_index
    @match_index=new_match_index
  end

  def match_index
    @match_index
  end

  def set_matches new_matches
    @matches = new_matches
  end

  def add_match new_match
    @matches ||= []
    @matches << new_match
  end

  def no_matches?
    return true if @matches.nil? || @matches.empty?
    false
  end

  def jump_to_first_match
    populate_matches
    unless @matches.empty?
      set_match_index 0
      @entry_pos_y = @matches[0].fetch(:row)
      @entry_pos_x = @matches[0].fetch(:col_begin)
      update_window_offset_top
    end
  end

  def jump_to_line line
    if (line > last_display_entries_pos)
      # show error
    else
      @entry_pos_y = line
      @entry_pos_x = 0
      update_window_offset_top
    end
    draw
  end

  def search(finished)
    #set_jump finished
    populate_matches 
    if finished == true
      jump_to_first_match
      draw
    else
      draw_menu
    end
  end

  def jump_to_match(forward=true)
    # forward/backward
    populate_matches

    search_mode = ContextModel.instance.search_context
    forward_offset = forward == true ? 1 : -1
    offset = search_mode == ContextModel::CONTEXT_SEARCH_FORWARD ? forward_offset : forward_offset*-1

    new_match_index = @match_index+offset

    # wrap
    new_match_index = 0 if (new_match_index == @matches.size)
    new_match_index = (@matches.size-1) if (new_match_index == -1)
    set_match_index new_match_index
    # TODO - these lines work if the match is on the same screen 
    # but breaks if we need to jump to new screen
    @entry_pos_y = @matches[new_match_index].fetch(:row)
    @entry_pos_x = @matches[new_match_index].fetch(:col_begin)

    update_window_offset_top
  end

  def clear_matches
    @matches.clear unless @matches.nil?
  end

  def matches
    @matches
  end

  def populate_matches 
    search_term = ContextModel.instance.search_term
    clear_matches
    
    # go through each token and find matches
    reg_pattern = /#{Regexp.quote(search_term)}/
    
    display_entries.each_with_index do |token, index|
      new_matches = token.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      new_matches.each_with_index do |match, i|
        add_match({row: index, match: match, col_begin: match.begin(0), col_end: match.end(0)})
      end
    end
  end

  def in_matches(my_matches, j)
    my_matches.each do |match|
      return true if((j >= match.offset(0)[0]) && (j < match.offset(0)[1]))
    end
    false
  end
end
