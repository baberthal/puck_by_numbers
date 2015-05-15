FactoryGirl.define do
  factory :game do
    season
    gcode 20001
    fscore_home 3
    fscore_away 4
    game_start DateTime.new(2014, 10, 8, 19, 15, 0, '-4')
    game_end DateTime.new(2014, 10, 8, 21, 55, 0, '-4')
    periods 3

    after(:create) { |game| game.event_scrape }
  end

end
