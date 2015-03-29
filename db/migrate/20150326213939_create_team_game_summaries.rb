class CreateTeamGameSummaries < ActiveRecord::Migration
  def change
    create_table :team_game_summaries do |t|
			t.belongs_to :game, index:true
			t.belongs_to :team, index:true
			t.integer :gf
			t.integer :sf
			t.integer :msf
			t.integer :bsf
			t.integer :scf
			t.integer :cf
			t.integer :zso
			t.integer :hits
			t.integer :pen
			t.integer :fo_won
			t.float :toi

      t.timestamps null: false
    end
  end
end
