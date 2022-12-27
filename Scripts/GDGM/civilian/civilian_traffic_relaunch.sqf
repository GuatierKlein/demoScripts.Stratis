params ["_pos"];

_nearest_loc = nearestLocation [_pos, "Invisible"];
_nearbyLocations2 = nearestLocations [_pos, ["Invisible"], 3500];

_pos_logic_veh = createAgent ["Logic", _pos, [], 0, "FORM"]; 
_road_list_copy = _pos_logic_veh nearRoads 150;
deleteVehicle _pos_logic_veh;

if (GDGM_car_traffic) then {
	for [{_i = 0}, {_i < random GDGM_traffic_coef}, {_i = _i + 1}] do {
		[_nearest_loc,_nearbyLocations2,_road_list_copy] spawn GDGM_fnc_civilian_car_traffic;
	};
};