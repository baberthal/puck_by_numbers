class AddSoManyIndices < ActiveRecord::Migration
  def change
    add_index :events, :situation
    add_index :events, :season_years
    add_index :events, :gcode
    add_index :events, :home_skaters
    add_index :events, :away_skaters
    add_index :players, :last_name
    add_index :players, :first_name
  end
end
