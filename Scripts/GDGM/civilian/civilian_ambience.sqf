params ["_pos","_loc","_house_list","_loc_sympth"];

if(count _house_list == 0) exitwith {};

_house_list_copy = _house_list;
_obj = objNull;
_soundSource = objNull;
_temp_array = [];
_temp_array_units_amb = [];

//market
_market_obj_array = nearestObjects [_pos, [
	"Land_MarketShelter_F", 
	"Land_Market_stalls_02_EP1",
	"Land_Market_stalls_01_EP1",
	"Land_Market_shelter_EP1",
	"Land_ClothShelter_02_F",
	"Land_ClothShelter_01_F"], 400];

if (count _market_obj_array != 0) then {
	
	_obj = selectRandom _market_obj_array;

	if (GDGM_ambience_sounds_activate) then {
		_soundSource = createSoundSource ["Zeus_Sound_Desert_MarketplaceAmbience", getPos _obj, [], 0];

		//_obj setVariable ["gdgm_sound_trigger", _soundSource ];	

		_soundSource addEventHandler ["FiredNear", { //MARCHE PAS + A NETTOYER
			params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];		
				deleteVehicle _unit;	
		}];
	};

	_temp_array pushBack _soundSource;
};
//market pop 	
//_newGrp = createGroup [civilian,true]; 	
_speakingArray = [];
for [ { private _i = 1 } , { _i <= 5} , { _i = _i + 1 } ] do {
	sleep 1;
	_relpos = _obj getRelPos [random 5, random 360];
	_unit = createAgent [unit_civ1, _relpos, [], 0, "NONE"];
	_unit setDir random 360;
	_unit setPos getPos _unit;
	doStop _unit;
	//(group _unit) setBehaviour "CARELESS";
	
	_unit disableAI "FSM";
	_unit setBehaviour "CARELESS";	

	_temp_array_units_amb pushBack _unit;
	_speakingArray pushBack _unit;
};	


[_speakingArray,_loc] spawn {
	params["_speakingArray","_loc"];

	waitUntil { _loc getVariable "gdgm_civ_spawned"};

	while {_loc getVariable "gdgm_civ_spawned"} do {
		[selectRandom _speakingArray] spawn GDGM_fnc_civilian_speak;
		sleep 5;
	};
};

//house 
if (GDGM_ambience_sounds_activate) then {

	_nb_discussion = [0,1] call BIS_fnc_randomInt;

	if (_nb_discussion == 1) then {
		_house = selectRandom _house_list_copy;
		_soundSource = createSoundSource ["Zeus_Sound_Misc_Dog_BarkingDogFar", getPos _house, [], 0];
		_temp_array pushBack _soundSource;
	};
	
	for [{_i = 0}, {_i < random [0,count _house_list * 0.1,count _house_list * 0.2]}, {_i = _i + 1;}] do {
		_house = selectRandom _house_list_copy;
		_house_list_copy = _house_list_copy - [_house];
		
		switch (GDGM_ambience_sounds) do {
			case 0 : {
				
			};
			case 1 : { //middle east
				_soundSource = createSoundSource [selectRandom ["Zeus_Sound_Desert_Arab_Talking","Zeus_Sound_Desert_Arab_Talking","Zeus_Sound_Desert_Arab_Talking","Zeus_Sound_Desert_Arabic_Music_Radio"], getPos _house, [], 0];
				
			};
			case 2 : { //africa
				_soundSource = createSoundSource [selectRandom ["Zeus_Sound_Africa_CrowdTalk1","Zeus_Sound_Africa_CrowdTalk2","Zeus_Sound_Africa_CrowdTalk3"], getPos _house, [], 0];
			};
		};
		
		_temp_array pushBack _soundSource;
		sleep 0.1;
	};

};

//discussion

_nb_discussion = 0;
_house_list_copy = _house_list; 

if (count _house_list < 20) then {
	_nb_discussion = [0,2] call BIS_fnc_randomInt;
} else {
	_nb_discussion = [2,4] call BIS_fnc_randomInt;
};

for [{_y = 0}, {_y < _nb_discussion}, {_y = _y + 1}] do {

	_house = selectRandom _house_list_copy;

	_pos_safe = [ //position du spawn
		getPos _house, //trouver une pos sure
		0, //min dist
		30, //max dist
		5, //object dist
		0, //water mode 0=no water
		0.7, //max grad between 0 and 1
		0, 
		[], 
		[[0,0,0], [0,0,0]]] call BIS_fnc_findSafePos;

	//_newGrp = createGroup [civilian,true]; 	
	_logic = createAgent ["Logic", _pos_safe, [], 0, "FORM"];

	//marker debug
	if (debug) then {
		_marker_block = "Marker_block" + (str getPos _logic);
		_marker_block_object = createMarker [_marker_block, getPos _logic];
		_marker_block setMarkerType "hd_warning"; //type marker	drapeau
		_marker_block setMarkerColor "ColorGreen"; 
	};

	_nb_discussers = [2,4] call BIS_fnc_randomInt;

	//sounds 

	if (GDGM_ambience_sounds != 0 && GDGM_ambience_sounds_activate) then {
		switch (GDGM_ambience_sounds) do {
			case 1 : { //middle east
				_soundSource = createSoundSource ["Zeus_Sound_Desert_Arab_Talking", _pos_safe, [], 0];
			};
			case 2 : { //africa
				_soundSource = createSoundSource [selectRandom ["Zeus_Sound_Africa_CrowdTalk1","Zeus_Sound_Africa_CrowdTalk2","Zeus_Sound_Africa_CrowdTalk3"], _pos_safe, [], 0];
			};
		};
		_temp_array pushBack _soundSource;
	};
	
	//unit spawn
	_speakingArray = [];
	for [{_i = 0}, {_i < _nb_discussers}, {_i = _i + 1}] do {
		
		_relpos = _logic getRelPos [1.2, random 360];
		//_unit = _newGrp createUnit [unit_civ1, _relpos, [], 0, "NONE"];
		_unit = createAgent [unit_civ1, _relpos, [], 0, "NONE"];
		_unit lookAt (_pos_safe vectorAdd [0,0,1.5]);
		doStop _unit;

		_unit disableAI "FSM";
		_unit setBehaviour "CARELESS";

		_temp_array_units_amb pushBack _unit;
		_speakingArray pushBack _unit;
		
		if (_i == 0) then  {
			//EH to stop 
			_unit setVariable ["gdgm_sound_trigger", _soundSource ];	

			_unit addEventHandler ["FiredNear", {
				params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];		
				if (isServer) then {
					_trg = _unit getVariable "gdgm_sound_trigger";
					deleteVehicle _trg;
				};			
			}];
		};
		sleep (0.1);
	};	
	deleteVehicle _logic;
	[_speakingArray,_loc] spawn {
		params["_speakingArray","_loc"];

		waitUntil { _loc getVariable "gdgm_civ_spawned"};

		while {_loc getVariable "gdgm_civ_spawned"} do {
			[selectRandom _speakingArray] spawn GDGM_fnc_civilian_speak;
			sleep 5;
		};
	};
};

[_temp_array_units_amb,_loc_sympth] spawn GDGM_fnc_civilian_action_array;

_civ_array = _loc getVariable "gdgm_civilian_array";
_loc setVariable ["gdgm_civilian_array", _civ_array + _temp_array + _temp_array_units_amb];






