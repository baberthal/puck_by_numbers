require 'rails_helper'

RSpec.describe TeamGameSummary, type: :model do
  it { should belong_to(:team) }
end
