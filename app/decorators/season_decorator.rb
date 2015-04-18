class SeasonDecorator < Draper::Decorator
  delegate_all

  def header
    "#{object.season_years.to_s[0..3]} -
    #{object.season_years.to_s[4..-1]} NHL Season"
  end

end
