class Team < ActiveRecord::Base
	has_many :events, foreign_key: :event_team_id
	has_many :home_games, class: "Game"
	has_many :away_games, class: "Game"
	has_many :players
end
