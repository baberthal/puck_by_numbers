class CreateEventPlayers < ActiveRecord::Migration
  def change
    create_table :event_players do |t|
      t.belongs_to :event, index: true
      t.belongs_to :player, index: true
      t.string :role, limit: 3

      t.timestamps null: false
    end
    add_foreign_key :event_players, :events
    add_foreign_key :event_players, :players
  end
end
