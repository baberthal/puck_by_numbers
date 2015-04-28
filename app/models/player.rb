class Player < ActiveRecord::Base
  include WithOrWithoutYou
  include PlayerStatable
  include PlayerScraper
  belongs_to :team
  has_many :primary_events, class_name: "Event", foreign_key: 'event_player_1_id'
  has_many :secondary_events, class_name: "Event", foreign_key: 'event_player_2_id'
  has_many :tertiary_events, class_name: "Event", foreign_key: 'event_player_3_id'
  has_many :a1_events, class_name: "Event", foreign_key: 'a1_id'
  has_many :a2_events, class_name: "Event", foreign_key: 'a2_id'
  has_many :a3_events, class_name: "Event", foreign_key: 'a3_id'
  has_many :a4_events, class_name: "Event", foreign_key: 'a4_id'
  has_many :a5_events, class_name: "Event", foreign_key: 'a5_id'
  has_many :a6_events, class_name: "Event", foreign_key: 'a6_id'
  has_many :h1_events, class_name: "Event", foreign_key: 'h1_id'
  has_many :h2_events, class_name: "Event", foreign_key: 'h2_id'
  has_many :h3_events, class_name: "Event", foreign_key: 'h3_id'
  has_many :h4_events, class_name: "Event", foreign_key: 'h4_id'
  has_many :h5_events, class_name: "Event", foreign_key: 'h5_id'
  has_many :h6_events, class_name: "Event", foreign_key: 'h6_id'
  has_many :events_as_home_G, class_name: "Event", foreign_key: 'home_G_id'
  has_many :events_as_away_G, class_name: "Event", foreign_key: 'away_G_id'
  has_many :player_game_summaries

  scope :goalies, -> { where(position: "G") }
  scope :skaters, -> { where.not(position: "G") }
  scope :active, -> { where.not(id: 1).where(active: true) }

  serialize :bio, Hash

  def games
    Game.by_player(self.id)
  end

  def events
    Event.by_player(self.id)
  end

  def set_active
    game = Game.select { |g| g.home_player_id_numbers.include?(self.id) ||
                         g.away_player_id_numbers.include?(self.id) }.last
    if !game.nil? && game.season_years == Season.last.season_years

      self.active = true
      self.save
    end
  end

  def change_team(new_team)
    self.team = new_team
    self.save
  end

  def determine_team
    a = games.last unless games.nil?
    if a.home_player_id_numbers.include?(id)
      t = a.home_team
    elsif a.away_player_id_numbers.include?(id)
      t = a.away_team
    else
      raise "Couldn't find the player in any recent events"
    end
    change_team(t)
  end

  def nickname
    nicknames = []
    if self.first_name == "Nathan"
      nicknames << "Nate"
    else
      nicknames << nil
    end
  end

  private

  def self.ransackable_scopes(auth_object = nil)
    %i(goalies skaters active)
  end

end
