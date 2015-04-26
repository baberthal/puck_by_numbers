class SeasonDecorator < Draper::Decorator
  delegate :current_page, :page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
  delegate_all

  def header
    "#{object.season_years.to_s[0..3]} -
    #{object.season_years.to_s[4..-1]} NHL Season"
  end

end
