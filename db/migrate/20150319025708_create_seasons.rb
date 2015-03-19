class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
			t.integer :season_years, limit: 8, null: false, unsigned: true
    end

		create_table :games do |t|
			t.belongs_to :season, index:true
			t.integer :game_number, limit: 4, null: false
			t.integer :gcode, limit: 5, null: false, index:true
			t.integer :status, limit: 1, null: false
			t.string :home_team, limit: 3, null: false, index:true
			t.string :away_team, limit: 3, null: false, index:true
			t.integer :fscore_home, limit: 2, null: false
			t.integer :fscore_away, limit: 2, null: false
			t.datetime :game_start, null: false, index: true
			t.datetime :game_end, null: false, index:true
			t.integer :periods, limit: 1, null: false
		end
	end
end
