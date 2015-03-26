module TeamFancyStats
	def team_corsi_for(team, options = {})
		t = team
		hs = options[:hs] || [1,2,3,4,5,6]
		as = options[:as] || [1,2,3,4,5,6]
		hs += 1 if hs.is_a? Integer
		as += 1 if as.is_a? Integer
		events.where(event_team: t, event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as).count
	end
end
