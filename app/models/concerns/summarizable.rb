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
      ts.gf = goals.where(team_params).size
      ts.sf = shots.where(team_params).size
      ts.msf = misses.where(team_params).size
      ts.bsf = blocks.where(team_params).size
      ts.cf = corsi_events.where(team_params).size
      ts.ca = corsi_events.where.not(team_params).size
      ts.c_diff = (ts.cf - ts.ca)
      ts.hits = hits.where(team_params).size
      ts.pen = penalties.where(team_params).size
      ts.fo_won = faceoffs.where(team_params).size
      ts.zso = zone_starts_o(team).where(situation: situation).size
      ts.toi = (events.where(situation: situation).sum(:event_length)/60).round(1)
    end
  end

  def create_player_summaries
    situations = [1,2,3,4,5,6,7]
    game_away_players = away_player_id_numbers

    column_names = [ :event_number, :event_type, :period, :seconds,
                     :event_team_id, :event_player_1_id, :event_player_2_id,
                     :event_player_3_id, :away_G_id, :home_G_id, :event_length,
                     :home_skaters, :away_skaters, :situation, :away_players,
                     :home_players ]

    game_events = self.events.pluck(:event_number, :event_type, :period,
                                    :seconds, :event_team_id, :event_player_1_id,
                                    :event_player_2_id, :event_player_3_id,
                                    :away_G_id, :home_G_id, :event_length,
                                    :home_skaters, :away_skaters, :situation,
                                    :away_players, :home_players)

    game_events.map!.each do |g|
      column_names.zip(g).to_h
    end

    players.each do |player|
      shot_types = ["GOAL", "SHOT"]
      fenwick_types = shot_types + ["MISS"]
      corsi_types = fenwick_types + ["BLOCK"]

      if game_away_players.include?(player.id)
        player_events = game_events.find_all { |e| e[:away_players].include? (player.id) }
        player_events.each { |e| e[:situation] = situation_flip(e[:situation]) }
        t_id = self.away_team_id
        o_zone = "Def"
      else
        player_events = game_events.find_all { |e| e[:home_players].include? (player.id) }
        t_id = self.home_team_id
        o_zone = "Off"
      end

      situations.each do |s|
        if s == 7
          event_table = player_events
        else
          event_table = player_events.find_all { |e| e[:situation] == s }
        end

        corsi_table = event_table.find_all { |e| corsi_types.include?(e[:event_type])}
        goal_table = event_table.find_all { |e| e[:event_type] == "GOAL" }
        fenwick_table = event_table.find_all { |e| fenwick_types.include?(e[:event_type])}
        face_table = event_table.find_all { |e| e[:event_type] == "FAC" }
        faceoff_table = face_table.find_all { |e| e[:event_player_1_id] == player.id || e[:event_player_2_id] == player.id }

        PlayerGameSummary.create(player: player, game: self, situation: s) do |ps|
          ps.goals = goal_table.count { |e| e[:event_player_1_id] == player.id }
          ps.a1 = goal_table.count { |e| e[:event_player_2_id] == player.id }
          ps.a2 = goal_table.count { |e| e[:event_player_3_id] == player.id }
          ps.points = ps.goals + ps.a1 + ps.a2
          ps.ind_cf = corsi_table.count { |e| e[:event_player_1_id] == player.id }
          ps.cf = corsi_table.count { |e| e[:event_team_id] == t_id }
          ps.ff = fenwick_table.count { |e| e[:event_team_id] == t_id }
          ps.c_diff = ps.cf - corsi_table.count { |e| e[:event_team_id] != t_id }
          ps.f_diff = ps.ff - fenwick_table.count { |e| e[:event_team_id] != t_id }
          ps.g_diff = ( goal_table.count { |e| e[:event_team_id] == t_id } -
                        goal_table.count { |e| e[:event_team_id] != t_id } )
          ps.blocks = event_table.count { |e| e[:event_type] == "BLOCK" && e[:event_player_1_id] == player.id }
          ps.fo_won = faceoff_table.count { |e| e[:event_team_id] == t_id }
          ps.fo_lost = faceoff_table.count { |e| e[:event_team_id] != t_id }
          ps.hits = event_table.count { |e| e[:event_type] == "HIT" && e[:event_player_1_id] == player.id }
          ps.hits_taken = event_table.count { |e| e[:event_type] == "HIT" && e[:event_player_2_id] == player.id }
          ps.pen = event_table.count { |e| e[:event_type] == "PENL" && e[:event_player_1_id] == player.id }
          ps.pen_drawn = event_table.count { |e| e[:event_type] == "PENL" && e[:event_player_2_id] == player.id }
          ps.toi = ( ( event_table.sum { |e| e[:event_length] } ) / 60 ).round(1)
        end

      end
    end

  end

  def situation_flip(sit)
    if sit == 2
      3
    elsif sit == 3
      2
    elsif sit == 5
      6
    elsif sit == 6
      5
    else
      sit
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
