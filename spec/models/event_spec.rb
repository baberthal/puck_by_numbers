require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { Event.first }
  subject { event }

  it "is invalid without an event_number" do
    event = Event.new
    expect { event.save }.to raise_error
  end

  it { should respond_to(:goalies_in?) }

  it { should belong_to(:event_team) }

  it { should belong_to(:event_player_1) }
  it { should belong_to(:event_player_2) }
  it { should belong_to(:event_player_3) }

  it { should belong_to(:away_G) }
  it { should belong_to(:home_G) }

  it { should belong_to(:a1) }
  it { should belong_to(:a2) }
  it { should belong_to(:a3) }
  it { should belong_to(:a4) }
  it { should belong_to(:a5) }
  it { should belong_to(:a6) }

  it { should belong_to(:h1) }
  it { should belong_to(:h2) }
  it { should belong_to(:h3) }
  it { should belong_to(:h4) }
  it { should belong_to(:h5) }
  it { should belong_to(:h6) }

end
