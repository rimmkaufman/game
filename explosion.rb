require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class Explosion <MultipleImageScrollSprite
	
	
	def initialize(x,y)
	  super(x,y, 'explosion16.bmp', 16, 64,64)
		@ay = 0 # explosion is not impacted by gravity
		@last_frame_persist = false
		@last_frame_loop = false
		@frame_delay_ms = 150
   	@groups = [:all]
		@depth = 0 # explosions are always on top
		Sound['explode.wav'].play	       	
	end
end



