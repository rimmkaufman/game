require "rubygame"
include Rubygame

Rubygame.init

screen = Rubygame::Screen.set_mode [500,400]
screen.title = 'Hello World'
screen.fill [255,255,255]




class PolySprite
	include Sprites::Sprite
	
	attr_accessor :vx, :vy, :speed
	def initialize(x,y)
		super()
		@vx, @vy = 1,1
		@speed = 40
		@rect = Rect.new(x,y,50,50)
		@image = Surface.new([50,50])
		@image.set_colorkey([0,0,0])
		
		@image.draw_polygon_s(	[[5,5],[40,5],[45,30],[30,30],[10,30]],	[0,0, 255])
		@area = Rubygame::Rect.new(0,0, *Rubygame::Screen.get_surface().size())
	end

	def update
		newpos = @rect.move(@vx,@vy) #

		# If the chimp starts to walk off the screen
		if (@rect.left < @area.left) or (@rect.right > @area.right)
			@vx = -@vx		# reverse direction of movement
			newpos = @rect.move(@vx,@vy) 
			# @image = @image.flip(true, false) # flip x
		end
		if (@rect.top < @area.top) or (@rect.bottom > @area.bottom)
			@vy = -@vy		# reverse direction of movement
			newpos = @rect.move(@vx,@vy) 
			# @image = @image.flip( false, true) # don't flip on y
		end
		@rect = newpos
	end
end



background = Rubygame::Surface.new(screen.size)
background.fill([250,250,250])
 

background.draw_polygon_s(\
	[[50, 50],[200,140],[250,460],[320,180],[60,170]],\
	[100,100,100])
background.blit(screen,[0,0])

all  = Sprites::Group.new
all.extend(Sprites::UpdateGroup)

ps = PolySprite.new(100,50)
all.push(ps)
 

 


queue = Rubygame::EventQueue.new

game_over = false

until game_over do
	all.update()
	background.blit(screen, [0, 0])
	all.draw(screen)
	screen.update()
	sleep(0.01)
	queue.each do |event|
    case event
      when Rubygame::ActiveEvent
        screen.update
      when Rubygame::QuitEvent
        game_over = true
    end
  end
end

Rubygame.quit