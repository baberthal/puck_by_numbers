class Event < ActiveRecord::Base
	belongs_to :game
	belongs_to :event_team, class_name: "Team"
	has_one :location
	belongs_to :event_player_1, :class_name => "Player"
	belongs_to :event_player_2, :class_name => "Player"
	belongs_to :event_player_3, :class_name => "Player"
	belongs_to :a1, :class_name => "Player"
	belongs_to :a2, :class_name => "Player"
	belongs_to :a3, :class_name => "Player"
	belongs_to :a4, :class_name => "Player"
	belongs_to :a5, :class_name => "Player"
	belongs_to :a6, :class_name => "Player"
	belongs_to :h1, :class_name => "Player"
	belongs_to :h2, :class_name => "Player"
	belongs_to :h3, :class_name => "Player"
	belongs_to :h4, :class_name => "Player"
	belongs_to :h5, :class_name => "Player"
	belongs_to :h6, :class_name => "Player"
	belongs_to :away_G, :class_name => "Player"
	belongs_to :home_G, :class_name => "Player"
end
