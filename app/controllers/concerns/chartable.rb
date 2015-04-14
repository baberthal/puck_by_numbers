module Chartable
  extend ActiveSupport::Concern

  def event_count_chart(game)
    @decorator = ChartDecorator.new(game)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.series(:type => 'area', :name => game.home_team.name,
               :data => game.running_event_count('corsi',
                                                  game.home_team,
                                                  params[:sit]),
               :color => "#{game.home_team.color1}")

      f.series(:type => 'area', :name => game.away_team.name,
               :data => game.running_event_count('corsi',
                                                  game.away_team,
                                                  params[:sit]),
               :color => "#{game.away_team.color1}")

      f.xAxis(:title => {:text => "Time"},
              :plotLines => @decorator.goal_lines,

              :plotBands => [{color: "#f9f9f9",
                              from: 0,
                              to: 20},

                             {color: "#eeeeee",
                              from: 20,
                              to: 40},

                             {color: "#cccccc",
                              from: 40,
                              to: 60}],

              :min => 0,
              :max => 60)

      f.yAxis(:title => {:text => "Event Count"}, :floor => 0)
      f.legend(:align => 'center', :verticalAlign => 'bottom')
      f.chart(height: 600, backgroundColor: 'transparent')
    end
  end

  def shift_chart(game)
    @decorator = ChartDecorator.new(game)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(type: 'bar')
      f.xAxis(categories: @decorator.player_name_shift_labels)
      f.yAxis(min: 0, title: 'Time')
      f.plotOptions(series: {stacking: 'normal'})
    end
  end

  def corsi_heat_map(game)
    @decorator = ChartDecorator.new(game)
    LazyHighCharts::HighChart.new('chart') do |f|
      f.chart(type: 'heatmap', backgroundColor: 'transparent')
      f.xAxis(categories: @decorator.flast_home,
              title: 'Home')
      f.yAxis(categories: @decorator.flast_away,
              title: 'Away')
      f.tooltip(backgroundColor: nil,
                borderWidth: 0,
                distance: 10,
                shadow: false,
                useHTML: true,
                pointFormat: '<span> {series.xAxis.categories.point} {point.y} {point.value} </span>')
      f.colorAxis(dataClasses: [{from: -100,
                                 to: -1,
                                 color: @decorator.acolor,
                                 name: "#{game.away_team.name} Advantage"},
                                {from: 0,
                                 to: 0,
                                 color: "#FFFFFF",
                                 name: "No Advantage"},
                                {from: 1,
                                 to: 100,
                                 color: @decorator.hcolor,
                                 name: "#{game.home_team.name} Advantage"}],
                  min: @decorator.heat_map_range(min: true),
                  max: @decorator.heat_map_range(max: true),
                  startOnTick: false,
                  stopOnTick: false)
      f.series({name: 'Head to Head Corsi',
                borderWidth: 1,
                data: GameChart.find_by(game: game, chart_type: 'corsi_heat_map').data,
                nullColor:'#FFFFFF',
                dataLabels: {enabled: true,
                             color: '#FFFFFF'}})
    end
  end

end
