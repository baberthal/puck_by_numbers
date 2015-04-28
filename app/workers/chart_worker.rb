class ChartWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)
    game.gather_chart_data
  end

end
