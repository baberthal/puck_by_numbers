module ColorMeMine
	include Math

	def color_diff(color1, color2)
		one = xyz_to_lab(rgb_to_xyz(color1))
		two = xyz_to_lab(rgb_to_xyz(color2))

		l_diff = ( two[0] - one[0] ) ** 2
		a_diff = ( two[1] - one[1] ) ** 2
		b_diff = ( two[2] - one[2] ) ** 2

		sqrt( l_diff + a_diff + b_diff )
	end

	def rgb_to_xyz(color)
		case color
		when String
			c = color.match(/#(..)(..)(..)/) # Three tits, awesome
			col = [ c[1].hex, c[2].hex, c[3].hex ].map { |x| ( x.to_f / 255 ) }
		when Array
			col = color.map { |x| ( x.to_f / 255 ) }
		end

		col.map!.each do |x|
			if x > 0.04045
				x = ( ( x + 0.055 ) / 1.055 ) ** 2.4
			else
				x /= 12.92
			end
			x *= 100
		end

		r = col[0]
		g = col[1]
		b = col[2]

		x = (( r * 0.4124 ) + ( g * 0.3576 ) + ( b * 0.1805 )).round(4)
		y = (( r * 0.2126 ) + ( g * 0.7152 ) + ( b * 0.0722 )).round(4)
		z = (( r * 0.0193 ) + ( g * 0.1192 ) + ( b * 0.9505 )).round(4)

		[x, y, z]
	end

	def xyz_to_lab(color)
		ref_x = 95.047
		ref_y = 100.000
		ref_z = 108.883

		x = color[0]
		y = color[1]
		z = color[2]

		x /= ref_x
		y /= ref_y
		z /= ref_z

	 	col = [x, y, z]

		col.map!.each do |c|
			if c > 0.008856
				c **= ( 1.0 / 3.0 )
			else
				c = ( 7.787 * c ) + ( 16.0 / 116.0 )
			end
		end

		x = col[0]
		y = col[1]
		z = col[2]

		cie_l = ( 116.0 * y ) - 16.0
		cie_a = 500.0 * ( x - y )
		cie_b = 200.0 * ( y - z )

		[cie_l, cie_a, cie_b]
	end

end
