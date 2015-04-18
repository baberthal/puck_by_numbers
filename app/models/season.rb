class Season < ActiveRecord::Base
  self.primary_key = :season_years
  has_many :games, :foreign_key => :season_years
  has_many :events, through: :games
end
