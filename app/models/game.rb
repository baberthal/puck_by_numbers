class Game < ActiveRecord::Base
	belongs_to :season
	has_many :events
	has_one :game_summary
	before_save :create_summary


	protected
		def create_summary
			game_summary.fscore_home = Game.fscore_home
			game_summary.fscore_away = Game.fscore_away
			game_summary.home_corsi_for_tot = Game.events.event_type.where( :event_type => ["BLOCK","GOAL", "MISS", "SHOT"], :event_team_id => Game.home_team ).sum
			game_summary.away_corsi_for_tot = Game.events.event_type.where( :event_type => ["BLOCK","GOAL", "MISS", "SHOT"], :event_team_id => Game.away_team ).sum
			game_summary.home_corsi_against_tot = game_summary.away_corsi_for_tot
			game_summary.away_corsi_against_tot = game_summary.home_corsi_for_tot
			game_summary.home_fenwick_for_tot = Game.events.event_type.where( :event_type => ["GOAL", "MISS", "SHOT"], :event_team_id => Game.home_team ).sum
			game_summary.away_fenwick_for_tot = Game.events.event_type.where( :event_type => ["GOAL", "MISS", "SHOT"], :event_team_id => Game.away_team ).sum
			game_summary.home_fenwick_against_tot = game_summary.away_fenwick_for_tot
			game_summary.away_fenwick_against_tot = game_summary.home_fenwick_for_tot

			game_summary.home_corsi_for_evens = Game.events.event_type.where( :event_type => ["BLOCK","GOAL", "MISS", "SHOT"], :event_team_id => Game.home_team, Game.home_skaters == 6, Game.away_skaters == 6 ).sum
			game_summary.away_corsi_for_evens = Game.events.event_type.where( :event_type => ["BLOCK","GOAL", "MISS", "SHOT"], :event_team_id => Game.away_team, Game.home_skaters == 6, Game.away_skaters == 6 ).sum
			game_summary.home_corsi_against_evens = game_summary.away_corsi_for_evens
			game_summary.away_corsi_against_evens = game_summary.home_corsi_for_evens
			game_summary.home_fenwick_for_evens = Game.events.event_type.where( :event_type => ["GOAL", "MISS", "SHOT"], :event_team_id => Game.home_team, Game.home_skaters == 6, Game.away_skaters == 6 ).sum
			game_summary.away_fenwick_for_evens = Game.events.event_type.where( :event_type => ["GOAL", "MISS", "SHOT"], :event_team_id => Game.away_team, Game.home_skaters == 6, Game.away_skaters == 6 ).sum
			game_summary.home_fenwick_against_evens = game_summary.away_fenwick_for_evens
			game_summary.away_fenwick_against_evens = game_summary.home_fenwick_for_evens
			game_summary.home_sc_for
			game_summary.away_sc_for
			game_summary.home_sc_against
			game_summary.away_sc_against
		end
end
