class ChangeGamesTable < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :season_id, :integer
      t.belongs_to :season, index: true
    end
  end
end
