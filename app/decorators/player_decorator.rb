class PlayerDecorator < Draper::Decorator
  delegate :current_page, :page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
  delegate_all

  def pretty_name(format = nil)
    last = object.last_name.to_s.titleize.split
    pretty_last = last.join
    if format == "f_last"
      "#{object.first_name.to_s[0]}. #{pretty_last}"
    else
      "#{object.first_name.titleize} #{pretty_last}"
    end
  end

  def team_full
    if object.team.nil?
      " - "
    else
      "#{object.team.name} #{object.team.nickname}"
    end
  end

  def pretty_pos
    if object.position.include?('L') || object.position.include?('R')
      "#{object.position}W"
    else
      "#{object.position}"
    end
  end
end

# vim: set expandtab:sw=2
