class Game < ActiveRecord::Base
  include Statable
  include Summarizable
  include Filterable
  include Analyzable
  include GameScraper

  self.primary_keys = :season_years, :gcode

  belongs_to :season, :foreign_key => :season_years
  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"
  has_many :events, :foreign_key => [:season_years, :gcode]
  has_many :event_teams, through: :events
  has_many :players, through: :events
  has_many :player_game_summaries, :foreign_key => [:season_years, :gcode]
  has_many :team_game_summaries, :foreign_key => [:season_years, :gcode]
  has_many :game_charts, :foreign_key => [:season_years, :gcode]

  scope :recent, -> { where("game_start >= ?", 2.days.ago)}

  after_create :parse_game_date, :set_status

  validates :gcode, :uniqueness => { :scope => :season_years }

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

  def home_players
    players.where(team_id: home_team_id).uniq
  end

  def away_players
    players.where(team_id: away_team_id).uniq
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

  def method_missing(method_name, *args)
    if self.decorate.respond_to?(method_name)
      self.decorate.send(method_name, *args)
    else
      super
    end
  end
end
