class AddNewFKsToLocation < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.integer :event_number, references: [:Event, :event_number], index: true
      t.integer :gcode, references: [:Game, :gcode], index: true
      t.integer :season_years, references: [:Season, :season_years], index: true
    end
  end
end
