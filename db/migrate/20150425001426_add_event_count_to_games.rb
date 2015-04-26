class AddEventCountToGames < ActiveRecord::Migration
  def change
    add_column :games, :event_count, :integer
  end
end
