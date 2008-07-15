require "rubygame"
require "scrollsprite"
require "caveconstants"
require "utils"
require "ship"
require "terrain"
require "explosion"
require "pixelcollision"
require "aliens"

include Rubygame
include Math

Rubygame.init


screen = Rubygame::Screen.set_mode([XMAX, YMAX])
screen.title = 'scrolling terrain'

# we use this to clear the screen by blitting it on before each update
background = Rubygame::Surface.new(screen.size)
background.fill(BG_COLOR)

background.blit(screen, [0, 0]) # clear screen
screen.update()

# preload sounds and images to avoid hesitation
Dir.foreach("images") {|f| if  f =~ /\.bmp$/ then Surface[f] end}
Dir.foreach("sounds") { |f| if f =~/\.wav$/ then Sound[f] end}
Sound.all_sounds_off()

# Music['love.mp3'].play

queue = Rubygame::EventQueue.new

SpriteGroup.new # ditto

clock = Clock.new { |clock| clock.target_framerate = 30 }


# get some landscape on the board
1000.times {
	Terrain.append_new_landscape
 	DistantTerrain.append_new_landscape 	
 	SpriteGroup::update(:all)
}

SpriteGroup.add(Ship.new) 

	
exit_game_loop  = false
game_paused = false
next_ship_birth_time = 0


until exit_game_loop do

	ship = SpriteGroup::sprites(:ship)[0]
	
  queue.each do |event|
  		
	case event
		when QuitEvent 
			exit_game_loop = true
		when KeyDownEvent 
			case event.key
				when K_Q  	
					exit_game_loop = true
				when K_ESCAPE 
					game_paused = ! game_paused
					Sound::toggle_all_sounds_pause
				when K_S 
					Sound::all_sounds_toggle_on_off
			end
		end
			ship.handle_event(event) if ship  	# handle ship keyboard events 		
		end

	if game_paused then next; end;

	if (!ship &&  next_ship_birth_time == 0) then 
		next_ship_birth_time = Clock.runtime + SHIP_REBIRTH_DELAY_SECS * 1000
	end
	if (!ship && next_ship_birth_time < Clock.runtime) then
		SpriteGroup::add(Ship.new)
		next_ship_birth_time = 0
	end
	
	if bernoulli?(0.01) then
			SpriteGroup::add(RedAlien.new(XMAX, 
				TERRAIN_BOTTOM - TERRAIN_TRIANGLE_MAX_HEIGHT - rand(200)))
	end		
	
	clock.tick
  background.blit(screen, [0, 0]) # clear screen
  DistantTerrain.append_new_landscape 
  Terrain.append_new_landscape
  SpriteGroup::handle_collisions
  SpriteGroup::update(:all) 
  SpriteGroup::draw(:all,screen)
  screen.update()
end

Rubygame::Mixer.close_audio()
Rubygame.quit


