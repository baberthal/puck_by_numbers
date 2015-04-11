class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_filter :get_season
  helper_method :sort_column, :sort_direction, :sit

  def get_season
    @season = Season.find(params[:season_id])
  end


  # GET /games
  # GET /games.json
  def index
    @games = @season.games.includes(:home_team, :away_team, :team_game_summaries, :player_game_summaries).all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @player_summaries = @game.player_game_summaries.includes(:player).sit_filter(params[:sit_id])
    @team_summaries = @game.team_game_summaries.includes(:team).sit_filter(params[:sit_id])
    @event_count_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series(:type => 'area', :name => @game.home_team.name,
               :data => @game.running_event_count('corsi', @game.home_team),
               :color => "#{@game.home_team.color1}")

      f.series(:type => 'area', :name => @game.away_team.name,
               :data => @game.running_event_count('corsi', @game.away_team),
               :color => "#{@game.away_team.color1}")

      f.xAxis(:title => {:text => "Time"},
              :plotBands => [{color: "#f9f9f9", from: 0, to: 20, label: {text: "Period 1"}},
                             {color: "#eeeeee", from: 20, to: 40, label: {text: "Period 2"}},
                             {color: "#cccccc", from: 40, to: 60, label: {text: "Period 3"}}],
              :min => 0,
              :max => 60)
      f.yAxis(:title => {:text => "Event Count"}, :floor => 0)
      f.legend(:align => 'center', :verticalAlign => 'bottom')
      f.chart({:height => 600})
      end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params[:game]
    end

    def sort_column
      PlayerGameSummary.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sit
      Situation.ids.include?(params[:sit]) ? params[:sit] : "1"
    end
end
