#include "GDGM_settings.sqf";
#include "baseFunctions.sqf";
#include "data\voices_ressource.sqf";
#include "data\houses.sqf";
#include "data\dialog_ressource.sqf";

if !(isServer) exitwith {};	

//create marker named AO_center and safe_zone_marker (area marker) to prevent enemies from spawning in your base, also a marker called huma_crate_spawn where the food crates will spawn
//draw an area marker named AO_area where you want bad guys to spawn, needs to be over simulated cities
//do not modify what is below unless you know what you are doing


if (isClass(configFile >> "CfgPatches" >> "16aa_immersion_c")) then {
	GDGM_ambience_sounds_activate = true;
} else {
	GDGM_ambience_sounds_activate = false; 
};

_j= 0 ;
_location_spawn_count = 0;
_location_camp_count = 0;
GDGM_nonrandom_civ = false;
created_loc_array = []; 
_nb_of_created_loc = 0;
_use_custom_marker = true;

AO_loc_array = [];
occupied_loc_array = [];
_minimum_house = 2;


	
unit_civ1 = "C_man_1";
unit_civ_veh_moving_array = [
	"C_SUV_01_F",
	"C_offroad_01_F",
	"C_hatchback_01_F"
];
unit_civ_veh_array = unit_civ_veh_moving_array;

//custom location
_temp_village_array = [];

if (_use_custom_marker) then {
	//place a village game logic and the script will use it as a custom location 	
	_additional_loc = nearestObjects [getMarkerPos "AO_center", ["LocationVillage_F"], _OP_radius];

	if (count _additional_loc != 0) then {
		{
			_new_location = createLocation ["NameCity", _x, 300, 300]; 
			_temp_village_array pushBack _new_location;
		} foreach _additional_loc;
	};
};

nearbyLocations = [];

if (_use_automatic_village_detect) then {
	nearbyLocations = nearestLocations [getMarkerPos "AO_center", ["NameCity","NameVillage","NameCityCapital"], _OP_radius]; 
} else {
	nearbyLocations = _temp_village_array;
};
//you can use "CityCenter" on A2 maps like Takistan, it has better positions, just test what works best on your map
//you can remove "NameVillage" if your map has a weird location layout

{
	//create
	_locationPos = locationPosition _x;		
	_new_location = [_locationPos,text _x] call GDGM_invisibleLoc;

	if!(_new_location isEqualTo locationNull) then {
		created_loc_array pushBack _new_location;
	};
} foreach nearbyLocations;






