//spawn car traffic
params ["_nearest_loc","_nearbyLocations2","_road_list_copy"];

sleep 5;

if ((count _nearbyLocations2 > 1 && daytime > 5) && !(_nearest_loc getVariable "GDGM_civ_spawned") && count _road_list_copy != 0) then {	
	while {!(_nearest_loc getVariable "GDGM_civ_spawned") && (_nearest_loc getVariable "GDGM_civtrav_spawned")} do {			
		
		sleep (random 10);	

		//spawn pos
		private _road_segment = selectRandom _road_list_copy;
		private _info = getRoadInfo _road_segment;
		private _dir = (_info select 6) getDir (_info select 7);

		//destination 
		_nearbyloc_index = [1,count _nearbyLocations2 - 1] call BIS_fnc_randomInt; 
		_next_loc = _nearbyLocations2 select _nearbyloc_index;
		_next_loc_pos = locationPosition _next_loc;	
		_road_list2 = [_next_loc_pos select 0,_next_loc_pos select 1] nearRoads 150;

		if (count _road_list2 == 0) exitwith {};

		_veh = createVehicle [selectRandom unit_civ_veh_moving_array, getPos _road_segment, [], 0, "NONE"];
		_veh setDir _dir;
		_veh setPos getPos _veh;
		_vehSpots = count(fullCrew [_veh, "", true]);

		_unit = createAgent [unit_civ1, getPos _road_segment, [], 0, "NONE"];
		[[_unit]] spawn GDGM_fnc_civilian_action_array;
		_unit moveInDriver _veh;
		_unit setBehaviour "CARELESS";
		_unit forceSpeed 11.5;
		_unit setDestination [getPos (selectRandom _road_list2), "LEADER PLANNED", true];

		for [{_i = 1}, {_i < _vehSpots}, {_i = _i + 1}] do {
			_unit = createAgent [unit_civ1, getPos _road_segment, [], 0, "NONE"];
			[[_unit]] spawn GDGM_fnc_civilian_action_array;
			_unit moveInAny _veh;
			_unit setBehaviour "CARELESS";
		};

		//action stop
		[_veh,
			["<t color='#DF0303'>STOP VEHICLE</t>",	
				{	
					params ["_target", "_caller", "_actionId", "_arguments"];				
					//_target forceSpeed 0;
					[_target, 0] remoteExec ["forceSpeed",2];
					_caller playActionNow "gestureFreeze";
				},
				nil,		// arguments
				6,		// priority
				true,		// showWindow
				true,		// hideOnUse
				"",			// shortcut
				"alive _target", 	// condition
				30,			// radius
				false,		// unconscious
				"",			// selection
				""			// memoryPoint
		]] remoteExec ["addAction",0,true];

		//action go
		[_veh,
			["<t color='#00FF00'>GO</t>",	
				{	
					params ["_target", "_caller", "_actionId", "_arguments"];				
					//_target forceSpeed 11.5;
					[_target, 11.5] remoteExec ["forceSpeed",2];
					_caller playActionNow "gestureGo";
				},
				nil,		// arguments
				6,		// priority
				true,		// showWindow
				true,		// hideOnUse
				"",			// shortcut
				"alive _target", 	// condition
				30,			// radius
				false,		// unconscious
				"",			// selection
				""			// memoryPoint
		]] remoteExec ["addAction",0,true];
		
		//action get out
		[_veh,
			["<t color='#DF0303'>GET OUT</t>",	
				{	
					params ["_target", "_caller", "_actionId", "_arguments"];				
					_caller playActionNow "gestureFollow";
					_driver = driver _target;			
					_driver action ["getOut", _target];
					_driver doMove (position _driver);
				},
				nil,		// arguments
				6,		// priority
				true,		// showWindow
				true,		// hideOnUse
				"",			// shortcut
				"alive _target", 	// condition
				5,			// radius
				false,		// unconscious
				"",			// selection
				""			// memoryPoint
		]] remoteExec ["addAction",0,true];
		/*
		//search
		[
			_veh,											// Object the action is attached to
			"<t color='#00FF00'>Search Vehicle</t>",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 3 && speed _target < 1",						// Condition for the action to be shown
			"_caller distance _target < 3 && speed _target < 1",						// Condition for the action to progress
			{},  // Code executed when action starts
			{},													// Code executed on every progress tick
			{ 
				params ["_target", "_caller", "_actionId", "_arguments"];				
				[_target,clientOwner,_caller] execVM "scripts\civilian\vehicle_search.sqf";					
			},				
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			5,													// Action duration [s]
			0,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state
		] remoteExec ["BIS_fnc_holdActionAdd", 0, true];	// MP compatible implementation
		*/

		waitUntil { sleep 4; moveToCompleted _unit || moveToFailed _unit || !(_nearest_loc getVariable "GDGM_civtrav_spawned") || !alive _veh};
		if (alive _veh) then {
			{_veh deleteVehicleCrew _x } forEach crew _veh;
		};
		deleteVehicle _veh;		
	};
};