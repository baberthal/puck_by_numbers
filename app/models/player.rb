class Player < ActiveRecord::Base
	include PlayerFancyStats
	belongs_to :team
	has_many :participants
	has_many :primary_events, class_name: "Event", foreign_key: 'primary_event_player_id', autosave: true
	has_many :events, through: :participants
	has_many :games, through: :events

	def change_team(new_team_id)
		self.team_id = new_team_id
		self.save
	end

end
