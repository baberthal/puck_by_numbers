class PlayerWorker
  include Sidekiq::Worker

  def perform(player_id)
    player = Player.find(player_id)
    begin
      player.set_active
    rescue
      player.active = false
      player.save
    end
  end

end
