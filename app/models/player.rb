class Player < ActiveRecord::Base
	belongs_to :team
	has_many :participants
	has_many :events, through: :participants
	has_many :event_roles, through: :participants


	private
	def determine_team
		self.team = Player.events.where(event_player_1_id: Player.id).last.event_team.id
	end

end
