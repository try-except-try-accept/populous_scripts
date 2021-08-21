---------------------------
-- try-except-try-accept --
-- 08/09/2021 -------------
-- udontknowluadoya? ------
---------------------------

-- Import modules and include files
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

-- Constants
MAX_TOWER_SPACING = 10

-- Initiate the blue tribe
computer_init_player(_gsi.Players[TRIBE_BLUE])

-- Allow guard tower to be available on buildings panel?
PThing.BldgSet(TRIBE_BLUE, M_BUILDING_DRUM_TOWER, TRUE)

-- Allow 10 guard towers to be built at a time
WRITE_CP_ATTRIB(TRIBE_BLUE, ATTR_MAX_BUILDINGS_ON_GO, 10)

-- Must turn on building mode
STATE_SET(TRIBE_BLUE, TRUE, CP_AT_TYPE_CONSTRUCT_BUILDING)

function count_enemy_buildings(x,z,radius)
local count = 0;
local c3d = MAP_XZ_2_WORLD_XYZ(x,z)
SearchMapCells(CIRCULAR,0,0,radius,world_coord3d_to_map_idx(c3d),function(me)
me.MapWhoList:processList(function(t)
if (t.Type == T_BUILDING) then
if (t.Owner ~= TRIBE_ORANGE) then
count = count+1
end
end
return true
end)
return true
end)
return count
end



function OnTurn() 
	
	local shaman = getShaman(TRIBE_BLUE)	
	
	if (shaman ~= nil) then
		
		local c3d = shaman.Pos.D3			
		new_loc_2d.Pos = world_coord3d_to_map_idx(c3d);					
		local braves = get_nearest_n_things(c3d, 100, T_PERSON, TRIBE_BLUE, 10)		
		for i, dude in pair(braves) do
			log("Found a brave")
			log(type(dude))
		end
		
		-- Or.... spawning random tower plans
		--------------------------------------------------
			
		--createThing(T_BUILDING, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, new_loc_3d, false, false)
		--log("spawned a tower - this works!")
	
	end
end


function get_nearest_n_things(c3d, radius, thing_type, owner, n)
	
	local count = 0	
	local selection = {}
	log("init locals")
	
	for s = 1, radius, SCAN_INCREMENT
	do 	
		log("Looping. s is "... s)
		SearchMapCells(
			CIRCULAR, 0, 0, s, world_coord3d_to_map_idx(c3d),
			function(me)
				me.MapWhoList:processList(
				function(current_thing)
					log("current thing is")
					log(type(current_thing))
					
					if (current_thing.Type == thing_type) then
						if (current_thing.Owner ~= owner) then													
							log("Found something I'm looking for!")
							table.insert(selection, current_thing)
							count++
							if (count==n) then								
								return false
							end
							
						end
						return true -- keep  processList() loop running
					end					
				end)
				
				if (count==n) then								
					return false
				end
				return true -- keep  SearchMapCells() loop running
			end)
			
		log("Found" .. n .. "things in total")
		
		return selection
	end
end



