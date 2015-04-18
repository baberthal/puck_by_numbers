class RemoveSeasonidFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :season_id, :integer
  end
end
