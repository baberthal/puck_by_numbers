class Player < ActiveRecord::Base
	include PlayerStatable
	belongs_to :team
	has_many :participants
	has_many :primary_events, class_name: "Event", foreign_key: 'event_player_1_id', autosave: true
	has_many :secondary_events, class_name: "Event", foreign_key: 'event_player_2_id', autosave: true
	has_many :tertiary_events, class_name: "Event", foreign_key: 'event_player_3_id', autosave: true
	has_many :events, through: :participants
	has_many :games, through: :events
	has_many :player_game_summaries

	def change_team(new_team_id)
		self.team_id = new_team_id
		self.save
	end

end
