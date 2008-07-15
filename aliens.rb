include Rubygame
require "rubygame"
require "ftor"
require "caveconstants"
require "utils"
require "scrollsprite"
require "bda"


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

		def col_rect_padding() return [10,10] end
		
		def update
			endtime = Clock.runtime + 2000; 
			dir = Ftor.new_am( rand_between(0, 2*PI), RED_ALIEN_SPEED)
			Bda::do('red alien movement', self, 
				lambda {|obj| Clock.runtime < endtime}, 
				lambda {|obj|  obj.vx, obj.vy = dir.to_a},
				lambda {},
				lambda {|obj| obj.vy = 0}
			)
		super	
		end
		
end



