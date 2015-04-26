class ChangeEventTable < ActiveRecord::Migration
  def change
    change_column_null :games, :game_number, true
  end
end
