class AddTeamToGameChart < ActiveRecord::Migration
  def change
    change_table :game_charts do |t|
      t.integer :team_id, references: [:Team, :team_id]
    end
  end
end
