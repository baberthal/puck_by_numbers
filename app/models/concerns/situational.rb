module Situational
  extend  ActiveSupport::Concern

  included do
    before_save :set_situation, :on => :create
  end

  def set_situation
    # Remind ourselves what the situations are
    # 1 -- 5 on 5 Evens
    # 2 -- Home Powerplay
    # 3 -- Away Powerplay
    # 4 -- 4 on 4 Evens
    # 5 -- Home Goalie Pulled
    # 6 -- Away Goalie Pulled
    if self.home_skaters == 6 && self.away_skaters == 6 && self.goalies_in?
      self.situation = 1

    elsif self.home_skaters == 6 && self.away_skaters == 5 && self.goalies_in?
      self.situation = 2

    elsif self.home_skaters == 5 && self.away_skaters == 6 && self.goalies_in?
      self.situation = 3

    elsif self.home_skaters == 5 && self.away_skaters == 5 && self.goalies_in?
      self.situation = 4

    elsif self.home_G_id == nil && self.away_G_id != nil
      self.situation = 5

    elsif self.home_G_id != nil && self.away_G_id == nil
      self.situation = 6

    end
  end

end
