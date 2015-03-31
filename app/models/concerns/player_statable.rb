module PlayerStatable
	def goals
		primary_events.where(event_type: "GOAL").uniq
	end

	def primary_assists
		secondary_events.where(event_type: "GOAL").uniq
	end

	def secondary_assists
		tertiary_events.where(event_type: "GOAL").uniq
	end

	def shots
		primary_events.where(event_type: ["GOAL", "SHOT"]).uniq
	end

	def misses
		primary_events.where(event_type: "MISS").uniq
	end

	def blocks
		primary_events.where(event_type: "BLOCK").uniq
	end

	def ind_corsi_events
		primary_events.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"]).uniq
	end

	def ind_fenwick_events
		primary_events.where(event_type: ["GOAL", "SHOT", "MISS"]).uniq
	end

	def on_ice_corsi_events
		events.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"]).uniq
	end

	def on_ice_fenwick_events
		events.where(event_type: ["GOAL", "SHOT", "MISS"]).uniq
	end

	def corsi_for
		on_ice_corsi_events.where(event_team: team).uniq
	end

	def fenwick_for
		on_ice_fenwick_events.where(event_team: team).uniq
	end

	def corsi_against
		on_ice_corsi_events.where.not(event_team: team).uniq
	end

	def fenwick_against
		on_ice_fenwick_events.where.not(event_team: team).uniq
	end

	def on_ice_goals
		events.where(event_type: "GOAL").uniq
	end

	def ind_scoring_chances
		a = primary_events.joins(:location, :game).where(event_type: "SHOT", locations: {:new_location_section => [1,2,3,4]})
		b = primary_events.joins(:location, :game).where(event_type: ["SHOT", "BLOCK"], locations: {:new_location_section => [4,5,6,7]})
		a + b
	end

	def zone_starts_o_home
		events.joins(:location, :game).where(event_type: "FAC", locations: {:home_zone => "Off"}, games: {:home_team_id => team.id}).uniq
	end

	def zone_starts_o_away
		events.joins(:location, :game).where(event_type: "FAC", locations: {:home_zone => "Def"}, games: {:away_team_id => team.id}).uniq
	end

	def zone_starts_d_home
		events.joins(:location, :game).where(event_type: "FAC", locations: {:home_zone => "Def"}, games: {:home_team_id => team.id}).uniq
	end

	def zone_starts_d_away
		events.joins(:location, :game).where(event_type: "FAC", locations: {:home_zone => "Off"}, games: {:away_team_id => team.id}).uniq
	end

	def hits
		primary_events.where(event_type: "HIT").uniq
	end

	def hits_taken
		secondary_events.where(event_type: "HIT").uniq
	end

	def penalties
		primary_events.where(event_type: "PENL").where.not("description like ?", "%fighting%").uniq
	end

	def penalties_drawn
		secondary_events.where(event_type: "PENL").where.not("description like ?", "%fighting%").uniq
	end

	def faceoffs_won
		primary_events.where(event_type: "FAC").uniq
	end

	def faceoffs_lost
		secondary_events.where(event_type: "FAC").uniq
	end

	def time_on_ice(options = {})
		if options[:game_id]
			a = events.where(game_id: options[:game_id]).pluck(:event_length)
		else
			a = events.pluck(:event_length)
		end
		b = a.inject{|sum,x| sum + x }
		(b/60).round(1)
	end

end
