class Game < ActiveRecord::Base
	belongs_to :season
	has_many :events
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"
	scope :home_events, -> { joins(:events).where('events.event_team_id = ?', :home_team) }



#	protected
#		def generate_summary
#			game_summary = GameSummary.new
#			game_summary.game_id = self.id
#		end
end
