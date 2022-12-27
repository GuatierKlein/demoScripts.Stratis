params ["_pos","_loc","_symp"];

_house_list = nearestObjects [_pos,allowed_house, 125];
_unit = objNull;
_temp_array = [];

{
	_house_pos = getPosATL _x;
	_unit = createAgent [unit_civ1, _house_pos, [], 0, "NONE"];

	_temp_array pushback _unit;		
	_unit setPosATL _house_pos;

	_unit disableAI "FSM";
	_unit setBehaviour "CARELESS";
	_unit forceSpeed (_unit getSpeed "SLOW");	

	_unit setDestination [_pos getPos [(4 + random 2),random 360], "LEADER PLANNED", true];

	sleep 1;
} foreach _house_list;

[_temp_array,_symp] spawn GDGM_fnc_civilian_action_array;

_civ_array = _loc getVariable "gdgm_civilian_array";
_loc setVariable ["gdgm_civilian_array", _civ_array + _temp_array];		

while {_loc getVariable "gdgm_civ_spawned"} do {
	[selectRandom _temp_array] spawn GDGM_fnc_civilian_speak;
	sleep 5;
};