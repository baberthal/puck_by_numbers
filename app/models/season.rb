class Season < ActiveRecord::Base
	has_many :games
	has_many :events, through: :games
end
