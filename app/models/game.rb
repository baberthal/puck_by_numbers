class Game < ActiveRecord::Base
  include Statable
  include Summarizable
  include Filterable
  include Analyzable
  include GameScraper

  self.primary_keys = :season_years, :gcode

  belongs_to :season, :foreign_key => :season_years, inverse_of: :games
  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"
  has_many :events, :foreign_key => [:season_years, :gcode], inverse_of: :game
  has_many :event_teams, through: :events
  has_many :a1, -> { distinct }, through: :events
  has_many :a2, -> { distinct }, through: :events
  has_many :a3, -> { distinct }, through: :events
  has_many :a4, -> { distinct }, through: :events
  has_many :a5, -> { distinct }, through: :events
  has_many :a6, -> { distinct }, through: :events
  has_many :h1, -> { distinct }, through: :events
  has_many :h2, -> { distinct }, through: :events
  has_many :h3, -> { distinct }, through: :events
  has_many :h4, -> { distinct }, through: :events
  has_many :h5, -> { distinct }, through: :events
  has_many :h6, -> { distinct }, through: :events
  has_many :player_game_summaries, :foreign_key => [:season_years, :gcode]
  has_many :team_game_summaries, :foreign_key => [:season_years, :gcode]
  has_many :game_charts, :foreign_key => [:season_years, :gcode], inverse_of: :game

  scope :recent, -> { where("game_start >= ?", 2.days.ago)}
  scope :scraped, -> { joins(:events).where(events: { seconds: 3600 }) }
  scope :uncharted, -> { where(game_charts_count: nil)}
  scope :playoffs, -> { where(session: 2) }
  scope :regular_season, -> { where(session: 1) }

  after_create :parse_game_date, :set_status, :set_game_number
  before_save :set_session

  validates :gcode, :uniqueness => { :scope => :season_years }

  serialize :home_player_id_numbers, Array
  serialize :away_player_id_numbers, Array

  def players
    Player.where(id: player_ids)
  end

  def home_players
    unless home_player_id_numbers?
      home_ids = []
      home_ids << self.events.pluck(:h1_id,
                                    :h2_id,
                                    :h3_id,
                                    :h4_id,
                                    :h5_id,
                                    :h6_id,
                                    :home_G_id).uniq
      home_ids.flatten!
      home_ids.uniq!
      home_ids.compact!
      self.home_player_id_numbers = home_ids
      self.save
    end
    Player.where(id: home_player_id_numbers)
  end

  def away_players
    unless away_player_id_numbers?
      away_ids = []
      away_ids << self.events.pluck(:a1_id,
                                    :a2_id,
                                    :a3_id,
                                    :a4_id,
                                    :a5_id,
                                    :a6_id,
                                    :away_G_id).uniq
      away_ids.flatten!
      away_ids.uniq!
      away_ids.compact!
      self.away_player_id_numbers = away_ids
      self.save
    end
    Player.where(id: away_player_id_numbers)
  end

  def home_player_ids
    home_player_id_numbers
  end

  def away_player_ids
    away_player_id_numbers
  end

  def player_ids
    [home_player_id_numbers, away_player_id_numbers].flatten!
  end

  def self.by_player(player_id)
    Game.select { |g| g.player_ids.include?(player_id) }
  end

  def self.unscraped
    ev = Event.final.pluck(:season_years, :gcode).transpose.each { |e| e.uniq! }
    where{season_years.in ev[0]}.where{gcode.not_in ev[1]}
  end


  def self.unsummarized_playerwise
    p_sums = PlayerGameSummary.pluck(:season_years, :gcode).transpose.each { |e| e.uniq! }
    Game.where(season_years: p_sums[0]).where.not(gcode: p_sums[1])
  end

  def self.unsummarized_teamwise
    t_sums = TeamGameSummary.pluck(:season_years, :gcode).transpose.each { |e| e.uniq! }
    Game.where(season_years: t_sums[0]).where.not(gcode: t_sums[1])
  end

  def in_progress?
    true if self.game_start < Time.now && self.game_end.nil?
  end

  def set_status
    if self.game_end?
      if self.periods == 3
        self.status = 3
      elsif self.periods == 4
        self.status = 4
      elsif self.periods == 5
        self.status = 5
      end
    elsif self.game_start < Time.now && self.game_end.nil?
      self.status = 2
    else
      self.status = 1
    end
    self.save
  end

  def parse_game_date
    self.date = self.game_start.to_date
    self.save
  end

  def set_game_number
    self.game_number = self.gcode.to_s.split('')[2..-1].join('').to_i
    self.save
  end

  def home_team_summary
    team_game_summaries.find_by(team_id: home_team_id)
  end

  def away_team_summary
    team_game_summaries.find_by(team_id: away_team_id)
  end

  def away_player_summaries
    player_game_summaries.joins(:player).where(player: {team: away_team})
  end

  def home_player_summaries
    player_game_summaries.joins(:player).where(player: {team: home_team})
  end

  def live_event_count(type, team, situation=nil)
    situation ||= 1
    if type == "corsi"
      a = self.corsi_events.where(event_team_id: team.id,
                                  situation: situation).uniq.pluck(:seconds)
    elsif type == "fenwick"
      a = self.fenwick_events.where(event_team_id: team.id,
                                    situation: situation).uniq.pluck(:seconds)
    end
    arr = a.each_with_index.map { |value, index| [(value/60).round(2), index+1] }
    arr.unshift([0,0])
    arr.insert(-1, [60, arr.last[1]])
  end

  def home_goals
    hg = goals.where(event_team: self.home_team).pluck(:seconds)
    hg.each.map { |x| x/60.round(2)}
  end

  def away_goals
    ag = goals.where(event_team: self.away_team).pluck(:seconds)
    ag.each.map { |x| x/60.round(2) }
  end

  def corsi_heat_map_data
    self.game_charts.where(chart_type: 'corsi_heat_map').pluck(:data)
  end

  def chart
    ChartWorker.perform_async(self.id)
  end

  def set_session
    if gcode.to_s[0] == '3'
      self.session = 2
    elsif gcode.to_s[0] == '2'
      self.session = 1
    else
      self.session = 0
    end
  end

  private
  def self.ransackable_scopes(auth_object = nil)
    %i(playoffs regular_season)
  end

end
