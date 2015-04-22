module WithOrWithoutYou
  include ApplicationHelper

  def wowy(partner, options = {})
    options[:situation] ||= 1
    if partner == self
      raise "can't be without myself!"
    end

    my_events = self.events.where(situation: options[:situation])

    your_events = partner.events.ids

    our_events = my_events.where(id: your_events)

    my_toi = (my_events.sum(:event_length)/60).round(2)

    your_toi = (partner.events.where(situation: options[:situation])
               .sum(:event_length)/60).round(2)

    our_toi = (our_events.sum(:event_length)/60).round(2)

    my_percentage_toi = ((our_toi/my_toi)*100).round(2)

    your_percentage_toi = ((our_toi/your_toi)*100).round(2)

    my_goals = self.goals.where(situation: options[:situation])

    my_goals_with_you = my_goals.where(id: your_events).count.to_f

    my_primary_assists = self.primary_assists
                         .where(situation: options[:situation])

    my_primary_assists_with_you =
      my_primary_assists.where(id: your_events).count.to_f

    my_primary_assists_to_you =
      my_primary_assists.where(event_player_1: partner).count.to_f

    your_primary_assists_to_me =
      my_goals.where(event_player_2: partner).count.to_f

    my_goals = my_goals.count.to_f

    my_primary_assists = my_primary_assists.count.to_f

    my_cf_baseline =
      ((self.corsi_for.where(situation: options[:situation]).count.to_f)/
       (self.on_ice_corsi_events.where(situation: options[:situation])
       .count.to_f)*100).round(2)

    my_cf_with_you =
      ((self.corsi_for.where(situation: options[:situation], id: your_events).count.to_f)/(self.on_ice_corsi_events.where(situation: options[:situation], id: your_events).count.to_f)*100).round(2)

    my_cf_without_you =
      ((self.corsi_for.where(situation: options[:situation])
        .where.not(id: your_events).count.to_f)/
        (self.on_ice_corsi_events.where(situation: options[:situation])
        .where.not(id: your_events).count.to_f
        )*100).round(2)

    my_gf_baseline =
      ((self.team_on_ice_goals.where(situation: options[:situation]).count.to_f/
        self.on_ice_goals.where(situation: options[:situation])
        .count.to_f)*100).round(2)

    my_gf_with_you =
      if self.on_ice_goals.where(situation: options[:situation],
                                 id: your_events).count == 0
        0
      else
        ((self.team_on_ice_goals.where(situation: options[:situation],
                                       id: your_events).count/
          self.on_ice_goals.where(situation: options[:situation],
                                  id: your_events).count)*100).round(2)
      end

    my_gf_without_you =
      if self.on_ice_goals.where(situation: options[:situation])
         .where.not(id: your_events).count == 0
        0
      else
        ((self.team_on_ice_goals.where(situation: options[:situation])
          .where.not(id: your_events).count/
          self.on_ice_goals.where(situation: options[:situation])
            .not(id: your_events).count
         )*100).round(2)
      end

    stats = [{ my_toi: my_toi },
             { your_toi: your_toi },
             { our_toi: our_toi },
             { my_percentage_toi: my_percentage_toi },
             { your_percentage_toi: your_percentage_toi },
             { my_goals: my_goals },
             { my_goals_with_you: my_goals_with_you },
             { my_primary_assists_with_you: my_primary_assists_with_you },
             { my_primary_assists_to_you: my_primary_assists_to_you },
             { your_primary_assists_to_me: your_primary_assists_to_me },
             { my_cf_baseline: my_cf_baseline },
             { my_cf_with_you: my_cf_with_you },
             { my_cf_without_you: my_cf_without_you },
             { my_gf_baseline: my_gf_baseline },
             { my_gf_with_you: my_gf_with_you },
             { my_gf_without_you: my_gf_without_you }]

    stats
  end

end


