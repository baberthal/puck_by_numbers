module GameScraper
  def game_scrape(start_game, end_game)
    r = Rserve::Simpler.new
    r.eval("setwd('/Users/morgan/nhlscrapr-run.R')")
    r.eval("library(nhlscrapr)")
    r.eval("all.games <- full.game.database()")
    r.eval("to.scrape <- subset(all.games, season == #{self.season_years} & gcode > #{start_game} & gcode < #{end_game})")
    r.eval("compile.all.games(new.game.table=to.scrape, wait=2)")
    r.eval("load('source-data/nhlscrapr-core.RData')")
    game_count = r.eval("nrow(games)").to_ruby

    for i in 1..game_count
      this_game = r.eval("games[#{i},]").to_ruby

      away = Team.find_by(abbr: this_game[5])
      home = Team.find_by(abbr: this_game[6])

      start_time = this_game[10].split
      end_time = this_game[11].split[0]
      game_date = this_game[9]
      game_year = game_date.split("-")[0].to_i
      game_month = game_date.split("-")[1].to_i
      game_day = game_date.split("-")[2].to_i
      start_hour = start_time[0].split(":")[0].to_i
      start_min = start_time[0].split(":")[1].to_i
      end_hour = end_time.split(":")[0].to_i
      end_min = end_time.split(":")[1].to_i

      if start_hour < 11
        start_hour += 12
        end_hour += 12
      end

      if start_time[1] == "EST"
        offset = "-5"
      elsif start_time[1] == "CST"
        offset = "-6"
      elsif start_time[1] == "MST"
        offset = "-7"
      elsif start_time[1] == "PST"
        offset = "-8"
      elsif start_time[1] == "EDT"
        offset = "-4"
      elsif start_time[1] == "CDT"
        offset = "-5"
      elsif start_time[1] == "MDT"
        offset = "-6"
      elsif start_time[1] == "PDT"
        offset = "-7"
      end

      Game.find_or_initialize_by!(season_years: self.season_years,
                              gcode: this_game[3]) do |g|

        g.game_number = this_game[2],
        g.home_team = home,
        g.away_team = away,
        g.fscore_home = this_game[8],
        g.fscore_away = this_game[7],
        g.game_start = DateTime.new(game_year,
                                    game_month,
                                    game_day,
                                    start_hour,
                                    start_min,
                                    0,
                                    offset),
        g.game_end = DateTime.new(game_year,
                                  game_month,
                                  game_day,
                                  end_hour,
                                  end_min,
                                  0,
                                  offset),
        g.periods = this_game[-1].to_i
        g.save
      end

    end
  end

  def event_scrape
    r = Rserve::Simpler.new
    r.eval("setwd('/Users/morgan/nhlscrapr-run.R')")
    r.eval("library(nhlscrapr)")
    r.eval("load('source-data/nhlscrapr-#{self.season_years}.RData')")
    r.eval("these.events <- subset(grand.data, gcode == #{self.gcode})")
    these_events = r.eval("these.events").to_ruby

    for i in 0..these_events[0].length - 1
      Event.find_or_initialize_by(season_years: self.season_years,
                                  gcode: self.gcode,
                                  event_number: these_events['event'][i].to_i) do |e|

                                    e.period = these_events['period'][i].to_i
                                    e.seconds = these_events['seconds'][i].to_f
                                    e.event_type = these_events['etype'][i].to_s
                                    e.event_team = Team.find_by(abbr: these_events['ev.team'][i])
                                    e.event_player_1 = Player.find(these_events['ev.player.1'][i].to_i)
                                    e.event_player_2 = Player.find(these_events['ev.player.2'][i].to_i)
                                    e.event_player_3 = Player.find(these_events['ev.player.3'][i].to_i)
                                    e.away_G = Player.find(these_events['away.G'][i].to_i)
                                    e.home_G = Player.find(these_events['home.G'][i].to_i)
                                    e.description = these_events['type'][i].to_s
                                    e.home_score = these_events['home.score'][i].to_i
                                    e.away_score = these_events['away.score'][i].to_i
                                    e.event_length = these_events['event.length'][i].to_f
                                    e.home_skaters = these_events['home.skaters'][i].to_i
                                    e.away_skaters = these_events['away.skaters'][i].to_i
                                    e.save
                                  end


      Location.find_or_initialize_by(event: Event.last) do |l|
        l.distance = these_events['distance'][i].to_i
        l.home_zone = these_events['homezone'][i].to_s if these_events['homezone'][i] =~ /('Neu'|'Off'|'Def')/
        l.x_coord = these_events['xcoord'][i].to_i
        l.y_coord = these_events['ycoord'][i].to_i
        l.location_section = these_events['loc.section'][i].to_i
        l.new_location_section = these_events['new.loc.section'][i].to_i
        l.new_x_coord = these_events['newxc'][i].to_i
        l.new_x_coord = these_events['newyc'][i].to_i
        l.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a1'][i].to_i) unless these_events['a1'][i].to_i == 1
        p.event_role = "a1"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a2'][i].to_i) unless these_events['a2'][i].to_i == 1
        p.event_role = "a2"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a3'][i].to_i) unless these_events['a3'][i].to_i == 1
        p.event_role = "a3"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a4'][i].to_i) unless these_events['a4'][i].to_i == 1
        p.event_role = "a4"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a5'][i].to_i) unless these_events['a5'][i].to_i == 1
        p.event_role = "a5"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['a6'][i].to_i) unless these_events['a6'][i].to_i == 1
        p.event_role = "a6"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h1'][i].to_i) unless these_events['h1'][i].to_i == 1
        p.event_role = "h1"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h2'][i].to_i) unless these_events['h2'][i].to_i == 1
        p.event_role = "h2"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h3'][i].to_i) unless these_events['h3'][i].to_i == 1
        p.event_role = "h3"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h4'][i].to_i) unless these_events['h4'][i].to_i == 1
        p.event_role = "h4"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h5'][i].to_i) unless these_events['h5'][i].to_i == 1
        p.event_role = "h5"
        p.save
      end

      Participant.new(event: Event.last) do |p|
        p.player = Player.find(these_events['h6'][i].to_i) unless these_events['h6'][i].to_i == 1
        p.event_role = "h6"
        p.save
      end
    end

  end
end
