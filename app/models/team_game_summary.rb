class TeamGameSummary < ActiveRecord::Base
	belongs_to :team
	belongs_to :game

	validates :team_id, :uniqueness => { :scope => [:game_id, :situation] }

	scope :sit, ->(skaters) { where("situation = ?", skaters) }
end
