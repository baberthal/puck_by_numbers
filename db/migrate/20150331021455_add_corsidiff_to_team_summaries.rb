class AddCorsidiffToTeamSummaries < ActiveRecord::Migration
  def change
    add_column :team_game_summaries, :c_diff, :integer
    add_column :team_game_summaries, :f_diff, :integer
  end
end
