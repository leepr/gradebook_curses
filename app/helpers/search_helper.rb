module SearchHelper
  def current_match=(new_match)
    @current_match
  end

  def current_match
    @current_match
  end

  def matches=(new_matches)
    @matches = new_matches
  end

  def add_match(new_match)
    @matches ||= []
    @matches << new_match
  end

  def matches
    @matches
  end

  def set_jump(jump)
    @jump_to_first_match=jump
  end

  def get_jump
    @jump_to_first_match
  end

  def search_display_data 
    search_term = ContextModel.instance.search_term
    
    # go through each token and find matches
    reg_pattern = /#{Regexp.quote(search_term)}/
    
    display_data.each_with_index do |token, index|
      matches = token.to_enum(:scan, reg_pattern).map{Regexp.last_match}
      matches.each do |match|
        add_match match
        if get_jump
          current_match=match
          @position = index
          set_jump false
        end
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
