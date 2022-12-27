if (IsServer) then {
	params ["_unit"];
	_house_list = [];
	_house_pos_all = [];
	_house_pos = [];

	_unit setVariable ["gdgm_haspanic", true ];	

	if (other_map_houses) then {
		_house_list = _unit nearObjects ["House", 40];
	} else {
		_house_list = nearestObjects [_unit,allowed_house, 40];
	};

	if (count _house_list != 0) then {
		_house = selectRandom _house_list;
		_house_pos_all = _house buildingPos -1;
		
		if (count _house_pos_all != 0) then {
			_house_pos = selectRandom _house_pos_all;
		} else {
			_house_pos = getPos _house;
		};

		_unit moveTo _house_pos;
		_unit forceSpeed (_unit getSpeed "FAST");
	} else {
		_unit disableAI "PATH";
		_unit setUnitPos "DOWN";
	};	
};