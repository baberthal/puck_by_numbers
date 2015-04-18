module PlayersHelper
	def accordion_tag_for(player)
		content_tag(:li, class:"accordion-navigation") do
			link_to(player.pretty_name, dom_id(player))
			div_for(player, class:"content")
		end
	end

end
