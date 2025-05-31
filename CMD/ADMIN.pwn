CMD:acmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Moderator/Admin Commands:"LB2_E"\n\
 	/aduty /a /h /asay /togooc /o /goto /sendto /get /freeze /unfreeze /arevive /spec /slap\n\
 	/caps /peject /astats /ostats /acuff /auncuff /jetpack /getip /aka /akaip /jail /unjail\n\
	/kick /ban /unban /respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs /settwittername /setbooster\n\
	/reports /asks /ans /ar /dr /vmodels /vehname /apv /aveh /gotoveh /getveh /respawnveh /respawnra /aject /setvw");

	strcat(line3, "\n\n"WHITE_E"Admin Junior Commands:"LB2_E"\n\
 	/sethp /setbone /afuel /agl /clearreports /afix /setskin /akill /ann /cd /settime /setweather\n\
    /ojail /owarn /setam /gotoco /gotohouse /gotobisnis /gotodoor /gotolocker /gotogs /banip /unbanip");

	strcat(line3, "\n\n"WHITE_E"Admin Commands:"LB2_E"\n\
	/oban /reloadweap /resetweap /sethbe /setlevel\n\
 	/createdoor /editdoor");

	strcat(line3, ""WHITE_E"\n\nHead Admin Commands:"LB2_E"\n\
	/setname /setvip /setfaction /setleader /takemoney /takegold /giveweap\n\
	/veh /destroyveh");

	strcat(line3, "\n\n"WHITE_E"Executive Admin Commands:"LB2_E"\n\
	/sethelperlevel /setadminname /setmoney /givemoney /setbankmoney /givebankmoney\n\
	/setmaterial /setcomponent /createpv /destroypv /explode /makequiz /agive\n\n\
	"WHITE_E"Developer/CEO:"LB2_E"\n\
	/setadminlevel /setgold /givegold /setstock /setprice\n\
	/setpassword /createhouse /edithouse /createbisnis /editbisnis");
 	
	strcat(line3, "\n{B897FF}Warga Kota{FFFFFF} - Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Staff Commands", line3, "OK","");
	return true;
}

CMD:arelease(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Kamu harus menjadi Admin level 5.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/arelease <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return ErrorMsg(playerid, "Player tersebut belum masuk!");

	if(pData[otherid][pArrest] == 0)
	    return ErrorMsg(playerid, "The player isn't in arrest!");

	pData[otherid][pArrest] = 0;
	pData[otherid][pArrestTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPositionEx(otherid, 1526.69, -1678.05, 5.89, 267.76, 2000);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
	return true;
}

CMD:makequiz(playerid, params[])
{
	if(pData[playerid][pAdmin] > 4)
	{
		new tmp[128], string[256], str[256], pr;
		if(sscanf(params, "s", tmp)) {
			SyntaxMsg(playerid, "/makequiz [option]");
			SyntaxMsg(playerid, "question, answer, price, end");
			InfoMsg(playerid, "Tolong buat jawabannya dulu.");
			return 1;
		}
		if(!strcmp(tmp, "question", true, 8))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return SyntaxMsg(playerid, "/makequiz question [question]");
			if (quiz == 1) return ErrorMsg(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			if (answermade == 0) return ErrorMsg(playerid, "tolong buat jawaban dulu...");
			if (qprs == 0) return ErrorMsg(playerid, "Tolong tambahkan hadiah terlebih dahulu.");
			format(string, sizeof(string), "{7fffd4}[QUIZ]: %s, Hadiah {00FF00}$%d.", str, qprs);
			SendClientMessageToAll(0xFFFF00FF, string);
			SendClientMessageToAll(-1,"{FFFFFF}Anda bisa memberi jawaban dengan menggunakan {B897FF}/answer.");
			quiz = 1;
		}
		else if(!strcmp(tmp, "answer", true, 6))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return SyntaxMsg(playerid, "/makequiz answer [answer]");
			if (quiz == 1) return InfoMsg(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			answers = str;
			answermade = 1;
			format(string, sizeof(string), "Anda telah membuat jawaban, {00FF00}%s.", str);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "price", true, 5))
		{
			if(sscanf(params, "s[128]d", tmp, pr)) return SyntaxMsg(playerid, "/makequiz price [amount]");
			if (quiz == 1) return ErrorMsg(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan / makequiz end.");
			if (answermade == 0) return ErrorMsg(playerid, " Membuat jawabannya lebih dulu...");
			if (pr <= 0) return ErrorMsg(playerid, "buat harga lebih besar dari 0!");
			qprs = pr;
			format(string, sizeof(string), "Anda telah menempatkan {00FF00}%d sebagai jumlah hadiah untuk kuis.", pr);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "end", true, 3))
		{
			if (quiz == 0) return ErrorMsg(playerid, "Sayangnya tidak ada kuis dari admin server.");
			SendClientMessageToAll(0xFF0000FF, "Sayangnya Admin server telah mengakhiri kuis tersebut.");
			answermade = 0;
			quiz = 0;
			qprs = 0;
			answers = "";
		}
	}
	else return PermissionError(playerid);
	return 1;
}

CMD:answer(playerid, params[])
{
	new tmp[256], string[256];
	if (quiz == 0) return ErrorMsg(playerid, "Sayangnya tidak ada kuis dari admin server.");
	if (sscanf(params, "s[256]", tmp)) return SyntaxMsg(playerid, "/answer [jawaban]");
	if(strcmp(tmp, answers, true)==0)
	{
		GivePlayerMoneyEx(playerid, qprs);
		format(string, sizeof(string), "[QUIZ]: %s telah memberikan jawaban yang benar '%s' dari kuis dan mendapatkan hadiah {00FF00}%d.", ReturnName(playerid), answers, qprs);
		SendClientMessageToAll(0xFFFF00FF, string);
		answermade = 0;
		quiz = 0;
		qprs = 0;
		answers = "";
	}
	else
	{
		ErrorMsg(playerid,"Jawaban yang salah coba keberuntungan Anda lain kali.");
	}
	return 1;
}

CMD:hcmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Junior Helper Commands:"LB2_E"\n\
 	/aduty /h /asay /o /goto /sendto /get /freeze /unfreeze\n\
	/kick /slap /caps /acuff /auncuff /reports /ar /dr");

	strcat(line3, "\n\n"WHITE_E"Senior Helper Commands:"LB2_E"\n\
 	/spec /peject /astats /ostats /jetpack\n\
    /jail /unjail");

	strcat(line3, "\n\n"WHITE_E"Head Helper Commands:"LB2_E"\n\
	/respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs\n");
 	
	strcat(line3, "\n{B897FF}Warga Kota{FFFFFF} - Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Staff Commands", line3, "OK","");
	return true;
}

CMD:admins(playerid, params[])
{
	new count = 0, line3[512];
	if(pData[playerid][pAdmin] > 0)
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s(%s) (ID: %i)", line3, GetStaffRank(i), pData[i][pName], pData[i][pAdminname], i);
				count++;
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online!", "Close", "");
	}
	else
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				if(pData[i][pAdminDuty] == 1)
				{
					format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s (ID: %i)", line3, GetStaffRank(i), pData[i][pAdminname], i);
					count++;
				}
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online duty!", "Close", "");
	}
	return 1;
}

CMD:adminjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new count = 0, line3[512];
	foreach(new i:Player)
	{
		if(pData[i][pJail] > 0)
		{
			format(line3, sizeof(line3), "%s\n"WHITE_E"%s(ID: %d) [Jail Time: %d seconds]", line3, pData[i][pName], i, pData[i][pJailTime]);
			count++;
		}
	}
	if(count > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", line3, "Close", "");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", "There are no player in jail!", "Close", "");
	}
	return 1;
}

//---------------------------[ Admin Level 1 ]--------------------
CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	if(!strcmp(pData[playerid][pAdminname], "None"))
		return ErrorMsg(playerid, "Kamu harus setting Nama Admin mu!");
	
	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_PURPLE, "* %s telah on duty admin.", pData[playerid][pName]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_PURPLE, "* %s telah on helper duty.", pData[playerid][pName]);
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty]) 
            SetFactionColor(playerid);
        else 
            SetPlayerColor(playerid, COLOR_WHITE);
                
        SetPlayerName(playerid, pData[playerid][pName]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_PURPLE, "* %s telah off admin duty.", pData[playerid][pName]);
    }
	return 1;
}

CMD:asay(playerid, params[]) 
{
    new text[225];

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

    if(sscanf(params,"s[225]",text))
        return SyntaxMsg(playerid, "/asay [text]");
        
    SendClientMessageToAllEx(COLOR_PURPLE,"{ff0000}**[STAFF]** (%s{ff0000}) "YELLOW_E"%s: "LG_E"%s", GetStaffRank(playerid), pData[playerid][pAdminname], ColouredText(text));
    return 1;
}

CMD:h(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/h <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), "{1e90ff}[Helper Chat] (%s{1e90ff}) "WHITEP_E"%s(%i): {ffffff}%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	foreach(new ii : Player) 
	{
		if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] == 1)
		{
			SendClientMessage(ii, COLOR_LB, mstr);	
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] == 1)
			{
				SendClientMessage(ii, COLOR_LB, line);
			}
		}
	}
	return 1;
}

CMD:a(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/a <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), ""RED_E"[Admin Chat] {7fffd4}%s {ffff00}%s(%i): {ffffff}%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	foreach(new ii : Player) 
	{
		if(pData[ii][pAdmin] > 0)
		{
			SendClientMessage(ii, COLOR_LB, mstr);	
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pAdmin] > 0)
			{
				SendClientMessage(ii, COLOR_LB, line);
			}
		}
	}
	return true;
}

CMD:togooc(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

    if(TogOOC == 0)
    {
        SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s has disabled global OOC chat.", pData[playerid][pAdminname]);
        TogOOC = 1;
    }
    else
    {
        SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s has enabled global OOC chat (DON'T SPAM).", pData[playerid][pAdminname]);
        TogOOC = 0;
    }
    return 1;
}

CMD:o(playerid, params[])
{
    if(TogOOC == 1 && pData[playerid][pAdmin] < 1 && pData[playerid][pHelper] < 1) 
            return ErrorMsg(playerid, "An administrator has disabled global OOC chat.");

    if(isnull(params))
        return SyntaxMsg(playerid, "/o [global OOC]");

    /*if(pData[playerid][pDisableOOC])
        return ErrorMsg(playerid, "You must enable OOC chat first.");*/

    if(strlen(params) < 90)
    {
        foreach (new i : Player) if(pData[i][IsLoggedIn] == true && pData[i][pSpawned] == 1)
        {
            if(pData[playerid][pAdmin] == 1) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[MODERATOR] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 2) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[ADMIN JR] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 3) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[ADMIN] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 4) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[ADMIN SR] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 5) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[HEAD ADMIN] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
            else if(pData[playerid][pAdmin] == 6) SendClientMessageEx(i, COLOR_WHITE, "(( {FF0000}[CEO] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			else if(pData[playerid][pHelper] > 0 && pData[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(i, COLOR_WHITE, "(( {00FF00}[HELPER] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			}
            else
            {
                SendClientMessageEx(i, COLOR_WHITE, "(( {33FFCC}Player %s{FFFFFF} (%d): %s ))", pData[playerid][pName], playerid, params);
            }
        }
    }
    else
        return ErrorMsg(playerid, "The text to long, maximum character is 90");

    return 1;
}

CMD:id(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/id [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
		return ErrorMsg(playerid, "No player online or name is not found!");
	
	Servers(playerid, "Name: %s(ID: %d)", pData[otherid][pName], otherid);
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/goto [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SendPlayerToPlayer(playerid, otherid);
	Servers(otherid, "%s has been teleported to you.", pData[playerid][pName]);
	Servers(playerid, "You has teleport to %s position.", pData[otherid][pName]);
	return 1;
}

CMD:sendto(playerid, params[])
{
    static
        type[24],
		otherid;

    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);

    if(sscanf(params, "us[32]", otherid, type))
    {
        SyntaxMsg(playerid, "/send [player] [name]");
        InfoMsg(playerid, "[NAMES]:{FFFFFF} ls, lv, sf, ooczone");
        return 1;
    }
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!strcmp(type,"ls")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1788.1824,-1877.3479,13.6007);
        }
        else 
		{
            SetPlayerPosition(otherid,1788.1824,-1877.3479,13.6007,750);
        }
        SetPlayerFacingAngle(otherid,271.4230);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"sf")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),-1425.8307,-292.4445,14.1484);
        }
        else 
		{
            SetPlayerPosition(otherid,-1425.8307,-292.4445,14.1484,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"lv")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1686.0118,1448.9471,10.7695);
        }
        else 
		{
            SetPlayerPosition(otherid,1686.0118,1448.9471,10.7695,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"ooczone")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		        return ErrorMsg(playerid, "Pemain tersebut sedang menggunakan kendaraan");

		SetPlayerPosition(otherid, 2511.6230,698.3489,4996.7656,750);
		SetPlayerFacingAngle(otherid,179.4088);
		SetPlayerInterior(otherid, 1);
		SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
	    Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = 1;
	    pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
    }
    return 1;
}

CMD:get(playerid, params[])
{
    new otherid;

	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/get [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "The specified user(s) are not connected.");
	
	if(pData[playerid][pSpawned] == 0 || pData[otherid][pSpawned] == 0)
		return ErrorMsg(playerid, "Player/Target sedang tidak spawn!");
		
	if(pData[playerid][pJail] > 0 || pData[otherid][pJail] > 0)
		return ErrorMsg(playerid, "Player/Target sedang di jail");
		
	if(pData[playerid][pArrest] > 0 || pData[otherid][pArrest] > 0)
		return ErrorMsg(playerid, "Player/Target sedang di arrest");

	if(pData[playerid][pAdmin] < pData[otherid][pAdmin] > 0)
		return ErrorMsg(playerid, "Anda tidak dapat menarik Admin dengan level paling tinggi");

    SendPlayerToPlayer(otherid, playerid);

    Servers(playerid, "Anda menarik %s.", pData[otherid][pName]);
    Servers(otherid, "%s telah menarik mu.", pData[playerid][pName]);
    return 1;
}

CMD:freeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/freeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 1;

    TogglePlayerControllable(otherid, 0);
    Servers(playerid, "You have frozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been frozen movements by Admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/unfreeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 0;

    TogglePlayerControllable(otherid, 1);
    Servers(playerid, "You have unfrozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been unfrozen movements by Admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:arevive(playerid, params[])
{

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/arevive [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(!pData[otherid][pInjured])
        return ErrorMsg(playerid, "Tidak bisa revive karena tidak injured.");

    SetPlayerHealthEx(otherid, 100.0);
    pData[otherid][pInjured] = 0;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;

    ClearAnimations(otherid);

    SendStaffMessage(COLOR_PURPLE, "Staff %s have revived player %s.", pData[playerid][pAdminname], ReturnName(otherid));
    Info(otherid, "Staff %s has revived your character.", pData[playerid][pAdminname]);
    return 1;
}

CMD:spec(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);

    if(!isnull(params) && !strcmp(params, "off", true))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
            return ErrorMsg(playerid, "You are not spectating any player.");

		pData[pData[playerid][pSpec]][playerSpectated]--;
        PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
        PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

        SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, false);
		pData[playerid][pSpec] = -1;

        return Servers(playerid, "You are no longer in spectator mode.");
    }
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/spectate [playerid/PartOfName] - Type '/spec off' to stop spectating.");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(otherid == playerid)
		return ErrorMsg(playerid, "You can't spectate yourself bro..");

    if(pData[playerid][pAdmin] < pData[otherid][pAdmin])
        return ErrorMsg(playerid, "You can't spectate admin higher than you.");
		
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);

        pData[playerid][pInt] = GetPlayerInterior(playerid);
        pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(otherid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(otherid));

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(otherid))
	{
		new vID = GetPlayerVehicleID(otherid);
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(otherid));
		if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
	    {
	    	Servers(playerid, "You are now spectating %s(%i) who is driving a %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
		else
		{
		    Servers(playerid, "You are now spectating %s(%i) who is a passenger in %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
	}
    else
	{
        PlayerSpectatePlayer(playerid, otherid);
	}
	pData[otherid][playerSpectated]++;
    SendStaffMessage(COLOR_PURPLE, "%s now spectating %s (ID: %d).", pData[playerid][pAdminname], pData[otherid][pName], otherid);
    Servers(playerid, "You are now spectating %s (ID: %d).", pData[otherid][pName], otherid);
    pData[playerid][pSpec] = otherid;
    return 1;
}

CMD:slap(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new Float:POS[3], otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/slap <ID>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	SetPlayerPos(otherid, POS[0], POS[1], POS[2] + 9.0);
	if(IsPlayerInAnyVehicle(otherid)) 
	{
		RemovePlayerFromVehicle(otherid);
		//OnPlayerExitVehicle(otherid, GetPlayerVehicleID(otherid));
	}
	SendStaffMessage(COLOR_PURPLE, "Admin %s telah men-slap player %s", pData[playerid][pAdminname], pData[otherid][pName]);

	PlayerPlaySound(otherid, 1130, 0.0, 0.0, 0.0);
	return 1;
}

CMD:caps(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
 	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/caps <ID>");
	    InfoMsg(playerid, "Function: Will disable caps for the player, type again to enable caps.");
	    return 1;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!GetPVarType(otherid, "Caps"))
	{
	    // Disable Caps
	    SetPVarInt(otherid, "Caps", 1);
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah menon-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	else
	{
	    // Enable Caps
		DeletePVar(otherid, "Caps");
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah meng-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	return 1;
}

CMD:peject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/peject <ID>");
	    return 1;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!IsPlayerInAnyVehicle(otherid))
	{
		ErrorMsg(playerid, "Player tersebut tidak berada dalam kendaraan!");
		return 1;
	}

	new vv = GetVehicleModel(GetPlayerVehicleID(otherid));
	Servers(playerid, "You have successfully ejected %s(%i) from their %s.", pData[otherid][pName], otherid, GetVehicleModelName(vv - 400));
	Servers(otherid, "%s(%i) has ejected you from your %s.", pData[playerid][pName], playerid, GetVehicleModelName(vv));
	RemovePlayerFromVehicle(otherid);
	return 1;
}

CMD:aitems(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/aitems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return ErrorMsg(playerid, "That player is not logged in yet.");
		
	DisplayItems(playerid, otherid);
	return 1;
}

CMD:astats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/check [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return ErrorMsg(playerid, "That player is not logged in yet.");

	DisplayStats(playerid, otherid);
	return 1;
}

CMD:ostats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new name[24], PlayerName[24];
	if(sscanf(params, "s[24]", name))
	{
	    SyntaxMsg(playerid, "/ostats <player name>");
 		return 1;
 	}

 	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		if(!strcmp(PlayerName, name, true))
		{
			ErrorMsg(playerid, "Player is online, you can use /stats on them.");
	  		return 1;
	  	}
	}

	// Load User Data
    new cVar[500];
    new cQuery[600];

	strcat(cVar, "email,admin,helper,level,levelup,vip,vip_time,gold,reg_date,last_login,money,bmoney,brek,hours,minutes,seconds,");
	strcat(cVar, "gender,age,faction,family,warn,job,job2,interior,world");

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT %s FROM players WHERE username='%e' LIMIT 1", cVar, name);
	mysql_tquery(g_SQL, cQuery, "LoadStats", "is", playerid, name);
	return true;
}

CMD:acuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid, mstr[128];		
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/acuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return ErrorMsg(playerid, "You cannot handcuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "You must be near this player.");

    if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
        return ErrorMsg(playerid, "The player must be onfoot before you can cuff them.");

    if(pData[otherid][pCuffed])
        return ErrorMsg(playerid, "The player is already cuffed at the moment.");

    pData[otherid][pCuffed] = 1;
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);

    format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, mstr);

    Servers(playerid, "Player %s telah berhasil di cuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah mengcuffed anda.", pData[playerid][pName]);
    return 1;
}

CMD:auncuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/auncuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return ErrorMsg(playerid, "You cannot uncuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return ErrorMsg(playerid, "The player is not cuffed at the moment.");

    static
        string[64];

    pData[otherid][pCuffed] = 0;
    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

    format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, string);
	Servers(playerid, "Player %s telah berhasil uncuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah uncuffed tangan anda.", pData[playerid][pName]);
    return 1;
}

CMD:jetpack(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    }
    else
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(otherid, SPECIAL_ACTION_USEJETPACK);
        Servers(playerid, "You have spawned a jetpack for %s.", pData[otherid][pName]);
    }
    return 1;
}

CMD:getip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
		
	new otherid, PlayerIP[16], giveplayer[24];
	if(sscanf(params, "u", otherid))
 	{
  		SyntaxMsg(playerid, "/getip <ID>");
		return 1;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		ErrorMsg(playerid, "You can't get the server owners ip!");
  		Servers(otherid, "%s(%i) tried to get your IP!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	Servers(playerid, "%s(%i)'s IP: %s", giveplayer, otherid, PlayerIP);
	return 1;
}

CMD:aka(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new otherid, PlayerIP[16], query[128];
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/aka <ID/Name>");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		ErrorMsg(playerid, "You can't AKA the server owner!");
  		Servers(otherid, "%s(%i) tried to AKA you!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", PlayerIP);
	mysql_tquery(g_SQL, query, "CheckPlayerIP", "is", playerid, PlayerIP);
	return true;
}

CMD:akaip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new query[128];
	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/akaip <IP>");
		return true;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", params);
	mysql_tquery(g_SQL, query, "CheckPlayerIP2", "is", playerid, params);
	return true;
}

CMD:vmodels(playerid, params[])
{
    new string[3500];

    if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);

    for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
    {
        format(string,sizeof(string), "%s%d - %s\n", string, i+400, g_arrVehicleNames[i]);
    }
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vehicle Models", string, "Close", "");
    return 1;
}

CMD:vehname(playerid, params[]) {

	if(pData[playerid][pAdmin] >= 1) 
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle Search:");

		new
			string[128];

		if(isnull(params)) return ErrorMsg(playerid, "No keyword specified.");
		if(!params[2]) return ErrorMsg(playerid, "Search keyword too short.");

		for(new v; v < sizeof(g_arrVehicleNames); v++) 
		{
			if(strfind(g_arrVehicleNames[v], params, true) != -1) {

				if(isnull(string)) format(string, sizeof(string), "%s (ID %d)", g_arrVehicleNames[v], v+400);
				else format(string, sizeof(string), "%s | %s (ID %d)", string, g_arrVehicleNames[v], v+400);
			}
		}

		if(!string[0]) ErrorMsg(playerid, "No results found.");
		else if(string[127]) ErrorMsg(playerid, "Too many results found.");
		else SendClientMessageEx(playerid, COLOR_WHITE, string);

		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	else
	{
		PermissionError(playerid);
	}
	return 1;
}

CMD:owarn(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);
	
	new player[24], tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[50]", player, tmp))
		return SyntaxMsg(playerid, "/owarn <name> <reason>");

	if(strlen(tmp) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /warn on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id,warn FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OWarnPlayer", "iss", playerid, player, tmp);
	return 1;
}

function OWarnPlayer(adminid, NameToWarn[], warnReason[])
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {B897FF}'%s' "WHITE_E"does not exist.", NameToWarn);
	}
	else
	{
	    new RegID, warn;
		cache_get_value_index_int(0, 0, RegID);
		cache_get_value_index_int(0, 1, warn);
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah memberi warning(offline) player %s. [Reason: %s]", pData[adminid][pAdminname], NameToWarn, warnReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET warn=%d WHERE reg_id=%d", warn+1, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:ojail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);

	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return SyntaxMsg(playerid, "/ojail <name> <time in minutes)> <reason>");

	if(strlen(tmp) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");
	if(datez < 1 || datez > 60)
	{
 		if(pData[playerid][pAdmin] < 5)
   		{
			ErrorMsg(playerid, "Jail time must remain between 1 and 60 minutes");
  			return 1;
   		}
	}
	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /jail on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OJailPlayer", "issi", playerid, player, tmp, datez);
	return 1;
}

function OJailPlayer(adminid, NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {B897FF}'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60;
		cache_get_value_index_int(0, 0, RegID);

		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah menjail(offline) player %s selama %d menit. [Reason: %s]", pData[adminid][pAdminname], NameToJail, jailTime, jailReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:jail(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new reason[60], timeSec, otherid;
	if(sscanf(params, "uD(15)S(*)[60]", otherid, timeSec, reason))
	{
	    SyntaxMsg(playerid, "/jail <ID/Name> <time in minutes> <reason>)");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] > 0)
	{
	    Servers(playerid, "%s(%i) is already jailed (gets out in %d minutes)", pData[otherid][pName], otherid, pData[otherid][pJailTime]);
	    InfoMsg(playerid, "/unjail <ID/Name> to unjail.");
	    return true;
	}
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}
	if(reason[0] != '*' && strlen(reason) > 60)
	{
	 	ErrorMsg(playerid, "Reason too long! Must be smaller than 60 characters!");
	   	return true;
	}
	if(timeSec < 1 || timeSec > 60)
	{
	    if(pData[playerid][pAdmin] < 5)
	 	{
			ErrorMsg(playerid, "Jail time must remain between 1 and 60 minutes");
	    	return 1;
	  	}
	}
	pData[otherid][pJail] = 1;
	pData[otherid][pJailTime] = timeSec * 60;
	JailPlayer(otherid);
	if(reason[0] == '*')
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah menjail player %s selama %d menit.", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah menjail player %s selama %d menit. [Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], timeSec, reason);
		//anticheatlogs
		new DCC_Embed:logss;
		new yy, mm, dd, timestamp[200];
		getdate(yy, mm , dd);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, mm, dd);
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "Warga Kota");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0xff0000);
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		DCC_SetEmbedDescription(logss, "Player Jail");
		new stroi[5000];
		format(stroi, sizeof(stroi), "%s", UcpData[otherid][uUsername]);
		DCC_AddEmbedField(logss, "Nama UCP", stroi, true);
		format(stroi, sizeof(stroi), "%s", pData[otherid][pName]);
		DCC_AddEmbedField(logss, "Character", stroi, true);
		format(stroi, sizeof(stroi), "%s", reason);
		DCC_AddEmbedField(logss, "Reason", stroi, true);
		format(stroi, sizeof(stroi), "%d", timeSec);
		DCC_AddEmbedField(logss, "Time Jailed", stroi, true);
		format(stroi, sizeof(stroi), "%s", pData[playerid][pAdminname]);
		DCC_AddEmbedField(logss, "Punishment By", stroi, true);
		DCC_SendChannelEmbedMessage(cheatlogs, logss);
	}
	return 1;
}


CMD:unjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/unjail <ID/Name>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] == 0)
	    return ErrorMsg(playerid, "The player isn't in jail!");

	pData[otherid][pJail] = 0;
	pData[otherid][pJailTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPos(otherid, 1529.6,-1691.2,13.3);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah unjailed %s", pData[playerid][pAdminname], pData[otherid][pName]);
	return true;
}

CMD:kick(playerid, params[])
{
    static
        reason[128];

	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "us[128]", otherid, reason))
        return SyntaxMsg(playerid, "/kick [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return ErrorMsg(playerid, "The specified player has higher authority.");

    SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} %s was kicked by Admin %s. Reason: %s.", pData[otherid][pName], pData[playerid][pAdminname], reason);
    //cheatlogs
	new DCC_Embed:logss;
	new yy, m, d, timestamp[200];

	getdate(yy, m , d);

	format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
	logss = DCC_CreateEmbed("");
	DCC_SetEmbedTitle(logss, "LOGS KICK/BANNED");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
	DCC_SetEmbedUrl(logss, "");
	DCC_SetEmbedThumbnail(logss, "");
	DCC_SetEmbedFooter(logss, "", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] was kicked by Admin %s | Reason: %s.", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID], pData[playerid][pAdminname], reason);
	DCC_AddEmbedField(logss, "", stroi, true);
	DCC_SendChannelEmbedMessage(cheatlogs, logss);
	//Log_Write("logs/kick_log.txt", "[%s] %s has kicked %s for: %s.", ReturnTime(), ReturnName(otherid, 0), ReturnName(otherid, 0), reason);
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
    KickEx(otherid);
    return 1;
}

CMD:ban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	new ban_time, datez, tmp[60], otherid;
	if(sscanf(params, "uds[60]", otherid, datez, tmp))
	{
	    SyntaxMsg(playerid, "/tempban <ID/Name> <time (in days) 0 for permanent> <reason> ");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
 	if(datez < 0) ErrorMsg(playerid, "Please input a valid ban time.");
	if(pData[playerid][pAdmin] < 2)
	{
		if(datez > 10 || datez <= 0) return ErrorMsg(playerid, "Anda hanya dapat membanned selama 1-10 hari!");
	}
	/*if(otherid == playerid)
	    return ErrorMsg(playerid, "You are not able to ban yourself!");*/
	if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
	{
		Servers(otherid, "** %s(%i) has just tried to ban you!", pData[playerid][pName], playerid);
 		ErrorMsg(playerid, "You are not able to ban a admin with a higher level than you!");
 		return true;
   	}
	new PlayerIP[16], giveplayer[24];
	
   	//SetPlayerPosition(otherid, 405.1100,2474.0784,35.7369,360.0000);
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	if(!strcmp(tmp, "ab", true)) tmp = "Airbreak";
	else if(!strcmp(tmp, "ad", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "ads", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "hh", true)) tmp = "Health Hacks";
	else if(!strcmp(tmp, "wh", true)) tmp = "Weapon Hacks";
	else if(!strcmp(tmp, "sh", true)) tmp = "Speed Hacks";
	else if(!strcmp(tmp, "mh", true)) tmp = "Money Hacks";
	else if(!strcmp(tmp, "rh", true)) tmp = "Ram Hacks";
	else if(!strcmp(tmp, "ah", true)) tmp = "Ammo Hacks";
	if(datez != 0)
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah membanned player %s selama %d hari. [Reason: %s]", pData[playerid][pAdminname], giveplayer, datez, tmp);
		//cheatlogs
		new DCC_Embed:logss;
		new yy, m, d, timestamp[200];

		getdate(yy, m , d);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "LOGS KICK/BANNED");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0xb897ff); //0xffa500 
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		new stroi[5000];
		format(stroi, sizeof(stroi), "**[BANNED]** __%s__ was **BANNED** by admin %s. | Selama: __%d__ Hari | Reason: __%s__.", giveplayer, pData[playerid][pAdminname], datez, tmp);
		DCC_AddEmbedField(logss, "", stroi, true);
		DCC_SendChannelEmbedMessage(cheatlogs, logss);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah membanned permanent player %d. {FFFFFF}[Reason: %s]", pData[playerid][pAdminname], giveplayer, tmp);
		//cheatlogs
		new DCC_Embed:logss;
		new yy, m, d, timestamp[200];

		getdate(yy, m , d);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "LOGS KICK/BANNED");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0xb897ff); //0xffa500 
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		new stroi[5000];
		format(stroi, sizeof(stroi), "**[BANNED]** __%s__ was **BANNED PERMANENT** by admin %s. Reason: __%s__.", giveplayer, pData[playerid][pAdminname], tmp);
		DCC_AddEmbedField(logss, "", stroi, true);
		DCC_SendChannelEmbedMessage(cheatlogs, logss);
	}
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
	BanPlayerMSG(otherid, playerid, tmp);
 	if(datez != 0)
    {
		Servers(otherid, "This is a "RED_E"TEMP-BAN {B897FF}that will last for %d days.", datez);
		ban_time = gettime() + (datez * 86400);
	}
	else
	{
		Servers(otherid, "This is a "RED_E"Permanent Banned {B897FF}please contack admin for unbanned!.", datez);
		ban_time = datez;
	}
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, pData[playerid][pAdminname], tmp, gettime(), ban_time);
	mysql_tquery(g_SQL, query);
	KickEx(otherid);
	return true;
}

CMD:unban(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);
	
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))
	{
	    SyntaxMsg(playerid, "/unban <ban name>");
	    return true;
	}
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT name,ip FROM banneds WHERE name = '%e'", tmp);
	mysql_tquery(g_SQL, query, "OnUnbanQueryData", "is", playerid, tmp);
	return 1;
}

function OnUnbanQueryData(adminid, BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new banIP[16], query[128];
		cache_get_value_name(0, "ip", banIP);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE ip = '%s'", banIP);
		mysql_tquery(g_SQL, query);

		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} %s(%i) has unbanned %s from the server.", pData[adminid][pAdminname], adminid, BannedName);
	}
	else
	{
		Error(adminid, "No player named '%s' found on the ban list.", BannedName);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
    static
        reason[32];

    if(pData[playerid][pAdmin] < 1)
        if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "us[32]", otherid, reason))
        return SyntaxMsg(playerid, "/warn [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return ErrorMsg(playerid, "The specified player has higher authority.");

	pData[otherid][pWarn]++;
	SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah memberikan warning kepada player %s [Reason: %s] [Total Warning: %d/20{FFFFFF}]", pData[playerid][pAdminname], pData[otherid][pName], reason, pData[otherid][pWarn]);
    return 1;
}

CMD:unwarn(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/unwarn [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[otherid][pWarn] -= 1;
    Servers(playerid, "You have unwarned 1 point %s's warnings.", pData[otherid][pName]);
	Servers(otherid, "%s has unwarned 1 point your warnings.", pData[playerid][pAdminname]);
    SendStaffMessage(COLOR_PURPLE, "Admin %s has unwarned 1 point to %s's warnings.", pData[playerid][pAdminname], pData[otherid][pName]);
    return 1;
}

CMD:respawnsapd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAPDVehicles);x++)
	{
		if(IsVehicleEmpty(SAPDVehicles[x]))
		{
			SetVehicleToRespawn(SAPDVehicles[x]);
			SetValidVehicleHealth(SAPDVehicles[x], 2000);
			SetVehicleFuel(SAPDVehicles[x], 100);
			SwitchVehicleDoors(SAPDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PURPLE, "%s has respawned SAPD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsags(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAGSVehicles);x++)
	{
		if(IsVehicleEmpty(SAGSVehicles[x]))
		{
			SetVehicleToRespawn(SAGSVehicles[x]);
			SetValidVehicleHealth(SAGSVehicles[x], 2000);
			SetVehicleFuel(SAGSVehicles[x], 100);
			SwitchVehicleDoors(SAGSVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PURPLE, "%s has respawned SAGS vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsamd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAMDVehicles);x++)
	{
		if(IsVehicleEmpty(SAMDVehicles[x]))
		{
			SetVehicleToRespawn(SAMDVehicles[x]);
			SetValidVehicleHealth(SAMDVehicles[x], 2000);
			SetVehicleFuel(SAMDVehicles[x], 100);
			SwitchVehicleDoors(SAMDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PURPLE, "%s has respawned SAMD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsana(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SANAVehicles);x++)
	{
		if(IsVehicleEmpty(SANAVehicles[x]))
		{
			SetVehicleToRespawn(SANAVehicles[x]);
			SetValidVehicleHealth(SANAVehicles[x], 2000);
			SetVehicleFuel(SANAVehicles[x], 100);
			SwitchVehicleDoors(SANAVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PURPLE, "Admin %s has respawned SANA vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnjobs(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SweepVeh);x++)
	{
		if(IsVehicleEmpty(SweepVeh[x]))
		{
			SetVehicleToRespawn(SweepVeh[x]);
			SetValidVehicleHealth(SweepVeh[x], 2000);
			SetVehicleFuel(SweepVeh[x], 100);
			SwitchVehicleDoors(SweepVeh[x], false);
		}
	}
	for(new xx;xx<sizeof(BaggageVeh);xx++)
	{
		if(IsVehicleEmpty(BaggageVeh[xx]))
		{
			SetVehicleToRespawn(BaggageVeh[xx]);
			SetValidVehicleHealth(BaggageVeh[xx], 2000);
			SetVehicleFuel(BaggageVeh[xx], 1000);
			SwitchVehicleDoors(BaggageVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(BusVeh);xx++)
	{
		if(IsVehicleEmpty(BusVeh[xx]))
		{
			SetVehicleToRespawn(BusVeh[xx]);
			SetValidVehicleHealth(BusVeh[xx], 2000);
			SetVehicleFuel(BusVeh[xx], 100);
			SwitchVehicleDoors(BusVeh[xx], false);
		}
	}
	/*for(new xx;xx<sizeof(KurirCar);xx++)
	{
		if(IsVehicleEmpty(KurirCar[xx]))
		{
			SetVehicleToRespawn(KurirCar[xx]);
			SetValidVehicleHealth(KurirCar[xx], 2000);
			SetVehicleFuel(KurirCar[xx], 1000);
			SwitchVehicleDoors(KurirCar[xx], false);
		}
	}*/
	for(new xx;xx<sizeof(ForVeh);xx++)
	{
		if(IsVehicleEmpty(ForVeh[xx]))
		{
			SetVehicleToRespawn(ForVeh[xx]);
			SetValidVehicleHealth(ForVeh[xx], 2000);
			SetVehicleFuel(ForVeh[xx], 100);
			SwitchVehicleDoors(ForVeh[xx], false);
		}
	}
	SendStaffMessage(COLOR_PURPLE, "Admin %s has respawned Jobs vehicles.", pData[playerid][pAdminname]);
	return 1;
}

RespawnNearbyVehicles(playerid, Float:radi)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i=1; i<MAX_VEHICLES; i++)
    {
        if(GetVehicleModel(i))
        {
            new Float:posx, Float:posy, Float:posz;
            new Float:tempposx, Float:tempposy, Float:tempposz;
            GetVehiclePos(i, posx, posy, posz);
            tempposx = (posx - x);
            tempposy = (posy - y);
            tempposz = (posz - z);
            if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
            {
				if(IsVehicleEmpty(i))
				{
					//SetVehicleToRespawn(i);
					SetTimerEx("RespawnPV", 3000, false, "d", i);
					SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s telah merespawn kendaraan disekitar dengan radius %d.", pData[playerid][pAdminname], radi);
					SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Jika kendaraan lumber pribadi anda terkena respawn admin gunakan /v park untuk meload kembali lumber anda!");
				}
			}
        }
    }
}

CMD:respawnrad(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
		
	new rad;
	if(sscanf(params, "d", rad)) return SyntaxMsg(playerid, "/respawnrad [radius] | respawn vehicle nearest");
	
	if(rad > 50) return ErrorMsg(playerid, "Maximal 50 radius");
	RespawnNearbyVehicles(playerid, rad);
	return 1;
}

//----------------------------[ Admin Level 2 ]-----------------------
CMD:sethp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/sethp [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SetPlayerHealthEx(otherid, jumlah);
	SendStaffMessage(COLOR_PURPLE, "%s{FFFFFF} telah men set jumlah hp player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set hp anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setbone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setbone [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pHead] = jumlah;
	pData[otherid][pPerut] = jumlah;
	pData[otherid][pLFoot] = jumlah;
	pData[otherid][pRFoot] = jumlah;
	pData[otherid][pLHand] = jumlah;
	pData[otherid][pRHand] = jumlah;
	SendStaffMessage(COLOR_PURPLE, "%s telah men set jumlah Kondisi tulang Player %s ", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set Kondisi tulang anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setam [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(jumlah > 95)
	{
		SetPlayerArmourEx(otherid, 98);
	}
	else
	{
		SetPlayerArmourEx(otherid, jumlah);
	}
	SendStaffMessage(COLOR_PURPLE, "%s{FFFFFF} telah men set jumlah armor player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set armor anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:afuel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);

	if(IsPlayerInAnyVehicle(playerid)) 
	{
		SetVehicleFuel(GetPlayerVehicleID(playerid), 100);
		Servers(playerid, "Vehicle Fueled!");
	}
	else
	{
		ErrorMsg(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:afix(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);
	
    if(IsPlayerInAnyVehicle(playerid)) 
	{
        SetValidVehicleHealth(GetPlayerVehicleID(playerid), 1000);
		ValidRepairVehicle(GetPlayerVehicleID(playerid));
        Servers(playerid, "Vehicle Fixed!");
    }
	else
	{
		ErrorMsg(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:setjob1(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return SyntaxMsg(playerid, "/setjob1 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(jobid < 0 || jobid > 7)
        return ErrorMsg(playerid, "Invalid ID. 0 - 7.");
		
	pData[otherid][pJob] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job1 player %d(%d){FFFFFF} menjadi %d(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job1 anda menjadi %d(%d)", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setjob2(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return SyntaxMsg(playerid, "/setjob2 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(jobid < 0 || jobid > 7)
        return ErrorMsg(playerid, "Invalid ID. 0 - 7.");
		
	pData[otherid][pJob2] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job2 player %d(%d){FFFFFF} menjadi %d(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job2 anda menjadi %d(%d){FFFFFF}", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new
        skinid,
		otherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, skinid))
        return SyntaxMsg(playerid, "/skin [playerid/PartOfName] [skin id]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(skinid < 0 || skinid > 299)
        return ErrorMsg(playerid, "Invalid skin ID. Skins range from 0 to 299.");

    SetPlayerSkin(otherid, skinid);
	pData[otherid][pSkin] = skinid;

    Servers(playerid, "You have set %s's skin to ID: %d.", ReturnName(otherid), skinid);
    Servers(otherid, "%s has set your skin to ID: %d.", ReturnName(playerid), skinid);
    return 1;
}

CMD:akill(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	new reason[60], otherid;
	if(sscanf(params, "uS(*)[60]", otherid, reason))
	{
	    SyntaxMsg(playerid, "/akill <ID/Name> <optional: reason>");
	    return 1;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	SetPlayerHealth(otherid, 0.0);

	if(reason[0] != '*')
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Servers: Admin %s has killed %s "GREY_E"[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], reason);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PURPLE, "Servers: Admin %s has killed %s", pData[playerid][pAdminname], pData[otherid][pName]);
	}
	return 1;
}

CMD:ann(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

 	if(isnull(params))
    {
	    SyntaxMsg(playerid, "/announce <msg>");
	    return 1;
	}
	// Check for special trouble-making input
   	if(strfind(params, "~x~", true) != -1)
		return ErrorMsg(playerid, "~x~ is not allowed in announce.");
	if(strfind(params, "#k~", true) != -1)
		return ErrorMsg(playerid, "The constant key is not allowed in announce.");
	if(strfind(params, "/q", true) != -1)
		return ErrorMsg(playerid, "You are not allowed to type /q in announcement!");

	// Count tildes (uneven number = faulty input)
	new iTemp = 0;
	for(new i = (strlen(params)-1); i != -1; i--)
	{
		if(params[i] == '~')
			iTemp ++;
	}
	if(iTemp % 2 == 1)
		return ErrorMsg(playerid, "You either have an extra ~ or one is missing in the announcement!");
	
	new str[512];
	format(str, sizeof(str), "~w~%s", params);
	GameTextForAll(str, 6500, 3);
	return true;
}

CMD:settime(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

	new time, mstr[128];
	if(sscanf(params, "d", time))
	{
		SyntaxMsg(playerid, "/time <time ID>");
		return true;
	}

	SendClientMessageToAllEx(COLOR_PURPLE, "{B897FF}Server: {FFFFFF}Admin %s(%i){FFFFFF} has changed the time to: "YELLOW_E"%d", pData[playerid][pAdminname], playerid, time);

	format(mstr, sizeof(mstr), "~r~Time changed: ~b~%d", time);
	GameTextForAll(mstr, 3000, 5);

	SetWorldTime(time);
	WorldTime = time;
	foreach(new ii : Player)
	{
		SetPlayerTime(ii, time, 0);
	}
	return 1;
}

CMD:setweather(playerid, params[])
{
    new weatherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "d", weatherid))
        return SyntaxMsg(playerid, "/setweather [weather ID]");

    SetWeather(weatherid);
	WorldWeather = weatherid;
	foreach(new ii : Player)
	{
		SetPlayerWeather(ii, weatherid);
	}
    SetGVarInt("g_Weather", weatherid);
    SendClientMessageToAllEx(COLOR_PURPLE,"{B897FF}Server: {FFFFFF}%s have changed the weather ID", pData[playerid][pAdminname]);
    Servers(playerid, "You have changed the weather to ID: %d.", weatherid);
    return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
		
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return SyntaxMsg(playerid, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

	SuccesMsg(playerid, "Anda telah terteleportasi ke kordinat tersebut.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:cd(playerid)
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(Count != -1) return ErrorMsg(playerid, "There is already a countdown in progress, wait for it to end!");

	Count = 6;
	countTimer = SetTimer("pCountDown", 1000, 1);

	foreach(new ii : Player)
	{
		showCD[ii] = 1;
	}
	SendClientMessageToAllEx(COLOR_PURPLE, "[SERVER] "LB_E"Admin %s has started a global countdown!", pData[playerid][pAdminname]);
	return 1;
}

//---------------[ Admin Level 3 ]------------
CMD:oban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	    return PermissionError(playerid);

	new player[24], datez, reason[50];
	if(sscanf(params, "s[24]D(0)s[50]", player, datez, reason))
	{
	    SyntaxMsg(playerid, "/oban <ban name> <time in days (0 for permanent ban)> <reason>");
	    InfoMsg(playerid, "Will ban a player while he is offline. If time isn't specified it will be a perm ban.");
	    return true;
	}
	if(strlen(reason) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		new PlayerName[24];
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /ban on him.");
	  		return true;
	  	}
	}

	new query[128];

	mysql_format(g_SQL, query, sizeof(query), "SELECT ip FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OnOBanQueryData", "issi", playerid, player, reason, datez);
	return true;
}

CMD:banip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/banip <IP Address>");
		return true;
	}
	if(strfind(params, "*", true) != -1 && pData[playerid][pAdmin] != 5)
	{
		ErrorMsg(playerid, "You are not authorized to ban ranges.");
  		return true;
  	}

	SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%d){FFFFFF} IP banned address %d.", pData[playerid][pAdminname], playerid, params);
	
	new tstr[128];
	format(tstr, sizeof(tstr), "banip %s", params);
	SendRconCommand(tstr);
	return 1;
}

CMD:unbanip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/unbanip <IP Address>");
		return true;
	}
	new mstr[128];
	format(mstr, sizeof(mstr), "unbanip %s", params);
	SendRconCommand(mstr);
	format(mstr, sizeof(mstr), "reloadbans");
	SendRconCommand(mstr);
	Servers(playerid, "You have unbanned IP address %s.", params);
	return 1;
}

CMD:reloadweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/reloadweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    SetWeapons(otherid);
    Servers(playerid, "You have reload %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reload your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:resetweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/resetweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    ResetPlayerWeaponsEx(otherid);
    Servers(playerid, "You have reset %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reset your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:setlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setlevel [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pLevel] = jumlah;
	SetPlayerScore(otherid, jumlah);
	SendStaffMessage(COLOR_PURPLE, "%s{FFFFFF} telah men set jumlah level player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set level anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:sethbe(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/sethbe [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pHunger] = jumlah;
	pData[otherid][pEnergy] = jumlah;
	pData[otherid][pBladder] = jumlah;
	pData[otherid][pSick] = 0;
	SetPlayerDrunkLevel(playerid, 0);
	SendStaffMessage(COLOR_PURPLE, "%s{FFFFFF} telah men set jumlah hbe player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set HBE anda", pData[playerid][pAdminname]);
	return 1;
}

//----------------------------[ Admin Level 4 ]---------------
CMD:setname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	new otherid, tmp[20];
	if(sscanf(params, "is[20]", otherid, tmp))
	{
	   	SyntaxMsg(playerid, "/setname <ID/Name> <newname>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return ErrorMsg(playerid, "Player belum masuk!");
	if(pData[otherid][IsLoggedIn] == false)	return ErrorMsg(playerid, "That player is not logged in.");
	
	if(strlen(tmp) < 4) return ErrorMsg(playerid, "New name can't be shorter than 4 characters!");
	if(strlen(tmp) > 20) return ErrorMsg(playerid, "New name can't be longer than 20 characters!");

	if(!IsValidName(tmp)) return ErrorMsg(playerid, "Name contains invalid characters, please doublecheck!");
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", tmp);
	mysql_tquery(g_SQL, query, "SetName", "iis", otherid, playerid, tmp);
	return 1;
}


// SetName Callback
function SetName(otherplayer, playerid, nname[])
{
	if(!cache_num_rows())
	{
		new oldname[24], newname[24], query[248];
		GetPlayerName(otherplayer, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(otherplayer, "Admin %s telah mengganti nickname anda menjadi (%s)", pData[playerid][pAdminname], nname);
		Info(otherplayer, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_PURPLE, "Admin %s telah mengganti nickname player %d(%d){FFFFFF} menjadi %s", pData[playerid][pAdminname], oldname, otherplayer, nname);
		
		SetPlayerName(otherplayer, nname);
		GetPlayerName(otherplayer, newname, sizeof(newname));
		pData[otherplayer][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		if(pData[otherplayer][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
	}
    return 1;
}

function ChangeName(playerid, nname[])
{
	if(!cache_num_rows())
	{
		if(pData[playerid][pGold] < 500) return ErrorMsg(playerid, "Not enough gold!");
		pData[playerid][pGold] -= 500;
		
		new oldname[24], newname[24], query[248];
		GetPlayerName(playerid, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(playerid, "Anda telah mengganti nickname anda menjadi (%s)", nname);
		InfoMsg(playerid, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_PURPLE, "Player %d(%d){FFFFFF} telah mengganti nickname menjadi %d(%d){FFFFFF}", oldname, playerid, nname, playerid);
		
		SetPlayerName(playerid, nname);
		GetPlayerName(playerid, newname, sizeof(newname));
		pData[playerid][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
		return 1;
	}
    return 1;
}

CMD:setbooster(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	
	new dayz, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, dayz))
	{
	    SyntaxMsg(playerid, "/setbooster <ID/Name> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	if(dayz < 0)
		return ErrorMsg(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return ErrorMsg(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pBooster] = 1;
	if(dayz == 0)
	{
		pData[otherid][pBoostTime] = 0;
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%d){FFFFFF} telah menset Roleplay Booster kepada %s(%d) ke level permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid);
	}
	else
	{
		pData[otherid][pBoostTime] = gettime() + (dayz * 86400);
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%d){FFFFFF} telah menset Roleplay Booster kepada %s(%d) selama %d hari!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz);
	}
	
	format(tmp, sizeof(tmp), "(%d days)", dayz);
	StaffCommandLog("SETBOOSTER", playerid, otherid, tmp);
	return 1;
}

CMD:setvip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	
	new alevel, dayz, otherid, tmp[64];
	if(sscanf(params, "udd", otherid, alevel, dayz))
	{
	    SyntaxMsg(playerid, "/setvip <ID/Name> <level 0 - 3> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	if(alevel > 3)
		return ErrorMsg(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return ErrorMsg(playerid, "Level can't be lower than 0!");
	if(dayz < 0)
		return ErrorMsg(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return ErrorMsg(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pVip] = alevel;
	if(dayz == 0)
	{
		pData[otherid][pVipTime] = 0;
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%d){FFFFFF} telah menset VIP kepada %s(%d) ke level %s permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, GetVipRank(otherid));
	}
	else
	{
		pData[otherid][pVipTime] = gettime() + (dayz * 86400);
		SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%d){FFFFFF} telah menset VIP kepada %s(%d) selama %d hari ke level %s!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz, GetVipRank(otherid));
	}
	
	format(tmp, sizeof(tmp), "%d(%d days)", alevel, dayz);
	StaffCommandLog("SETVIP", playerid, otherid, tmp);
	return 1;
}

CMD:giveweap(playerid, params[])
{
    static
        weaponid,
        ammo;
		
	new otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udI(250)", otherid, weaponid, ammo))
        return SyntaxMsg(playerid, "/givewep [playerid/PartOfName] [weaponid] [ammo]");

    if(otherid == INVALID_PLAYER_ID)
        return ErrorMsg(playerid, "You cannot give weapons to disconnected players.");


    if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return ErrorMsg(playerid, "You have specified an invalid weapon.");

    if(ammo < 1 || ammo > 500)
        return ErrorMsg(playerid, "You have specified an invalid weapon ammo, 1 - 500");

    GivePlayerWeaponEx(otherid, weaponid, ammo);
    Servers(playerid, "You have give %s a %s with %d ammo.", pData[otherid][pName], ReturnWeaponName(weaponid), ammo);
    return 1;
}

CMD:setfaction(playerid, params[])
{
	new fid, rank, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udd", otherid, fid, rank))
        return SyntaxMsg(playerid, "/setfaction [playerid/PartOfName] [1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW 5.PEDAGANG] [rank 1-6]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return ErrorMsg(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 5)
        return ErrorMsg(playerid, "You have specified an invalid faction ID 0 - 5.");
		
	if(rank < 1 || rank > 6)
        return ErrorMsg(playerid, "You have specified an invalid rank 1 - 6.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionRank] = rank;
		Servers(playerid, "You have set %s's faction ID %d with rank %d.", pData[otherid][pName], fid, rank);
		Servers(otherid, "%s has set your faction ID to %d with rank %d.", pData[playerid][pName], fid, rank);
	}
	
	format(tmp, sizeof(tmp), "%d(%d rank)", fid, rank);
	StaffCommandLog("SETFACTION", playerid, otherid, tmp);
    return 1;
}

CMD:setleader(playerid, params[])
{
	new fid, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, fid))
        return SyntaxMsg(playerid, "/setleader [playerid/PartOfName] [0.None, 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW, 5.PEDAGANG]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return ErrorMsg(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 5)
        return ErrorMsg(playerid, "You have specified an invalid faction ID 0 - 4.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionLead] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction leader.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction leader.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 6;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
	}
	
	format(tmp, sizeof(tmp), "%d", fid);
	StaffCommandLog("SETLEADER", playerid, otherid, tmp);
    return 1;
}

CMD:takemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new money, otherid;
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/takemoney <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

 	if(money > pData[otherid][pMoney])
		return ErrorMsg(playerid, "Player doesn't have enough money to deduct from!");

	GivePlayerMoneyEx(otherid, -money);
	SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%i){FFFFFF} has taken away money "RED_E"%s{FFFFFF} from %s", pData[playerid][pAdminname], FormatMoney(money), pData[otherid][pName]);
	return true;
}

CMD:takegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new gold, otherid;
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/takegold <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

 	if(gold > pData[otherid][pGold])
		return ErrorMsg(playerid, "Player doesn't have enough gold to deduct from!");

	pData[otherid][pGold] -= gold;
	SendClientMessageToAllEx(COLOR_PURPLE, "Server:{FFFFFF} Admin %s(%i){FFFFFF} has taken away gold "RED_E"%d from %s", pData[playerid][pAdminname], gold, pData[otherid][pName]);
	return 1;
}

CMD:veh(playerid, params[])
{
    static
        model[32],
        color1,
        color2;

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "s[32]I(0)I(0)", model, color1, color2))
        return SyntaxMsg(playerid, "/veh [model id/name] <color 1> <color 2>");

    if((model[0] = GetVehicleModelByName(model)) == 0)
        return ErrorMsg(playerid, "Invalid model ID.");

    static
        Float:x,
        Float:y,
        Float:z,
        Float:a,
        vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = CreateVehicle(model[0], x, y, z, a, color1, color2, 600);

    if(GetPlayerInterior(playerid) != 0)
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    if(GetPlayerVirtualWorld(playerid) != 0)
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    SetVehicleNumberPlate(vehicleid, "STATIC");
    Servers(playerid, "Anda memunculkan %s (%d, %d).", GetVehicleModelName(model[0]), color1, color2);
    return 1;
}

CMD:agl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/agl [playerid id/name]");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SendStaffMessage(COLOR_PURPLE, "%s{FFFFFF} telah memberi sim kepada player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah memberi sim anda", pData[playerid][pAdminname]);
	return 1;
}
//-----------------------------[ Admin Level 5 ]------------------
CMD:sethelperlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    SyntaxMsg(playerid, "/sethelperlevel <ID/Name> <level 0 - 3>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	if(alevel > 3)
		return ErrorMsg(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return ErrorMsg(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pHelper] = alevel;
	Servers(playerid, "You has set helper level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your helper level to %d", pData[otherid][pName], playerid, alevel);
	SendStaffMessage(COLOR_PURPLE, "Admin %s telah menset %d(%d){FFFFFF} sebagai staff helper level %d(%d){FFFFFF}",  pData[playerid][pAdminname], pData[otherid][pName], otherid, GetStaffRank(playerid), alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETHELPERLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:settwittername(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	
	new aname[128], otherid, query[128], string[63];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    SyntaxMsg(playerid, "/settwittername <ID/Name> <Twitter name>");
	    return true;
	}
	
	format(string, sizeof(string), "%s", aname);
	pData[otherid][pRegTwitter] = 1;
	mysql_format(g_SQL, query, sizeof(query), "SELECT twittername FROM players WHERE twittername='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeTwitterName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:setadminname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new aname[128], otherid, query[128];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    SyntaxMsg(playerid, "/setadminname <ID/Name> <admin name>");
	    return true;
	}
	
	mysql_format(g_SQL, query, sizeof(query), "SELECT adminname FROM players WHERE adminname='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeAdminName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	ResetPlayerMoneyEx(otherid);
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah mengset uang %d(%d){FFFFFF} menjadi %d!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/givemoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah memberikan uang %d(%d){FFFFFF} dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setbankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setbankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[playerid][pBankMoney] = money;
	
	Servers(playerid, "Kamu telah mengset uang rekening banki %d(%d){FFFFFF} menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang rekening bank anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givebankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/givebankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[playerid][pBankMoney] += money;
	
	Servers(playerid, "Kamu telah memberikan uang rekening bank %d(%d){FFFFFF} dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang rekening bank kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setmaterial(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setmaterial <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[otherid][pMaterial] = money;
	
	Servers(playerid, "Kamu telah menset material %d(%d){FFFFFF} dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset material kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMATERIAL", playerid, otherid, tmp);
	return 1;
}

CMD:setvw(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setvw [playerid id/name] <virtual world>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SetPlayerVirtualWorld(otherid, jumlah);
	Servers(otherid, "Admin %s telah men set Virtual World anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setcomponent(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setcomponent <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[otherid][pComponent] = money;
	
	Servers(playerid, "Kamu telah menset component %d(%d){FFFFFF} dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset component kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}

CMD:explode(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	new Float:POS[3], otherid, giveplayer[24];
	if(sscanf(params, "u", otherid))
	{
		SyntaxMsg(playerid, "/explode <ID/Name>");
		return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));

	Servers(playerid, "You have exploded %s(%i).", giveplayer, otherid);
	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	CreateExplosion(POS[0], POS[1], POS[2], 7, 5.0);
	return true;
}

//--------------------------[ Admin Level 6 ]-------------------
CMD:setadminlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    SyntaxMsg(playerid, "/setadminlevel <ID/Name> <level 0 - 4>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	if(alevel > 6)
		return ErrorMsg(playerid, "Level can't be higher than 6!");
	if(alevel < 0)
		return ErrorMsg(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	UcpData[otherid][uAdmin] = alevel;
	pData[otherid][pAdmin] = UcpData[otherid][uAdmin];
	Servers(playerid, "You has set admin level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your admin level to %d", pData[otherid][pName], playerid, alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETADMINLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:setgold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/setgold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] = gold;
	
	Servers(playerid, "Kamu telah menset gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah menset gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("SETGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:givegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/givegold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] += gold;
	
	Servers(playerid, "Kamu telah memberikan gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah memberikan gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("GIVEGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:agive(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			SyntaxMsg(playerid, "/agive [playerid] [name] [ammount]");
			InfoMsg(playerid, "Names: bandage, medicine, snack, sprunk, material, component, marijuana, obat, gps");
			return 1;
		}
			
		if(strcmp(name,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");
			
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan perban kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"medicine",true) == 0) 
		{
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medicine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan medicine kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan snack kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"material",true) == 0) 
		{
			
			if(ammount > 500)
				return ErrorMsg(playerid, "Invalid ammount 1 - 500");
			
			new maxmat = pData[otherid][pMaterial] + ammount;
			
			if(maxmat > 500)
				return ErrorMsg(playerid, "That player already have maximum material!");
			
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Material kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"component",true) == 0) 
		{
			
			if(ammount > 500)
				return ErrorMsg(playerid, "Invalid ammount 1 - 500");
			
			new maxcomp = pData[otherid][pComponent] + ammount;
			
			if(maxcomp > 500)
				return ErrorMsg(playerid, "That player already have maximum component!");
			
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Component kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"obat",true) == 0) 
		{	
			pData[otherid][pObat] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Obat kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Obat kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			pData[otherid][pGPS] += ammount;
			Info(playerid, "Anda telah berhasil memberikan GPS kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan GPS kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

CMD:setprice(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        SyntaxMsg(playerid, "/setprice [name] [price]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [MaterialPrice], [LumberPrice], [ComponentPrice], [MetalPrice], [GasOilPrice], [CoalPrice], [ProductPrice]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [FoodPrice], [FishPrice], [GsPrice] [ObatPrice]");
        return 1;
    }
	if(!strcmp(name, "materialprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [materialprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MaterialPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set material price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "lumberprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [lumberprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        LumberPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set lumber price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "componentprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [componentprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ComponentPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set component price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "metalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [metalprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MetalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set metal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gasoilprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [gasoilprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GasOilPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set gasoil price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "coalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [coalprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        CoalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set coal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "productprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [productprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ProductPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set product price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medicineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [medicineprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedicinePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set medicine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medkitprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [medkitprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedkitPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set medkit price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "foodprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [foodprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FoodPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set food price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "fishprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FishPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set fish price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gsprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [gsprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GStationPrice = price;
		foreach(new gsid : GStation)
		{
			if(Iter_Contains(GStation, gsid))
			{
				GStation_Save(gsid);
				GStation_Refresh(gsid);
			}
		}
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set gs price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "obatprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [obatprice] [price]");

        if(price < 0 || price > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ObatPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set obat price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	return 1;
}

CMD:setstock(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        SyntaxMsg(playerid, "/setstock [name] [stock]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [material], [allcrate], [component], [product], [gasoil] [food] [obat]");
        return 1;
    }
	if(!strcmp(name, "material", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [material] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Material = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set material to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "allcrate", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [allcrate] [stok]");

        if(stok < 0 || stok > 1000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 1000.");

		CrateFish = stok;
		CrateComponent = stok;
		CrateMaterial = stok;
		FishStock = stok;
        //Component = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set allcrate trucker to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "component", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [component] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Component = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set component to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "product", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [product] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Product = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set product to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "gasoil", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [gasoil] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GasOil = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set gasoil to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "apotek", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [apotek] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Apotek = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set apotek stok to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "food", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [food] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Food = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set food stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "obat", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [obat] [stok]");

        if(stok < 0 || stok > 5000)
            return ErrorMsg(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ObatMyr = stok;
		Server_Save();
        SendAdminMessage(COLOR_PURPLE, "%s set obat stok to %d.", pData[playerid][pAdminname], stok);
    }
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			UpdateWeapons(playerid);
			UpdatePlayerData(playerid);
			Servers(pid, "Sorry, server will be maintenance and your data have been saved.");
			KickEx(pid);
		}
	}
	return 1;
}

CMD:setpassword(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new cname[21], query[128], pass[65], tmp[64];
	if(sscanf(params, "s[21]s[20]", cname, pass))
	{
	    SyntaxMsg(playerid, "/setpassword <name> <new password>");
	    InfoMsg(playerid, "Make sure you enter the players name and not ID!");
	   	return 1;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT password FROM players WHERE username='%s'", cname);
	mysql_tquery(g_SQL, query, "ChangePlayerPassword", "iss", playerid, cname, pass);
	
	format(tmp, sizeof(tmp), "%s", pass);
	StaffCommandLog("SETPASSWORD", playerid, INVALID_PLAYER_ID, tmp);
	return 1;
}

// SetPassword Callback
function ChangePlayerPassword(admin, cPlayer[], newpass[])
{
	if(cache_num_rows() > 0)
	{
		new query[512], pass[65], salt[16];
		Servers(admin, "Password for %s has been set to \"%s\"", cPlayer, newpass);
		
		for (new i = 0; i < 16; i++) salt[i] = random(94) + 33;
		SHA256_PassHash(newpass, salt, pass, 65);

		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET password='%s', salt='%e' WHERE username='%s'", pass, salt, cPlayer);
		mysql_tquery(g_SQL, query);
	}
	else
	{
	    // Name Exists
		Error(admin, "The name"DARK_E"'%s' "WHITE_E"doesn't exist in the database!", cPlayer);
	}
    return 1;
}


CMD:playsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		SyntaxMsg(playerid, "/playsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}

CMD:playnearsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		SyntaxMsg(playerid, "/playnearsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp, x, y, z, 35.0, 1);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}

CMD:stopsong(playerid)
{
	StopAudioStreamForPlayer(playerid);
	Servers(playerid, "Song stop!");
	return 1;
}

CMD:setcs(playerid, params[])
{
	new otherid;
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	if(sscanf(params, "u", otherid))
		return Usage(playerid, "/setcs <ID/ Name>");
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "No player online or name is not found!");

	pData[otherid][pCharacterStory] = 1;
	SendAdminMessage(COLOR_RED, "%s mengaktifkan CS %s", GetRPName(playerid), GetRPName(otherid));
	Servers(otherid, "Admin %s mengaktifkan CS kamu", GetRPName(otherid), GetRPName(playerid));
	return 1;
}

CMD:delcs(playerid, params[])
{
	new otherid;
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	if(sscanf(params, "u", otherid))
		return Usage(playerid, "/delcs <ID/ Name>");
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "No player online or name is not found!");

	pData[otherid][pCharacterStory] = 0;
	SendAdminMessage(COLOR_RED, "%s menonaktifkan CS %s", GetRPName(playerid), GetRPName(otherid));
	Servers(otherid, "Admin %s menonaktifkan CS kamu", GetRPName(otherid), GetRPName(playerid));
	return 1;
}

CMD:setstat(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], query[248], param[32], ammount, otherid;
        if(sscanf(params, "us[24]S()[32]", otherid, name, param))
		{
			Usage(playerid, "/setstat [playerid] [names]");
			Info(playerid, "Names: Level, LevelUp, Gold, Money, Bank, Health, Armour, Hunger, Energy");
			Info(playerid, "Names: PhoneCredit, Job1, Job2, Fish, Worm, Sprunk, Snack, Seed, Food, Potato");
			Info(playerid, "Names: Wheat, Orange, Bandage, Medkit, Medicine, Marijuana, Component, Material");
			return 1;
		}
			
		if(!strcmp(name, "level", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [level] [ammount]");
			}

			pData[otherid][pLevel] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Level {FFFF00}%s {ffffff}ke level %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Level{ffffff} kamu ke %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET level = %i WHERE reg_id = %i", pData[otherid][pLevel], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "levelup", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [levelup] [ammount]");
			}

			pData[otherid][pLevelUp] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Poin Level {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Poin Level{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET levelup = %i WHERE reg_id = %i", pData[otherid][pLevelUp], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "gold", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [gold] [ammount]");
			}

			pData[otherid][pGold] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Gold {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Gold{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET gold = %i WHERE reg_id = %i", pData[otherid][pGold], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "money", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [money] [ammount]");
			}

			pData[otherid][pMoney] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Money {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), FormatMoney(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Money{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET money = %i WHERE reg_id = %i", pData[otherid][pMoney], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "bank", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [bank] [ammount]");
			}

			pData[otherid][pBankMoney] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bank Money {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), FormatMoney(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bank Money{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney = %i WHERE reg_id = %i", pData[otherid][pBankMoney], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "phonecredit", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [phonecredit] [ammount]");
			}

			pData[otherid][pPhoneCredit] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Phone Credit {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Phone Credit{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET phonecredit = %i WHERE reg_id = %i", pData[otherid][pPhoneCredit], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "health", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [health] [ammount]");
			}

			pData[otherid][pHealth] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Health {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Health{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET health = %i WHERE reg_id = %i", pData[otherid][pHealth], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "armour", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [armour] [ammount]");
			}

			pData[otherid][pArmour] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Armour {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Armour{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET armour = %i WHERE reg_id = %i", pData[otherid][pArmour], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "hunger", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [hunger] [ammount]");
			}

			pData[otherid][pHunger] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Hunger {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Hunger{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET hunger = %i WHERE reg_id = %i", pData[otherid][pHunger], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "energy", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [energy] [ammount]");
			}

			pData[otherid][pEnergy] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Energy {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Energy{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET energy = %i WHERE reg_id = %i", pData[otherid][pEnergy], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "job1", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				Usage(playerid, "/setstat [playerid] [job1] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage, <11> Pemotong Ayam");
				return 1;
			}
			if(!(0 <= ammount <= 11))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job = %i WHERE reg_id = %i", pData[otherid][pJob], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "job2", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				Usage(playerid, "/setstat [playerid] [job2] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage, <11> Pemotong Ayam");
				return 1;
			}
			if(!(0 <= ammount <= 11))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob2] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job2 = %i WHERE reg_id = %i", pData[otherid][pJob2], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		/*else if(!strcmp(name, "job1", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				Usage(playerid, "/setstat [playerid] [job1] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage");
				return 1;
			}
			if(!(0 <= ammount <= 10))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job = %i WHERE reg_id = %i", pData[otherid][pJob], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "job2", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				Usage(playerid, "/setstat [playerid] [job2] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage");
				return 1;
			}
			if(!(0 <= ammount <= 10))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob2] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job2 = %i WHERE reg_id = %i", pData[otherid][pJob2], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}*/
		else if(!strcmp(name, "medicine", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [medicine] [ammount]");
			}

			pData[otherid][pMedicine] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET medicine = %i WHERE reg_id = %i", pData[otherid][pMedicine], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "medkit", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [medkit] [ammount]");
			}

			pData[otherid][pMedkit] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medkit {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET Medkit = %i WHERE reg_id = %i", pData[otherid][pMedkit], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "snack", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [snack] [ammount]");
			}

			pData[otherid][pSnack] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Snack {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Snack{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET snack = %i WHERE reg_id = %i", pData[otherid][pSnack], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "sprunk", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [sprunk] [ammount]");
			}

			pData[otherid][pSprunk] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Sprunk {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Sprunk{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET sprunk = %i WHERE reg_id = %i", pData[otherid][pSprunk], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "bandage", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [bandage] [ammount]");
			}

			pData[otherid][pBandage] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bandage {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bandage{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bandage = %i WHERE reg_id = %i", pData[otherid][pBandage], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "material", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [material] [ammount]");
			}

			pData[otherid][pMaterial] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Material {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Material{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET material = %i WHERE reg_id = %i", pData[otherid][pMaterial], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "component", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [component] [ammount]");
			}

			pData[otherid][pComponent] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Component {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Component{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET component = %i WHERE reg_id = %i", pData[otherid][pComponent], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "food", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [food] [ammount]");
			}

			pData[otherid][pFood] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Food {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Food{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET food = %i WHERE reg_id = %i", pData[otherid][pFood], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "seed", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [seed] [ammount]");
			}

			pData[otherid][pSeed] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Seed {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Seed{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET seed = %i WHERE reg_id = %i", pData[otherid][pSeed], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "potato", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [potato] [ammount]");
			}

			pData[otherid][pPotato] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Potato {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Potato{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET potato = %i WHERE reg_id = %i", pData[otherid][pPotato], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "orange", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [orange] [ammount]");
			}

			pData[otherid][pOrange] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Orange {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Orange{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET orange = %i WHERE reg_id = %i", pData[otherid][pOrange], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "wheat", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [wheat] [ammount]");
			}

			pData[otherid][pWheat] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Wheat {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Wheat{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET wheat = %i WHERE reg_id = %i", pData[otherid][pWheat], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "marijuana", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [marijuana] [ammount]");
			}

			pData[otherid][pMarijuana] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Marijuana {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Marijuana{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET marijuana = %i WHERE reg_id = %i", pData[otherid][pMarijuana], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "fish", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [fish] [ammount]");
			}

			pData[otherid][pFish] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Fish {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Fish{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET fish = %i WHERE reg_id = %i", pData[otherid][pFish], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "worm", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [worm] [ammount]");
			}

			pData[otherid][pWorm] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Worm {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Worm{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET worm = %i WHERE reg_id = %i", pData[otherid][pWorm], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "fam", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return Usage(playerid, "/setstat [playerid] [fam] [ammount]");
			}

			pData[otherid][pFamily] = ammount;
			pData[otherid][pFamilyRank] = 1;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Family {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Family{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET family = %i, familyrank = %i WHERE reg_id = %i", pData[otherid][pFamily], pData[otherid][pFamilyRank], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else 
		{
			return 1;
		}
	}	
	return 1;
}

CMD:checkucp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
			
	new name[24];
	if(sscanf(params, "s[24]", name))
	{
	    Usage(playerid, "/checkucp <ucpname>");
 		return 1;
 	}

    new cQuery[600];

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT username FROM players WHERE ucp='%e'", name);
	mysql_tquery(g_SQL, cQuery, "CheckUCP", "is", playerid, name);
	return true;
}
CMD:sethpall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new lstr[1024];
	format(lstr, sizeof(lstr), "ADMINISTRATOR | %s: {ffffff}Telah menyembuhkan semua player yang ada di kota", pData[playerid][pAdminname]);
    SendClientMessageToAll(COLOR_PINK2, lstr);
	foreach(new pid : Player)
	{
	    SetPlayerHealth(pid, 100);
	}
	return 1;
}
CMD:setstressall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
    new lstr[1024];
	format(lstr, sizeof(lstr), "ADMINISTRATOR | %s: {ffffff}Telah mereset stress semua player yang ada di kota", pData[playerid][pAdminname]);
	SendClientMessageToAll(COLOR_PINK2, lstr);
	foreach(new pid : Player)
	{
	    pData[pid][pBladder] = 100;
	}
	return 1;
}
CMD:setrek(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "You don't have use permission");

    new targetid, option;
    if(sscanf(params,"ui", targetid, option)) return SyntaxMsg(playerid, "/setrek [player targetid or name] [ bank rek]");
    if(!IsPlayerConnected(targetid)) return ErrorMsg(playerid, "There is player not connect");
    Servers(playerid, "Kamu telah mengset rekening "BLUE_E"%s "YELLOW_E"menjadi = %s", ReturnName(targetid), option);
    Servers(targetid, "Admin "BLUE_E"%s "YELLOW_E"telah mengset rekening kamu menjadi menjadi = %s", ReturnName(playerid), option);
    pData[targetid][pBankRek] = option;
    return 1;
}