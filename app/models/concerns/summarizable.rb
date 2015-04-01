module Summarizable
	def create_team_summary(team, options={})
		team_params = { event_team_id: team.id }

		if options[:situation] == "5v5"
			skater_params = { home_skaters: 6, away_skaters: 6 }
			goalie_not_params = { home_G_id: nil, away_G_id: nil }

		elsif options[:situation] == "pplay"
			if team.id == home_team_id
				skater_params = { home_skaters: 6, away_skaters: 5 }
			else
				skater_params = { home_skaters: 5, away_skaters: 6 }
			end
			goalie_not_params = { home_G_id: nil, away_G_id: nil }

		elsif options[:situation] == "short"
			if team.id == home_team_id
				skater_params = { home_skaters: 5, away_skaters: 6 }
			else
				skater_params = { home_skaters: 6, away_skaters: 5 }
			end
			goalie_not_params = { home_G_id: nil, away_G_id: nil }

		elsif options[:situation] == "4v4"
			skater_params = { home_skaters: 5, away_skaters: 5 }
			goalie_not_params = { home_G_id: nil, away_G_id: nil }

		elsif options[:situation] == "goalie-pull"
			skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
			if team.id == home_team_id
				goalie_params = { home_G_id: nil }
				goalie_not_params = { away_G_id: nil }
			else
				goalie_params = { away_G_id: nil }
				goalie_not_params = { home_G_id: nil }
			end

		elsif options[:situation] == "opposing-goalie-pull"
			if team.id == home_team_id
				goalie_params = { away_G_id: nil }
				goalie_not_params = { home_G_id: nil }
			else
				goalie_params = { home_G_id: nil }
				goalie_not_params = { away_G_id: nil }
			end

		elsif options[:situation] == "any"
			skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
			goalie_not_params = { home_G_id: 1, away_G_id: 1 }
		end

		goals_query = goals.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		shots_query = shots.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		miss_query = misses.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		block_query = blocks.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		corsi_for_query = corsi_events.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		corsi_against_query = corsi_events.where.not(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		hits_query = hits.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		pen_query = penalties.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		fow_query = faceoffs.where(team_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		if team.id == home_team_id
			zso_query = zone_starts_o_home.where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		else
			zso_query = zone_starts_o_away.where(skater_params).where.not(goalie_not_params).where(goalie_params).count
		end

		TeamGameSummary.create(team_id: team.id, game_id: id, situation: options[:situation]) do |ts|
			ts.gf = goals_query
			ts.sf = shots_query
			ts.msf = miss_query
			ts.bsf = block_query
			ts.cf = corsi_for_query
			ts.ca = corsi_against_query
			ts.c_diff = (corsi_for_query - corsi_against_query)
			ts.hits = hits_query
			ts.pen = pen_query
			ts.fo_won = fow_query
			ts.zso = zso_query
		end
	end

	def create_player_summaries(options = {})
		players.uniq.each do |player|
			game_params = { game_id: id }

			if options[:situation] == "5v5"
				skater_params = { home_skaters: 6, away_skaters: 6 }
				goalie_not_params = { home_G_id: nil, away_G_id: nil }

			elsif options[:situation] == "pplay"
				if player.team_id == home_team_id
					skater_params = { home_skaters: 6, away_skaters: 5 }
				else
					skater_params = { home_skaters: 5, away_skaters: 6 }
				end
				goalie_not_params = { home_G_id: nil, away_G_id: nil }

			elsif options[:situation] == "short"
				if player.team_id == home_team_id
					skater_params = { home_skaters: 5, away_skaters: 6 }
				else
					skater_params = { home_skaters: 6, away_skaters: 5 }
				end
				goalie_not_params = { home_G_id: nil, away_G_id: nil }

			elsif options[:situation] == "4v4"
				skater_params = { home_skaters: 5, away_skaters: 5 }
				goalie_not_params = { home_G_id: nil, away_G_id: nil }

			elsif options[:situation] == "goalie-pull"
				skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
				if player.team_id == home_team_id
					goalie_params = { home_G_id: nil }
					goalie_not_params = { away_G_id: nil }
				else
					goalie_params = { away_G_id: nil }
					goalie_not_params = { home_G_id: nil }
				end

			elsif options[:situation] == "opposing-goalie-pull"
				if player.team_id == home_team_id
					goalie_params = { away_G_id: nil }
					goalie_not_params = { home_G_id: nil }
				else
					goalie_params = { home_G_id: nil }
					goalie_not_params = { away_G_id: nil }
				end

			elsif options[:situation] == "any"
				skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
				goalie_not_params = { home_G_id: 1, away_G_id: 1 }
			end

			PlayerGameSummary.create(player: player, game_id: id, situation: options[:situation]) do |ps|
				ps.goals = player.goals.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.a1 = player.primary_assists.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.a2 = player.secondary_assists.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.points = player.goals.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count + player.primary_assists.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count + player.secondary_assists.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.ind_cf = player.ind_corsi_events.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.c_diff = (player.on_ice_corsi_events.where(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count) - (player.on_ice_corsi_events.where.not(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count)
				ps.f_diff = (player.on_ice_fenwick_events.where(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count) - (player.on_ice_fenwick_events.where.not(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count)
				ps.g_diff = (player.on_ice_goals.where(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count) - (player.on_ice_goals.where.not(event_team: player.team).where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count)
				ps.cf = player.corsi_for.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.ff = player.fenwick_for.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.zso = (player.zone_starts_o_home.where(game_id: id).count + player.zone_starts_o_away.where(game_id: id).count)
				ps.zsd = (player.zone_starts_d_home.where(game_id: id).count + player.zone_starts_d_away.where(game_id: id).count)
				ps.blocks = player.blocks.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.fo_won = player.faceoffs_won.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.fo_lost = player.faceoffs_lost.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.hits = player.hits.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.hits_taken = player.hits_taken.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.pen = player.penalties.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.pen_drawn = player.penalties_drawn.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).count
				ps.toi = (player.events.where(game_params).where(skater_params).where.not(goalie_not_params).where(goalie_params).sum(:event_length)/60).round(1)
			end
		end
	end

	def create_all_summaries
		create_team_summary(self.home_team, situation: "5v5")
		create_team_summary(self.home_team, situation: "pplay")
		create_team_summary(self.home_team, situation: "short")
		create_team_summary(self.home_team, situation: "4v4")
		create_team_summary(self.home_team, situation: "goalie-pull")
		create_team_summary(self.home_team, situation: "opposing-goalie-pull")
		create_team_summary(self.home_team, situation: "any")
		create_team_summary(self.away_team, situation: "5v5")
		create_team_summary(self.away_team, situation: "pplay")
		create_team_summary(self.away_team, situation: "short")
		create_team_summary(self.away_team, situation: "4v4")
		create_team_summary(self.away_team, situation: "goalie-pull")
		create_team_summary(self.away_team, situation: "opposing-goalie-pull")
		create_team_summary(self.away_team, situation: "any")
		create_player_summaries(situation: "5v5")
		create_player_summaries(situation: "pplay")
		create_player_summaries(situation: "short")
		create_player_summaries(situation: "4v4")
		create_player_summaries(situation: "goalie-pull")
		create_player_summaries(situation: "opposing-goalie-pull")
		create_player_summaries(situation: "any")
	end
end
