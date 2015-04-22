module PlayersHelper
  def accordion_tag_for(player)
    content_tag(:li, class:"accordion-navigation") do
      link_to(player.pretty_name, dom_id(player))
      div_for(player, class:"content")
    end
  end

  def wiki_link_draft(player)
    if player.bio[:drafted]
      link_to("  /  #{player.bio[:draft_year]} NHL Entry Draft", "http://en.wikipedia.org/wiki/#{player.bio[:draft_year]}_NHL_Entry_Draft")
    else
      "Undrafted"
    end
  end
end
