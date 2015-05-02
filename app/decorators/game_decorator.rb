class GameDecorator < Draper::Decorator
  delegate :current_page, :page, :total_pages, :limit_value,
           :entry_name, :total_count, :offset_value, :last_page?
  delegate_all

  def is_recent?
    object.start_time < 2.days.ago
  end

  def status_to_human
    if object.status == 1
      "Preview"
    elsif object.status == 2
      "In Progress"
    elsif object.status == 3
      "Complete"
    elsif object.status == 4
      "Complete (OT)"
    elsif object.status == 5
      "Complete (SO)"
    else
      "Unknown"
    end
  end

  def session_to_human
    if object.session == 2
      "Playoffs"
    elsif object.session == 1
      "Regular"
    else
      "Unknown"
    end
  end

  def index_header
    "#{object.season_years.to_s[0..3]} -
     #{object.season_years.to_s[4..-1]} NHL Season"
  end
end
