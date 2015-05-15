module Statable
  def goals
    events.where(event_type: "GOAL")
  end

  def goals_against
    events.where.not(event_type: "GOAL")
  end

  def shots
    events.where(event_type: ["GOAL", "SHOT"])
  end

  def misses
    events.where(event_type: "MISS")
  end

  def blocks
    events.where(event_type: "BLOCK")
  end

  def corsi_events
    events.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"])
  end

  def fenwick_events
    events.where(event_type: ["GOAL", "SHOT", "MISS"])
  end

  def hits
    events.where(event_type: "HIT")
  end

  def penalties
    events.where(event_type: "PENL")
  end

  def faceoffs
    events.where(event_type: "FAC")
  end

  def zone_starts_o(team)
    if team == home_team
      events.joins(:location).where(event_type: "FAC",
                                    locations: {:home_zone => "Off" })
    elsif team == away_team
      events.joins(:location).where(event_type: "FAC",
                                    locations: {:home_zone => "Def" })
    end
  end

end
