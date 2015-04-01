class AddSituationToPlayerGameSummaries < ActiveRecord::Migration
  def change
    add_column :player_game_summaries, :situation, :string
  end
end
