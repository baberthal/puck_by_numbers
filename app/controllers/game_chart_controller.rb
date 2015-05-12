class GameChartController < ApplicationController
  helper_method :sit

  def event_count_chart
    @game = Game.find(params[:id])
    @away_data = GameChart.find_by(game: @game,
                                   situation: sit,
                                   team: @game.away_team,
                                   chart_type: 'running_corsi_count_chart').data
    @home_data = GameChart.find_by(game: @game,
                                   situation: sit,
                                   team: @game.home_team,
                                   chart_type: 'running_corsi_count_chart').data
    @decorator = ChartDecorator.new(@game)
    render json: @home_data
    render json: @away_data
  end

  private
  def sit
    %w[1 2 3 4 5 6 7].include?(params[:sit_id]) ? params[:sit_id] : "1"
  end

end
