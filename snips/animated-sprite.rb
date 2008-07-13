require "rubygame"
 
# Include the Rubygame namespace, so we don't have to put `Rubygame::' in front of things.
include Rubygame
 
TWOPI = Math::PI * 2
 
# A simple class which serves as an example of how you can make a sprite
# object play through a sequence of frames of an animation.
class BasicAnimatedSprite
  include Sprites::Sprite
 
  attr_accessor :currentframe
 
  # Initialize a new basic animated sprite.
  # pos is the starting position of the sprite (it will be centered here)
  # frames in an Array containing many Surfaces, one for each animation frame.
  def initialize(pos, frames)
    super()                     # Sprite initialization
    @pos = pos
    @frames = frames            # Array of Surfaces
    @currentframe = 0           # Incremented every frame
 
 
    update()
  end
 
  # [D.]
  # This is called once per frame. It changes our image to the next frame
  # of the animation.
  def update()
    @currentframe += 1
    @image = @frames[@currentframe]
 
    # If we have gone past the last frame of the animation, we loop and start
    # over again on the first frame.
    if (@image == nil)
      @currentframe = @currentframe % @frames.length
      @image = @frames[@currentframe]
    end
 
    # Re-make our Rect, in case the image size has changed.
    @rect = @image.make_rect()
    @rect.center = @pos
  end
end
 
def main()
 
  # Making a new display window and setting a useful title
  $screen = Screen.new([400,300])
  $screen.title = "Animated Sprite Test - press Q to quit"
 
  # This will be the background of our animation, a medium blue color.
  $background = Surface.new($screen.size)
  $background.fill([50,0,150])
  $background.blit($screen, [0,0])
 
  # Creating an event queue.
  $queue = EventQueue.new()
 
  # Generate an image for each frame of our animation.
  # You could also load the frames from an image file, etc, but we will
  # generate our frames on the fly to make distribution easier.
 
  anim_frames = []              # This will hold all our frames
  frames = 16                    # How many frames we want to generate.
 
  0.upto(frames-1) do |i|
    # Here we make a new surface ...
    s = Surface.new([64,64])
    # ... fill part of it with a color (which brightens as i increases) ...
    s.fill([100 + i*155/frames]*3, [16,16,32,32])
    # ... then rotate it (the angle increases as i increases) ...
    s = s.rotozoom(i*(90.0/frames), 1, true)
    # Finally we append it to our Array of frames.
    anim_frames << s
  end
 
  # Create a new sprite group to manage our sprite(s)
  group = Sprites::Group.new()
  group.extend(Sprites::UpdateGroup)
 
  # Create an animated sprite. We pass its position, plus the image sequence.
  group << BasicAnimatedSprite.new([300,150], anim_frames)
 
  # Create another one at a different location, with the sequence reversed.
  group << BasicAnimatedSprite.new([100,200], anim_frames.reverse)
 
  # Here we will loop until we throw :rubygame_quit.
  # Every loop is one frame of our animation.
  catch(:quit) do
    loop do
 
      # [A.] Process each event in the queue, and throw :quit
      # if the user pressed Q or Esc on the keyboard, or clicked the
      # close button.
      $queue.each do |event|
        case(event)
        when KeyDownEvent
          case event.key
          when K_ESCAPE
            throw :quit
          when K_Q
            throw :quit
          end
        when QuitEvent
          throw :quit
        end
      end
 
      # [B.] Erase (draw over) our sprites at their current position.
      group.undraw($screen,$background)
 
      # [C.] Update all the sprites in the group (although there
      # is only one sprite in this example).
      group.update()
 
      # [E.] Draw all the sprites to the screen.
      group.draw($screen)
 
      # [F.] Refresh the screen.
      $screen.update()
 
      # [G.] Wait a little while (so the animation doesn't go too fast)
      Clock.delay(100)
    end
  end
 
end
 
# Run the main() function when executing this file, to start the game loop.
main()