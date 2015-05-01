require 'rails_helper'

RSpec.describe Season, type: :model do
  it { should have_many(:games) }
end
