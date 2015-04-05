class Participant < ActiveRecord::Base
	belongs_to :event
	belongs_to :player

	after_create :destroy_blanks
	after_create :determine_player_team

	def destroy_blanks
		self.destroy if player_id.nil?
	end

	def determine_player_team
		player.determine_team unless player_id.nil?
	end
end
