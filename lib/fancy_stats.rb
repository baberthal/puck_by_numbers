module FancyStats
	def team_corsi_for(team, options = {})
		#if team
		#	:home_team
		#else
		#	:home_team
		#end
		t = team
		hs = options[:hs]+1
		as = options[:as]+1
		events.where(event_team: t, event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as).count
	end
end
