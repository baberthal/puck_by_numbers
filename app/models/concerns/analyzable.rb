module Analyzable
  extend ActiveSupport::Concern

  def head_to_head(player1, player2, situation = nil)
    situation ||= 1
    if situation == 7
      situation = [1,2,3,4,5,6]
    end
    p1_events = self.participants.where(player_id: player1.id).pluck(:event_id)
    p2_events = self.participants.where(player_id: player2.id).pluck(:event_id)
    h2h_c_events = self.corsi_events.where(id: p1_events)
                                    .where(id: p2_events)
                                    .where(situation: situation)
    h2h_p1 = h2h_c_events.where(event_team: player1.team).count
    h2h_p2 = h2h_c_events.where(event_team: player2.team).count
    if player1.team == self.home_team
      h2h_p1 - h2h_p2
    else
      h2h_p2 - h2h_p1
    end
  end

  def get_heat_map_data(options = {})
    options[:situation] ||= 1
    home_players = self.players.where(team: self.home_team).uniq.order(id: :asc)
    away_players = self.players.where(team: self.away_team).uniq.order(id: :asc)
    series = []
    home_players.each_with_index do |p,i|
      for a,n in away_players.map.with_index do
        series << [i,n,self.head_to_head(p,a, options[:situation])]
      end
    end
    GameChart.create(game: self,
                     chart_type: 'corsi_heat_map',
                     data: series,
                     situation: options[:situation])
  end

  def get_event_count_data(team, options = {})
    options[:situation] ||= 1
    options[:type] ||= 'corsi'

    if options[:type] == 'corsi'
      events = self.corsi_events.where(situation: options[:situation])
    elsif options[:type] == 'fenwick'
      events = self.fenwick_events.where(situation: options[:situation])
    elsif options [:type] == 'shots'
      events = self.shots.where(situation: options[:situation])
    end

    ecount = events.where(event_team: team).uniq.pluck(:seconds)

    arr = ecount.each_with_index.map { |v,i| [(v/60).round(2), i + 1] }
    arr.unshift([0,0])
    arr.insert(-1, [60, arr.last[1]])

    GameChart.create(game: self,
                     chart_type: "running_#{options[:type]}_count_chart",
                     data: arr,
                     situation: options[:situation],
                     team_id: team.id)
  end

  def gather_chart_data
    self.get_heat_map_data(situation: 1)
    self.get_heat_map_data(situation: 2)
    self.get_heat_map_data(situation: 3)
    self.get_heat_map_data(situation: 4)
    self.get_heat_map_data(situation: 5)
    self.get_heat_map_data(situation: 6)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 1)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 2)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 3)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 4)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 5)
    self.get_event_count_data(self.home_team, type: 'corsi', situation: 6)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 1)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 2)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 3)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 4)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 5)
    self.get_event_count_data(self.away_team, type: 'corsi', situation: 6)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 1)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 2)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 3)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 4)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 5)
    self.get_event_count_data(self.home_team, type: 'fenwick', situation: 6)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 1)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 2)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 3)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 4)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 5)
    self.get_event_count_data(self.away_team, type: 'fenwick', situation: 6)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 1)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 2)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 3)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 4)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 5)
    self.get_event_count_data(self.home_team, type: 'shots', situation: 6)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 1)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 2)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 3)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 4)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 5)
    self.get_event_count_data(self.away_team, type: 'shots', situation: 6)
  end

end
