class Participant < ActiveRecord::Base

  def destroy_blanks
    self.destroy if player_id.nil?
  end

end
