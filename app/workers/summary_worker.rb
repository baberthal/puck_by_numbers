class SummaryWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)
    game.create_all_summaries
  end

end
