require 'set'

class SpriteGroup 
		
	def initialize
		@@g = Hash.new
		@@s = Hash.new
		groups = [:all, :alien, :can_be_killed, :can_kill, :distant_terrain, :ship, :terrain, :shield] 
    groups.each {|g| @@g[g] = Array.new}
	end

	def self::handle_collisions
		collided = Hash.new
		for cbk in @@g[:can_be_killed] do
			cbk.near_miss = Set.new()
			for ck in @@g[:can_kill] do
				next if ck == cbk # can't kill self
				if cbk.collide_sprite?(ck) then
					if !collided.key?(cbk) then collided[cbk] = Array.new end # perhaps better as a set?
					collided[cbk].push(ck)
				end
			end
		end
		for cbk in collided.keys do
			cbk.handle_collision(collided[cbk]) # send handle_collision all the sprites which hit me
		end
	end
			
	def self::update(g) 
		raise ArgumentError, "bad group: #{g}" unless @@g.key?(g)
		for s in @@g[g] do
			s.update
		end
	end 

	def self::draw(g, surface) 
		raise ArgumentError, "bad group: #{g}" unless @@g.key?(g)
		for s in @@g[g].sort { |a,b| b.depth <=> a.depth} do
			s.draw(surface)
		end
	end 

	# add sprite to all its groups 
	def self::add(sprite)
		id = sprite.object_id
		@@s[id] = Set.new unless @@s.key?(id)
		for g in sprite.groups do
			raise ArgumentError, "bad group: #{g}" unless @@g.key?(g)
			raise ArgumentError, "cannot add sprite twice" if @@g[g].include?(sprite)
			@@g[g].push(sprite)
			@@s[id].add(g)
		end
		sprite.update() # ensures there is a surface ready to go
	end
	
	def self::kill(sprite)
		id = sprite.object_id
		raise ArgumentError, "cannot kill unregistered sprite #{sprite} id=#{id}" unless @@s.key?(id)
		for g in @@s[id] do
			@@g[g].delete_if {|s| s.object_id == id}
		end
		@@s.delete(id)
	end

	def self::kill_group(g)
		sprites(g).each {|s| kill(s)}
	end

	def self::groups(sprite)
		id = sprite.object_id
		raise ArgumentError, "unregistered sprite #{sprite} id=#{id}" unless @@s.key?(id)
		return @@s[id]
	end
	
	def self::sprites(g)
		raise ArgumentError, "bad group: #{$g}" unless @@g.key?(g)
		return @@g[g]
	end
	
	def self::ship
		return sprites(:ship)[0] # convenience method
	end
end
