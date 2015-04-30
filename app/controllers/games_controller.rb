class GamesController < ApplicationController
  include Chartable
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: :index
  helper_method :sort_column, :sort_direction, :sit

  # GET /games
  # GET /games.json
  def index
    @q = Game.ransack(params[:q])
    @q.sorts = 'date desc' if @q.sorts.empty?
    @games = if params[:q]
               @q.result.includes(:home_team, :away_team).page(params[:page]).decorate
             else
               []
             end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @pq = @game.player_game_summaries.sit_filter(sit).ransack(search_params)
    @tq = @game.team_game_summaries.sit_filter(sit).ransack(search_params)
    @player_summaries = @pq.result.includes(:player)
    @team_summaries = @tq.result.includes(:team)
    @event_count_chart = event_count_chart(@game)
    @corsi_heat_map = corsi_heat_map(@game)
  end

  # GET /games/new
  def new
    @game = Game.new
    if @game.save
      GameUpdater.perform_async(@game.id)
    end
  end

  def search
    index
    render :index
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    if @game.save
      GameUpdater.perform_async(@game.id)
    end

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
    GameUpdater.perform_async(@game.id)
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
      @season = Season.find_by(season_years: params[:season_id])
      @game = @season.games.find_by(gcode: params[:gcode])
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
      %w[1 2 3 4 5 6 7].include?(params[:sit_id]) ? params[:sit_id] : "1"
    end
end
