



########################
# THIS IS A MESS, TOTAL CRAP
########################
 




require "rubygame"
include Rubygame

Rubygame.init

screen = Rubygame::Screen.set_mode [500,400]
screen.title = 'Hello World'
screen.fill [255,255,255]

 # Create and test a new surface
a = Surface.new([200,100])

# Draw a bunch of shapes on the new surface to try out the drawing module
a.fill([100,100,100])
rect1 = Rect.new([50,50, 30, 10]) # x,y,w,h
a.fill([0,0,0],rect1)


a.blit(screen,[100,30]) #x,y of where to put surface
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