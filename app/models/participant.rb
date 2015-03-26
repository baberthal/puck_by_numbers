class Participant < ActiveRecord::Base
	belongs_to :event
	belongs_to :player

	after_create :destroy_blanks

	def destroy_blanks
		@participant.destroy if player_id.nil?
	end
end
