class PlayerGameSummary < ActiveRecord::Base
  include Filterable
  belongs_to :player
  belongs_to :game, :foreign_key => [:season_years, :gcode]
  validates :player_id, :uniqueness => { :scope => [:gcode, :season_years, :situation] }

  def get_zone_start_data
    if situation == 7
      events = Event.where(gcode: gcode, season_years: season_years, event_type: "FAC").by_player(player_id).includes(:location)
    else
      events = Event.where(gcode: gcode, season_years: season_years, event_type: "FAC", situation: situation).by_player(player_id).includes(:location)
    end

    home_players = self.game.home_player_id_numbers
    away_players = self.game.away_player_id_numbers

    if home_players.include?(player_id)
      o_zone = "Off"
    elsif away_players.include?(player_id)
      o_zone = "Def"
    end

    self.zso = events.where(locations: { home_zone: o_zone }).count
    self.zsd = events.where.not(locations: { home_zone: o_zone }).count
    self.save
  end
end

