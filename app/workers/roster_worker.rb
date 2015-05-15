class RosterWorker
  include Sidekiq::Worker

  def perform(player_id, options={})
    Player.find_or_initialize_by(player_id) do |player|
      player.position = options[:pos].to_s
      player.last_name = options[:last].to_s.downcase
      player.first_name = options[:first].to_s.downcase
      player.number_first_last = options[:numfirstlast].to_s
      player.player_index = options[:index].to_i
      player.pC = options[:pC].to_i
      player.pR = options[:pR].to_i
      player.pL = options[:pL].to_i
      player.pD = options[:pD].to_i
      player.pG = options[:pG].to_i
      player.save
    end

  end
end
