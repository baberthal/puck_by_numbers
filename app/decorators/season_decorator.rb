class SeasonDecorator
  attr_reader :season

  def initialize(season)
    @season = season
  end

  def header
    "#{@season.season_years.to_s[0..3]} -
    #{@season.season_years.to_s[4..-1]} NHL Season"
  end
end
