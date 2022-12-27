params["_unit"];

//if(_unit getVariable "gdgm_haspanic") exitwith {};

_sound = selectRandom GDGM_voiceFiles;
_path = "";

if(GDGM_civLanguage == "PER") then {
	_path = "A3\Dubbing_Radio_F\data\PER\"+ speaker _unit + _sound;
};
if(GDGM_civLanguage == "POL") then {
	_path = "A3\Dubbing_Radio_F_Enoch\data\POL\"+ speaker _unit + _sound;
};

//systemChat _path;
playSound3D [_path, _unit, false, getPosASL _unit, 1, pitch _unit, 80];

_unit setRandomLip true;
sleep 2;
_unit setRandomLip false;