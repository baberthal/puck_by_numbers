module WithOrWithoutYou

  def wowy(partner, options = {})
    options[:situation] ||= 1
    if partner == self
      raise "can't be without myself!"
    end

    my_events = self.events
    your_events = partner.events.ids
    our_events = my_events.where(id: your_events)

    my_toi = (my_events.sum(:event_length)/60).round(2)
    your_toi = (your_events.sum(:event_length)/60).round(2)
    our_toi = (our_events.sum(:event_length)/60).round(2)
    my_percentage_toi = ((our_toi/my_toi)*100).round(2)
    your_percentage_toi = ((our_toi/your_toi)*100).round(2)

    my_goals = self.goals
    my_goals_with_you = my_goals.where(id: your_events)

  end

end

