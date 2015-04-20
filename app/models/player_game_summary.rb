class PlayerGameSummary < ActiveRecord::Base
  include Filterable
  belongs_to :player
  belongs_to :game, :foreign_key => [:season_years, :gcode]
  validates :player_id, :uniqueness => { :scope => [:gcode, :season_years, :situation] }
end

