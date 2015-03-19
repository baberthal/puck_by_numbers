class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
			t.string :position, limit: 1
			t.string :last_name
			t.string :first_name
			t.string :number_first_last
			t.integer :player_index, unsigned: true
			t.integer :pC, limit: 1, unsigned: true
			t.integer :pR, limit: 1, unsigned: true
			t.integer :pL, limit: 1, unsigned: true
			t.integer :pD, limit: 1, unsigned: true
			t.integer :pG, limit: 1, unsigned: true
    end
  end
end
