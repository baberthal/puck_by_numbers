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
end
