class GameChart < ActiveRecord::Base
  belongs_to :game, :foreign_key => [:season_years, :gcode], counter_cache: true
  serialize :data, Array

  validates :data, :game, presence: true
  validates :chart_type, :uniqueness => { :scope => [:season_years,
                                                     :gcode,
                                                     :situation,
                                                     :team_id] }
end
