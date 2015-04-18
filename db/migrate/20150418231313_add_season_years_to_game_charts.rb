class AddSeasonYearsToGameCharts < ActiveRecord::Migration
  def change
    change_table :game_charts do |t|
      t.remove :game_id
      t.integer :season_years, limit: 8, references: [:Season, :season_years]
      t.integer :gcode, references: [:Game, :gcode]
    end
  end
end
