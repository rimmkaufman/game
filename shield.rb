require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class Shield 
	
	include Sprites::Sprite	

			
	def initialize(x,y)
		super() 
		@groups = [:all, :shield]
		@depth = 9 # just above ship
		@cx = x
		@cy = y 
		# Sound[sound_filename].play	       	
		end
	
	def update
			ships = SpriteGroup.sprites(:ship)
			if ships.size == 0 then
			SpriteGoup.kill(self)
			return
		end
		r = 35 # radius
		alpha = rand_between(75, 150)  # 0 = fully transparent, 255 = fully opaque
		@image = Surface.new([2*r, 2*r])
		@image.set_alpha(alpha)
		@image.fill(BG_COLOR)
		@image.set_colorkey(BG_COLOR)
		@image.draw_circle_s([r,r],r, [255,255, 0])
	
		@rect = @image.make_rect
		ship = ships[0]
		@rect.cx = ship.rect.cx
		@rect.cy = ship.rect.cy
	end
	
end



