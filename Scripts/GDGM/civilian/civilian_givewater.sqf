
				
				
//execute if has water
_pos = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_target = _this select 3;
_type = _this select 4; //1 = cigs or 2 = water

_target disableAI "PATH";
_target lookat _caller;

_nearest_loc = nearestLocation [_pos, "Invisible"];
_loc_sympth = _nearest_loc getVariable "gdgm_local_sympathy";

if (_loc_sympth < 200) then {
	_nearest_loc setVariable ["gdgm_local_sympathy", _loc_sympth + 2 ];
};					

if (_type == 1) then {
	[_caller, "ACE_WaterBottle"] remoteExec ["removeItem", 0];
	"You gave one water bottle to that civilian!" remoteExec ["systemChat",_id];
} else {
	[_caller, "murshun_cigs_cig0"] remoteExec ["removeItem", 0];
	"You gave one cigarette to that civilian!" remoteExec ["systemChat",_id];
	_target addGoggles "murshun_cigs_cig0";
};

/*
[_caller,"AmovPercMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon_gear"]remoteExec ["playMoveNow",0];
[_caller,"AmovPercMstpSrasWrflDnon_gear_AmovPercMstpSrasWrflDnon"]remoteExec ["playMove",0];
*/

_caller playActionNow "PutDown";
sleep 1;
_target playActionNow "gestureHi";
[_target] spawn GDGM_fnc_civilian_speak;

[_target,GDGM_dialog_thankyou] remoteExec ["globalChat",_id];	
_target setVariable ["gdgm_givenwater", true ];

sleep 4;
_target enableAI "PATH";
