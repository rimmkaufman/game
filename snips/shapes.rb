require "rubygame"
include Rubygame

Rubygame.init

screen = Rubygame::Screen.set_mode [500,400]
screen.title = 'Hello World'
screen.fill [0,0,255]


# Make the background surface
background = Surface.new(screen.size)

# Create and test a new surface
a = Surface.new([100,100])

# Draw a bunch of shapes on the new surface to try out the drawing module
a.fill([70,70,255])
rect1 = Rect.new([3,3,94,94])
a.fill([40,40,1500],rect1)
a.draw_box_s([30,30],[70,70],[0,0,0])
a.draw_box([31,31],[69,69],[255,255,255])
a.draw_circle_s([50,50],10,[100,150,200])
# Two diagonal white lines, the right anti-aliased, the left not.
a.draw_line([31,69],[49,31],[255,255,255])
a.draw_line_a([49,31],[69,69],[255,255,255])
# Finally, copy this interesting surface onto the background image 
a.blit(background,[50,50],[0,0,90,80])

# Draw some shapes on the background for fun
# ... a filled pentagon with a lighter border
background.draw_polygon_s(\
	[[50,150],[100,140],[150,160],[120,180],[60,170]],\
	[100,100,100])
background.draw_polygon_a(\
	[[50,150],[100,140],[150,160],[120,180],[60,170]],\
	[200,200,200])
background.blit(screen,[0,0])
screen.update

queue = Rubygame::EventQueue.new

game_over = false

until game_over do
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