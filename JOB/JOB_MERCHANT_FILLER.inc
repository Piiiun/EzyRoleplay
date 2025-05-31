CreateJoinMFPoint()
{
	//JOBS
	new strings[128];
	//CreateDynamicPickup(1239, 23, 1227.8773,181.8018,20.3798, -1, -1, -1, 50);
	//format(strings, sizeof(strings), "[Merchant Filler Jobs]\n{ffffff}Jadilah Pekerja Merchant Filler disini\n{7fffd4}/getjob /accept job");
	//CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1227.8773,181.8018,20.3798, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // mf

	CreateDynamicPickup(2912, 23, 1241.7877, 211.7296, 19.5547, -1, -1, -1, 150.0);
	format(strings, sizeof(strings), "[Merchant Box Store]\n"WHITE_E"use command '"YELLOW_E"/box take"WHITE_E"' to pickup box package", CrateComponent);
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1241.7877, 211.7296, 19.5547, 150.0); // comp

	CreateDynamicPickup(2912, 23, 357.1034,-1810.3799,4.5015, -1, -1, -1, 50.0);
	format(strings, sizeof(strings), "[Merchant Restock]\n"WHITE_E"use command '"YELLOW_E"/box sell"WHITE_E"' to sell box package", CrateComponent);
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 357.1034,-1810.3799,4.5015, 2.0); // comp

}

//merchant Restock
/*GetRestockVending()
{
	new tmpcount;
	foreach(new id : Vendings)
	{
	    if(VendingData[id][vendingRestock] == 1)
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnRestockVendingID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_VENDING) return -1;
	foreach(new id : Bisnis)
	{
	    if(VendingData[id][vendingRestock] == 1)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
	    }
	}
	return -1;
}*/
Player_GiveBox(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
	pData[playerid][CarryingBox] = true;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 1271, 1, 0.002953, 0.469660, -0.009797, 269.851104, 34.443557, 0.000000, 0.804894, 1.000000, 0.822361 );
	//Info(playerid, "Masukkan Ke Mobil"GREEN_E"/box load"WHITE_E"untuk memasukkan ke mobil");
	InfoMsg(playerid, "Masukkan Ke Mobil /box load untuk memasukkan ke mobil");
	return 1;
}

Player_RemoveBox(playerid)
{
	if(!IsPlayerConnected(playerid) || !pData[playerid][CarryingBox]) return 0;
	ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
	RemovePlayerAttachedObject(playerid, 9);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	pData[playerid][CarryingBox] = false;
	return 1;
}

Player_DropBox(playerid, death_drop = 0)
{
    if(!IsPlayerConnected(playerid) || !pData[playerid][CarryingBox]) return 0;
    new id = Iter_Free(Boxs);
    if(id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, BoxData[id][boxDroppedBy], MAX_PLAYER_NAME);

		if(!death_drop)
		{
		    x += (1.0 * floatsin(-a, degrees));
			y += (1.0 * floatcos(-a, degrees));
			
			ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		}

		BoxData[id][boxSeconds] = BOX_LIFETIME;
		BoxData[id][boxObjID] = CreateDynamicObject(1271, x, y, z - 0.4, 0.0, 0.0, a);
		
		format(label, sizeof(label), "Box (%d)\n"WHITE_E"Dropped By "GREEN_E"%s\n"WHITE_E"%s\nUse /cargo pickup.", id, BoxData[id][boxDroppedBy], ConvertToMinutes(BOX_LIFETIME));
		BoxData[id][boxLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, x, y, z - 0.2, 5.0, .testlos = 1);
		
		BoxData[id][boxTimer] = SetTimerEx("RemoveBox", 1000, true, "i", id);
		Iter_Add(Boxs, id);
    }
    
    Player_RemoveBox(playerid);
	return 1;
}

Vehicle_BoxCount(vehicleid)
{
	//if(!IsValidVehicle(vehicleid)) return -1;
	new count = 0;
	for(new i; i < 2; i++) count += BoxStorage[vehicleid][i];
	return count;
}

GetClosestBox(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist, Float: pos[3];
	foreach(new i : Boxs)
	{
	    GetDynamicObjectPos(BoxData[i][boxObjID], pos[0], pos[1], pos[2]);
	    tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}

	return id;
}
CMD:mfhelp(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_MERCHANTFILLER, DIALOG_STYLE_LIST, "Merchant Filler", "Tekan Disini", "Setuju", "Cancel");
	return 1;
}


CMD:box(playerid, params[])
{
	if(pData[playerid][pJob] == 12 || pData[playerid][pJob2] == 12)
	{
		if(IsPlayerInAnyVehicle(playerid)) return ErrorMsg(playerid, "Anda harus keluar dari kendaraan.");
		if(isnull(params)) return SyntaxMsg(playerid, "/box [take/sell/list/load/unload]");
		
		if(!strcmp(params, "take", true))
		{
	    	if(pData[playerid][pJobTime] > 0)
			{
	    		Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pJobTime]);
	    		return 1;
			}
			new rego = 10;
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1241.7877, 211.7296, 19.5547))
				return ErrorMsg(playerid, "Kamu tidak berada di pembelian box");
			if(pData[playerid][CarryingBox] == true)
				return ErrorMsg(playerid, "Kamu masih membawa box product!");
			if(GetPlayerMoney(playerid) < rego)
				return Error(playerid, "Uangmu tidak cukup untuk membeli box seharga %s", FormatMoney(rego));

			ShowProgressbar(playerid, "Mengangkat...", 1);
			Player_GiveBox(playerid);
			Server_AddMoney(rego);
            GivePlayerMoneyEx(playerid,-50);
			pData[playerid][pEnergy] -= 3;
            Servers(playerid,"Kamu berhasil membeli {ffff00}merchant box{ffffff}seharga %s", FormatMoney(rego));
        	
		}
		else if(!strcmp(params, "sell", true))
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, 357.1034,-1810.3799,4.5015))
			{
				if(pData[playerid][CarryingBox] == false)
					return ErrorMsg(playerid, "Kamu tidak membawa box product!");

				ShowItemBox(playerid, "Uang", "Received_620x", 1212, 2);
				GivePlayerMoneyEx(playerid, 620);
				Pedagang += 150;			

				pData[playerid][pJobTime] += 480;
				pData[playerid][pEnergy] -= 3;
			    ShowProgressbar(playerid, "Menjual...", 1);
				ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
				Player_RemoveBox(playerid);
				SuccesMsg(playerid, "Anda mendapatkan uang salary dari merchant.");
			}	
			else return ErrorMsg(playerid, "Anda harus berada didekat dengan box drop pedagang anda.");
		}
		else if(!strcmp(params, "list", true))
		{
			new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
			if(!IsValidVehicle(vehicleid)) return ErrorMsg(playerid, "You're not near any vehicle.");
			if(!IsATruck(vehicleid)) return ErrorMsg(playerid, "Vehicle isn't a mining vehicle.");
			new string[196], title[32], type[64];//, harga;
			format(string, sizeof(string), "Type\tAmount\n");
			for(new i; i < 2; i++)
			{
				if(BoxData[i][boxType] == 0)
				{
					type = "Merchant Box";
				}
				//if(BoxData[i][boxType] == 1)
				//{
				//	type = "Product Business";
				//}
				else
				{
					type = "Unknown";
				}
				format(string, sizeof(string), "%s%s\t{2ECC71}%d Box\n", string, type, Vehicle_BoxCount(vehicleid));
			}
			format(title, sizeof(title), "Merchant Box List {E74C3C}(%d/%d)", Vehicle_BoxCount(vehicleid), BOX_LIMIT);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Close", "");
		}
		else if(!strcmp(params, "load", true))
		{
			new carid = -1;
			if(!pData[playerid][CarryingBox]) return ErrorMsg(playerid, "You're not carrying a Box.");
			if(IsPlayerInAnyVehicle(playerid)) return ErrorMsg(playerid, "Anda harus keluar dari kendaraan.");
			new vehicleid = GetNearestVehicleToPlayer(playerid, 5.5, false);
			if(vehicleid == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "You not in near any vehicles.");
			if(!IsATruck(vehicleid)) return ErrorMsg(playerid, "You're not near a benson car.");
			if(GetTrunkStatus(vehicleid))
			{
				if(Vehicle_BoxCount(vehicleid) >= BOX_LIMIT) return ErrorMsg(playerid, "You can't load any more logs to this vehicle.");
				if((carid = Vehicle_Nearest(playerid)) != -1)
				{
					if(IsValidVehicle(pvData[carid][cVeh]))
					{
						pvData[carid][cBox]++;
					}
					BoxStorage[vehicleid][ pData[playerid][CarryingBox] ]++;
				}
				pData[playerid][pEnergy] -= 3;
                ShowProgressbar(playerid, "Load Box...", 2);
				Player_RemoveBox(playerid);
				InfoMsg(playerid, "Loaded a box");
				//Info(playerid, "Loaded a box.");
			} 
			else ErrorMsg(playerid, "Kamu belum membuka trunk kendaraan");	
		}
		else if(!strcmp(params, "unload", true))
		{
			new carid = -1;
			if(pData[playerid][CarryingBox]) return ErrorMsg(playerid, "You're already carrying a box.");
			new vehicleid = GetNearestVehicleToPlayer(playerid, 5.5, false);		
			if(vehicleid == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "You not in near any vehicles.");
			if(!IsATruck(vehicleid)) return ErrorMsg(playerid, "You're not near a benson car.");
			if(GetTrunkStatus(vehicleid))
			{
				if(Vehicle_BoxCount(vehicleid) < 1) return ErrorMsg(playerid, "This vehicle doesn't have any Boxs.");
				if((carid = Vehicle_Nearest(playerid)) != -1)
				{
					if(IsValidVehicle(pvData[carid][cVeh]))
					{
						pvData[carid][cBox]--;
					}
					BoxStorage[vehicleid][ pData[playerid][CarryingBox] ]--;
				}
				pData[playerid][pEnergy] -= 3;
                ShowProgressbar(playerid, "Unload...", 2);
				Player_GiveBox(playerid);
				InfoMsg(playerid, "You've taken a box from the car.");
			}	
			else ErrorMsg(playerid, "Kamu belum membuka trunk kendaraan");
		}
		else if(!strcmp(params, "pickup", true))
		{
			if(pData[playerid][CarryingBox]) return ErrorMsg(playerid, "You're already carrying a Box.");
			new tid = GetClosestBox(playerid);
			if(tid == -1) return ErrorMsg(playerid, "You're not near a Box.");
			BoxData[tid][boxSeconds] = 1;
			RemoveBox(tid);
			
			Player_GiveBox(playerid);
			InfoMsg(playerid, "You've taken a Box from ground.");
		}
	}	
	else return ErrorMsg(playerid, "Kamu bukan Merchant Filler!");
	return 1;
}