require "rubygame"
include Rubygame

require "caveconstants"
require "spritegroup"
require "utils"


class ScrollSprite
	
	include Sprites::Sprite	

	@@bg_color = BG_COLOR
	@@loaded_frames = Hash.new
 
	def handle_after_last_frame() SpriteGroup.kill(self); end
  def handle_offscreen_left() SpriteGroup.kill(self) end
	def handle_offscreen_right() SpriteGroup.kill(self) end
  def bound_vx(vx)	return vx  end
	def bound_vy(vy)	 return vy  end
	def bound_rect(r) return r end
	def load_frames() 	raise 'virtual' end

	def handle_collision
		SpriteGroup::add(Explosion.new(self.rect.x, self.rect.y))
		SpriteGroup.kill(self)
	end

	attr_accessor :vx, :ax, :vy, :ay, :last_frame_persist, :last_frame_loop, :frame_delay_ms, :groups
	
	# Initialize a new ScrollSprite

	# x:: x coord of top left
	# y:: y coord of top left
	
	def initialize(x, y)
		super()
		@groups = Array.new	
		@last_frame_persist = true # default behavior, use accessor to change
		@last_frame_loop  = false # default behavior, use accessor to change
		@frame_delay_ms = 150 # default delay, use accessor to change
		@last_frame_time = 0
		@frames = load_frames()
    max_h = @frames.map{|i| i.h}.max # find height of tallest frame
    max_w = @frames.map{|i| i.w}.max # find width of widest frame
    @rect = Rect.new(x,y, max_w, max_h)
    @frames.each { |x| x.set_colorkey(@@bg_color)} 
    @current_frame = 0 # frame counter
  	@ay = GRAVITY_VACCEL # everything falls, unless we override    
	  @ax = 0
	  @vx = 0
	  @vy = 0
	end
  
	# Update sprite, showing correct frame, scrolling horizontally left, 
  def update 
		# determine if we need to go next frame	
			if Clock.runtime - @last_frame_time > @frame_delay_ms then
  		@current_frame += 1
  		@last_frame_time = Clock.runtime
		end
  	if @current_frame >= @frames.size then
  		case
			when  @last_frame_persist then 	@current_frame = @frames.size - 1 
			when  @last_frame_loop  then   			@current_frame = 0
			else
				handle_after_last_frame()
				return # leave function, don't render
			end	
  	end
		@image = @frames[@current_frame]	
		
		if (@image == nil)
			p "nil image??"
			exit
		end
		
  	@vy += @ay
  	@vy = bound_vy(@vy)
  	@vx += @ax	 
  	@vx = bound_vx(@vx)
  	vx_relative = @vx - TERRAIN_SPEED # relative to the scrolling frame of reference
  	@rect.move!(vx_relative, @vy)
  	@rect = bound_rect(@rect)
  	if @rect.right < XMIN then handle_offscreen_left() end
    if @rect.left > XMAX then handle_offscreen_right() end
  	if @rect.top < YMIN then handle_offscreen_top() end
  	#### KILLME # if @rect.bottom  > YMAX then handle_offscreen_bottom() end
	end  	

end

class ImageScrollSprite < ScrollSprite
	
	def load_frames
			#return @@loaded_frames[@img_filename] if @@loaded_frames[@img_filename] 
			#@@loaded_frames[@img_filename] = [Surface.load_image(@img_filename)]
			return Surface[@img_filename]
		end
	
	def initialize(x, y, img_filename)
		@img_filename = img_filename
		super(x, y)
	end
end

class MultipleImageScrollSprite < ScrollSprite
	
	def initialize(x,y, img_filename, num_frames, frame_w, frame_h)
		@img_filename = img_filename
		@num_frames = num_frames
		@frame_w= frame_w
		@frame_h = frame_h
		super(x,y)
	end
		
	
	def load_frames
			return @@loaded_frames[@img_filename] if @@loaded_frames[@img_filename] 
			allframes = Surface[@img_filename]
			
			size = [@frame_w, @frame_h]
			frames = Array.new(@num_frames) { |i| 
			frames_per_row = allframes.width / @frame_w
			  f = Surface.new(size) 
				r = allframes.blit(f, [0,0], [ (i%frames_per_row)*@frame_w, (i/frames_per_row)*@frame_h, *size])
	    	f.set_colorkey(@@bg_color)
				f
			}
			@@loaded_frames[@img_filename] = frames
			return @@loaded_frames[@img_filename]
	end
end	
