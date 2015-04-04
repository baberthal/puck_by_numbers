class Game < ActiveRecord::Base
	include Statable
	include Summarizable
	belongs_to :season
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"
	has_many :events
	has_many :event_teams, through: :events
	has_many :players, through: :events
	has_many :player_game_summaries
	has_many :team_game_summaries
	has_many :participants, through: :events

	scope :recent, -> { where("game_start >= ?", 2.days.ago)}

	accepts_nested_attributes_for :events

	def home_team_summary
		team_game_summaries.find_by(team_id: home_team_id)
	end

	def away_team_summary
		team_game_summaries.find_by(team_id: away_team_id)
	end

	def home_players
		players.where(team_id: home_team_id).uniq
	end

	def away_players
		players.where(team_id: away_team_id).uniq
	end
end
