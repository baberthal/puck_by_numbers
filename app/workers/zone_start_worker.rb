class ZoneStartWorker
  include Sidekiq::Worker

  def perform(game_summary_id)
    gs = PlayerGameSummary.find(game_summary_id)
    gs.get_zone_start_data
  end

end
