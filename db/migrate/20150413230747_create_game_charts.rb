class CreateGameCharts < ActiveRecord::Migration
  def change
    create_table :game_charts do |t|
      t.belongs_to :game
      t.string :chart_type
      t.text :data

      t.timestamps null: false
    end
  end
end
