

params ["_pos_loc"];
_gdgm_daytime = daytime;
		
_nearest_loc = nearestLocation [_pos_loc, "Invisible"];
_nearbyLocations = nearestLocations [_pos_loc, ["Invisible"], 2000];
_nearbyLocations2 = nearestLocations [_pos_loc, ["Invisible"], 3500];
_do_we_spawn = _nearest_loc getVariable "gdgm_is_occupied";
_loc_symp = _nearest_loc getVariable "gdgm_local_sympathy";
_road_list = [];
_road_list_copy = [];

_temp_array_civ = [];
_temp_array = [];
_next_loc_pos = [0,0,0];

//sheperd
if (spawn_animals) then  {
	[_pos_loc,_nearest_loc] execVM "scripts\civilian\civilian_sheperd.sqf";
};

//spawn vehicle				
	
if (spawn_cars_on_roads == true) then {	
	_pos_logic_veh = createAgent ["Logic", _pos_loc, [], 0, "FORM"]; 
	_road_list = _pos_logic_veh nearRoads 150;
	_road_list_copy = _road_list;
	if (count _road_list != 0) then {
		_random_nb_cars = [1 ,5] call BIS_fnc_randomInt; //random nb of cars on roadside
		
		for [ { private _j = 0 } , { _j < _random_nb_cars } , { _j = _j + 1 } ] do {	
			
			_road_segment = selectRandom _road_list;
			_car_spawn_pos = getPos _road_segment;					
			
			if (debug) then {
				_marker_car = "Marker_car" + (str _car_spawn_pos);
				_marker_car_object = createMarker [_marker_car, _car_spawn_pos];
				_marker_car setMarkerType "hd_warning"; //type marker	drapeau
				_marker_car setMarkerColor "ColorOrange"; 
			};

			private _info = getRoadInfo _road_segment;
			private _dir = (_info select 6) getDir (_info select 7);
			
			//decaler pos											
			_block_logic_road = createAgent ["Logic", _car_spawn_pos, [], 0, "FORM"]; 
			_road_side = selectRandom [90,-90];
			_car_spawn_pos = _block_logic_road getRelPos [2.3, _dir + _road_side];
			deleteVehicle _block_logic_road;
			
			_veh = createVehicle [selectRandom unit_civ_veh_array, _car_spawn_pos, [], 0, "NONE"];	
			_veh setDir _dir;
			_veh setPos getPos _veh;

			_temp_array pushBack _veh;

			_road_list = _road_list - [_road_segment];
		};	
	};
	deleteVehicle _pos_logic_veh;	
};	
//spawn barricade

if (enable_barricade && _loc_symp < 120 && (random 120) > _loc_symp && count _road_list != 0) then {
	_nb_of_barricade = random [1,2,4];
	for [{_i = 0}, {_i < _nb_of_barricade}, {_i = _i + 1}] do {
		[selectrandom _road_list,_nearest_loc,_loc_symp,_do_we_spawn] execVM "scripts\civilian\barricade.sqf";
	};			
};		

//spawn civil

if (count _nearbyLocations > 1 && _gdgm_daytime > 6 && _gdgm_daytime < 23) then {			

	//_nb_of_traveling_civs_group = [1, count _nearbyLocations] call BIS_fnc_randomInt; 

	//for [ { private _y = 1 } , { _y <= _nb_of_traveling_civs_group} , { _y = _y + 1 } ] do {

		_nb_of_traveling_civs = [1,2] call BIS_fnc_randomInt; 			
		_newGrp = createGroup [civilian,true]; 	

		_pos_safe = [ //position du spawn
			_pos_loc, 
			0, //min dist
			30, //max dist
			3, //object dist
			0, //water mode 0=no water
			0.8, //max grad between 0 and 1
			0, 
			[], 
			[_pos_loc, _pos_loc]] call BIS_fnc_findSafePos;

		for [ { private _i = 1 } , { _i <= _nb_of_traveling_civs} , { _i = _i + 1 } ] do {
			sleep 0.1;
			_unit = _newGrp createUnit [unit_civ1,  _pos_safe, [], 0, "FORM"];
			/////////////////////////////////
			_temp_array_civ pushBack _unit;
			/////////////////////////////////
			_unit disableAI "FSM";	
			_unit disableAI "CHECKVISIBLE";	
			_unit disableAI "WEAPONAIM";	
			_unit disableAI "TARGET";	
			_unit disableAI "AUTOTARGET";
			sleep (GDGM_AdditionalUnitCreationDelay);
		};	

		_nearbyloc_index = [1,count _nearbyLocations - 1] call BIS_fnc_randomInt; 
		_next_loc = _nearbyLocations select _nearbyloc_index;
		_next_loc_pos = locationPosition _next_loc;	

		_pos_next_safe = [ //position du spawn
		_next_loc_pos, 
		0, //min dist
		30, //max dist
		2, //object dist
		0, //water mode 0=no water
		0.8, //max grad between 0 and 1
		0, 
		[], 
		[_next_loc_pos, _next_loc_pos]] call BIS_fnc_findSafePos;					
		
		_wp1 = _newGrp addWaypoint [_pos_safe, 0];    
		_wp1 setWaypointType "Move";
		_wp1 setWaypointBehaviour "CARELESS";
		_wp1 setwaypointcombatmode "RED"; 
		_wp1 setWaypointSpeed "LIMITED"; 		
		
		_wp2 = _newGrp addWaypoint [_pos_next_safe, 20];
		_wp2 setWaypointType "Move";
		_wp2 setWaypointBehaviour "CARELESS";
		_wp2 setwaypointcombatmode "RED"; 
		_wp2 setWaypointSpeed "LIMITED"; 
		
		_wp3 = _newGrp addWaypoint [_pos_safe, 20];
		_wp3 setWaypointType "cycle";
		_wp3 setWaypointBehaviour "CARELESS";
		_wp3 setwaypointcombatmode "RED"; 
		_wp3 setWaypointSpeed "LIMITED"; 				
		//};
} else {
	if (debug) then {
		[west, "HQ"] sideChat "traveling civs : no other close locations";
	};
};

//interface and stuff
[_temp_array_civ] spawn GDGM_fnc_civilian_action_array;

//soldier spawn
/*
if (_do_we_spawn && count created_pos_camp != 0) then {		
		
	sleep 1;
	_nb_of_traveling_civs = [2,6] call BIS_fnc_randomInt; 			
	_newGrp = createGroup [gdgm_side,true]; 	

	_pos_safe = [ //position du spawn
		_pos_loc, 
		0, //min dist
		30, //max dist
		3, //object dist
		0, //water mode 0=no water
		0.8, //max grad between 0 and 1
		0, 
		[], 
		[_pos_loc, _pos_loc]] call BIS_fnc_findSafePos;

		_unit = objNull;

	for [ { private _i = 1 } , { _i <= _nb_of_traveling_civs} , { _i = _i + 1 } ] do {
		sleep 1;
		switch (_i) do {
			case 1: { _unit = _newGrp createUnit [unit_NCO,  _pos_safe, [], 0, "FORM"] };
			case 5: { _unit = _newGrp createUnit [selectRandom [unit_MG,unit_AT],  _pos_safe, [], 0, "FORM"] };
			case 6: { _unit = _newGrp createUnit [unit_grenadier,  _pos_safe, [], 0, "FORM"] };				
			default { _unit = _newGrp createUnit [unit_rifleman,  _pos_safe, [], 0, "FORM"]; };
		};	
		/////////////////////////////////
		_temp_array pushBack _unit;
		/////////////////////////////////
	};	
	//closest camp pos
	_dist = 0;
	_camp_pos = [0,0,0];

	while {_dist < 200} do {
		_camp_pos = selectrandom created_pos_camp;		
		_dist = _camp_pos distance _pos_safe;
	};
																
	sleep 0.1;
	
	_wp1 = _newGrp addWaypoint [_pos_safe, 0];    
	_wp1 setWaypointType "Move";
	_wp1 setWaypointBehaviour "SAFE";
	_wp1 setwaypointcombatmode "RED"; 
	_wp1 setWaypointSpeed "LIMITED"; 
	
	sleep 0.1;
	
	_wp2 = _newGrp addWaypoint [_camp_pos, 10];
	_wp2 setWaypointType "Move";
	_wp2 setWaypointBehaviour "SAFE";
	_wp2 setwaypointcombatmode "RED"; 
	_wp2 setWaypointSpeed "LIMITED"; 
	
	sleep 0.1;
	
	_wp3 = _newGrp addWaypoint [_pos_safe, 20];
	_wp3 setWaypointType "cycle";
	_wp3 setWaypointBehaviour "SAFE";
	_wp3 setwaypointcombatmode "RED"; 
	_wp3 setWaypointSpeed "LIMITED"; 				
					
};	
*/

_spawned_suff = _nearest_loc getVariable "gdgm_spawned_travelers";
_nearest_loc setVariable ["gdgm_spawned_travelers", _spawned_suff + _temp_array + _temp_array_civ];	

_nearest_loc setVariable ["gdgm_civtrav_spawned", true ];

//spawn car traffic

if (GDGM_car_traffic) then {
	for [{_i = 0}, {_i < random GDGM_traffic_coef}, {_i = _i + 1}] do {
		[_nearest_loc,_nearbyLocations2,_road_list_copy] spawn GDGM_fnc_civilian_car_traffic;
	};
};



