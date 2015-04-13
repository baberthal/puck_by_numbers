class AddSituationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :situation, :integer
  end
end
