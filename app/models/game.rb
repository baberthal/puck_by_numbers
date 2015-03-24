class Game < ActiveRecord::Base
	belongs_to :season
	has_many :events
	has_many :event_teams, through: :events
	has_many :participants, through: :events
	has_many :players, through: :participants
	belongs_to :home_team, class: "Team", foreign_key: :home_team_id
	belongs_to :away_team, class: "Team", foreign_key: :away_team_id

#	protected
#		def generate_summary
#			game_summary = GameSummary.new
#			game_summary.game_id = self.id
#		end
end
