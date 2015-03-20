class Event < ActiveRecord::Base
	belongs_to :game
	belongs_to :team, foreign_key: event_team
	has_one :location
	has_one :event_player_1, source: :players
	has_one :event_player_2, source: :players
	has_one :event_player_3, source: :players
	has_one :a1, source: :players
	has_one :a2, source: :players
	has_one :a3, source: :players
	has_one :a4, source: :players
	has_one :a5, source: :players
	has_one :a6, source: :players
	has_one :h1, source: :players
	has_one :h2, source: :players
	has_one :h3, source: :players
	has_one :h4, source: :players
	has_one :h5, source: :players
	has_one :h6, source: :players
end
