require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class Explosion <MultipleImageScrollSprite
		
	
	def initialize(x,y, filename='explosion16.bmp', frames=16, frameh=64, framew=64)
	  super(x,y, filename, frames, frameh, framew)
		@ay = 0 # explosion is not impacted by gravity
		@last_frame_persist = false
		@last_frame_loop = false
		@frame_delay_ms = 150
   	@groups = [:all, :can_kill]
		@depth = 0 # explosions are always on top
		Sound['explode.wav'].play	       	
	end
end



