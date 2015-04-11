class Game < ActiveRecord::Base
	include Statable
	include Summarizable
	belongs_to :season
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"
	has_many :events
	has_many :event_teams, through: :events
	has_many :players, through: :events
	has_many :player_game_summaries
	has_many :team_game_summaries
	has_many :participants, through: :events

	scope :recent, -> { where("game_start >= ?", 2.days.ago)}

	accepts_nested_attributes_for :events

	def home_team_summary
		team_game_summaries.find_by(team_id: home_team_id)
	end

	def away_team_summary
		team_game_summaries.find_by(team_id: away_team_id)
	end

	def away_player_summaries
		player_game_summaries.joins(:player).where(player: {team: away_team})
	end

	def home_player_summaries
		player_game_summaries.joins(:player).where(player: {team: home_team})
	end

	def home_players
		players.where(team_id: home_team_id).uniq
	end

	def away_players
		players.where(team_id: away_team_id).uniq
	end

	def running_event_count(type, team)
		if type == "corsi"
			a = self.corsi_events.where(event_team_id: team).uniq.pluck(:seconds)
		elsif type == "fenwick"
			a = self.fenwick_events.where(event_team_id: team).uniq.pluck(:seconds)
		end
		arr = a.each_with_index.map { |value, index| [(value/60).round(2), index+1] }
		arr.unshift([0,0])
		arr.insert(-1, [60, arr.last[1]])
	end

	def home_goals
		hg = goals.where(event_team: self.home_team).pluck(:seconds)
		hg.each.map { |x| x/60.round(2)}
	end

	def away_goals
		ag = goals.where(event_team: self.away_team).pluck(:seconds)
		ag.each.map { |x| x/60.round(2) }
	end
end
