module GameScraper
  def game_scrape(start_game = nil, end_game = nil)
    r = Rserve::Simpler.new
    begin
      r.eval("setwd('..')")
      if r.eval("getwd()").payload[0] != "/Users/morgan/nhlscrapr-run.R"
        raise "Working Directory Error"
      end
    rescue
      r.eval("setwd('/Users/morgan/nhlscrapr-run.R')")
    end

    r.eval("library(nhlscrapr)")
    r.eval("all.games <- full.game.database()")
    if start_game == nil && end_game == nil
      r.eval("to.scrape <- subset(all.games, season == #{self.season_years})")
    elsif start_game != nil && end_game == nil
      r.eval("to.scrape <- subset(all.games, season == #{self.season_years} & gcode >= #{start_game})")
    else
      r.eval("to.scrape <- subset(all.games, season == #{self.season_years} & gcode >= #{start_game} & gcode <= #{end_game})")
    end
    r.eval("compile.all.games(new.game.table=to.scrape, wait=2)")
    r.eval("load('source-data/nhlscrapr-core.RData')")

    games = r.eval("games").to_ruby
    names = games.names
    names.map! { |n| n.gsub(/\./, "_").to_sym }
    games = games.transpose
    game_array = []

    games.each do |g|
      game_array << names.zip(g).to_h
    end

    game_array.each do |game|
      begin
        single_game_scrape(game)
      rescue
        next
      end
    end
  end


  def single_game_scrape(game)
    away = Team.find_by(abbr: game[:awayteam])
    home = Team.find_by(abbr: game[:hometeam])

    start_time = game[:game_start].split
    end_time = game[:game_end].split[0]
    game_date = game[:date]
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

    Game.find_or_initialize_by(season_years: self.season_years,
                               gcode: game[:gcode]) do |g|

      g.game_number = game[:gamenumber].to_i,
      g.home_team = home,
      g.away_team = away,
      g.fscore_home = game[:homescore].to_i,
      g.fscore_away = game[:awayscore].to_i,
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
      g.periods = game[:periods].to_i,
      g.save
    end
  end


  def event_scrape
    r = Rserve::Simpler.new
    begin
      r.eval("setwd('..')")
      if r.eval("getwd()").payload[0] != "/Users/morgan/nhlscrapr-run.R"
        raise "Working Directory Error"
      end
    rescue
      r.eval("setwd('/Users/morgan/nhlscrapr-run.R')")
    end
    r.eval("library(nhlscrapr)")
    r.eval("load('source-data/nhlscrapr-#{self.season_years}.RData')")
    r.eval("game.events <- subset(grand.data, gcode == #{self.gcode})")
    game_events = r.eval("game.events").to_ruby
    names = game_events.names
    names.map! { |n| n.gsub(/\./, "_").to_sym }
    game_events = game_events.transpose
    event_array = []

    game_events.each do |g|
      event_array << names.zip(g).to_h
    end

    event_array.each do |event|
      Event.new(season_years: self.season_years, gcode: self.gcode, event_number: event[:event].to_i) do |e|
        e.period = event[:period].to_i
        e.seconds = event[:seconds].to_f
        e.event_type = event[:etype].to_s
        e.event_team = Team.find_by(abbr: event[:ev_team])
        e.event_player_1_id = unless event[:ev_player_1].to_i == 1
                                event[:ev_player_1].to_i
                              else
                                nil
                              end
        e.event_player_2_id = unless event[:ev_player_2].to_i == 1
                                event[:ev_player_2].to_i
                              else
                                nil
                              end

        e.event_player_3_id = unless event[:ev_player_3].to_i == 1
                                event[:ev_player_3].to_i
                              else
                                nil
                              end

        e.away_G_id = event[:away_G].to_i unless event[:away_G].to_i == 1
        e.home_G_id = event[:home_G].to_i unless event[:home_G].to_i == 1
        e.h1_id = event[:h1].to_i unless event[:h1].to_i == 1
        e.h2_id = event[:h2].to_i unless event[:h2].to_i == 1
        e.h3_id = event[:h3].to_i unless event[:h3].to_i == 1
        e.h4_id = event[:h4].to_i unless event[:h4].to_i == 1
        e.h5_id = event[:h5].to_i unless event[:h5].to_i == 1
        e.h6_id = event[:h6].to_i unless event[:h6].to_i == 1
        e.a1_id = event[:a1].to_i unless event[:a1].to_i == 1
        e.a2_id = event[:a2].to_i unless event[:a2].to_i == 1
        e.a3_id = event[:a3].to_i unless event[:a3].to_i == 1
        e.a4_id = event[:a4].to_i unless event[:a4].to_i == 1
        e.a5_id = event[:a5].to_i unless event[:a5].to_i == 1
        e.a6_id = event[:a6].to_i unless event[:a6].to_i == 1
        e.description = event[:type].to_s
        e.home_score = event[:home_score].to_i
        e.away_score = event[:away_score].to_i
        e.event_length = event[:event_length].to_f
        e.home_skaters = event[:home_skaters].to_i
        e.away_skaters = event[:away_skaters].to_i
        e.save
      end

      Location.new(season_years: self.season_years, gcode: self.gcode, event_number: event[:event].to_i) do |l|
        l.distance = event[:distance].to_i
        l.home_zone = event[:homezone].to_s if event[:homezone] =~ /('Neu'|'Off'|'Def')/
        l.x_coord = event[:xcoord].to_i
        l.y_coord = event[:ycoord].to_i
        l.location_section = event[:loc_section].to_i
        l.new_location_section = event[:new_loc_section].to_i
        l.new_x_coord = event[:newxc].to_i
        l.new_x_coord = event[:newyc].to_i
        l.save
      end

    end

  end
end
#  vim: set ts=8 sw=2 tw=0 et :
