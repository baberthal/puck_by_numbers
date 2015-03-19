class Event < ActiveRecord::Base
	belongs_to :game
	belongs_to :team, foreign_key: event_team
end
