module Summarizable

  def create_team_summary(team, sit)
    if team == away_team # Flip the PP / SH if the team is away
      if sit == 2
        situation = 3
      elsif sit == 3
        situation = 2
      elsif sit == 5
        situation = 6
      elsif sit == 6
        situation = 5
      else
        situation = sit # Even strenghth ids are the same
      end
    elsif team == home_team # Situations have standard numbers if home team
      situation = sit
    end

    if sit == 7 # Represents 'all' situations
      team_params = {event_team_id: team.id}
    else
      team_params = {event_team_id: team.id, situation: situation}
    end

    TeamGameSummary.create(team_id: team.id, game: self, situation: sit) do |ts|
      ts.gf = goals.where(team_params).count
      ts.sf = shots.where(team_params).count
      ts.msf = misses.where(team_params).count
      ts.bsf = blocks.where(team_params).count
      ts.cf = corsi_events.where(team_params).count
      ts.ca = corsi_events.where.not(team_params).count
      ts.c_diff = (ts.cf - ts.ca)
      ts.hits = hits.where(team_params).count
      ts.pen = penalties.where(team_params).count
      ts.fo_won = faceoffs.where(team_params).count
      ts.zso = zone_starts_o(team).where(situation: situation).count
      ts.toi = (events.where(situation: situation).sum(:event_length)/60).round(1)
    end
  end

  def create_player_summaries(sit)
    players.uniq.each do |player|
      if player.team == away_team
        if sit == 1
          situation = 1
        elsif sit == 2
          situation = 3
        elsif sit == 3
          situation = 2
        elsif sit == 4
          situation = 4
        elsif sit == 5
          situation = 6
        elsif sit == 6
          situation = 5
        else
          situation = 6
        end
      elsif player.team == home_team
        situation = sit
      end

      if sit == 7
        game_params = { game: self }
      else
        game_params = { game: self, situation: situation }
      end

      PlayerGameSummary.create(player: player, game: self, situation: sit) do |ps|
        ps.goals = player.goals.where(game_params).count
        ps.a1 = player.primary_assists.where(game_params).count
        ps.a2 = player.secondary_assists.where(game_params).count
        ps.points = ps.goals + ps.a1 + ps.a2
        ps.ind_cf = player.ind_corsi_events.where(game_params).count
        ps.cf = player.corsi_for.where(game_params).count
        ps.ff = player.fenwick_for.where(game_params).count
        ps.c_diff = (player.on_ice_corsi_events.where(event_team: player.team).where(game_params).count) - (player.on_ice_corsi_events.where.not(event_team: player.team).where(game_params).count)
        ps.f_diff = (player.on_ice_fenwick_events.where(event_team: player.team).where(game_params).count) - (player.on_ice_fenwick_events.where.not(event_team: player.team).where(game_params).count)
        ps.g_diff = (player.on_ice_goals.where(event_team: player.team).where(game_params).count) - (player.on_ice_goals.where.not(event_team: player.team).where(game_params).count)
        ps.zso = (player.zone_starts_o_home.where(game: self).count + player.zone_starts_o_away.where(game: self).count)
        ps.zsd = (player.zone_starts_d_home.where(game: self).count + player.zone_starts_d_away.where(game: self).count)
        ps.blocks = player.blocks.where(game_params).count
        ps.fo_won = player.faceoffs_won.where(game_params).count
        ps.fo_lost = player.faceoffs_lost.where(game_params).count
        ps.hits = player.hits.where(game_params).count
        ps.hits_taken = player.hits_taken.where(game_params).count
        ps.pen = player.penalties.where(game_params).count
        ps.pen_drawn = player.penalties_drawn.where(game_params).count
        ps.toi = (player.events.where(game_params).sum(:event_length)/60).round(1)
      end
    end
  end

  def create_all_summaries
    create_team_summary(self.home_team, 1)
    create_team_summary(self.home_team, 2)
    create_team_summary(self.home_team, 3)
    create_team_summary(self.home_team, 4)
    create_team_summary(self.home_team, 5)
    create_team_summary(self.home_team, 6)
    create_team_summary(self.home_team, 7)
    create_team_summary(self.away_team, 1)
    create_team_summary(self.away_team, 2)
    create_team_summary(self.away_team, 3)
    create_team_summary(self.away_team, 4)
    create_team_summary(self.away_team, 5)
    create_team_summary(self.away_team, 6)
    create_team_summary(self.away_team, 7)
    create_player_summaries(1)
    create_player_summaries(2)
    create_player_summaries(3)
    create_player_summaries(4)
    create_player_summaries(5)
    create_player_summaries(6)
    create_player_summaries(7)
  end
end
