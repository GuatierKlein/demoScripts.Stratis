//serverside

_unit = _this select 0;
_caller = _this select 1;

_unit disableAI "PATH";
_unit lookat _caller;


