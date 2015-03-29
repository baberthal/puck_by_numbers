class Game < ActiveRecord::Base
	include Statable
	belongs_to :season
	belongs_to :home_team, :class_name => "Team"
	belongs_to :away_team, :class_name => "Team"
	has_many :events
	has_many :event_teams, through: :events
	has_many :players, through: :events
	has_many :player_game_summaries
	has_many :team_game_summaries
	has_many :participants, through: :events

	def home_team_summary
		team_game_summaries.find_by(team_id: home_team_id)
	end

	def away_team_summary
		team_game_summaries.find_by(team_id: away_team_id)
	end

	def create_team_summary(team)
		TeamGameSummary.create(team_id: team.id) do |ts|
			ts.game_id = id
			ts.gf = goals.where(event_team_id: team.id).count
			ts.sf = shots.where(event_team_id: team.id).count
			ts.msf = misses.where(event_team_id: team.id).count
			ts.bsf = blocks.where(event_team_id: team.id).count
			ts.cf = corsi_events.where(event_team_id: team.id).count
			ts.hits = hits.where(event_team_id: team.id).count
			ts.pen = penalties.where(event_team_id: team.id).count
			ts.fo_won = faceoffs.where(event_team_id: team.id).count
		end
	end

	def create_player_summaries
		players.uniq.each do |player|
			PlayerGameSummary.create(player: player) do |ps|
				ps.game_id = id
				ps.goals = player.goals.where(game_id: id).count
				ps.a1 = player.primary_assists.where(game_id: id).count
				ps.a2 = player.secondary_assists.where(game_id: id).count
				ps.points = player.goals.where(game_id: id).count + player.primary_assists.where(game_id: id).count + player.secondary_assists.where(game_id: id).count
				ps.ind_cf = player.ind_corsi_events.where(game_id: id).count
				ps.c_diff = (player.on_ice_corsi_events.where(game_id: id, event_team: player.team).count) - (player.on_ice_corsi_events.where(game_id: id).where.not(event_team: player.team).count)
				ps.f_diff = (player.on_ice_fenwick_events.where(game_id: id, event_team: player.team).count) - (player.on_ice_fenwick_events.where(game_id: id).where.not(event_team: player.team).count)
				ps.g_diff = (player.on_ice_goals.where(game_id: id, event_team: player.team).count) - (player.on_ice_goals.where(game_id: id).where.not(event_team: player.team).count)
				ps.cf = player.corsi_for.where(game_id: id).count
				ps.ff = player.fenwick_for.where(game_id: id).count
				ps.blocks = player.blocks.where(game_id: id).count
				ps.fo_won = player.faceoffs_won.where(game_id: id).count
				ps.fo_lost = player.faceoffs_lost.where(game_id: id).count
				ps.hits = player.hits.where(game_id: id).count
				ps.hits_taken = player.hits_taken.where(game_id: id).count
				ps.pen = player.penalties.where(game_id: id)
				ps.pen_drawn = player.penalties_drawn.where(game_id: id).count
			end
		end
	end
end
