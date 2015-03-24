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
			t.belongs_to :home_team, class: "Team", index:true
			t.belongs_to :away_team, class: "Team", index:true
			t.integer :fscore_home, limit: 2, null: false
			t.integer :fscore_away, limit: 2, null: false
			t.datetime :game_start, null: false, index: true
			t.datetime :game_end, null: false, index:true
			t.integer :periods, limit: 1, null: false
		end

		create_table :events do |t|
			t.belongs_to :game, index:true
			t.integer :event_number, limit: 3, unsigned: true, null: false
			t.integer :period, limit: 1, unsigned: true, null: false
			t.float :seconds, null: false
			t.string :event_type, null: false
			t.belongs_to :event_team, class: "Team", index:true
			t.belongs_to :event_player_1, class: "Player", index:true
			t.belongs_to :event_player_2, class: "Player", index:true
			t.belongs_to :event_player_3, class: "Player", index:true
			t.integer :a1_id
			t.integer :a2_id
			t.integer :a3_id
			t.integer :a4_id
			t.integer :a5_id
			t.integer :a6_id
			t.integer :h1_id
			t.integer :h2_id
			t.integer :h3_id
			t.integer :h4_id
			t.integer :h5_id
			t.integer :h6_id
			t.belongs_to :away_G, class: "Player", index:true
			t.belongs_to :home_G, class: "Player", index:true
			t.string :description
			t.integer :home_score, null: false, limit: 2, unsigned: true
			t.integer :away_score, null: false, limit: 2, unsigned: true
			t.float :event_length
			t.integer :home_skaters, null: false, limit: 2, unsigned: true
			t.integer :away_skaters, null: false, limit: 2, unsigned: true
		end

		create_table :locations do |t|
			t.belongs_to :event, index:true
			t.integer :distance, unsigned: true, limit: 3
			t.string :home_zone, limit: 3
			t.integer :x_coord, limit: 3
			t.integer :y_coord, limit: 3
			t.integer :location_section, unsigned: true, limit: 2
			t.integer :new_location_section, unsigned: true, limit: 2
			t.integer :new_x_coord, limit: 3
			t.integer :new_y_coord, limit: 3
		end
	end
end
