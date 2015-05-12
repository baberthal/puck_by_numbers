require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.second }
  subject { game }

  it { should respond_to(:players) }
  it { should respond_to(:in_progress?)}

  it { should belong_to(:season) }
  it { should belong_to(:home_team) }
  it { should belong_to(:away_team) }

  it { should respond_to(:chart) }

  it { should respond_to(:top_performers) }
  it { should respond_to(:top_goal_scorer) }
  it { should respond_to(:top_point_getter) }
  it { should respond_to(:top_corsi_performer) }

  it "has a top goal scorer" do
    expect(game.top_performers[0]).to eq(game.top_goal_scorer.id)
  end

  it "has a top point getter" do
    expect(game.top_performers[1]).to eq(game.top_point_getter.id)
  end

  it "has a top corsi performer" do
    expect(game.top_performers[2]).to eq(game.top_corsi_performer.id)
  end

  it "has three top performers" do
    expect(game.top_performers.count).to eq 3
  end

end
