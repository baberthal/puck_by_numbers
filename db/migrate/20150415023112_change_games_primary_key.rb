class ChangeGamesPrimaryKey < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :season_years, limit: 8, references: [:Season, :season_years]
    end
  end
end
