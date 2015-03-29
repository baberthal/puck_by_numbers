class CreatePlayerGameSummaries < ActiveRecord::Migration
  def change
    create_table :player_game_summaries do |t|
			t.belongs_to :player, index:true
			t.belongs_to :game, index:true
			t.integer :goals
			t.integer :a1
			t.integer :a2
			t.integer :points
			t.integer :ind_sc
			t.integer :ind_cf
			t.integer :c_diff
			t.integer :f_diff
			t.integer :g_diff
			t.integer :cf
			t.integer :ff
			t.integer :zso
			t.integer :zsd
			t.integer :blocks
			t.integer :fo_won
			t.integer :fo_lost
			t.integer :hits
			t.integer :hits_taken
			t.integer :pen
			t.integer :pen_drawn
			t.float :toi

			t.timestamps null: false
		end
  end
end
