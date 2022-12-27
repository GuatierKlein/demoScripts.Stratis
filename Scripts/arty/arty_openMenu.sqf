//clientside
createDialog "dialogArty";

artillery_pieces_array_client = [];
ammo_array = [];
_artillery_names_array = [];

_id = clientOwner;
[[_id],"scripts\arty\send_arty.sqf"]remoteExecCall ["execVM",2];


ctrlSetText [040512,GDGM_art_X_coord]; //X
ctrlSetText [040513,GDGM_art_Y_coord]; //Y
ctrlSetText [040515,GDGM_art_shots]; //shots
ctrlSetText [040518,GDGM_art_dist]; //dist
ctrlSetText [040519,GDGM_art_angle]; //angle

waitUntil { sleep 0.1; count artillery_pieces_array_client != 0};

//get classname
{
	_veh = typeOf  _x;
	_artillery_names_array pushBack _veh;
} foreach artillery_pieces_array_client;

//get display name
{
	_vehName = getText (configFile >> "CfgVehicles" >> _x >> "displayName");
	_count = count units group (artillery_pieces_array_client select _foreachindex);
	_vehName = _vehName + " (" + str _count + ")";
	lbAdd [040514,_vehName];
} foreach _artillery_names_array;

//get and display ammo
_display = findDisplay 04051;
_lb_piece = _display displayCtrl 040514;

//EH lb changed
_lb_piece ctrlAddEventHandler ["LBSelChanged", 
{
	_index = lbCurSel 040514;
	lbClear 040516;
	_arty_piece = artillery_pieces_array_client select _index;
	ammo_array = getArtilleryAmmo [_arty_piece];
	{
		_ammo_display_name = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
		lbAdd [040516,_ammo_display_name];		
	} foreach ammo_array;
}];

while {dialog} do {
	GDGM_art_X_coord = ctrlText 040512;
	GDGM_art_Y_coord = ctrlText 040513;
	GDGM_art_shots = ctrlText 040515;
	GDGM_art_dist = ctrlText 040518;
	GDGM_art_angle = ctrlText 040519;
	sleep 0.3;
};


