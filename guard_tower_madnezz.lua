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


function OnTurn() 
	
	local shaman = getShaman(TRIBE_BLUE)	
	
	if (shaman ~= nil) then
		
		local new_loc_3d = Coord3D.new()	
		log("3d coords obj")
		
		new_loc_3d.Xpos = shaman.Pos.D3.Xpos + G_RANDOM(10)
		new_loc_3d.Zpos = shaman.Pos.D3.Zpos + G_RANDOM(10)
		new_loc_3d.Ypos = shaman.Pos.D3.Ypos			
		
		log("3d coords set")
		
		local new_loc_2d = MapPosXZ.new();
		log("2d coords obj")
		new_loc_2d.Pos = world_coord3d_to_map_idx(new_loc_3d);
		
		log("3d to 2d converted")
		-- Laying random tower plans near the shaman
		BUILD_DRUM_TOWER(TRIBE_BLUE, new_loc_2d.XZ.X, new_loc_2d.XZ.Z);		

		log("laid tower plan - why can't i see?")		
		
		-- Or.... spawning random tower plans
		--------------------------------------------------
			
		--createThing(T_BUILDING, M_BUILDING_DRUM_TOWER, TRIBE_BLUE, new_loc_3d, false, false)
		--log("spawned a tower - this works!")
	
	end
end


