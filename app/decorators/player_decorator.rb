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

  def pretty_number
    unless player.bio.nil?
      player.bio[:number]
    else
      nil
    end
  end

  def pretty_height
    unless player.bio.nil?
      player.bio[:height]
    else
      nil
    end
  end

  def pretty_weight
    unless player.bio.nil?
      player.bio[:weight]
    else
      nil
    end
  end

  def pretty_shoots
    unless player.bio.nil?
      player.bio[:shoots]
    else
      nil
    end
  end

  def pretty_birthdate
    unless player.bio.nil?
      player.bio[:birthdate].strftime("%B %-d, %Y")
    else
      nil
    end
  end

  def pretty_birthplace
    unless player.bio.nil?
      player.bio[:birthplace]
    else
      nil
    end
  end

  def pretty_drafted
    unless player.bio.nil?
      player.bio[:draft_team]
    else
      nil
    end
  end

  def pretty_draft_round
    unless player.bio.nil?
      player.bio[:round]
    else
      nil
    end
  end
end

# vim: set expandtab:sw=2
