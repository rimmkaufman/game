class BoolTimer
	def initialize(delay_secs)
		@go_false_time = Clock.runtime + delay_secs * 1000
	end
	def status?
		return Clock.runtime < @go_false_time
	end
end

module Rubygame::Sprites::Sprite
	def col_rect(); raise 'overriden'; end
end
		
	
class Rubygame::Sound
	@@active_sounds = Array.new
	@@active_sounds_volume = Hash.new
	@@sound_on = true
	alias :play_original :play 
	def play
		@@active_sounds.delete_if { |s| s.stopped?}
		@@active_sounds.push(self)
		self.play_original if @@sound_on
	end
	
	def self.toggle_all_sounds_pause
		if @@active_sounds.size > 0 then
			if @@active_sounds[0].paused? then
				@@active_sounds.each {|s| s.unpause}
			else
				@@active_sounds.each {|s| s.pause}
			end
		end
	end

	def self.all_sounds_on() 	@@sound_on = true end
	def self.all_sounds_off() 	@@sound_on = false end
	def self.all_sounds_toggle_on_off() 		@@sound_on = !@@sound_on end
			
end

class Rubygame::Surface
	Surface.autoload_dirs = %w(images)
end

class Rubygame::Sound
	Sound.autoload_dirs = %w(sounds)
end

class Rubygame::Music
	Music.autoload_dirs = %w(music)
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
	
	def rand_between(a,b)
		if a.class.to_s == 'Float' or b.class.to_s == 'Float' then
			return a + (b-a) * rand  # if sent float(s), return floats
		else 
			return a + rand(b-a) # otherwise, return ints
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

