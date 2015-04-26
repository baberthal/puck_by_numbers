class Location < ActiveRecord::Base
  self.primary_keys = [:event_number, :gcode, :season_years]
  belongs_to :event, :foreign_key => [:event_number, :gcode, :season_years]
  validates :event_number, :uniqueness => { scope: [:gcode, :season_years]}
end
