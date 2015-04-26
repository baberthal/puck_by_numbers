module Analyzable
  extend ActiveSupport::Concern

  def get_heat_map_data
    situations = [1,4,7]

    home_players = self.home_players.where.not(position: "G").pluck(:id)
    home_players << self.home_players.where(position: "G").pluck(:id)
    home_players.flatten!
    home_id = self.home_team_id

    away_players = self.away_players.where.not(position: "G").pluck(:id)
    away_players << self.away_players.where(position: "G").pluck(:id)
    away_players.flatten!
    away_id = self.away_team_id

    game_events = self.corsi_events.pluck(:event_number,
                                          :event_team_id,
                                          :event_player_1_id,
                                          :event_player_2_id,
                                          :event_player_3_id,
                                          :event_type,
                                          :situation,
                                          :home_players,
                                          :away_players)


    column_names = [ :event_number, :event_team_id, :event_player_1,
                     :event_player_2, :event_player_3, :event_type,
                     :situation, :home_players, :away_players ]

    game_events.map!.each do |g|
      column_names.zip(g).to_h
    end

    situations.each do |sit|
      if sit == 7
        event_table = game_events
      else
        event_table = game_events.select { |e| e[:situation] == sit }
      end

      series = []
      home_players.each_with_index do |p,i|
        h_events = event_table.select { |e| e[:home_players].include?(p) }

        away_players.each_with_index do |a,n|
          shared_events = h_events.select { |s| s[:away_players].include?(a) }
          pp shared_events[0]
          home_adv = shared_events.select { |s| s[:event_team_id] == home_id }
          away_adv = shared_events.select { |s| s[:event_team_id] == away_id }
          head_to_head = home_adv.size - away_adv.size
          series << [i, n, head_to_head]
        end

      end

      GameChart.create(game: self,
                       chart_type: "corsi_heat_map",
                       data: series,
                       situation: sit)

    end
  end


  def get_event_count_data(team, options = {})
    situations = [1,2,3,4,5,6,7]
    options[:type] ||= 'corsi'

    if options[:type] == 'corsi'
      events = self.corsi_events
    elsif options[:type] == 'fenwick'
      events = self.fenwick_events
    elsif options [:type] == 'shots'
      events = self.shots
    end

    situations.each do |sit|
      if sit == 7
        s = [1,2,3,4,5,6,7]
      else
        s = sit
      end

      ecount = events.where(event_team_id: team.id, situation: s).pluck(:event_type, :seconds)

      arr = ecount.each_with_index.map { |v,i| { name: v[0], x: (v[1]/60).round(2), y: i + 1 } }
      arr.unshift({ name: "START", x: 0, y: 0 })
      arr.insert(-1, { name: "GAME END", x: 60, y: arr.last[:y] } )

      GameChart.create(game: self,
                       chart_type: "running_#{options[:type]}_count_chart",
                       data: arr,
                       situation: sit,
                       team_id: team.id)

    end
  end


  def gather_chart_data
    self.get_heat_map_data
    self.get_event_count_data(self.home_team, type: 'corsi')
    self.get_event_count_data(self.away_team, type: 'corsi')
  end

end
