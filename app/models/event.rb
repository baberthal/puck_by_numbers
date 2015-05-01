class Event < ActiveRecord::Base
  include Filterable
  include Situational
  include Categorizable

  serialize :home_players, Array
  serialize :away_players, Array

  self.primary_keys = [:event_number, :gcode, :season_years]

  belongs_to :game, :foreign_key => [:season_years, :gcode], counter_cache: :event_count, inverse_of: :events
  belongs_to :event_team, :class_name => "Team"
  has_one :location, :foreign_key => [:event_number, :gcode, :season_years]
  belongs_to :event_player_1, :class_name => "Player"
  belongs_to :event_player_2, :class_name => "Player"
  belongs_to :event_player_3, :class_name => "Player"
  belongs_to :away_G, :class_name => "Player"
  belongs_to :home_G, :class_name => "Player"
  belongs_to :a1, :class_name => "Player", :foreign_key => :a1_id
  belongs_to :a2, :class_name => "Player", :foreign_key => :a2_id
  belongs_to :a3, :class_name => "Player", :foreign_key => :a3_id
  belongs_to :a4, :class_name => "Player", :foreign_key => :a4_id
  belongs_to :a5, :class_name => "Player", :foreign_key => :a5_id
  belongs_to :a6, :class_name => "Player", :foreign_key => :a6_id
  belongs_to :h1, :class_name => "Player", :foreign_key => :h1_id
  belongs_to :h2, :class_name => "Player", :foreign_key => :h2_id
  belongs_to :h3, :class_name => "Player", :foreign_key => :h3_id
  belongs_to :h4, :class_name => "Player", :foreign_key => :h4_id
  belongs_to :h5, :class_name => "Player", :foreign_key => :h5_id
  belongs_to :h6, :class_name => "Player", :foreign_key => :h6_id

  scope :final, -> { where(seconds: 3600) }
  validates :event_number, :uniqueness => { :scope => [:gcode, :season_years] }
  before_save :cache_players

  def players
    a1 a2 a3 a4 a5 a6 h1 h2 h3 h4 h5 h6
  end

  def self.by_player(player_id)
    where("a1_id = :player OR a2_id = :player OR a3_id = :player OR a4_id = :player OR a5_id = :player OR a6_id = :player OR h1_id = :player OR h2_id = :player OR h3_id = :player OR h4_id = :player OR h5_id = :player OR h6_id = :player OR home_G_id = :player OR away_G_id = :player", player: player_id).uniq
  end

  def goalies_in?
    if self.home_G_id != nil && self.away_G_id != nil
      true
    else
      false
    end
  end

  def cache_players
    home = []
    home << h1_id
    home << h2_id
    home << h3_id
    home << h4_id
    home << h5_id
    home << home_G_id
    home.compact!

    away = []
    away << a1_id
    away << a2_id
    away << a3_id
    away << a4_id
    away << a5_id
    away << away_G_id
    away.compact!

    self.home_players = home
    self.away_players = away
  end

end
