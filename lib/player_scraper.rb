module PlayerScraper
  def bio_scrape
    player = self
    headshot_path = "app/assets/images/players/#{player.id}.jpg"
    headshot_rel_path = "players/#{player.id}.jpg"

    agent = Mechanize.new do |a|
      a.log = Logger.new('log/mech_log.txt')
    end

    page = agent.get('http://www.nhl.com/ice/playersearch.htm?navid=nav-ply-search#')
    name_permutations = ["#{player.first_name} #{player.last_name}",
       player.number_first_last.to_s.gsub(/[0-9]/, "").strip,
       "#{player.first_name[0..2]} #{player.last_name}",
       "#{player.nickname[0]} #{player.last_name}"]
    try = 0
    while try < 4
      form = page.form_with(action: "http://www.nhl.com/ice/search.htm")
      form.q = name_permutations[try]
      page = agent.submit(form)
      if page.links_with(:href => /PlayerBio/)[0].nil?
        try += 1
      else
        try = 4
        page = page.links_with(:href => /PlayerBio/)[0].click
      end
    end

    page.image_with(src: /mugs/).fetch.save headshot_path unless File.exist?(headshot_path)

    self.headshot = headshot_rel_path

    bio_info = []
    page.search("//table[@class='bioInfo']//tr").children.each do |c|
      bio_info << c.content
    end

    bio_info.map!.each do |s|
      s.strip
    end

    bio_keys = []
    bio_values = []

    bio_info.each_with_index do |v,i|
      if i == 0 || i % 2 == 0
        bio_keys << v
      else
        bio_values << v
      end
    end

    bio_keys.map!.each do |v|
      v.chop.downcase.to_sym
    end

    bio_values.map!.each do |v|
      v.strip
    end

    bio_keys.delete_at(-1)
    bio_values.delete_at(-1)

    bio_hash = Hash[*bio_keys.zip(bio_values).flatten]
    bio_hash[:number] = bio_hash[:number].to_i
    bio_hash[:weight] = bio_hash[:weight].to_i
    bio_hash[:birthdate] = Date.parse(bio_hash[:birthdate].split("\n")[0])
    bio_hash[:birthplace] = bio_hash[:birthplace].split.join(" ")
    bio_hash[:round] = bio_hash[:round].sub(/\s\W(Prospect Bio)/, "").gsub(/\n/, '').gsub(/[[:blank:]]{2}/, " ") if bio_hash[:round]
    bio_hash[:draft_team] = bio_hash[:drafted].split[0] if bio_hash[:drafted]
    bio_hash[:draft_year] = bio_hash[:drafted].split[2] if bio_hash[:drafted]

    self.bio = bio_hash
    self.save

  end
end
