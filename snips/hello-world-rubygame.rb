require 'rubygame'

Rubygame.init

screen = Rubygame::Screen.set_mode [320,240]
screen.title = 'Hello World'
screen.fill [0,0,255]
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