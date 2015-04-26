class ChangePlayerIdNumbersOnGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.rename :player_id_numbers, :home_player_id_numbers
      t.text :away_player_id_numbers
    end
  end
end
