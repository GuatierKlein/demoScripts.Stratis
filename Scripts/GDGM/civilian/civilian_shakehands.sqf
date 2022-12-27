//execute if has water
params ["_pos","_caller","_target"];

_target disableAI "PATH";
_target lookat _caller;

_nearest_loc = nearestLocation [_pos, "Invisible"];
_loc_sympth = _nearest_loc getVariable "gdgm_local_sympathy";

if (_loc_sympth < 200 && !(_target getVariable "gdgm_shookhands")) then {
	_nearest_loc setVariable ["gdgm_local_sympathy", _loc_sympth + 0.5 ];
	_target setVariable ["gdgm_shookhands", true ];
};					

_caller playActionNow "PutDown";
_target playActionNow "PutDown";
[_target] spawn GDGM_fnc_civilian_speak;


sleep 2;
_target enableAI "PATH";	