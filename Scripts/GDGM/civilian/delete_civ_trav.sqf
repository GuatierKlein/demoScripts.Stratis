//run with null = [_pos] execVM "scripts\delete_civ_trav.sqf";

	
params ["_pos"];
_nearest_loc = nearestLocation [_pos, "Invisible"];
_nearest_loc setVariable ["gdgm_civtrav_spawned", false ];

sleep 15; //security in case of early spawn

_civ_array = _nearest_loc getVariable "gdgm_spawned_travelers"; 

{
	deleteVehicle _x;
	sleep 0.1;
} foreach _civ_array;



