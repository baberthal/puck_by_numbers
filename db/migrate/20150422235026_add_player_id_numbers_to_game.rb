class AddPlayerIdNumbersToGame < ActiveRecord::Migration
  def change
    add_column :games, :player_id_numbers, :text
  end
end
