require "rubygame"
include Rubygame

Rubygame.init

screen = Rubygame::Screen.set_mode [500,400]
screen.title = 'Hello World'
screen.fill [255,255,255]

background = Surface.new(screen.size)

background.draw_polygon_s(\
	[[50,150],[100,140],[150,160],[120,180],[60,170]],\
	[100,100,100])
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