require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class RedAlien <MultipleImageScrollSprite
															
	def initialize(x,y)
	  super(x,y, 'redalien4.bmp', 4, 40,40)
	  @ay = 0 
		@ax = 0
		@vx = 0
		@last_frame_persist = false
		@last_frame_loop = true
		@frame_delay_ms = 250
   	@groups = [:all, :can_kill, :can_be_killed, :alien]
		@depth = 10 
		end
end



