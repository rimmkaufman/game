class Rubygame::Sound
	@@active_sounds = Array.new
	@@active_sounds_volume = Hash.new
	alias :play_original :play 
	def play
		@@active_sounds.delete_if { |s| s.stopped?}
		@@active_sounds.push(self)
		self.play_original
	end
	
	def self.toggle_pause
		if @@active_sounds.size > 0 then
			if @@active_sounds[0].paused? then
				@@active_sounds.each {|s| s.unpause}
			else
				@@active_sounds.each {|s| s.pause}
			end
		end
	end

	def self.toggle_volume
		if @@active_sounds.size > 0 then
			if @@active_sounds[0].volume > 0 then
				@@active_sounds.each {	|s| 
					@@active_sounds_volume[s.object_id] = s.volume
					s.volume = 0	
				}
			else
				@@active_sounds.each {|s| s.volume = @@active_sounds_volume[s.object_id] || 1.0}
			end
		end
	end


	
end

class Rubygame::Surface
	Surface.autoload_dirs = %w(images)
end

class Rubygame::Sound
	Sound.autoload_dirs = %w(sounds)
end


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

