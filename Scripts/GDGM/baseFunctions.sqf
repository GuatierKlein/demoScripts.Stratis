//functions
GDGM_fnc_civilian_life = compile preprocessFile "scripts\GDGM\civilian\civilian_life.sqf";
GDGM_fnc_civilian_trav = compile preprocessFile "scripts\GDGM\civilian\civilian_travellers.sqf";
GDGM_fnc_civilian_action_array = compile preprocessFile "scripts\GDGM\civilian\civilian_actions_array.sqf";
GDGM_fnc_civilian_panic = compile preprocessFile "scripts\GDGM\civilian\civilian_panic.sqf";
GDGM_fnc_civilian_ambience = compile preprocessFile "scripts\GDGM\civilian\civilian_ambience.sqf";
GDGM_fnc_civilian_delete = compile preprocessFile "scripts\GDGM\civilian\delete_civ.sqf";
GDGM_fnc_civilian_delete_trav = compile preprocessFile "scripts\GDGM\civilian\delete_civ_trav.sqf";
GDGM_fnc_civilian_walk_loop = compile preprocessFile "scripts\GDGM\civilian\civilian_walk_loop.sqf";
GDGM_fnc_civilian_car_traffic = compile preprocessFile "scripts\GDGM\civilian\civilian_traffic.sqf";
GDGM_fnc_civilian_car_traffic_relaunch = compile preprocessFile "scripts\GDGM\civilian\civilian_traffic_relaunch.sqf";
GDGM_fnc_civilian_speak = compile preprocessFile "scripts\GDGM\civilian\speak.sqf";

GDGM_invisibleLoc = {
    params ["_pos","_loc_name","_stab","_symp","_marker","_hqArray","_ammoArray","_garriArray"];

	if (isNil "_pos") exitwith {systemChat "Invalid pos"};

	_new_location = locationNull;
    _test_logic = createAgent ["logic", _locationPos, [], 0, "form"];
	//test si min house
    _house_list = nearestobjects [_test_logic, ["house"], 500];
    deletevehicle _test_logic;

    

        if (!(_locationPos inArea "blacklist_marker") && count _house_list >= _minimum_house) then {          

			//size
			_size = 0;
			_house_list = nearestObjects [_locationPos,allowed_house, 500];
			if(count _house_list < GDGM_smallTownMaxSize) then {
				_size = 1;
			} else {
				if(count _house_list < GDGM_bigTownMinSize) then {
					_size = 2;
				} else {
					_size = 3;
				};
			};
            
			//creer obj
            _new_location = createLocation ["invisible", _locationPos, 300, 300];

            _new_location setVariable ["gdgm_markername", _marker ];
            _new_location setVariable ["gdgm_local_name", _loc_name ];
            _new_location setVariable ["gdgm_civilian_array", [] ];
            _new_location setVariable ["gdgm_spawned_units", [] ];
            _new_location setVariable ["gdgm_spawned_travelers", [] ];
            _new_location setVariable ["gdgm_spawned_vehicles", [] ];
            _new_location setVariable ["gdgm_has_IED", false ];
            _new_location setVariable ["gdgm_civ_spawned", false ];
            _new_location setVariable ["gdgm_civtrav_spawned", false ];
			_new_location setVariable ["gdgm_size", _size ];
        
           
			// trigger civilian
			
			_trg_civ = createTrigger ["EmptyDetector", _locationPos];
			_trg_civ settriggerArea [GDGM_spawn_distance_civ, GDGM_spawn_distance_civ, 0, false, 175];
			_trg_civ settriggerActivation ["ANYplayer", "PRESENT", true];
			_trg_civ settriggerStatements ["this", "if (isServer) then {
				[getPos thistrigger] spawn GDGM_fnc_civilian_life
			};
			", "if (isServer) then {
				[getPos thistrigger] spawn GDGM_fnc_civilian_delete;
				[getPos thistrigger] spawn GDGM_fnc_civilian_car_traffic_relaunch;
			};
			"];
			_trg_civ settriggerInterval 5;
			_trg_civ settriggerTimeout [4, 4, 4, false];
			
			// trg travellers
			
			_trg_civ_trav = createTrigger ["EmptyDetector", _locationPos];
			_trg_civ_trav settriggerArea [GDGM_spawn_distance + 500, GDGM_spawn_distance + 500, 0, false, 175];
			_trg_civ_trav settriggerActivation ["ANYplayer", "PRESENT", true];
			_trg_civ_trav settriggerStatements ["this", "if (isServer) then {
				null = [getPos thistrigger] spawn GDGM_fnc_civilian_trav
			};
			", "if (isServer) then {
				[getPos thistrigger] spawn GDGM_fnc_civilian_delete_trav
			};
			"];
			_trg_civ_trav settriggerInterval 5;
			_trg_civ_trav settriggerTimeout [4, 4, 4, false];

		};
	//("Created location " + _loc_name + " at " + str _pos) remoteExec ["systemChat",0];
	_new_location;
};

