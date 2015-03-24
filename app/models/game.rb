class Game < ActiveRecord::Base
	belongs_to :season
	has_many :events
	has_many :event_teams, through: :events
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"

	def team_corsi_for(team, options = {})
		if team
			:home_team
		else
			:home_team
		end
		t = team
		hs = options[:hs]-1
		as = options[:as]-1
		events.where(event_team: t, event_type: ["BLOCK", "MISS", "SHOT", "GOAL"]).count
	end

#	protected
#		def generate_summary
#			game_summary = GameSummary.new
#			game_summary.game_id = self.id
#		end
end
