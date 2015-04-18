class ChangeEventsTable < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :game_id, :integer
      t.belongs_to :game, index: true
      t.integer :season_years, limit:8
    end
  end
end
