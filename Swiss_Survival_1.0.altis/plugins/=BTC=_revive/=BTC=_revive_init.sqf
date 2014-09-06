/*
Created by =BTC= Giallustio
version 0.98 Offical release
Visit us at: 
http://www.blacktemplars.altervista.org/
06/03/2012
*/

////////////////// EDITABLE \\\\\\\\\\\\\\\\\\\\\\\\\\
BTC_revive_time_min = 5;
BTC_revive_time_max = 60;
BTC_who_can_revive  = ["Man"];
BTC_disable_respawn = 0;
BTC_respawn_gear    = 1;
BTC_active_lifes    = 0;
BTC_lifes           = 1;
BTC_spectating      = 0;//0 = disable; 1 = units group; 2 = side units; 3 = all units
BTC_spectating_view = [0,0];//To force a view set the first number of the array to 1. The second one is the view mode: 0 = first person; 1 = behind the back; 2 = High; 3 = free
BTC_s_mode_view     = ["First person","Behind the back","High","Free"];
BTC_black_screen    = 0;//Black screen + button while unconscious or action wheel and clear view
BTC_action_respawn  = 0;//if black screen is set to 0 you can choose if you want to use the action wheel or the button. Keep in mind that if you don't use the button, the injured player can use all the action, frag too....
BTC_camera_unc      = 0;
BTC_camera_unc_type = ["Behind the back","High","Free"];
BTC_respawn_time    = 0;
BTC_active_mobile   = 0;//Active mobile respawn (You have to put in map the vehicle and give it a name. Then you have to add one object per side to move to the mobile (BTC_base_flag_west,BTC_base_flag_east) - (1 = yes, 0 = no))
BTC_mobile_respawn  = 0;//Active the mobile respawn fnc (1 = yes, 0 = no)
BTC_mobile_respawn_time = 10;//Secs delay for mobile vehicle to respawn
BTC_need_first_aid = 0;//You need a first aid kit to revive (1 = yes, 0 = no)
BTC_pvp = 0; //(disable the revive option for the enemy)
BTC_injured_marker = 1;
BTC_3d_can_see     = ["Man"];
BTC_3d_distance    = 30;
BTC_3d_icon_size   = 0.5;
BTC_3d_icon_color  = [1,0,0,1];
BTC_dlg_on_respawn = 1;//1 = Mobile only - 2 Leader group and mobile - 3 = Units group and mobile - 4 = All side units and mobile
BTC_objects_actions_west = [hq_blu1];	// Object for teleporting to MHQ
BTC_objects_actions_east = [];
BTC_objects_actions_guer = [];
BTC_objects_actions_civ  = [];
if (isServer) then
{
	BTC_vehs_mobile_west = [];//Editable - define mobile west
	BTC_vehs_mobile_east = [];//Editable - define mobile east
	BTC_vehs_mobile_guer = [];//Editable - define mobile independent
	BTC_vehs_mobile_civ  = [];//Editable - define mobile civilian
};
////////////////// Don't edit below \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if (!isDedicated) then {};
//FNC
call compile preprocessFile "plugins\=BTC=_revive\=BTC=_functions.sqf";

if (isServer) then
{
	//Mobile
	BTC_vehs_mobile_west_str = [];BTC_vehs_mobile_east_str = [];BTC_vehs_mobile_guer_str = [];BTC_vehs_mobile_civ_str = [];
	if (BTC_active_mobile == 1 && count BTC_vehs_mobile_west != 0) then {for "_i" from 0 to ((count BTC_vehs_mobile_west) - 1) do {_veh = (BTC_vehs_mobile_west select _i);_var = str (_veh);BTC_vehs_mobile_west_str = BTC_vehs_mobile_west_str + [_var];_veh setVariable ["BTC_mobile_west",_var,true];if (BTC_mobile_respawn == 1) then { _resp = [_veh,_var,"BTC_mobile_west"] spawn BTC_vehicle_mobile_delete; _resp = [_veh,_var,"BTC_mobile_west"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_west;};
	if (BTC_active_mobile == 1 && count BTC_vehs_mobile_east != 0) then {for "_i" from 0 to ((count BTC_vehs_mobile_east) - 1) do {_veh = (BTC_vehs_mobile_east select _i);_var = str (_veh);BTC_vehs_mobile_east_str = BTC_vehs_mobile_east_str + [_var];_veh setVariable ["BTC_mobile_east",_var,true];if (BTC_mobile_respawn == 1) then {_resp = [_veh,_var,"BTC_mobile_east"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_east;};
	if (BTC_active_mobile == 1 && count BTC_vehs_mobile_guer != 0) then {for "_i" from 0 to ((count BTC_vehs_mobile_guer) - 1) do {_veh = (BTC_vehs_mobile_guer select _i);_var = str (_veh);BTC_vehs_mobile_guer_str = BTC_vehs_mobile_guer_str + [_var];_veh setVariable ["BTC_mobile_guer",_var,true];if (BTC_mobile_respawn == 1) then {_resp = [_veh,_var,"BTC_mobile_guer"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_guer;};
	if (BTC_active_mobile == 1 && count BTC_vehs_mobile_civ != 0) then {for "_i" from 0 to ((count BTC_vehs_mobile_civ) - 1) do {_veh = (BTC_vehs_mobile_civ select _i);_var = str (_veh);BTC_vehs_mobile_civ_str = BTC_vehs_mobile_civ_str + [_var];_veh setVariable ["BTC_mobile_civ",_var,true];if (BTC_mobile_respawn == 1) then {_resp = [_veh,_var,"BTC_mobile_civ"] spawn BTC_vehicle_mobile_respawn;};};} else {{deleteVehicle _x} foreach BTC_vehs_mobile_civ;};
	if (BTC_active_mobile == 1) then {publicVariable "BTC_vehs_mobile_west_str";publicVariable "BTC_vehs_mobile_east_str";publicVariable "BTC_vehs_mobile_guer_str";publicVariable "BTC_vehs_mobile_civ_str";};
	//
	BTC_killed_pveh = [];publicVariable "BTC_killed_pveh";
	BTC_drag_pveh = [];publicVariable "BTC_drag_pveh";
	BTC_carry_pveh = [];publicVariable "BTC_carry_pveh";
	BTC_marker_pveh = [];publicVariable "BTC_marker_pveh";
	BTC_load_pveh = [];publicVariable "BTC_load_pveh";
	BTC_pullout_pveh = [];publicVariable "BTC_pullout_pveh";
};
if (isDedicated) exitWith {};

BTC_dragging = false;
BTC_respawn_cond = false;
//Init
[] spawn
{
	waitUntil {!isNull player};
	waitUntil {player == player};
	"BTC_drag_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_carry_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_marker_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_load_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_pullout_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	"BTC_killed_pveh" addPublicVariableEventHandler BTC_fnc_PVEH;
	BTC_r_mobile_selected = objNull;
	BTC_r_bleeding = 0;
	BTC_r_bleeding_loop = false;
	player addRating 9999;
	BTC_r_list = [];
	BTC_side = playerSide;
	BTC_r_s_cam_view = [-15,-15,15];
	BTC_respawn_marker = format ["respawn_%1",playerSide];
	if (BTC_respawn_marker == "respawn_guer") then {BTC_respawn_marker = "respawn_guerrila";};
	if (BTC_respawn_marker == "respawn_civ") then {BTC_respawn_marker = "respawn_civilian";};
	BTC_r_base_spawn = "Land_HelipadEmpty_F" createVehicleLocal getMarkerPos BTC_respawn_marker;
	player addEventHandler ["Killed", BTC_player_killed];
	if (BTC_respawn_gear == 1) then {player addEventHandler ["HandleDamage", {_this spawn BTC_fnc_handledamage_gear;_this select 2}];};
	player setVariable ["BTC_need_revive",0,true];
	//{_x setVariable ["BTC_need_revive",0,true];} foreach allunits;//[] spawn {while {true} do {sleep 0.1;player sidechat format ["%1",BTC_r_mobile_selected];};};
	if (BTC_pvp == 1) then {player setVariable ["BTC_revive_side",str (BTC_side),true];};
	player setVariable ["BTC_dragged",0,true];
	if ([player] call BTC_is_class_can_revive) then {player addAction [("<t color=""#ED2744"">") + ("First aid") + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_first_aid], 8, true, true, "", "[] call BTC_check_action_first_aid"];};
	player addAction [("<t color=""#ED2744"">") + ("Drag") + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_drag], 8, true, true, "", "[] call BTC_check_action_drag"];
	player addAction [("<t color=""#ED2744"">") + ("Carry") + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_carry], 8, true, true, "", "[] call BTC_check_action_drag"];
	player addAction [("<t color=""#ED2744"">") + ("Pull out injured") + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[],BTC_pull_out], 8, true, true, "", "[] call BTC_pull_out_check"];
	if (BTC_active_mobile == 1) then 
	{
		switch (true) do
		{
			case (BTC_side == west) : {{private ["_veh"];_veh = _x;_spawn = [_x] spawn BTC_mobile_marker;{_x addAction [("<t color=""#ED2744"">") + ("Move to mobile " + _veh) + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["[""%1""] call BTC_mobile_check",_veh]];} foreach BTC_objects_actions_west;} foreach BTC_vehs_mobile_west_str;};
			case (BTC_side == east) : {{private ["_veh"];_veh = _x;_spawn = [_x] spawn BTC_mobile_marker;{_x addAction [("<t color=""#ED2744"">") + ("Move to mobile " + _veh) + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["[""%1""] call BTC_mobile_check",_veh]];} foreach BTC_objects_actions_east;} foreach BTC_vehs_mobile_east_str;};
			case (str (BTC_side) == "guer") : {{private ["_veh"];_veh = _x;_spawn = [_x] spawn BTC_mobile_marker;{_x addAction [("<t color=""#ED2744"">") + ("Move to mobile " + _veh) + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["[""%1""] call BTC_mobile_check",_veh]];} foreach BTC_objects_actions_guer;} foreach BTC_vehs_mobile_guer_str;};
			case (BTC_side == civilian) : {{private ["_veh"];_veh = _x;_spawn = [_x] spawn BTC_mobile_marker;{_x addAction [("<t color=""#ED2744"">") + ("Move to mobile " + _veh) + "</t>","plugins\=BTC=_revive\=BTC=_addAction.sqf",[[_veh],BTC_move_to_mobile], 8, true, true, "", format ["[""%1""] call BTC_mobile_check",_veh]];} foreach BTC_objects_actions_civ;} foreach BTC_vehs_mobile_civ_str;};
		};
	}
	else
	{
		BTC_vehs_mobile_west_str = [];BTC_vehs_mobile_east_str = [];BTC_vehs_mobile_guer_str = [];BTC_vehs_mobile_civ_str = [];
	};
	BTC_gear = [player] call BTC_get_gear;
	if (({player isKindOf _x} count BTC_3d_can_see) > 0) then {if (BTC_pvp == 1) then {_3d = [] spawn BTC_3d_markers_pvp;} else {_3d = [] spawn BTC_3d_markers;};};
	//[] spawn {while {true} do {sleep 0.5;hintSilent format ["%1",BTC_gear];};};
	BTC_revive_started = true;
	//hint "REVIVE STARTED";
};