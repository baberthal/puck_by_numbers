module Categorizable
  def goals
    self.where(event_type: "GOAL")
  end

  def shots
    self.where(event_type: ["GOAL", "SHOT"])
  end

  def misses
    self.where(event_type: "MISS")
  end

  def blocks
    self.where(event_type: "BLOCK")
  end

  def corsi_events
    self.where(event_type: ["GOAL", "SHOT", "MISS", "BLOCK"])
  end

  def fenwick_events
    self.where(event_type: ["GOAL", "SHOT", "MISS"])
  end

  def hits
    self.where(event_type: "HIT")
  end

  def penalties
    self.where(event_type: "PENL")
  end

  def faceoffs
    self.where(event_type: "FAC")
  end
end
