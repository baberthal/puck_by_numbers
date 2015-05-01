require 'rails_helper'

RSpec.describe PlayerGameSummary, type: :model do

  it { should belong_to(:player) }

  it { should respond_to(:get_zone_start_data) }

end
