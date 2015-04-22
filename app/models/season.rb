class Season < ActiveRecord::Base
  include GameScraper
  self.primary_key = :season_years
  has_many :games, :foreign_key => :season_years
  has_many :events, through: :games
end
