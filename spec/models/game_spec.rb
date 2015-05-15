require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { build(:game) }
  subject { game }

  it { should respond_to(:players) }
  it { should respond_to(:in_progress?)}

  it { should belong_to(:season) }
  it { should belong_to(:home_team) }
  it { should belong_to(:away_team) }

  it { should respond_to(:chart) }

  it { should have_many(:events) }
end
