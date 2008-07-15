
class Bda

	@@h = Hash.new

	def self::do(bda_name, obj, while_true, do_before, do_during, do_after )
		obj_key = obj.object_id
		if !@@h.key?(obj_key) then
			@@h[obj_key] = Hash.new
		end
		if !@@h[obj_key].key?(bda_name) then
			@@h[obj_key][bda_name] = while_true
			do_before.call(obj)
		end
		while_true_result = @@h[obj_key][bda_name].call(obj)
		if while_true_result then
			do_during.call(obj)
		else
			do_after.call(obj)
			@@h[obj_key].delete(bda_name)
		end
	end

	def self::kill(obj)
		obj_key = obj.object_id
		@@h.delete(obj_key)
	end

end
