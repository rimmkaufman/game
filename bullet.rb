require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"
require 'spritegroup'


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
		Sound['singleshot.wav'].play
	end

	def handle_collision
		SpriteGroup.add(Explosion.new(self.rect.x, self.rect.y, 'smallexplosion16.bmp', 16, 16,16))
		SpriteGroup.kill(self)
	end

	def load_frames
		img = Surface.new([3,3])		
		img.draw_box_s([0,0],[3,3],[0,0,0])
		return [img]
	end

end



