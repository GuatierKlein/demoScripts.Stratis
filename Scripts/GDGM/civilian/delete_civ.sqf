//run with null = [_pos] execVM "scripts\delete_civ.sqf";


	
params ["_pos"];


sleep 15; //security in case of early spawn

_nearest_loc = nearestLocation [_pos, "Invisible"];
_nearest_loc setVariable ["gdgm_civ_spawned", false ];

if (debug) then {
	hint "deleting civilians";
}; 

_civ_array = _nearest_loc getVariable "gdgm_civilian_array"; 

_count = count _civ_array;

for [ { private _i = 0 } , { _i < _count} , { _i = _i + 1 } ] do {
	deleteVehicle (_civ_array select _i);
	sleep 0.1;
};
_nearest_loc setVariable ["gdgm_civilian_array", [] ];		

