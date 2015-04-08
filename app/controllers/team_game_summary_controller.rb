class TeamGameSummaryController < ApplicationController
  def index
    @search = TeamGameSummary.search(params[:q])
    @team_game_summaries = @search.result
  end

  def show
  end

end
