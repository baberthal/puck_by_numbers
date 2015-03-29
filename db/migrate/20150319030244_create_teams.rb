class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
			t.string :abbr, limit: 3
			t.string :nickname
    end
  end
end
