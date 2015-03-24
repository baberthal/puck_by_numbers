class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
			t.belongs_to :player, index: true
			t.belongs_to :event, index: true
			t.string :event_role, limit: 3
		end
  end
end
