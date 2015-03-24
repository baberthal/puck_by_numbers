class Player < ActiveRecord::Base
	belongs_to :team
	has_many :event_players
	has_many :events, through: :event_players
end
