// AI
add_civ_waypoints = compile preprocessFileLineNumbers "scripts\server\ai\add_civ_waypoints.sqf";
add_defense_waypoints = compile preprocessFileLineNumbers "scripts\server\ai\add_defense_waypoints.sqf";
battlegroup_ai = compile preprocessFileLineNumbers "scripts\server\ai\battlegroup_ai.sqf";
building_defence_ai = compile preprocessFileLineNumbers "scripts\server\ai\building_defence_ai.sqf";
patrol_ai = compile preprocessFileLineNumbers "scripts\server\ai\patrol_ai.sqf";
prisonner_ai = compile preprocessFileLineNumbers "scripts\server\ai\prisonner_ai.sqf";
troup_transport = compile preprocessFileLineNumbers "scripts\server\ai\troup_transport.sqf";

// Battlegroup
spawn_air = compile preprocessFileLineNumbers "scripts\server\battlegroup\spawn_air.sqf";
spawn_battlegroup = compile preprocessFileLineNumbers "scripts\server\battlegroup\spawn_battlegroup.sqf";

// Game
check_victory_conditions = compile preprocessFileLineNumbers "scripts\server\game\check_victory_conditions.sqf";

// Patrol
manage_one_civilian_patrol = compile preprocessFileLineNumbers "scripts\server\patrols\manage_one_civilian_patrol.sqf";
manage_one_patrol = compile preprocessFileLineNumbers "scripts\server\patrols\manage_one_patrol.sqf";
reinforcements_manager = compile preprocessFileLineNumbers "scripts\server\patrols\reinforcements_manager.sqf";
send_paratroopers = compile preprocessFileLineNumbers "scripts\server\patrols\send_paratroopers.sqf";

// Secondary objectives
fob_hunting = compile preprocessFileLineNumbers "scripts\server\secondary\fob_hunting.sqf";
convoy_hijack = compile preprocessFileLineNumbers "scripts\server\secondary\convoy_hijack.sqf";
search_and_rescue = compile preprocessFileLineNumbers "scripts\server\secondary\search_and_rescue.sqf";

// Sector
attack_in_progress_fob = compile preprocessFileLineNumbers "scripts\server\sector\attack_in_progress_fob.sqf";
attack_in_progress_sector = compile preprocessFileLineNumbers "scripts\server\sector\attack_in_progress_sector.sqf";
ied_manager = compile preprocessFileLineNumbers "scripts\server\sector\ied_manager.sqf";
manage_one_sector = compile preprocessFileLineNumbers "scripts\server\sector\manage_one_sector.sqf";
wait_to_spawn_sector = compile preprocessFileLineNumbers "scripts\server\sector\wait_to_spawn_sector.sqf";

// Globals
active_sectors = []; publicVariable "active_sectors";

execVM "scripts\server\base\startgame.sqf";
execVM "scripts\server\base\huron_manager.sqf";
execVM "scripts\server\base\startvehicle_spawn.sqf";
[] call KPLIB_fnc_createSuppModules;
execVM "scripts\server\battlegroup\counter_battlegroup.sqf";
execVM "scripts\server\battlegroup\random_battlegroups.sqf";
execVM "scripts\server\battlegroup\readiness_increase.sqf";
execVM "scripts\server\game\apply_default_permissions.sqf";
execVM "scripts\server\game\cleanup_vehicles.sqf";
if (!KPLIB_fog_param) then {execVM "scripts\server\game\fucking_set_fog.sqf";};
execVM "scripts\server\game\manage_time.sqf";
execVM "scripts\server\game\manage_weather.sqf";
execVM "scripts\server\game\playtime.sqf";
execVM "scripts\server\game\save_manager.sqf";
execVM "scripts\server\game\spawn_radio_towers.sqf";
execVM "scripts\server\game\synchronise_vars.sqf";
execVM "scripts\server\game\synchronise_eco.sqf";
execVM "scripts\server\game\zeus_synchro.sqf";
execVM "scripts\server\offloading\show_fps.sqf";
execVM "scripts\server\patrols\civilian_patrols.sqf";
execVM "scripts\server\patrols\manage_patrols.sqf";
execVM "scripts\server\patrols\reinforcements_resetter.sqf";
if (KPLIB_ailogistics) then {execVM "scripts\server\resources\manage_logistics.sqf";};
execVM "scripts\server\resources\manage_resources.sqf";
execVM "scripts\server\resources\recalculate_resources.sqf";
execVM "scripts\server\resources\recalculate_timer.sqf";
execVM "scripts\server\resources\recalculate_timer_sector.sqf";
execVM "scripts\server\resources\unit_cap.sqf";
execVM "scripts\server\sector\lose_sectors.sqf";

KPLIB_fsm_sectorMonitor = [] call KPLIB_fnc_sectorMonitor;
if (KPLIB_high_command) then {KPLIB_fsm_highcommand = [] call KPLIB_fnc_highcommand;};

// Select FOB templates
switch (KPLIB_presetEnemies) do {
    case 1: {
        KPLIB_fob_templates = [
            "scripts\fob_templates\apex\template1.sqf",
            "scripts\fob_templates\apex\template2.sqf",
            "scripts\fob_templates\apex\template3.sqf",
            "scripts\fob_templates\apex\template4.sqf",
            "scripts\fob_templates\apex\template5.sqf"
        ];
    };
    case 12: {
        KPLIB_fob_templates = [
            "scripts\fob_templates\unsung\template1.sqf",
            "scripts\fob_templates\unsung\template2.sqf",
            "scripts\fob_templates\unsung\template3.sqf",
            "scripts\fob_templates\unsung\template4.sqf",
            "scripts\fob_templates\unsung\template5.sqf"
        ];
    };
    default {
        KPLIB_fob_templates = [
            "scripts\fob_templates\default\template1.sqf",
            "scripts\fob_templates\default\template2.sqf",
            "scripts\fob_templates\default\template3.sqf",
            "scripts\fob_templates\default\template4.sqf",
            "scripts\fob_templates\default\template5.sqf",
            "scripts\fob_templates\default\template6.sqf",
            "scripts\fob_templates\default\template7.sqf",
            "scripts\fob_templates\default\template8.sqf",
            "scripts\fob_templates\default\template9.sqf",
            "scripts\fob_templates\default\template10.sqf"
        ];
    };
};

// Civil Reputation
execVM "scripts\server\civrep\init_module.sqf";

// Civil Informant
execVM "scripts\server\civinformant\init_module.sqf";

// Asymmetric Threats
execVM "scripts\server\asymmetric\init_module.sqf";

// Groupcheck for deletion when empty
execVM "scripts\server\offloading\group_diag.sqf";

{
    if ((_x != player) && (_x distance (markerPos KPLIB_respawn_marker) < 200 )) then {
        deleteVehicle _x;
    };
} forEach allUnits;

// Server Restart Script from K4s0
if (KPLIB_restart > 0) then {
    execVM "scripts\server\game\server_restart.sqf";
};

if (KPLIB_limited_zeus) then {
    zm1 setVariable ["Addons", 0, true];
    removeAllCuratorAddons zm1;

    zm1 setCuratorCoef ["edit", -1e8];
    zm1 setCuratorCoef ["place", -1e8];
    zm1 setCuratorCoef ["synchronize", 0];
    zm1 setCuratorCoef ["delete", 0];
    zm1 setCuratorCoef ["destroy", -1e8];
} else {
    zm1 setVariable ["Addons", 3, true];
    removeAllCuratorAddons zm1;

    private _allAddons = ("true" configClasses (configFile >> "CfgPatches")) apply {configName _x};
    zm1 addCuratorAddons _allAddons;

    zm1 setCuratorCoef ["edit", 0];
    zm1 setCuratorCoef ["place", 0];
    zm1 setCuratorCoef ["synchronize", 0];
    zm1 setCuratorCoef ["delete", 0];
    zm1 setCuratorCoef ["destroy", 0];
};
