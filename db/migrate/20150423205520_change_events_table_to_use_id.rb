class ChangeEventsTableToUseId < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.rename :h1, :h1_id
      t.rename :h2, :h2_id
      t.rename :h3, :h3_id
      t.rename :h4, :h4_id
      t.rename :h5, :h5_id
      t.rename :h6, :h6_id
      t.rename :a1, :a1_id
      t.rename :a2, :a2_id
      t.rename :a3, :a3_id
      t.rename :a4, :a4_id
      t.rename :a5, :a5_id
      t.rename :a6, :a6_id
    end
  end
end
