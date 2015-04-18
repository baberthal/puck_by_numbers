class FixKeysOnGameSummaries < ActiveRecord::Migration
  def change
    change_table :team_game_summaries do |t|
      t.remove :game_id
      t.integer :season_years, limit: 8, references: [:Season, :season_years]
      t.integer :gcode, limit: 8, references: [:Game, :gcode]
    end

    change_table :player_game_summaries do |t|
      t.remove :game_id
      t.integer :season_years, limit: 8, references: [:Season, :season_years]
      t.integer :gcode, limit: 8, references: [:Game, :gcode]
    end
  end
end
