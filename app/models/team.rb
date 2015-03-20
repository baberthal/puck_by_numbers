class Team < ActiveRecord::Base
	has_many :events, foreign_key: :event_team_id
end
