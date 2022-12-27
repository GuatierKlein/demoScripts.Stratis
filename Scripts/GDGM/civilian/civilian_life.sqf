//civilian_life.sqf

//code to run on trigger to check nearest location
/*
_nearest_loc = nearestLocation [getPos player, "Invisible"];
_test_symp = _nearest_loc getVariable "gdgm_local_sympathy";
_test_symp = str _test_symp; 
_name_loc = _nearest_loc getVariable "gdgm_local_name"; 
_message_coords = "Name, sympathy : " + _test_symp + " " + _name_loc; 
[west, "HQ"] sideChat _message_coords;
*/

//debut
if (isServer) then {
	params ["_pos"];
	_house_list = [];
	_nb_of_civs = 0;
	_spawn_terrorist = false;
	_village_size = 0;
	_unit = objNull;
	_house = objNull;
	_house_pos_all = [];

	_pos_logic_civ = createAgent ["Logic", _pos, [], 0, "FORM"]; 
	
	_nearest_loc = nearestLocation [_pos, "Invisible"];
	_nearest_loc setVariable ["gdgm_civilian_array", [] ];	

	_temp_array = [];
	_temp_array_units = [];

	//type de batiments
	if (other_map_houses) then {
		_house_list = _pos_logic_civ nearObjects ["House", 300];
	} else {
		_house_list = nearestObjects [_pos_logic_civ,allowed_house, 300];
	};

	//ambience 
	if (daytime > 7 && daytime < 22) then {
		[_pos,_nearest_loc,_house_list,100] spawn GDGM_fnc_civilian_ambience;
	};

	if (daytime > 7 && daytime < 22) then {
		//determination de nombre de spawn
		if (count _house_list > 50) then {
			if (count _house_list > 75) then {
				_nb_of_civs = 35;
				//_village_size = 4;
			} else {
				_nb_of_civs = 25; 
				//_village_size = 3;
			};
			
		} else {
			if (count _house_list > 10) then {
				_nb_of_civs = 15; 
				//_village_size = 2;
			} else {
				_nb_of_civs = count _house_list; 
				//_village_size = 1;
			};			
		};
	};

	//goat if small village
	if (count _house_list < 20 && spawn_animals) then {
		_is_goat = [0,1] call BIS_fnc_randomInt; 
		_goat_array = [];
		if (_is_goat == 1) then {
			_pos_safe = [ //position du spawn
				_pos, //trouver une pos sure
				0, //min dist
				200, //max dist
				3, //object dist
				0, //water mode 0=no water
				0.7, //max grad between 0 and 1
				0, 
				[], 
				[_pos, _pos]] call BIS_fnc_findSafePos;
			for [{_i = 0}, {_i < 10}, {_i = _i + 1}] do {	
				sleep 0.1;			
				_animal = createAgent [selectRandom ["Goat_random_F","Sheep_random_F"], _pos_safe, [], 0, "FORM"];
				_goat_array pushBack _animal;
			};
			_civ_array = _nearest_loc getVariable "gdgm_civilian_array";
			_nearest_loc setVariable ["gdgm_civilian_array", _civ_array + _goat_array ];		
		};
	};	

	//spawn des unités
	for [ { private _i = 1 } , { _i <= _nb_of_civs} , { _i = _i + 1 } ] do {
		
		_house_pos_all = [];

		while {count _house_pos_all == 0} do {
			_house = selectrandom _house_list;
			_house_pos_all = _house buildingPos -1;
		};
		
		_house_pos = selectRandom _house_pos_all;

		_unit = createAgent [unit_civ1, _house_pos, [], 0, "NONE"];

		_temp_array_units pushback _unit;	
		
		_unit setPosATL _house_pos;

		_unit disableAI "FSM";
		_unit setBehaviour "CARELESS";
		_unit forceSpeed (_unit getSpeed "SLOW");	

		while {count _house_pos_all == 0} do {
			_house = selectrandom _house_list;
			_house_pos_all = _house buildingPos -1;
		};

		_house_pos = selectRandom _house_pos_all;	
		_unit setDestination [_house_pos, "LEADER PLANNED", true];
		_house_pos_all = [];

		sleep (0.1);
	};
	deleteVehicle _pos_logic_civ;
	
	_nearest_loc setVariable ["gdgm_civ_spawned", true ];
	[_temp_array_units,100] spawn GDGM_fnc_civilian_action_array;
	[_temp_array_units,_house_list,_nearest_loc] spawn GDGM_fnc_civilian_walk_loop;
	
	_civ_array = _nearest_loc getVariable "gdgm_civilian_array";
	_nearest_loc setVariable ["gdgm_civilian_array", _civ_array + _temp_array + _temp_array_units];		
};


