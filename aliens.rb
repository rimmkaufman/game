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
		@collision_rect_padding_x = @collision_rect_padding_y = 20
		end

	def handle_collision(hit_by)
		return if hit_by.all? {|s| s.class.to_s == 'RedAlien'} # red aliens are not fatal to eachother
		SpriteGroup.add(Explosion.new(self.rect.x, self.rect.y))
		SpriteGroup.kill(self)
	end

		def update
			Bda::do('red alien movement', self, 
				lambda {|obj| @timer.status? }, 
				lambda {|obj| 
					@dir = Ftor.new_am( rand_between(0, 2*PI), RED_ALIEN_SPEED);
					obj.vx, obj.vy = @dir.to_a
					@timer = BoolTimer.new(RED_ALIEN_DIR_SECS)
					@have_reversed = false
				},
				lambda {|obj| 
					if (obj.near_miss) and (obj.near_miss.any? {|s| s.class.to_s =~ /^Terrain/}) and  (true or !@have_reversed)	 then 
						p "reversing, obj=#{obj.object_id}"	
						@dir =-@dir;  
						obj.vx, obj.vy = @dir.to_a; 
						@timer = BoolTimer.new(RED_ALIEN_DIR_SECS)
						@have_reversed = true				
				end},
				lambda {|obj| obj.vx = 0; obj.vy = 0; @have_reversed=false}
			)
		super	
		end
		
end



