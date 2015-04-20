class AddIndexToTeamGameSummaries < ActiveRecord::Migration
  def change
    add_index :team_game_summaries, :season_years
    add_index :team_game_summaries, :gcode
  end
end
