module ApplicationHelper

  def wp(s, &b)
    { "#{s}" => eval(s.to_s, b.binding) }
  end

end

