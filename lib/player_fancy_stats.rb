module PlayerFancyStats
	def player_corsi_for(options = {})
		hs = options[:hs] || [1,2,3,4,5,6]
		as = options[:as] || [1,2,3,4,5,6]
		options[:game] ||= nil
		hs += 1 if hs.is_a? Integer
		as += 1 if as.is_a? Integer
		if options[:game]
			events.where(event_team: self.team, event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as, game_id: :game).count
		else
			events.where(event_team: self.team, event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as).count
		end
	end

	def player_corsi_against(options = {})
		hs = options[:hs] || [1,2,3,4,5,6]
		as = options[:as] || [1,2,3,4,5,6]
		options[:game] ||= nil
		hs += 1 if hs.is_a? Integer
		as += 1 if as.is_a? Integer
		if options[:game]
			events.where(event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as, game_id: :game).where.not(event_team: self.team).count
		else
			events.where(event_type: ["BLOCK", "MISS", "SHOT", "GOAL"], home_skaters: hs, away_skaters: as).where.not(event_team: self.team).count
		end
	end

end
