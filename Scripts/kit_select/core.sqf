BAR_enableCustomKitOnRespawn = false; 
//true = le kit sauvegardé à l'arsenal sera automatiquement appliqué au respawn en plus de la spécialisation du mannequin choisit
//false = le kit du mannequin et la spécialisation sera appliqué au respawn sans le kit sauvegardé à l'arsenal

//NE PAS MODIFIER EN DESSOUS
player setVariable ["BAR_kit", kit_ne];
BAR_customKit = getUnitLoadout kit_ne;

BAR_fnc_setKit = {
	params ["_kit"];
	player setVariable ["BAR_kit",_kit];
};

BAR_fnc_applyKit = {
	_kit_unit = player getVariable "BAR_kit";

	_loadout = getUnitLoadout _kit_unit;
	player setUnitLoadout _loadout;
	
	player setUnitRank (rank _kit_unit);
	
	_eng = _kit_unit getVariable "ACE_IsEngineer";

	if ([_kit_unit,1] call ace_medical_treatment_fnc_isMedic || [_kit_unit,2] call ace_medical_treatment_fnc_isMedic) then {
		player setVariable ["ace_medical_medicclass",1, true]; // set as doctor
	} else {
		player setVariable ["ace_medical_medicclass",0, true]; 
	};

	if (!isNil "_eng") then {		
		if (_eng == 1 || _eng == 2) then {
			player setVariable ["ACE_IsEngineer",_eng, true]; // set as engineer
		} else {
			player setVariable ["ACE_IsEngineer",0, true]; 
		};
	} else {
		player setVariable ["ACE_IsEngineer",0, true]; 
	};

	if ([_kit_unit] call ace_common_fnc_isEOD) then {		
		player setVariable ["ACE_isEOD", true,true];
	} else {
		player setVariable ["ACE_isEOD", false,true];
	};

	
	systemChat ("AuxSan : " + str ([player,1] call ace_medical_treatment_fnc_isMedic)); //affiche true si medic, false sinon
	systemChat ("Compétence d'ingénieur : " + str (player getVariable "ACE_IsEngineer")); //affiche 1 ou 2 si sapeur, 0 sinon
	systemChat ("Expert explosif : " + str (player getVariable "ACE_isEOD")); //affiche 1 ou 2 si EOD, 0 sinon
	systemChat ("Grade : " + rank player); //affiche le grade reçu
	call BAR_fcn_applyInsignia;
};

//insignes
BAR_fcn_applyInsignia = {
	[player, ""] call BIS_fnc_setUnitInsignia;
	[player, player getVariable "playerInsigne"] call BIS_fnc_setUnitInsignia;
};

BAR_fnc_setInsignia = {
	params ["_insigne"];
	player setVariable ["playerInsigne",_insigne];
	call BAR_fcn_applyInsignia;
};

player setVariable ["playerInsigne","base"];