require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"
require "spritegroup"


# This class scrolls triangles   
class TriangleScrollSprite < ScrollSprite

	def load_frames
		w,h,c = @tss_w, @tss_h, @tss_color # convenience 
	  img = Surface.new([w,h]).fill(@@bg_color)
	  img.draw_polygon_s([[0,h], [w/2,0], [w,h], [0,h]], c)
	  return [img]
	end
	
	def initialize(w_c, w_r, h_c, h_r, tss_color) 
		@w_c, @w_r, @h_c, @h_r, @tss_color = w_c, w_r, h_c, h_r, tss_color	
		@tss_w = w_c + rand(w_r)
		@tss_h = h_c + rand(h_r)
		super(XMAX, TERRAIN_BOTTOM - @tss_h) 
		end
end

class DistantTerrainTriangle < TriangleScrollSprite 
	def handle_offscreen_right() end # terrain can bleed off to right
	def bound_vy(vy)  return 0 end   # the terrain doesn't sink under gravity!
	def bound_vx(vx)	 return DISTANT_TERRAIN_SPEED end # far mountains move more slowly
	def initialize
		super(400,300,200,200, LIGHTGRAY)
    @depth = 30
		@groups = [:all, :distant_terrain]
	end
end


class TerrainTriangle < TriangleScrollSprite 
	def bound_vy(vy) return 0 end    # terrain doesn't sink under gravity!
	def handle_offscreen_right() end # terrain can bleed off to right
 	def initialize
   	super(50,100, 100,50, BROWN)
	  @depth = 20
   	@groups = [:all, :terrain, :can_kill]
   	end
end
		
class TerrainTrapezoid < ScrollSprite

def bound_vy(vy) return 0 end   # the terrain doesn't sink under gravity!
def handle_offscreen_right() end # terrain can bleed off to right
	
	def load_frames
		w,h = @_w, @_h # convenience assignments
		wt = 0.8 * w
		dw = 0.5 * (w-wt) 
	  img = Surface.new([w,h]).fill(@@bg_color)
	  img.draw_polygon_s([[0,h], [dw,0], [dw+wt,0], [w,h],[0,h]], BROWN)
	  return [img]
	end
	
	def initialize
		@_w = 450 + rand(200)
		@_h = 30 + rand(30)
		super(XMAX, TERRAIN_BOTTOM - @_h)
	  @depth  = 20
	  @groups = [:all, :terrain, :can_kill]   
	end
end
	

		
class DistantTerrain 

	def self::append_new_landscape 
	sprites = SpriteGroup.sprites(:distant_terrain)
	if sprites.size == 0 || sprites[-1].rect.centerx < XMAX then
			SpriteGroup.add(DistantTerrainTriangle.new())
		end
	end
end

class Terrain 
	
	def self::append_new_landscape
		sprites = SpriteGroup.sprites(:terrain)
		if sprites.size == 0 || sprites[-1].rect.centerx < XMAX then
			if bernoulli?(0.30) then
				SpriteGroup.add(TerrainTrapezoid.new()	)
			else
				SpriteGroup.add(TerrainTriangle.new())
			end
		end
	end	
end


