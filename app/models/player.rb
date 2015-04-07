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

	scope :goalies, -> { where(position: "G") }
	scope :skaters, -> { where.not(position: "G") }
	scope :active, -> { joins(:games).where.not(id: 1).where(games: { season_id: 1 }).uniq }

	def change_team(new_team)
		self.team = new_team
		self.save
	end

	def determine_team
		unless self.events.nil?
			a = self.events.joins(:participants, :game).last
			if a.participants.find_by(player: self).event_role[0].to_s.downcase == "a"
				t = a.game.away_team
			elsif a.participants.find_by(player: self).event_role[0].to_s.downcase == "h"
				t = a.game.home_team
			end
		end
		change_team(t)
	end

	def self.search(search)
		if search
			where('last_name LIKE ?', "%#{search}%")
		else
			all
		end
	end
end
