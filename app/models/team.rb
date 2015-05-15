class Team < ActiveRecord::Base
  include Statable
  has_many :events, foreign_key: :event_team_id
  has_many :home_games, :class_name => "Game", foreign_key: :home_team_id
  has_many :away_games, :class_name => "Game", foreign_key: :away_team_id
  has_many :players
  has_many :team_game_summaries

  def games
    home = home_games.pluck(:id)
    away = away_games.pluck(:id)
    all_games = [ home + away ].flatten
    Game.where(id: all_games)
  end

end
