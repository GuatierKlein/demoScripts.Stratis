params ["_units","_local_symp"];

{
	_x setVariable ["gdgm_hastalked", false ];
	_x setVariable ["gdgm_haspanic", false ];
	_x setVariable ["gdgm_givenwater", false ];
	_x setVariable ["gdgm_shookhands", false ];

	//set speaker
	if(GDGM_civLanguage == "PER") then {
		_x setSpeaker selectRandom ["Male01PER","Male02PER","Male03PER"];
	};
	if(GDGM_civLanguage == "POL") then {
		_x setSpeaker selectRandom ["Male01POL","Male02POL","Male03POL"];
	};


	_x setBehaviour "CARELESS";
	//random civ 
	if (GDGM_nonrandom_civ) then {
		_x setUnitLoadout (getUnitLoadout(selectRandom unit_civ_array));
	};
	//shake hands 
	[_x, 
	[
		"Shake hands",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			[[getPos _target,_caller,_target],"scripts\civilian\civilian_shakehands.sqf"] remoteExecCall ["execVM",2];																

		},
		nil,		// arguments
		5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"alive _target", 	// condition
		3,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	]] remoteExec ["addAction",0,true];
	//action to give water
	[_x, 
	[
		"Give water",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			_items = items _caller;				
			/*
			if (debug == true) then {
				_msg = "Items : " + (str _items);
				// [west, "HQ"] sideChat _msg;  
			};
			*/
			if ("ACE_WaterBottle" in _items) then {					
				//execute if has water
				civ_water_pos = getPos _target;

				[[civ_water_pos,_caller,clientOwner,_target,1],"scripts\civilian\civilian_givewater.sqf"] remoteExecCall ["execVM",2];																
			} else {
				systemChat "You don't have water in your inventory!";  
			};
		},
		nil,		// arguments
		5,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"alive _target", 	// condition
		3,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	]] remoteExec ["addAction",0,true];

	//action to stop
	[_x, 
	[
		"<t color='#DF0303'>Stop civilian</t>",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			//_target remoteExec ["doStop",2];
			//[_target,_caller] remoteExec ["lookAt",2];
			[[_target,_caller],"scripts\civilian\civilian_stop.sqf"] remoteExecCall ["execVM",2];	
			_caller playActionNow "gestureFreeze";
		},
		nil,		// arguments
		7,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"alive _target", 	// condition
		10,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	]] remoteExec ["addAction",0,true];

	//action to get down
	[_x, 
	[
		"<t color='#DF0303'>Get down!</t>",	// title
		{
			params ["_target", "_caller", "_actionId", "_arguments"]; // script

			_target remoteExec ["doStop",2];
			[_target,"DOWN"] remoteExec ["setUnitPos",2];
			_caller playActionNow "gestureGo";
		},
		nil,		// arguments
		7,		// priority
		true,		// showWindow
		true,		// hideOnUse
		"",			// shortcut
		"alive _target", 	// condition
		10,			// radius
		false,		// unconscious
		"",			// selection
		""			// memoryPoint
	]] remoteExec ["addAction",0,true];

	if (use_give_cigarette) then {
		//action to give cigarette
		[_x, 
		[
			"Give cigarette",	// title
			{
				params ["_target", "_caller", "_actionId", "_arguments"]; // script

				_items = items _caller;				

				if ("murshun_cigs_cig0" in _items) then {					
					civ_water_pos = getPos _target;

					[[civ_water_pos,_caller,clientOwner,_target,2],"scripts\civilian\civilian_givewater.sqf"] remoteExecCall ["execVM",2];																
				} else {
					systemChat "You don't have cigarettes in your inventory!";  
				};
			},
			nil,		// arguments
			5,		// priority
			true,		// showWindow
			true,		// hideOnUse
			"",			// shortcut
			"alive _target", 	// condition
			3,			// radius
			false,		// unconscious
			"",			// selection
			""			// memoryPoint
		]] remoteExec ["addAction",0,true];
	};

	//Interface
	[_x,
		["<t color='#DF0303'>Interaction menu</t>",	
			{	
				params ["_target", "_caller", "_actionId", "_arguments"];				
				[_target,_caller] execVM "GUI\scripts\open_CivInteractMenu.sqf" ;
			},
			nil,		// arguments
			6,		// priority
			true,		// showWindow
			true,		// hideOnUse
			"",			// shortcut
			"alive _target", 	// condition
			3,			// radius
			false,		// unconscious
			"",			// selection
			""			// memoryPoint
	]] remoteExec ["addAction",0,true];

	_x addEventHandler ["Hit", {
		//sympathy goes down
		params ["_x", "_source", "_damage", "_instigator"];
		
		if (isServer && isPlayer _source) then {						
			msg_death_civ = "A civilian named " + (name _x) + " has been hurt by " + (name _source) + "! Be careful!";
			[msg_death_civ]remoteExec ["systemChat",0];
		};

		[[_x], GDGM_fnc_civilian_panic] remoteExec ["spawn",2];
		
	}];

	if (vehicle _x == _x) then {
		_x addEventHandler ["FiredNear", {
			params ["_x", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];		
			if (isServer) then {
				//_x forceSpeed -1;
				_x removeAllEventHandlers "FiredNear";	
				if (_distance < 10) then {
					_x disableAI "PATH";
					_x setUnitPos "DOWN";
					_x setVariable ["gdgm_haspanic", true ];	
				} else {				
					[[_x], GDGM_fnc_civilian_panic] remoteExec ["spawn",2];					
				};
			};			
		}];
	};
	sleep 0.3;
} foreach _units;
