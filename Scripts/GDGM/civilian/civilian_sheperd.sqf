//activates with travellers
//serverside

_loc_pos = _this select 0;
_loc = _this select 1;

_logic = createAgent ["Logic", _loc_pos, [], 0, "FORM"];
_relpos = _logic getRelPos [random [200,600,1500], random 360];
deleteVehicle _logic;

//spawn sheperd 	
_unit = createAgent [unit_civ1, _relpos, [], 0, "NONE"];


/////////////////////////////////
_civ_array = _loc getVariable "gdgm_spawned_travelers";
_loc setVariable ["gdgm_spawned_travelers", _civ_array + [_unit]];
/////////////////////////////////
//interface and stuff 
[[_unit]] spawn GDGM_fnc_civilian_action_array;

//spawn dog
_relpos = _unit getRelPos [random [1,1.5,5], random 360];
_animal = createAgent [selectRandom ["Alsatian_Random_F","Fin_random_F"], _relpos, [], 0, "FORM"];
_animal disableAI "PATH";

//spawn animals
_nb_animals = random [5,7,12];
_type = [0,1] call BIS_fnc_randomInt; 
if (_type == 1) then {
	for [{_i = 0}, {_i < _nb_animals}, {_i = _i + 1}] do {
		_relpos = _unit getRelPos [random [3,5,10], random 360];
		_animal = createAgent ["Sheep_random_F", _relpos, [], 0, "FORM"];
		//_animal disableAI "PATH";
		_animal setVariable ["BIS_fnc_animalBehaviour_disable", true];
	};
} else {
	for [{_i = 0}, {_i < _nb_animals}, {_i = _i + 1}] do {
		_relpos = _unit getRelPos [random [3,5,10], random 360];
		_animal = createAgent ["Goat_random_F", _relpos, [], 0, "FORM"];
		//_animal disableAI "PATH";
		_animal setVariable ["BIS_fnc_animalBehaviour_disable", true];
	};
};


