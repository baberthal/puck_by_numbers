class CreateSituations < ActiveRecord::Migration
  def change
    create_table :situations do |t|
			t.string :name
    end
  end
end
