class AddSessionToGames < ActiveRecord::Migration
  def change
    add_column :games, :session, :integer
  end
end
