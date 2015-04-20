class AddSituationToGameCharts < ActiveRecord::Migration
  def change
    add_column :game_charts, :situation, :integer
  end
end
