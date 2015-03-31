module Summarizable
	def create_team_summary(team, options={})
		if options[:situation].downcase == "5v5"
			skater_opts = { hs: 6, as: 6 }
			goalie_not_opts = { hG: nil, aG: nil }

		elsif options[:situation].downcase == "pplay"
			if team.id == home_team_id
				skater_opts = { hs: 6, as: 5 }
				goalie_not_opts = { hG: nil, aG: nil }
			else
				skater_opts = { hs: 5, as: 6 }
				goalie_not_opts = { hG: nil, aG: nil }
			end

		elsif options[:situation].downcase == "short"
			if team.id == home_team_id
				skater_opts = { hs: 5, as: 6 }
				goalie_not_opts = { hG: nil, aG: nil }
			else
				skater_opts = { hs: 6, as: 5 }
				goalie_not_opts = { hG: nil, aG: nil }
			end

		elsif options[:situation].downcase == "4v4"
			skater_opts = { hs: 5, as: 5 }
			goalie_not_opts = { hG: nil, aG: nil }
		end

		TeamGameSummary.create(team_id: team.id, situation: options[:situation].downcase) do |ts|
			ts.game_id = id
			ts.gf = goals.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.sf = shots.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.msf = misses.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.bsf = blocks.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.cf = corsi_events.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.hits = hits.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.pen = penalties.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.fo_won = faceoffs.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			ts.c_diff = (corsi_events.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count)-(corsi_events.where(event_team_id: team.id).where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count)
			if team.id == home_team_id
				ts.zso = zone_starts_o_home.where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			else
				ts.zso = zone_starts_o_away.where("home_skaters = :hs, away_skaters = :as", skater_opts).where.not("away_G_id = :aG, home_G_id = :hG", goalie_not_opts).count
			end
		end
	end

	def create_player_summaries
		players.uniq.each do |player|
			PlayerGameSummary.create(player: player) do |ps|
				ps.game_id = id
				ps.goals = player.goals.where(game_id: id).count
				ps.a1 = player.primary_assists.where(game_id: id).count
				ps.a2 = player.secondary_assists.where(game_id: id).count
				ps.points = player.goals.where(game_id: id).count + player.primary_assists.where(game_id: id).count + player.secondary_assists.where(game_id: id).count
				ps.ind_cf = player.ind_corsi_events.where(game_id: id).count
				ps.c_diff = (player.on_ice_corsi_events.where(game_id: id, event_team: player.team).count) - (player.on_ice_corsi_events.where(game_id: id).where.not(event_team: player.team).count)
				ps.f_diff = (player.on_ice_fenwick_events.where(game_id: id, event_team: player.team).count) - (player.on_ice_fenwick_events.where(game_id: id).where.not(event_team: player.team).count)
				ps.g_diff = (player.on_ice_goals.where(game_id: id, event_team: player.team).count) - (player.on_ice_goals.where(game_id: id).where.not(event_team: player.team).count)
				ps.cf = player.corsi_for.where(game_id: id).count
				ps.ff = player.fenwick_for.where(game_id: id).count
				ps.zso = (player.zone_starts_o_home.where(game_id: id).count + player.zone_starts_o_away.where(game_id: id).count)
				ps.zsd = (player.zone_starts_d_home.where(game_id: id).count + player.zone_starts_d_away.where(game_id: id).count)
				ps.blocks = player.blocks.where(game_id: id).count
				ps.fo_won = player.faceoffs_won.where(game_id: id).count
				ps.fo_lost = player.faceoffs_lost.where(game_id: id).count
				ps.hits = player.hits.where(game_id: id).count
				ps.hits_taken = player.hits_taken.where(game_id: id).count
				ps.pen = player.penalties.where(game_id: id).count
				ps.pen_drawn = player.penalties_drawn.where(game_id: id).count
				ps.toi = player.time_on_ice(game_id: id)
			end
		end
	end
end
