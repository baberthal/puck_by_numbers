class TeamGameSummary < ActiveRecord::Base
	include Filterable
	belongs_to :team
	belongs_to :game

	validates :team_id, :uniqueness => { :scope => [:game_id, :situation] }

end
