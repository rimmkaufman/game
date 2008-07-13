require "rubygame"
include Rubygame

require "caveconstants"
require "utils"
require "scrollsprite"

class Explosion <MultipleImageScrollSprite
	
	attr_accessor :vdir, :adir; # this is a hack -- when ship becomes an explosion (ack), explosion needs to 
															# answer method calls for vdir and adir
	
	Rubygame::Mixer::open_audio( 22050, Rubygame::Mixer::AUDIO_U8,2,1024 )
	@@explode_sound = load_sound('explode.wav')														
															
	
	def initialize(x,y)
	  super(x,y, 'explosion16.bmp', 16, 64,64)
		@ay = 0 # explosion is not impacted by gravity
		@last_frame_persist = false
		@last_frame_loop = false
		@frame_delay_ms = 150
   	@groups = [:all, :can_kill]
		@depth = 0 # explosions are always on top
		Rubygame::Mixer::play(@@explode_sound,-1,0) # boom    		       	
	end
end



