class Game < ActiveRecord::Base
	include FancyStats
	belongs_to :season
	has_many :events
	has_many :event_teams, through: :events
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"


#	protected
#		def generate_summary
#			game_summary = GameSummary.new
#			game_summary.game_id = self.id
#		end
end
