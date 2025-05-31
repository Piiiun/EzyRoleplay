static
    hack_health[MAX_PLAYERS] = {0, ...},
    hack_armour[MAX_PLAYERS] = {0, ...},
    hack_teleport[MAX_PLAYERS] = {0, ...},
    hack_airbreak[MAX_PLAYERS] = {0, ...},
    hack_vehiclehealth[MAX_PLAYERS] = {0, ...},
    hack_vehtele[MAX_PLAYERS] = {0, ...},
    hack_fly[MAX_PLAYERS] = {0, ...},
    wrap_veh[MAX_PLAYERS] = {0, ...},
    veh_speedhack[MAX_PLAYERS] = {0, ...},
    onfoot_speedhack[MAX_PLAYERS] = {0, ...}
;

#include <YSI\y_hooks>
hook OnPlayerConnect(playerid) {
    hack_health[playerid] = 0;
    hack_armour[playerid] = 0;
    hack_teleport[playerid] = 0;
    hack_airbreak[playerid] = 0;
    hack_vehiclehealth[playerid] = 0;
    hack_vehtele[playerid] = 0;
    hack_fly[playerid] = 0;
    wrap_veh[playerid] = 0;
    veh_speedhack[playerid] = 0;
    onfoot_speedhack[playerid] = 0;
    return 1;
}

Function:OnCheatDetected(playerid, ip_address[], type, code)
{
   if(IsPlayerConnected(playerid))
        return 0;

    if(type) BlockIpAddress(ip_address, 0);
	else {
        switch(code)
        {
            case 0: {
                if(++hack_airbreak[playerid] == 3)
                {
                    foreach (new i : Player) 
                    
                    {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Airbreak Hack");
                    }
                    hack_airbreak[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {B897FF}%s (%s) "YELLOW_E"IP: {B897FF}%s "YELLOW_E"possible cheat onfoot airbreak hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat onfoot airbreak hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 1: {
                if(++hack_airbreak[playerid] == 3)
                {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Vehicle Airbreak Hack");
                    }
                    hack_airbreak[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle airbreak hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle airbreak hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 2:
            {
                new Float:x, Float:y, Float:z;
                AntiCheatGetPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z);

                if(++hack_teleport[playerid] == 3)
                {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Teleport Hack");
                    }
                    hack_teleport[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                new dc[128];
				format(dc, sizeof(dc),  "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
				SendDiscordMessage(2, dc);
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 3:
            {
                new Float:x, Float:y, Float:z;
                AntiCheatGetPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z);

                if(++hack_vehtele[playerid] == 3)
                {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Vehicle Teleport Hack");
                    }
                    hack_vehtele[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                new dc[128];
                format(dc, sizeof(dc),  "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle teleport hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 4:
            {
                if (++wrap_veh[playerid] == 3) {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Wrap vehicle hack");
                    }
                    wrap_veh[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat wrap vehicle hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat wrap vehicle hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 5: {
                new dc[128];
                format(dc, sizeof(dc),  "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle teleport to player hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle teleport to player hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle teleport to player hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
        
            case 7: {
                if(++hack_fly[playerid] == 3)
                {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Fly Hack");
                    }
                    hack_fly[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: %s IP: {7fffd4}%s "YELLOW_E"possible cheat fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }    
            case 8: {
                if(++hack_fly[playerid] == 3)
                {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Vehicle Fly Hack");
                    }
                    hack_fly[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat vehicle fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle fly hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 9: {
                if (++onfoot_speedhack[playerid] == 3) {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Onfoot speed hack");
                    }
                    onfoot_speedhack[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat onfoot speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat onfoot speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat onfoot speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 10: {
                if (++veh_speedhack[playerid] == 3) {
                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Vehicle speed hack");
                    }
                    veh_speedhack[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat vehicle speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle speed hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 11: 
            {
                if(++hack_vehiclehealth[playerid] == 3)
                {
                    new Float:health;
                    AntiCheatGetVehicleHealth(AntiCheatGetVehicleID(playerid), health);
                    SetVehicleHealth(AntiCheatGetVehicleID(playerid), health);

                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Vehicle Health Hack");
                    }
                    hack_vehiclehealth[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat vehicle health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat vehicle health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat vehicle health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 12: 
            {
                if(++hack_health[playerid] == 3)
                {
                    new Float:health;
                    AntiCheatGetHealth(playerid, health);
                    SetPlayerHealth(playerid, health);

                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Health Hack");
                    }
                    hack_health[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat health hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 13: 
            {
                if(++hack_armour[playerid] == 3)
                {
                    new Float:armor;
                    AntiCheatGetArmour(playerid, armor);
                    SetPlayerArmour(playerid, armor);

                    foreach (new i : Player) {
                        SendClientMessageEx(i, COLOR_PURPLE, "BotCmd: %s have been kicked from the server.", NormalName(playerid));
                        SendClientMessageEx(i, COLOR_PURPLE, "Reason: Armour Hack");
                    }
                    hack_armour[playerid] = 0;
                    KickEx(playerid);
                    return 1;
                }
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat armour hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat armour hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat armour hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            case 15: 
            {
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat weapon hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat weapon hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat weapon hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                KickEx(playerid);
            }
            case 16: 
            {
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat add ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat add ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat add ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                KickEx(playerid);
            }
            case 17: 
            {
                new dc[128];
                format(dc, sizeof(dc),  "id:%d] %s (%s) IP: %s possible cheat infinite ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat infinite ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat infinite ammo hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                KickEx(playerid);
            }
            case 18:
            {
                new dc[128];
                format(dc, sizeof(dc),  "[id:%d] %s (%s) IP: %s possible cheat using special animations hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                SendDiscordMessage(2, dc);
                SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"IP: {7fffd4}%s "YELLOW_E"possible cheat using special animations hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
                Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s possible cheat using special animations hack.", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid));
            }
            default: SendAdminMessage(COLOR_PURPLE, "AdmWarn: [id:%d] {7fffd4}%s (%s) "YELLOW_E"({7fffd4}%s"YELLOW_E") type: {7fffd4}%d "YELLOW_E"code {7fffd4}%d", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid), type, code), Log_Write("logs/anticheat_log.txt", "[id:%d] %s (%s) IP: %s type: %d code %d", playerid, NormalName(playerid), ReturnAdminName(playerid), GetPlayerIp(playerid), type, code);
        }
        // AntiCheatKickWithDesync(playerid, code);
    }
    return 1;
}