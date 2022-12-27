_unit = _this select 0;

_unit setVariable ["gdgm_hastalked", false ];
_unit setVariable ["gdgm_haspanic", false ];
_unit setVariable ["gdgm_givenwater", false ];
_unit setVariable ["gdgm_checked", false ];
/*
_unit setVariable ["lambs_danger_disableAI", true];
(group _unit) setVariable ["lambs_danger_disableGroupAI", true];
*/	


_unit setBehaviour "CARELESS";
//action to give water
[_unit, 
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
[_unit, 
[
	"<t color='#DF0303'>Stop civilian</t>",	// title
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; // script

		//_target remoteExec ["doStop",2];
		//[_target,_caller] remoteExec ["lookAt",2];
		[[_target,_caller],"scripts\civilian\civilian_stop.sqf"] remoteExecCall ["execVM",2];	
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
[_unit, 
[
	"<t color='#DF0303'>Get down!</t>",	// title
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; // script

		_target remoteExec ["doStop",2];
		[_target,"DOWN"] remoteExec ["setUnitPos",2];
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
	[_unit, 
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
[_unit,
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
/*
//search civilian and ID
[
	_unit,											// Object the action is attached to
	"<t color='#0044c2'>Search and ID</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 4 && alive _target",						// Condition for the action to be shown
	"_caller distance _target < 4",						// Condition for the action to progress
	{[[_target,_caller],"scripts\civilian\civilian_stop.sqf"] remoteExecCall ["execVM",2]; [_target,"UP"] remoteExec ["setUnitPos"]},  // Code executed when action starts
	{},													// Code executed on every progress tick
	{ 
		params ["_target", "_caller", "_actionId", "_arguments"]; 	

		_id = clientOwner;
		[[_target,_id,_caller],"scripts\civilian\civilian_search.sqf"] remoteExecCall ["execVM",2];

	},				
	{[_target,"PATH"] remoteExec ["enableAI",2]},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	5,													// Action duration [s]
	0,													// Priority
	false,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, true];	// MP compatible implementation
*/


_unit addEventHandler ["Hit", {
	//sympathy goes down
	params ["_unit", "_source", "_damage", "_instigator"];
	
	if (isServer && isPlayer _source) then {
		_nearest_loc = nearestLocation [getPos _unit, "Invisible"];				
		_current_sympathy = _nearest_loc getVariable "gdgm_local_sympathy";
		if (_current_sympathy >= 10) then {
			_nearest_loc setVariable ["gdgm_local_sympathy", _current_sympathy - 10 ];
		};				
		
		_name = name _unit;
		_player_name = name _source;
		msg_death_civ = "A civilian named " + _name + " has been hurt by " + _player_name + "! Be careful!";
		[msg_death_civ]remoteExec ["systemChat",0];
	};

	[[_unit], GDGM_fnc_civilian_panic] remoteExec ["spawn",2];
	
}];

_unit addEventHandler ["FiredNear", {
	params ["_x", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];		
	if (isServer) then {
		//_x forceSpeed -1;
		_x removeAllEventHandlers "FiredNear";	
		if (_distance < 10) then {
			_x disableAI "PATH";
			_x setUnitPos "DOWN";
			_x setVariable ["gdgm_haspanic", true ];	
		} else {				
			//if !(_x getVariable "gdgm_haspanic") then {
				[[_x], GDGM_fnc_civilian_panic] remoteExec ["spawn",2];
			//};
		};
	};			
}];