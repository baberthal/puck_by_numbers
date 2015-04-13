class RemoveSituations < ActiveRecord::Migration
  def change
    drop_table :situations
  end
end
