class GameUpdater
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)
    game.event_scrape
    game.home_players
    game.away_players
  end

end
#  vim: set ts=8 sw=2 tw=0 et :
