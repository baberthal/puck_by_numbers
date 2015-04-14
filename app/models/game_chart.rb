class GameChart < ActiveRecord::Base
  belongs_to :game
  serialize :data, Array
end
