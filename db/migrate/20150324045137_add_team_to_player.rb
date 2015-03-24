class AddTeamToPlayer < ActiveRecord::Migration
  def change
    add_reference :players, :team, index: true
    add_foreign_key :players, :teams
  end
end
