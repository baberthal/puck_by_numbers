class AddCorsiAgainstToTeamGameSummaries < ActiveRecord::Migration
	def change
		add_column :team_game_summaries, :ca, :integer
	end
end
