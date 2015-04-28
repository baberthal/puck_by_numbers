class AddGameChartsCountToGames < ActiveRecord::Migration
  def change
    add_column :games, :game_charts_count, :integer
  end
end
