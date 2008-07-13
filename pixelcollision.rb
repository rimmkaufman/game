class ScrollSprite
	
	def collide_sprite?(sprite)
		
			sprite_one = self
			sprite_two = sprite
			
			
			rect_one = sprite_one.rect.normalize
			rect_two = sprite_two.rect.normalize
			
			img_one = sprite_one.image
			img_two = sprite_two.image
			
			return false unless ((rect_one.l > rect_two.l && rect_one.l < rect_two.r) or 
																		(rect_two.l >  rect_one.l  && rect_two.l < rect_one.r)) &&
		       													((rect_one.t > rect_two.t && rect_one.t < rect_two.b) or
		        												(rect_two.t >  rect_one.t && rect_two.t < rect_one.b))
	
				ll = max(rect_one.l, rect_two.l)	        								
		    rr = min(rect_one.r, rect_two.r)
		    tt = max(rect_one.t, rect_two.t)
		    bb = min(rect_one.b, rect_two.b)
		    ww = rr - ll
		    hh = bb - tt

				grid = 5
				for i in ( 0.. grid) do
					for j in (0..grid) do
						xfract = i.to_f / grid
						yfract = j.to_f / grid
							xx = ll + xfract * ww
							yy = tt + yfract * hh
							pixel_one = img_one.get_at(xx - rect_one.l, yy - rect_one.t)
							pixel_two = img_two.get_at(xx - rect_two.l, yy - rect_two.t)
							pixel_one.pop; pixel_two.pop # remove opacity, just want RGB
							return true if (pixel_one != @@bg_color ) && (pixel_two !=@@bg_color) 								
		    		end
		    	end
		    return false		
		end	
end
