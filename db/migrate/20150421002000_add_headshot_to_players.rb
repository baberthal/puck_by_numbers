class AddHeadshotToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :headshot, :text
  end
end
