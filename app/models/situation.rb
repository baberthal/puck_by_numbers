class SituationQuery
	def initialize(model)
		@model = model
	end

	def sitfind(id)
    if  id == 1
      skater_params = { home_skaters: 6, away_skaters: 6 }
      goalie_not_params = { home_G_id: nil, away_G_id: nil }

    elsif  id == 2
      if ha == 'h'
        skater_params = { home_skaters: 6, away_skaters: 5 }
      else
        skater_params = { home_skaters: 5, away_skaters: 6 }
      end
      goalie_not_params = { home_G_id: nil, away_G_id: nil }

    elsif id == 3
      if ha == 'h'
        skater_params = { home_skaters: 5, away_skaters: 6 }
      else
        skater_params = { home_skaters: 6, away_skaters: 5 }
      end
      goalie_not_params = { home_G_id: nil, away_G_id: nil }

    elsif id == 4
      skater_params = { home_skaters: 5, away_skaters: 5 }
      goalie_not_params = { home_G_id: nil, away_G_id: nil }

    elsif id == 5
      skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
      if ha == 'h'
        goalie_params = { home_G_id: nil }
        goalie_not_params = { away_G_id: nil }
      else
        goalie_params = { away_G_id: nil }
        goalie_not_params = { home_G_id: nil }
      end

    elsif id == 6
      if ha == 'h'
        goalie_params = { away_G_id: nil }
        goalie_not_params = { home_G_id: nil }
      else
        goalie_params = { home_G_id: nil }
        goalie_not_params = { away_G_id: nil }
      end

    elsif id == 7
      skater_params = { home_skaters: [1,2,3,4,5,6], away_skaters: [1,2,3,4,5,6] }
      goalie_not_params = { home_G_id: 1, away_G_id: 1 }
    end

		@skater_params = skater_params
		@goalie_not_params = goalie_not_params
		if goalie_params?
			self.where(@skater_params).where.not(@goalie_params).where(@goalie_params)
		else
			self.where(@skater_params).where.not(@goalie_params)
		end
	end
end
