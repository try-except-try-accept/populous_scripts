
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

function find_random_land_pos_c2d()
    local c2d = Coord2D.new()
    c2d.Xpos = G_RANDOM(65535)
    c2d.Zpos = G_RANDOM(65535)
    log("Generated random pos which is" .. tostring(c2d.Xpos) .. ", " .. tostring(c2d.Zpos))
    return c2d
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

function TribeData:build_tower(place)
	log("ran the build tower function")	
	c3d = MAP_XZ_2_WORLD_XYZ(place.Xpos, place.Zpos)	
	createThing(T_BUILDING, M_BUILDING_DRUM_TOWER, self.tribe_code, c3d, false, false)
	log("made a tower")
	--BUILD_DRUM_TOWER(self.tribe_code, place.Xpos, place.Zpos)		
	self:get_tower_info()
	table.insert(self.towers, place)  -- record location tower was built.
	self:get_tower_info()
	log("Built a tower for tribe" .. tostring(self.tribe_code))		
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
		log("Currently looking at " .. tribe_code)	
		tribe:get_tower_info()
		
		if tribe:get_num_towers() < 10 then
		
			place = find_random_land_pos_c2d()			
			
			if is_map_point_land(place) then
				tribe:build_tower(place)							
				
			end
		end
	
	end

	


end