
import(Module_System)
import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_Math)
include("UtilPThings.lua")
include("UtilRefs.lua")

ALLOWED_DISTANCE = 10000

function find_random_land_pos_c2d()
    local c2d = Coord2D.new()
    c2d.Xpos = G_RANDOM(65535)
    c2d.Zpos = G_RANDOM(65535)
    log("Generated random pos which is" .. tostring(c2d.Xpos) .. ", " .. tostring(c2d.Zpos))
    return c2d
end



function confirm_ok_distance(location, other_things)
	for i, thing in ipairs(other_things) do
		log("Checking" .. tostring(location.Xpos) .. ", " .. tostring(location.Zpos) .. " vs. " .. thing.Xpos .. ", " .. thing.Zpos)
		if location.Xpos < thing.Xpos + ALLOWED_DISTANCE and location.Xpos > thing.Xpos - ALLOWED_DISTANCE then
			if location.Zpos < thing.Zpos + ALLOWED_DISTANCE and location.Zpos > thing.Zpos - ALLOWED_DISTANCE then
				log("Clash")
				return false
			end
		end
	
	end
	return true
end

function search_area(location, other_thing_type, other_thing_model)
	log("running function")
	
	local map_index = world_coord2d_to_map_idx(location)
	
	local location_valid = true
	
	SearchMapCellsXZ(CIRCULAR, 0, 0, ALLOWED_DISTANCE, map_index, function(me)
		me.MapWhoList:processList(function(t)
			if t.Type == other_thing_type and t.Model == other_thing_model then
				log("Too close to other towers.")
				location_valid = false
				return false
			else
				return true
			end
		end)
		if location_valid then
			return true
		else
			return false
		end
	end)
	
	if location_valid then log("Location was valid") end
	
	return location_valid
end

log("loaded   find_random_land_pos_c2d()")

function get_length(tbl)
	local total  = 0
	for v in pairs(tbl) do
		total = total + 1	
	end
	return total
end


TribeData = {tribe_code = nil}

function TribeData:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function TribeData:get_tower_info()	
	log("I am tribe " .. tostring(self.tribe_code) .. " and i have " .. self:get_num_towers() .. " towers")
end

function TribeData:get_num_towers()
	return get_length(self.towers)
end

function TribeData:get_tribe_code()
	return tostring(self.tribe_code)
end

function TribeData:build_tower()
	log("ran the build tower function")	
	place = find_random_land_pos_c2d()			
			
	while not is_map_point_land(place) do
		place = find_random_land_pos_c2d()			
	end		
	
	if confirm_ok_distance(place, self.towers) then
	
		c3d = MAP_XZ_2_WORLD_XYZ(place.Xpos, place.Zpos)	
		createThing(T_BUILDING, M_BUILDING_DRUM_TOWER, self.tribe_code, c3d, false, false)
		log("made a tower")
		--BUILD_DRUM_TOWER(self.tribe_code, place.Xpos, place.Zpos)		
		self:get_tower_info()
		table.insert(self.towers, place)  -- record location tower was built.
		self:get_tower_info()
		log("Built a tower for tribe" .. tostring(self.tribe_code))		
	
	end
end

log("Defined TribeData class")

enemies = {}

enemies[TRIBE_RED] = TribeData:new{tribe_code = TRIBE_RED, towers = {}}   -- this is the correct syntax for instantation params
enemies[TRIBE_YELLOW] = TribeData:new{tribe_code = TRIBE_YELLOW, towers = {}}
enemies[TRIBE_GREEN] = TribeData:new{tribe_code = TRIBE_GREEN, towers = {}}

log("instantiated enemy tribe data")


function OnTurn()

	-- iterate through each enemy tribe
	
	-- lay ten random guard tower plans
	
	for tribe_code, tribe in ipairs(enemies) do
		--log("Currently looking at " .. tribe_code)	
		--tribe:get_tower_info()
		
		if tribe:get_num_towers() < 10 then		
			
			tribe:build_tower()							
				
			
		end
	
	end

	


end