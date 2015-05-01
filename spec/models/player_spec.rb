require 'rails_helper'

RSpec.describe Player, type: :model do

  it { should belong_to(:team) }

  it { should have_many(:primary_events) }

  it { should have_many(:secondary_events) }

  it { should have_many(:tertiary_events) }

  it { should have_many(:a1_events) }
  it { should have_many(:a2_events) }
  it { should have_many(:a3_events) }
  it { should have_many(:a4_events) }
  it { should have_many(:a5_events) }
  it { should have_many(:a6_events) }

  it { should have_many(:h1_events) }
  it { should have_many(:h2_events) }
  it { should have_many(:h3_events) }
  it { should have_many(:h4_events) }
  it { should have_many(:h5_events) }
  it { should have_many(:h6_events) }

  it { should have_many(:events_as_home_G) }
  it { should have_many(:events_as_away_G) }

  it { should have_many(:player_game_summaries) }

  it { should respond_to(:games) }
  it { should respond_to(:events) }
  it { should respond_to(:determine_team) }
  it { should respond_to(:nickname) }
  it { should respond_to(:goals) }
end
