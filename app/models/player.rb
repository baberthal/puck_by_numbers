class Player < ActiveRecord::Base
	belongs_to :team
	has_many :participants
	has_many :events, through: :participants
end
