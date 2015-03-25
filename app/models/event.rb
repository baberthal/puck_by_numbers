class Event < ActiveRecord::Base
	belongs_to :game
	belongs_to :event_team, :class_name => "Team"
	has_one :location
	belongs_to :primary_event_player, :class_name => "Player", autosave: true
	belongs_to :event_player_2, :class_name => "Player"
	belongs_to :event_player_3, :class_name => "Player"
	belongs_to :away_G, :class_name => "Player"
	belongs_to :home_G, :class_name => "Player"
	has_many :participants
	has_many :players, through: :participants

	after_create :determine_player_teams

	def determine_player_teams
		primary_event_player.change_team(self.event_team_id) unless event_team.nil?
	end


end
