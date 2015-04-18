class ChangeStatusInGames < ActiveRecord::Migration
  def change
    change_column_null :games, :status, true
  end
end
