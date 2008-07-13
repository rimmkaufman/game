require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"



class Bullet < ScrollSprite
															
	def initialize(x,y)
	  super(x,y) 
	  @ay = 0 
		@ax = 0
		@vx = BULLET_HSPEED
		@last_frame_persist = false
		@last_frame_loop = true
		@frame_delay_ms = 250
   	@groups = [:all, :can_kill, :can_be_killed]
		@depth = 25 
		end

	def handle_collision
		SpriteGroup.kill(self)  # bullets dont explode, but they do vanish.  maybe a little explosion?
	end

	def load_frames
		img = Surface.new([3,3])		
		img.draw_box_s([0,0],[3,3],[0,0,0])
		return [img]
	end

end



