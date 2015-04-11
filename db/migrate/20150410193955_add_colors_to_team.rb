class AddColorsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :color1, :string
    add_column :teams, :color2, :string
    add_column :teams, :color3, :string
    add_column :teams, :color4, :string
  end
end
