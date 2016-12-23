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

  def jump_to_first_match
    populate_matches
    set_match_index 0
    @position = @matches[0].fetch(:line_pos)
  end

  def jump_to_match(next_match=true)
    # forward/backward
    populate_matches

    search_mode = ContextModel.instance.search_context
    forward_offset = next_match == true ? 1 : -1
    offset = search_mode == ContextModel::CONTEXT_SEARCH_FORWARD ? forward_offset : forward_offset*-1

    new_match_index = @match_index+offset

    # wrap
    new_match_index = 0 if (new_match_index == @matches.size)
    new_match_index = (@matches.size-1) if (new_match_index == -1)
    set_match_index new_match_index
    @position = @matches[new_match_index].fetch(:line_pos)
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
    
    display_data.each_with_index do |token, index|
      new_matches = token.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      new_matches.each_with_index do |match, i|
        add_match({line_pos: index, match: match})
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
