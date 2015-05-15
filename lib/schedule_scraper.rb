module ScheduleScraper
  def schedule_scrape
    season = self
    scheduled_games = []

    agent = Mechanize.new do |a|
      a.log = Logger.new('log/schedule_scrape.txt')
    end

    page = agent.get('http://www.nhl.com/ice/schedulebyseason.htm?navid=nav-sch-sea#')

    page.search('//*[@id="fullPage"]/div[2]/table[1]/tbody').children.each do |tr|
      game_info = []
      tr.children.each do |td|
        td.search('//')
      end
    end


  end
end
#  vim: set ts=8 sw=2 tw=0 et :
