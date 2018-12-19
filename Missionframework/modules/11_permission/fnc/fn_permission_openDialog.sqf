/*
    KPLIB_fnc_permission_openDialog

    File: fn_permission_openDialog.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2018-12-14
    Last Update: 2018-12-19
    License: GNU General Public License v3.0 - https://www.gnu.org/licenses/gpl-3.0.html

    Description:
        Opens the permission dialog.

    Parameter(s):
        NONE

    Returns:
        Function reached the end [BOOL]
*/

#include "..\..\..\KPGUI\KPGUI_defines.hpp"

// Create dialog
createDialog "KPLIB_permission";
disableSerialization;

// Dialog controls
private _dialog = findDisplay 758011;
private _ctrlPlayerList = _dialog displayCtrl 68740;

// Colors
private _red = [0.9,0,0,1];
private _green = [0,0.8,0,1];
private _white = [1,1,1,1];
private _orange = [1,0.5,0, 0.8];

// Fill the controls
private _index = _ctrlPlayerList lbAdd (localize "STR_KPLIB_DIALOG_PERMISSION_DEFAULT");
_ctrlPlayerList lbSetData [_index, "default"];

_index = _ctrlPlayerList lbAdd "- Online Players -";
_ctrlPlayerList lbSetData [_index, "placeholder"];
_ctrlPlayerList lbSetColor [_index, _orange];

private _UIDList = [];
{
    _UIDList pushBack (_x select 0);
} forEach KPLIB_permissionList;

{
    _index = _ctrlPlayerList lbAdd (name _x);
    _ctrlPlayerList lbSetData [_index, getPlayerUID _x];
    _UIDList deleteAt (_UIDList find _x);
} forEach (allPlayers - (entities "HeadlessClient_F"));

private _tempCtrl = controlNull;
private _data = [];
private _i = 0;
KPLIB_permission_tempControls = [];

{
    _data = missionNamespace getVariable [toLower _x, []];
    _tempCtrl = _dialog ctrlCreate ["KPGUI_PRE_ActiveText", 68741 + _i];
    _tempCtrl ctrlSetPosition [
        KP_GETCX(KP_X_VAL_C,KP_WIDTH_VAL_C,1,2),
        KP_GETCY(KP_Y_VAL_C,KP_HEIGHT_VAL_C,_i * 2,48),
        KP_GETW(KP_WIDTH_VAL_C,2),
        KP_GETH(KP_HEIGHT_VAL_C,24)
    ];
    _tempCtrl ctrlSetText (localize (_data select 1));
    _tempCtrl ctrlSetActiveColor _white;
    _tempCtrl setVariable ["Data", [_x, false]];
    _tempCtrl ctrlSetEventHandler ["MouseButtonClick", '[_this] call KPLIB_fnc_permission_changePermission'];
    _tempCtrl ctrlCommit 0;
    _tempCtrl ctrlEnable false;
    KPLIB_permission_tempControls pushBack _tempCtrl;
    _i = _i + 1;
} forEach KPLIB_permissionTypes;

true
