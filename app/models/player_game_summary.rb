class PlayerGameSummary < ActiveRecord::Base
	include Filterable

	belongs_to :player
	belongs_to :game

	validates :player_id, :uniqueness => { :scope => [:game_id, :situation] }

end

