class GamesController < ApplicationController
  include Chartable
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: :index
  before_filter :get_season
  helper_method :sort_column, :sort_direction, :sit

  def get_season
    @season = Season.find(params[:id])
  end


  # GET /games
  # GET /games.json
  def index
    #@q = Game.ransack(params[:q])
    #@games = @q.result.includes(:home_team,
    #                            :away_team,
    #                            :team_game_summaries,
    #                            :player_game_summaries)
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @pq = @game.player_game_summaries.sit_filter(params[:sit_id]).ransack(search_params)
    @tq = @game.team_game_summaries.sit_filter(params[:sit_id]).ransack(search_params)
    @player_summaries = @pq.result.includes(:player)
    @team_summaries = @tq.result.includes(:team)
    @event_count_chart = event_count_chart(@game)
    @corsi_heat_map = corsi_heat_map(@game)
  end

  # GET /games/new
  def new
    @game = Game.new
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
      %w[1 2 3 4 5 6 7].include?(params[:sit]) ? params[:sit] : "1"
    end
end
