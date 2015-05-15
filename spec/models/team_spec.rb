require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team) { Team.find(22) }
  subject { team }

  it { should have_many(:players) }

  it { should have_many(:home_games) }
  it { should have_many(:away_games) }
  it { should respond_to(:games) }

  it "has games" do
    game_ids = team.home_games.ids
    game_ids << team.away_games.ids
    game_ids.flatten!
    expect(team.games.ids.flatten!).to eq(game_ids)
  end
end
