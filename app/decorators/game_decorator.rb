class GameDecorator
	attr_reader :game

	def initialize(game)
		@game = game
	end

	def is_recent?
		game.start_time < 2.days.ago
	end

end
