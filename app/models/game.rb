class Game < ActiveRecord::Base
	belongs_to :season
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"
	has_many :events
	has_many :event_teams, through: :events
	has_many :participants, through: :events
	has_many :players, through: :participants

	def sa_for(team, options = {})
		options[:unblocked] ||= nil
		options[:sit] ||= "5v5"
		t = team
		etype = ["MISS", "SHOT", "GOAL"]
		etype << "BLOCK" unless options[:unblocked]

		if options[:sit] == "5v5"
			hs = 6
			as = 6

		elsif options[:sit] == "5v4"
			if team == home_team
				hs = 6
				as = 5
			else
				as = 6
				hs = 5
			end

		elsif options[:sit] == "4v5"
			if team == home_team
				hs = 6
				as = 5
			else
				as = 6
				hs = 5
			end

		else
			hs = [1,2,3,4,5,6]
			as = [1,2,3,4,5,6]
		end

		events.where(event_team: t, event_type: etype, home_skaters: hs, away_skaters: as).where.not(away_G: nil, home_G: nil).count
	end

#	protected
#		def generate_summary
#			game_summary = GameSummary.new
#			game_summary.game_id = self.id
#		end
end
