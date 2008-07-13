


class  Foo
	@@h = Hash.new
	p "should show once"
	def initialize(x)
			@y = 50
      @@h[x]= "love #{x}"
		end
		
		def gethash
			return @@h
		end
		
		def self.gethash
			return @@h
		end
	
	
end
	
p 'hi'
	z = Foo.new(45)
	p z.gethash
	
	h= z.gethash
	
	h['fish'] = 'marlin'
	
	z2 = Foo.new(100)
	
	p z.gethash
	
	p Foo.gethash
	
	y = Foo.new(999)
	z = Foo.new(456)
	p Foo.gethash