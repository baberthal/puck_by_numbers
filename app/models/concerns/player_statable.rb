module PlayerStatable
	def goals
		primary_events.where(event_type: "GOAL")
	end

	def primary_assists
		secondary_events.where(event_type: "GOAL")
	end

	def secondary_assists
		tertiary_events.where(event_type: "GOAL")
	end

	def shots
		primary_events.where(event_type: ["GOAL", "SHOT"])
	end

	def misses
		primary_events.where(event_type: "MISS")
	end

	def blocks
		primary_events.where(event_type: "BLOCK")
	end

	def ind_corsi_events
		primary_events.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"])
	end

	def ind_fenwick_events
		primary_events.where(event_type: ["GOAL", "SHOT", "MISS"])
	end

	def on_ice_corsi_events
		events.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"])
	end

	def on_ice_fenwick_events
		events.where(event_type: ["GOAL", "SHOT", "MISS"])
	end

	def corsi_for
		on_ice_corsi_events.where(event_team: team)
	end

	def fenwick_for
		on_ice_fenwick_events.where(event_team: team)
	end

	def corsi_against
		on_ice_corsi_events.where.not(event_team: team)
	end

	def fenwick_against
		on_ice_fenwick_events.where.not(event_team: team)
	end

	def on_ice_goals
		events.where(event_type: "GOAL")
	end

	def hits
		primary_events.where(event_type: "HIT")
	end

	def hits_taken
		secondary_events.where(event_type: "HIT")
	end

	def penalties
		primary_events.where(event_type: "PENL")
	end

	def penalties_drawn
		secondary_events.where(event_type: "PENL")
	end

	def faceoffs_won
		primary_events.where(event_type: "FAC")
	end

	def faceoffs_lost
		secondary_events.where(event_type: "FAC")
	end

end
