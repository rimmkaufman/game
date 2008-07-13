require "rubygame"
include Rubygame

Rubygame.init


screen = Rubygame::Screen.set_mode [500,400]
screen.title = 'Hello World'

background = Rubygame::Surface.new(screen.size)
background.fill([255,255,255])

class Explosion 
	
	include Sprites::Sprite	    

	def initialize
		super()
		allframes = Surface.load_image("explode.bmp")
		scale = 3
		size = [64 * scale, 64 * scale]
		@frames = Array.new(16) { |i| 
		  f = Surface.new(size) 
			r = allframes.blit(f, [0,0], [ (i%4)*64, (i/4)*64, 64,64])
	    # f.set_colorkey([0,0,0])
			f.zoom(scale)
		}
		@frames.push(f = Surface.new(size).fill([255,255,255]))
		@rect = Rect.new(0,0, *size)
  end

def update 
		if @frames.size > 0 
				@image = @frames.shift
			end	
	end
end

e = Explosion.new

queue = Rubygame::EventQueue.new

game_over = false

until game_over do
	background.blit(screen, [0, 0])
	e.update()
  e.draw(screen)
  screen.update
  sleep(0.1)
	
	
  queue.each do |event|
    case event
      when Rubygame::QuitEvent
        game_over = true
    end
  end
end

Rubygame.quit