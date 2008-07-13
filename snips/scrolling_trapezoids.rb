require "rubygame"
include Rubygame

Rubygame.init



class Trapezoid
	include Sprites::Sprite

	@@hspeed = 5 # TODO: make this variable
	
	def initialize(x, y, w_top, w_bot, h)
		super()
		if w_top > w_bot 
			raise ArgumentError, "wtop (#{w_top}) > wbot (#{w_bot})"
		end
		w_in = (w_bot - w_top) / 2
		@rect = Rect.new(x,y, w_bot, h )
		@image = Surface.new([w_bot, h])
		@image.set_colorkey([0,0,0]) # TODO: need to base on backround
		@image.draw_polygon_s([[0,h], [w_in,0], [w_in + w_top, 0], [w_bot,h], [0,h]],[100,100,100]) # TODO: fix color
	end	
	
	def update
		@rect.move!(-@@hspeed,0) 
	end
	
end

class TrapezoidGroup <  Sprites::Group
	def update
		if self[-1].rect.right() < 380
			t = Trapezoid.new(400, 200, 30, 40, 20)
			self.push(t)
			puts 'added!'
		end
		if self[0].rect.right() < 0
			self.shift()
			puts 'shift'
		end
		puts "there are now #{self.size()} elems"
		super
	end
end


screen = Rubygame::Screen.set_mode([500,400])
screen.title = 'scrolling trapezoids'


# we use this to clear the screen by blitting it on before each update
background = Rubygame::Surface.new(screen.size)
background.fill([255,255,255])


trapezoids  = TrapezoidGroup.new

t = Trapezoid.new(200, 200, 30, 40, 20)

trapezoids.push(t)
 

 
queue = Rubygame::EventQueue.new

game_over = false

until game_over do
	background.blit(screen, [0, 0]) # clear screen
	trapezoids.update()
	trapezoids.draw(screen)
	screen.update()
	sleep(0.2)
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