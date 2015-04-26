class AddEventsCountToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :primary_event_count, :integer
    add_column :players, :secondary_event_count, :integer
    add_column :players, :tertiary_event_count, :integer
    add_column :players, :event_count, :integer
  end
end
