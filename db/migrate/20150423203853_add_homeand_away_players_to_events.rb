class AddHomeandAwayPlayersToEvents < ActiveRecord::Migration
  def change
    add_column :events, :away_players, :text
    add_column :events, :home_players, :text
  end
end
