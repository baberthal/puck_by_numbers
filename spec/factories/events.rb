FactoryGirl.define do

  factory :event do
    game
    sequence(:event_number)
    association :event_team, factory: team
    home_score 1
    away_score 1
    home_skaters 6
    away_skaters 6
    association :event_player_1, factory: player
    association :event_player_2, factory: player
    association :event_player_3, factory: player

    trait :first_period do
      period 1
      sequence(:seconds)
    end

    trait :second_period do
      period 2
      sequence(:seconds)
    end

    trait :third_period do
      period 3
      sequence(:seconds)
    end
  end

end
