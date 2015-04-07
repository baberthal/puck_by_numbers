class PlayerGameSummary < ActiveRecord::Base
	belongs_to :player
	belongs_to :game

	validates :player_id, :uniqueness => { :scope => [:game_id, :situation] }

	scope :sit, ->(skaters) { where("situation = ?", skaters) }
end

