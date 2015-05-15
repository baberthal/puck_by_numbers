class AddGameForeignKeysToEvents < ActiveRecord::Migration
  def change
    add_column :events, :game_id, :integer
    add_foreign_key :events, :games
  end
end
