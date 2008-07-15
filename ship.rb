require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"
require "bullet"
require "shield"

class Ship <  MultipleImageScrollSprite

	attr_accessor :vdir, :adir;

	def handle_collision(hit_by)
		return if @shields_on # collisions don't matter, even terrain??
		super(hit_by)
	end


	def initialize
		x = SHIP_XMIN
		y = YMAX * 0.3
		super(x,y, 'ship4.bmp', 4, 70,30)
		@ay = 0 # ship is not impacted by gravity, some sort of vert thrusters :)
		@vdir = @adir = 0
		@last_frame_persist =  false
		@last_frame_loop = true
		@frame_delay_ms = 0
		@depth = 10 
		@next_bullet_birth_time = 0
		@am_firing = false
		@shields_on = false
		@groups = [:all, :can_kill,  :can_be_killed, :ship]
	end

	def bound_rect(r) 
		r.b = bound(SKY_TOP + r.h,  r.b, TERRAIN_BOTTOM)
		r.l = bound(SHIP_XMIN, r.l, SHIP_XMAX - r.w)
		return r
	end
	
	def bound_vx(vx)
		@vx = bound(-SHIP_MAX_HSPEED, @vx, SHIP_MAX_HSPEED)
	end	
	
	def update
		@vy = @vdir * SHIP_VSPEED
 		@vx += SHIP_HACCEL*@adir 
 		if @adir == 0 then @vx = TERRAIN_SPEED end # this lets ship "hover" horiz
		if @am_firing then
			handle_firing()
		end
 		super
	end

	def handle_firing
		if (@next_bullet_birth_time == 0) then 
			@next_bullet_birth_time = Clock.runtime + BULLET_BIRTH_DELAY_SECS * 1000
		end 									
		if (@next_bullet_birth_time < Clock.runtime) then
			SpriteGroup::add(Bullet.new(self.rect.right-BULLET_HSPEED, self.rect.centery))
			@next_bullet_birth_time = 0
		end
	end

	def handle_event (event)
		case event		
			when KeyDownEvent  
					
				case event.key
						when K_UP 
							@vdir = -1 
						when K_DOWN 
							@vdir = 1 
						when K_RIGHT 
				 			@adir = 1 
						when K_LEFT 
				 			@adir = -1
				 		when K_SPACE
				 			@am_firing = true
    				when K_RETURN
    					@shields_on = ! @shields_on
    					if (@shields_on) then
    						SpriteGroup.add(Shield.new(self.rect.cx, self.rect.cy))
    					else 
    						SpriteGroup.kill_group(:shield)
    					end
			 		end

			when KeyUpEvent 
			
					case event.key
					when K_UP 
						@vdir = 0 
 					when K_DOWN 
						@vdir = 0 
					when K_RIGHT
				 		@adir = 0 
		  		when K_LEFT 
		  			@adir = 0 
					when K_SPACE
						@am_firing = false
					end
 		end
	end	

end
