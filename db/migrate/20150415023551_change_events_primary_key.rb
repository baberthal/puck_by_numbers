class ChangeEventsPrimaryKey < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :season_years
      t.integer :season_years, limit: 8, references: [:Season, :season_years]
      t.integer :gcode, limit: 5, references: [:Game, :gcode]
    end
  end
end
