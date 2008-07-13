

class Numeric
	
	def bound(a,b)
		if self < a then return a end
		if self > b then return b end
		return self
	end
end

p 6.bound(5,7)

x = 100.4

p x.bound(10.0, 800)

p x.bound(200, 800)

p x.bound(10, 30)