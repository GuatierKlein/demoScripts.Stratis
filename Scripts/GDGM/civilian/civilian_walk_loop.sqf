params ["_civ_array","_house_list","_loc"];
_house = objNull;
_all_pos = [];

while {_loc getVariable "GDGM_civ_spawned"} do {

	private _index = _civ_array findIf {(moveToCompleted _x || moveToFailed _x) && !(_x getVariable "gdgm_haspanic")};
	if (_index != -1) then {
		while {count _all_pos == 0} do {
			_house = selectrandom _house_list;
			_all_pos = _house buildingPos -1;		
		};
		(_civ_array select _index) setDestination [(selectrandom _all_pos), "LEADER PLANNED", true];
		_all_pos = [];
	};
	sleep 2;
};
