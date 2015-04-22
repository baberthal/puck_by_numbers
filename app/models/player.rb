class Player < ActiveRecord::Base
  include WithOrWithoutYou
  include PlayerStatable
  include PlayerScraper
  belongs_to :team
  has_many :participants
  has_many :primary_events, class_name: "Event", foreign_key: 'event_player_1_id', autosave: true
  has_many :secondary_events, class_name: "Event", foreign_key: 'event_player_2_id', autosave: true
  has_many :tertiary_events, class_name: "Event", foreign_key: 'event_player_3_id', autosave: true
  has_many :a1_events, class_name: "Event", foreign_key: 'a1'
  has_many :a2_events, class_name: "Event", foreign_key: 'a2'
  has_many :a3_events, class_name: "Event", foreign_key: 'a3'
  has_many :a4_events, class_name: "Event", foreign_key: 'a4'
  has_many :a5_events, class_name: "Event", foreign_key: 'a5'
  has_many :a6_events, class_name: "Event", foreign_key: 'a6'
  has_many :h1_events, class_name: "Event", foreign_key: 'h1'
  has_many :h2_events, class_name: "Event", foreign_key: 'h2'
  has_many :h3_events, class_name: "Event", foreign_key: 'h3'
  has_many :h4_events, class_name: "Event", foreign_key: 'h4'
  has_many :h5_events, class_name: "Event", foreign_key: 'h5'
  has_many :h6_events, class_name: "Event", foreign_key: 'h6'
  has_many :games, through: :events
  has_many :player_game_summaries

  scope :goalies, -> { where(position: "G") }
  scope :skaters, -> { where.not(position: "G") }
  scope :active, -> { joins(:games).where.not(id: 1).where(games: { season_years: 20142015 }).uniq }

  serialize :bio, Hash

  def change_team(new_team)
    self.team = new_team
    self.save
  end

  def determine_team
    unless self.events.nil?
      a = self.events.joins(:participants, :game).last
      if a.participants.find_by(player: self).event_role[0].to_s.downcase == "a"
        t = a.game.away_team
      elsif a.participants.find_by(player: self).event_role[0].to_s.downcase == "h"
        t = a.game.home_team
      end
    end
    change_team(t)
  end

  private

  def self.ransackable_scopes(auth_object = nil)
    %i(goalies skaters active)
  end
end
