class ChangeSeasonPrimaryKeys < ActiveRecord::Migration
  def change
    change_column :seasons, :season_years, :primary_key
  end
end
