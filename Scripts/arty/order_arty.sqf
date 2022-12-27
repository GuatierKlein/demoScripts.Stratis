//clientside
_adj_pos = [0,0,0];

//recup la pos grid
_x_coord = ctrlText 040512;
_y_coord = ctrlText 040513;

_pos_grid = _x_coord + _y_coord;

_realPosition = _pos_grid call BIS_fnc_gridToPos;

_pos = _realPosition select 0;
_pos_real = [_pos select 0,_pos select 1,0];

//adjust pos
_dist = ctrlText 040518;
_dist = parseNumber _dist;
_angle = ctrlText 040519;
_angle = parseNumber _angle;

if (_angle != 0 || _dist != 0) then {
	_logic = createAgent ["Logic", _pos_real, [], 0, "FORM"];
	_adj_pos = _logic getRelPos [_dist, _angle];
	deleteVehicle _logic;
} else {
	_adj_pos = _pos_real;
};

//ammo 
{
	_y = _x;
	_units = units group _y;
	{
		_x setVehicleAmmoDef 1;
	} foreach _units;
} foreach artillery_pieces_array;


//arty fire
_index = lbCurSel 040514;
_index_ammo = lbCurSel 040516;

if (_index != -1 && _index_ammo != -1) then {
_arty = artillery_pieces_array_client select _index;
_artyAmmo = ammo_array select _index_ammo;
_shots = ctrlText 040515;
_shots = parseNumber _shots;
_isInRange = _adj_pos inRangeOfArtillery [[_arty], _artyAmmo];
_ETA = _arty getArtilleryETA [_adj_pos, _artyAmmo];

	if (_shots != 0 && _x_coord != "000" && _y_coord != "000" && _isInRange && _ETA != -1) then {
		[player,"Requesting artillery at grid " + _pos_grid] remoteExec ["globalChat",0];
		sleep 20;

		_arty_group = units group _arty;  
		{
			_x setVehicleAmmo 1;
			sleep 0.1;
		} foreach _arty_group;

		[_arty,"Roger that, firing " + str (_shots * count _arty_group) + " rounds at grid " + _pos_grid] remoteExec ["globalChat",0];
		sleep 1;
		[_arty,"ETA " + str _ETA + " seconds"] remoteExec ["globalChat",0];
		{
			[_x, [_adj_pos, _artyAmmo, _shots]] remoteExec ["doArtilleryFire",0];
			sleep random 2;
		} foreach _arty_group;		
	} else {
		if (!_isInRange || _ETA == -1) then {
			[_arty,"Negative, can't reach target, over"] remoteExec ["globalChat",0];
		} else {
			systemChat "Shots and coordinates can't be 0";
		};		
	};
} else {
	systemChat "You first need to select an artillery piece and its ammo";
};


