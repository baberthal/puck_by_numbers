class AddAllPlayersToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.integer :a1, references: [:Player, :player_id]
      t.integer :a2, references: [:Player, :player_id]
      t.integer :a3, references: [:Player, :player_id]
      t.integer :a4, references: [:Player, :player_id]
      t.integer :a5, references: [:Player, :player_id]
      t.integer :a6, references: [:Player, :player_id]
      t.integer :h1, references: [:Player, :player_id]
      t.integer :h2, references: [:Player, :player_id]
      t.integer :h3, references: [:Player, :player_id]
      t.integer :h4, references: [:Player, :player_id]
      t.integer :h5, references: [:Player, :player_id]
      t.integer :h6, references: [:Player, :player_id]
    end
  end
end
