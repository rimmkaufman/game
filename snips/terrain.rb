require "rubygame"
include Rubygame

require "caveconstants"
require "explosion"

# This class handles animated sprites which scrolling across the screen to the left,
# vanishing when they go off the left side.  
class ScrollSprite
	
	include Sprites::Sprite	    

	# Initialize a new ScrollSprite
	#
	# x:: x coordinate for initial location of left of sprite
	# y_bottom:: initial y coordinate of the BOTTOM of the sprite
	# xspeed:: horiz velocity
	# frames:: array of surfaces, comprising the sequence of frames for animation
	
	attr_accessor :xspeed
	
	def initialize(x, y_bottom, xspeed, frames)
		super()
		@frames = frames
    max_h = frames.map{|i| i.h}.max # find height of tallest frame
    max_w = frames.map{|i| i.w}.max # find width of widest frame
    @rect = Rect.new(x,y_bottom - max_h, max_w, max_h)
    @xspeed = xspeed
    frames.each { |x| x.set_colorkey([0,0,0])} # why is this black???
    @currentframe = 0 # counter
  end
	# Update sprite, showing correct frame, scrolling horizontally left, 
	# and killing sprite as leaves screen      
  def update 
		@currentframe = (@currentframe + 1) % @frames.size 
		@image = @frames[@currentframe] # load the image
  	@rect.move!(-@xspeed,0) # move horizontally left 
    if @rect.right() < 0
				self.kill  # went off screen, kill it
				return 
		  end
  end  	
end



# This class scrolls triangles   
class TerrainTriangle < ScrollSprite
	def initialize 
		w = 50 + rand(100)
		h = 100 + rand(50)
		@rect = Rect.new(XMAX, TERRAIN_BOTTOM-h, w, h )
	  @image = Surface.new([w,h])
    @image.set_colorkey(BG_COLOR) 
	  @image.draw_polygon_s([[0,h], [w/2,0], [w,h], [0,h]], BROWN)
		super(XMAX, TERRAIN_BOTTOM, TERRAIN_SPEED, [@image])
	end
end



class DistantTerrainTriangle < ScrollSprite
	def initialize 
		w = 400 + rand(300)
		h = 200 + rand(200)
		@rect = Rect.new(XMAX, TERRAIN_BOTTOM-h, w, h )
	  @image = Surface.new([w,h])
    @image.set_colorkey(BG_COLOR) 
	  @image.draw_polygon_s([[0,h], [w/2,0], [w,h], [0,h]], LIGHTGRAY)
		super(XMAX, TERRAIN_BOTTOM, DISTANT_TERRAIN_SPEED, [@image])
	end
end




class TerrainTrapezoid < ScrollSprite
def initialize 
		w = 400 + rand(100)
		h = 30 + rand(30)
		wt = 0.8 * w
		dw = 0.5 * (w-wt) 
		@rect = Rect.new(XMAX, TERRAIN_BOTTOM-h, w, h )
	  @image = Surface.new([w,h])
    @image.set_colorkey([0,0,0]) # TODO: need to base on backround
	  @image.draw_polygon_s([[0,h], [dw,0], [dw+wt,0], [w,h],[0,h]], BROWN)
		super(XMAX, TERRAIN_BOTTOM, TERRAIN_SPEED, [@image])
	end
end
	
	
class Terrain <  Sprites::Group
	def ship_crash?(ship)
		(ship.class.to_s == 'Ship') && 	(self.collide_sprite(ship).size > 0) 
	end	
	
	def update
  	if self.size == 0 || self[-1].rect.centerx() < XMAX
			if bernoulli?(0.25) then
				self.push(TerrainTrapezoid.new())
			else
  	  	self.push(TerrainTriangle.new())
			end
    end
    super
  end

	def stop_scrolling
		self.each{ |s| s.xspeed = 0}
	end
	
end

class DistantTerrain <  Sprites::Group
	
	def update
  	if self.size == 0 || self[-1].rect.centerx() < XMAX
		  	self.push(DistantTerrainTriangle.new())
		end
    super
  end

	def stop_scrolling
		self.each{ |s| s.xspeed = 0}
	end
	
end



