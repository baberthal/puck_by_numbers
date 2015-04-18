class ChartDecorator
  attr_reader :game, :chart

  def initialize(game)
    @game = game
  end

  def goal_lines
    gh = @game.goals.where(event_team: @game.home_team).pluck(:seconds)
    ga = @game.goals.where(event_team: @game.away_team).pluck(:seconds)
    goalsh = gh.map.each { |x| (x/60).round(1) }
    goalsa = ga.map.each { |x| (x/60).round(1) }
    plot_lines = []
    goalsh.each do |x|
      plot_lines << { color: "#{game.home_team.color1}",
                      width: 11, value: x, zIndex: 4,
                      label: {text: "#{@game.home_team.abbr} GOAL",
                              align: 'left', x: -5, y: 30,
                              style: { color: "#{@game.home_team.color2}",
                                       fontWeight: 'bold' } } }
    end
    goalsa.each do |x|
      plot_lines << { color: "#{game.away_team.color1}",
                      width: 11, value: x, zIndex: 4,
                      label: {text: "#{@game.away_team.abbr} GOAL",
                              align: 'left', x: -5, y: 30,
                              style: { color: "#{@game.away_team.color2}",
                                       fontWeight: 'bold' } } }
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
    GameChart.create(game_id: @game.id, chart_type: 'corsi_heat_map', data: series)
  end

  def heat_map_range(options = {})
    a = GameChart.find_by(game: @game, chart_type: 'corsi_heat_map').data
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

end
