class CreateGameSummaries < ActiveRecord::Migration
  def change
    create_table :game_summaries do |t|
			t.belongs_to :game, index:true
			t.integer :fscore_home
			t.integer :fscore_away
			t.integer :home_corsi_for_tot
			t.integer :away_corsi_for_tot
			t.integer :home_corsi_against_tot
			t.integer :away_corsi_against_tot
			t.integer :home_fenwick_for_tot
			t.integer :away_fenwick_for_tot
			t.integer :home_fenwick_against_tot
			t.integer :away_fenwick_against_tot
			t.integer :home_corsi_for_evens
			t.integer :away_corsi_for_evens
			t.integer :home_corsi_against_evens
			t.integer :away_corsi_against_evens
			t.integer :home_fenwick_for_evens
			t.integer :away_fenwick_for_evens
			t.integer :home_fenwick_against_evens
			t.integer :away_fenwick_against_evens
			t.integer :home_sc_for
			t.integer :away_sc_for
			t.integer :home_sc_against
			t.integer :away_sc_against
		end
  end
end
