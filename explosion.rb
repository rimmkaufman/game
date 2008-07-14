require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class Explosion <MultipleImageScrollSprite
		
	
	def initialize(x,y, image_filename='explosion16.bmp',
											sound_filename='explode.wav', frames=16, frameh=64, framew=64)
	  super(x,y, image_filename, frames, frameh, framew)
		@ay = 0 # explosion is not impacted by gravity
		@last_frame_persist = false
		@last_frame_loop = false
		@frame_delay_ms = 150
   	@groups = [:all, :can_kill]
		@depth = 0 # explosions are always on top
		Sound[sound_filename].play	       	
	end
end



