class Event < ActiveRecord::Base
  include Filterable
  include Situational

  belongs_to :game, :foreign_key => [:season_years, :gcode]
  belongs_to :event_team, :class_name => "Team"
  has_one :location
  belongs_to :event_player_1, :class_name => "Player", autosave: true
  belongs_to :event_player_2, :class_name => "Player"
  belongs_to :event_player_3, :class_name => "Player"
  belongs_to :away_G, :class_name => "Player"
  belongs_to :home_G, :class_name => "Player"
  has_many :participants
  has_many :players, through: :participants

  def goalies_in?
    if self.home_G_id != nil && self.away_G_id != nil
      true
    else
      false
    end
  end

end

