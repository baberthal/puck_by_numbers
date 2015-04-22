class AddInfoToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :external_id, :integer
  end
end
