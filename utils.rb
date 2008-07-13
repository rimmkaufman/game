
class Rubygame::Surface
	Surface.autoload_dirs = %w(images)
end

class Rubygame::Sound
	Sound.autoload_dirs = %w(sounds)
end


#class Numeric
#	def bound(a,b)
#		if self < a then return a end
#		if self > b then return b end
#		return self
#	end
#end

class Array
	def to_s
		return '[' + self.join(", ") + ']'
	end
end

module Math
	
	def max (*v) return v.max end
	def min (*v) return v.min end
	
	def bound(a,x,b)
		if x < a
			return a
		elsif x > b
			return b
		else
			return x
		end
	end
	
	def bernoulli?(p)
		rand(10000)/10000.0 < p
	end 

	def min(*v)
		v.min
	end
	
	def max(*v)
		v.max
	end
	
end

module Rubygame
	
	def load_sound(name)
    return nil unless (Rubygame::VERSIONS[:sdl_mixer] != nil)
    begin
        sound = Rubygame::Mixer::Sample.load_audio(name)
        return sound
    rescue Rubygame::SDLError
        puts "Cannot load sound " + name
        exit
    end
	end

end