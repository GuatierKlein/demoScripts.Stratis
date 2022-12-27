//version 1.0
if(!isServer) exitwith {};
//dans init.sqf 
//#include "fleeing.sqf";

/*
Que fait ce script?
Si une certaine proportion d'un groupe tombe, le groupe paniquera
REQUIERT LAMBS POUR FONCTIONNER
voir à la fin pour activer le script
*/

//PARAMETRES

// si true, les soldat qui fuire convergeront vers un marker aléatoire dans GDGM_customFleeingPos
// si false, la position sera aléatoirement determinée autour de la position du soldat
GDGM_fleeToCustomPos = true;
GDGM_customFleeingPos = [
	"fleeingPos",
	"fleeingPos_1",
	"fleeingPos_2",
	"fleeingPos_3"
];

//part du groupe qui doit être au tas pour que la fuite se déclenche
// si = 0.5, un groupe de 6 fuira quand 3 hommes seront au tas. L'arrondi est fait à l'entier supérieur.
GDGM_fleeingRatio = 0.5;

//proba de fuite quand quand la part d'homme à terre est dépassée
GDGM_fleeingChance = 0.75;

//FIN PARAMETRES
//NE PAS MODIFIER EN DESSOUS

GDGM_fnc_groupFlee = {
	params ["_grp"];

	if(!isServer) exitwith {};

	_baseUnitCount = count units _grp;
	if(!(_baseUnitCount > 2)) exitwith {};
	
	_unitCount = _baseUnitCount;
	_minAmount = ceil(_baseUnitCount * GDGM_fleeingRatio);
	while {_unitCount > 2} do {
		_unitCount = { alive _x } count units _grp;
		if(_unitCount <= _minAmount) then {
			if({ alive _x } count units _grp == 0) exitwith {};
			if(random 1 < GDGM_fleeingChance) then {
				_pos = [getPos leader _grp, _grp] call GDGM_fnc_findFleeingPos;
				[_grp, _pos, selectRandom [true,false],50] spawn lambs_wp_fnc_taskAssault;
			};

			_baseUnitCount = _unitCount;
			_minAmount = ceil(_baseUnitCount * GDGM_fleeingRatio);
			sleep 60;
		};
		sleep 2;
	};
};

GDGM_fnc_findFleeingPos = {
	params["_pos","_grp"];

	if(GDGM_fleeToCustomPos) exitwith {getMarkerPos selectRandom GDGM_customFleeingPos};

	_fleeingPos = _pos getPos [random [250,500,900], floor (random 360)];

	while {((leader _grp) findNearestEnemy _fleeingPos) distanceSqr _fleeingPos < 30*30 || surfaceIsWater _fleeingPos} do {
		_fleeingPos = _pos getPos [random [250,500,500], floor (random 360)];
	};
	_fleeingPos;
};

//mettre ici les groupes qui peuvent fuire en suivant ce modèle
//[nomDuGroupe] spawn GDGM_fnc_groupFlee;
//[group NomDunBonhommeDuGroupe] spawn GDGM_fnc_groupFlee;
//ne pas mettre dans l'init des unités, ça ne s'executera pas

// [grpSquare] spawn GDGM_fnc_groupFlee;
// [grpUsine] spawn GDGM_fnc_groupFlee;
// [groupNBridge] spawn GDGM_fnc_groupFlee;
// [groupSBridge] spawn GDGM_fnc_groupFlee;
// [groupVillage] spawn GDGM_fnc_groupFlee;
// [grpReinf] spawn GDGM_fnc_groupFlee;
