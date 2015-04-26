class ChartDecorator
  include ColorMeMine
  attr_reader :game, :chart

  def initialize(game)
    @game = game
  end

  def main_team_colors
    home_colors = [@game.home_team.color1,
                   @game.home_team.color2,
                   @game.home_team.color3,
                   @game.home_team.color4].compact
    away_colors = [@game.away_team.color1,
                   @game.away_team.color2,
                   @game.away_team.color3,
                   @game.away_team.color4].compact

    color_pairs = []
    home_colors.each do |h|
      away_colors.each do |a|
        color_pairs << [h, a, color_diff(h,a)]
      end
    end

    pairs = color_pairs.take_while { |c| c[0] == home_colors[0] || c[1] == away_colors[0] }.compact
    pairs.sort_by! { |p| p[2] }
    pairs.last
  end


  def goal_lines
    home_chart_color = main_team_colors[0]
    away_chart_color = main_team_colors[1]

    home_accent_color = if home_chart_color == @game.home_team.color1
                          "#{@game.home_team.color2}"
                        else
                          "#{@game.home_team.color1}"
                        end

    away_accent_color = if away_chart_color == @game.away_team.color1
                          "#{@game.away_team.color2}"
                        else
                          "#{@game.away_team.color1}"
                        end

    gh = @game.goals.where(event_team: @game.home_team).pluck(:seconds)
    ga = @game.goals.where(event_team: @game.away_team).pluck(:seconds)
    goalsh = gh.map.each { |x| (x/60).round(1) }
    goalsa = ga.map.each { |x| (x/60).round(1) }
    plot_lines = []
    goalsh.each do |x|
      plot_lines << { color: "#{home_chart_color}",
                      width: 5, value: x, zIndex: 4,
                      label: {
                        text: "#{@game.home_team.abbr} Goal",
                        align: 'center',
                        y: 20,
                        x: 0,
                        rotation: 0,
                        useHTML: true,
                        style: {
                          backgroundColor: "#{home_chart_color}",
                          color: "#{home_accent_color}"
                        }
                      }
      }
    end
    goalsa.each do |x|
      plot_lines << { color: "#{away_chart_color}",
                      width: 5, value: x, zIndex: 4,
                      label: {
                        text: "#{@game.away_team.abbr} Goal",
                        align: 'center',
                        y: 20,
                        x: 0,
                        rotation: 0,
                        useHTML: true,
                        style: {
                          backgroundColor: "#{away_chart_color}",
                          color: "#{away_accent_color}"
                        }
                      }
      }
    end
    plot_lines
  end

  def player_name_labels(team, options = {})
    options[:format] ||= 'full'
    labels = []
    @game.players.where(team: team).uniq.order(id: :asc).each do |p|
      p = p.decorate
      if options[:format] == 'full'
        labels << p.pretty_name
      elsif options[:format] == 'init'
        labels << p.pretty_name('f_last')
      end
    end
    labels
  end


  def shifts
  end

  def heat_map_series
    home_players =
      @game.players.where(team: @game.home_team).uniq.order(id: :asc)
    away_players =
      @game.players.where(team: @game.away_team).uniq.order(id: :asc)
    series = []
    home_players.each_with_index do |p,i|
      for a,n in away_players.map.with_index do
        series << [i,n,@game.head_to_head(p,a)]
      end
    end
    GameChart.create(game: @game, chart_type: 'corsi_heat_map', data: series)
  end

  def heat_map_range(options = {})
    a = GameChart.find_by(gcode: @game.gcode,
                          season_years: @game.season_years,
                          chart_type: 'corsi_heat_map').data
    val_range = []
    a.each do |x,y,v|
      val_range << v
    end
    if options[:min]
      val_range.min
    elsif options[:max]
      val_range.max
    else
      [val_range.min, val_range.max]
    end
  end

  # Formatting methods for names, etc
  def flast_home
    player_name_labels(@game.home_team, format: 'init')
  end

  def flast_away
    player_name_labels(@game.away_team, format: 'init')
  end

  def hcolor
    "#{@game.home_team.color1}"
  end

  def acolor
    "#{@game.away_team.color1}"
  end

  def situation_to_human
    if situation == 1
      "Even Strength 5v5"
    elsif situation == 2
      "#{self.game.home_team.name} Powerplay"
    elsif situation == 3
      "#{self.game.away_team.name} Powerplay"
    elsif situation == 4
      "Even Strength 4v4"
    elsif situation == 5
      "#{self.game.away_team.name} Goalie Pull"
    elsif situation == 6
      "#{self.game.away_team.name} Goalie Pull"
    end
  end

end
