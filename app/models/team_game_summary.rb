class TeamGameSummary < ActiveRecord::Base
	include Filterable
	belongs_to :team
	belongs_to :game, :foreign_key => [:season_years, :gcode]
	validates :team_id, :uniqueness => { :scope => [:gcode, :season_years, :situation] }

	def pretty_season
		"#{self.season_years.to_s[0..3]} - #{self.season_years.to_s[4..-1]}"
	end
end
