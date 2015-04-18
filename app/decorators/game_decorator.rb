class GameDecorator < Draper::Decorator
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

end
