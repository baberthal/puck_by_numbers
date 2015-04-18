class AddSituationToTeamGameSummary < ActiveRecord::Migration
  def change
    add_column :team_game_summaries, :situation, :string
  end
end
