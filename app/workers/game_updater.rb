class GameUpdater
	include Sidekiq::Worker

	def perform(season_years, gcode)
		game = Game.find([season_years, gcode])
		game.event_scrape
	end

end
