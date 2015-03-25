module TeamGameMethods
	def home_team
		team_games.where(home_away: "H")
	end

	def away_team
		team_games.where(home_away: "A")
	end
end
