class RemoveLimitFromPlayersActive < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.remove :active
      t.boolean :active
    end
  end
end
