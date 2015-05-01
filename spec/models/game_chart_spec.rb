require 'rails_helper'

RSpec.describe GameChart, type: :model do
  it { should serialize(:data) }
end
