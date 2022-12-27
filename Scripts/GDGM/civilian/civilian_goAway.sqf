//serverside
_unit = _this select 0;
_caller = _this select 1;

_unit enableai "PATH";

_pos = getPos _unit;
_nearest_loc = nearestLocation [_pos, "Invisible"];
_pos_flee = locationPosition _nearest_loc;

if (_unit distance _pos_flee < 75) then {

	_nearbyLocations = nearestLocations [_pos_flee, ["Invisible"], 15000];
	_pos_flee = locationPosition (_nearbyLocations select 1);
	_unit MoveTo _pos_flee;

	_unit forceSpeed (_unit getSpeed "FAST");


} else {
	//go way to closest town
	_pos_flee = locationPosition _nearest_loc;
	_unit moveTo _pos_flee;
	_unit forceSpeed (_unit getSpeed "FAST");
};

_caller playActionNow "gestureGo";



