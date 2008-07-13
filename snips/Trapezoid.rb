

class Trapezoid
            include Sprites::Sprite

            @@hspeed = 5 # TODO: make this variable
            
            def initialize(x, y, w_top, w_bot, h)
                        super()
                        if w_top > w_bot 
                                    raise ArgumentError, "wtop (#{w_top}) > wbot (#{w_bot})"
                        end
                        w_in = (w_bot - w_top) / 2
                        @rect = Rect.new(x,y-h, w_bot, h )
                        @image = Surface.new([w_bot, h])
                        @image.set_colorkey([0,0,0]) # TODO: need to base on backround
                        @image.draw_polygon_s([[0,h], [w_in,0], [w_in + w_top, 0], [w_bot,h], [0,h]],[100,100,100]) # TODO: fix color
            end       
            
            def update
                        @rect.move!(-@@hspeed,0) 
						if @rect.right() < 0
							self.kill
						end 
                    
           end
end

class RandTrapezoid < Trapezoid
            def initialize 
                        w_top = 30+rand(20)
                        w_bot = w_top + rand(90)
                        super(400,200,w_top,w_bot, 30+rand(40))
            end
end


class TrapezoidGroup <  Sprites::Group
            def update
                        if self[-1].rect.right() < 380
                                    t = RandTrapezoid.new
                                    self.push(t)
                                    puts 'added!'
                        end
#                        if self[0].rect.right() < 0
#                                    self.shift()
#                                    puts 'shift'
#                        end
                        puts "there are now #{self.size()} elems"
                        super
            end
end

