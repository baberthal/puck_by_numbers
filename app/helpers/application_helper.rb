module ApplicationHelper
	def sortable(column, col_title=nil, title=nil)
		col_title ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to col_title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class, :title => title}
	end
end
