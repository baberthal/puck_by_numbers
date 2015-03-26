class Player < ActiveRecord::Base
	belongs_to :team
	has_many :participants
	has_many :primary_events, class_name: "Event", foreign_key: 'primary_event_player_id', autosave: true
	has_many :events, through: :participants
	has_many :games, through: :events

	def change_team(new_team_id)
		self.team_id = new_team_id
		self.save
	end

	def sa_for(options = {})
		options[:games] ||= self.games.all
		options[:unblocked] ||= nil
		options[:sit] ||= "5v5"

		etype = ["MISS", "SHOT", "GOAL"]
		etype << "BLOCK" unless options[:unblocked]

		if options[:sit] == "5v5"
			hs = 6
			as = 6

		elsif options[:sit] == "5v4"
			if team == home_team
				hs = 6
				as = 5
			else
				as = 6
				hs = 5
			end

		elsif options[:sit] == "4v5"
			if team == home_team
				hs = 6
				as = 5
			else
				as = 6
				hs = 5
			end

		else
			hs = [1,2,3,4,5,6]
			as = [1,2,3,4,5,6]
		end

		self.events.where(game_id: options[:games], event_type: etype, home_skaters: hs, away_skaters: as).where.not(away_G: nil, home_G: nil).count
	end

end
