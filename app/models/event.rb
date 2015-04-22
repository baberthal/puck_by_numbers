class Event < ActiveRecord::Base
  include Filterable
  include Situational

  self.primary_keys = [:event_number, :gcode, :season_years]
  belongs_to :game, :foreign_key => [:season_years, :gcode]
  belongs_to :event_team, :class_name => "Team"
  has_one :location
  belongs_to :event_player_1, :class_name => "Player", autosave: true
  belongs_to :event_player_2, :class_name => "Player"
  belongs_to :event_player_3, :class_name => "Player"
  belongs_to :away_G, :class_name => "Player"
  belongs_to :home_G, :class_name => "Player"
  belongs_to :a1, :class_name => "Player", :foreign_key => :a1
  belongs_to :a2, :class_name => "Player", :foreign_key => :a2
  belongs_to :a3, :class_name => "Player", :foreign_key => :a3
  belongs_to :a4, :class_name => "Player", :foreign_key => :a4
  belongs_to :a5, :class_name => "Player", :foreign_key => :a5
  belongs_to :a6, :class_name => "Player", :foreign_key => :a6
  belongs_to :h1, :class_name => "Player", :foreign_key => :h1
  belongs_to :h2, :class_name => "Player", :foreign_key => :h2
  belongs_to :h3, :class_name => "Player", :foreign_key => :h3
  belongs_to :h4, :class_name => "Player", :foreign_key => :h4
  belongs_to :h5, :class_name => "Player", :foreign_key => :h5
  belongs_to :h6, :class_name => "Player", :foreign_key => :h6

  validates :event_number, :uniqueness => { :scope => :gcode }

  def goalies_in?
    if self.home_G_id != nil && self.away_G_id != nil
      true
    else
      false
    end
  end

end

