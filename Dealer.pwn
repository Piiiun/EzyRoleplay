Vehicle_GetCount(playerid)
{
    new count = 0;

    if (playerid != INVALID_PLAYER_ID)
    {
        for (new i = 0; i < MAX_PLAYER_VEHICLE; i++)
        {
            if (pvData[playerid][i][pvExists] == true)
            {
                count++;
            }
        }
    }

    return count;
}

static const MenuTruk[] = 
{
	422, 478, 554, 543, 440, 413, 418
};

static const MenuMotor[] =
{
	509, 481, 462, 510, 468, 461, 521, 586
};

static const MenuSuv[] =
{
	579, 400, 589, 479, 458
};

static const MenuClassic[] =
{
	536, 575, 534, 567, 535, 576, 412
};

static const Menu2Door[] =
{
	602, 496, 401, 518, 527, 589, 533, 526, 474,
	517, 410, 600, 436, 439, 549, 491, 402, 542,
	480, 562, 565, 559, 558, 555
};

static const Menu4Door[] =
{
	507, 585, 466, 492, 546, 551, 516, 467,
	426, 547, 405, 580, 550, 566, 540, 421, 
	529, 561, 560
};

GetVehicleCost(carid)
{
    //Category Kendaraan Non Dealer
	if(carid == 434) return 1000000; //Hotknife
	if(carid == 502) return 1000000; //Hotring Racer
	if(carid == 495) return 1000000; //Sandking
	if(carid == 451) return 1000000; //Turismo
	if(carid == 470) return 500000; //Patriot
	if(carid == 424) return 500000; //BF Injection
	if(carid == 522) return 800000; //Nrg
	if(carid == 411) return 1500000; //Infernus
	if(carid == 541) return 1400000; //Bullet
	if(carid == 504) return 1500000; //Bloodring Banger
	if(carid == 603) return 800000; //Phoenix
	if(carid == 415) return 1000000; //Cheetah
	if(carid == 402) return 500000; //Buffalo
	if(carid == 508) return 500000; //Journey
	if(carid == 457) return 500000; //Caddy
	if(carid == 471) return 500000; //Quad
	
	//Category Kendaraan Bikes/Motor
	if(carid == 481) return 500;  //Bmx
	if(carid == 509) return 500; //Bike
	if(carid == 510) return 700; //Mt bike
	if(carid == 463) return 4000; //Freeway harley
	if(carid == 521) return 7500; //Fcr 900
	if(carid == 461) return 6000; //Pcj 600
	if(carid == 581) return 5000; //Bf
	if(carid == 468) return 8000; //Sancehz
	if(carid == 586) return 4500; //Wayfare
	if(carid == 462) return 1000; //Faggio
    	//Category Kendaraan Cars
	if(carid == 445) return 11000; //Admiral
	if(carid == 496) return 15000; //Blista Compact
	if(carid == 401) return 12500; //Bravura
	if(carid == 518) return 13500; //Buccaneer
	if(carid == 527) return 13300; //Cadrona
	if(carid == 483) return 14000; //Camper
	if(carid == 542) return 18500; //Clover
	if(carid == 589) return 8500; //Club
	if(carid == 507) return 10000; //Elegant
	if(carid == 540) return 7950; //Vincent
	if(carid == 585) return 8200; //Emperor
	if(carid == 419) return 8100; //Esperanto
	if(carid == 526) return 7000; //Fortune
	if(carid == 466) return 1250; //Glendale
	if(carid == 492) return 1260; //Greenwood
	if(carid == 474) return 8800; //Hermes
	if(carid == 546) return 8800; //Intruder
	if(carid == 517) return 9900; //Majestic
	if(carid == 410) return 7200; //Manana
	if(carid == 551) return 7400; //Merit
	if(carid == 516) return 8300; //Nebula
	if(carid == 467) return 8800; //Oceanic
	if(carid == 404) return 9500; //Perenniel
	if(carid == 600) return 9000; //Picador
	if(carid == 426) return 8200; //Premier
	if(carid == 436) return 12300; //Previon
	if(carid == 547) return 10800; //Primo
	if(carid == 405) return 11700; //Sentinel
	if(carid == 458) return 8000; //Solair
	if(carid == 439) return 12800; //Stallion
	if(carid == 550) return 13300; //Sunrise
	if(carid == 566) return 7000; //Tahoma
	if(carid == 549) return 9500; //Tampa
	if(carid == 491) return 9600; //Virgo
	if(carid == 412) return 9300; //Voodoo
	if(carid == 421) return 8600; //Washington
	if(carid == 529) return 8100; //Willard
	if(carid == 555) return 18000; //Windsor
	if(carid == 580) return 12000; //Stafford
	if(carid == 475) return 15000; //Sabre
	if(carid == 545) return 12000; //Hustler

	//Category Kendaraan Lowriders
	if(carid == 536) return 8000; //Blade
	if(carid == 575) return 10800; //Broadway
	if(carid == 533) return 9300; //Feltzer
	if(carid == 534) return 9800; //Remington
	if(carid == 567) return 10000; //Savanna
	if(carid == 535) return 12000; //Slamvan
	if(carid == 576) return 13200; //Tornado
	if(carid == 566) return 13400; //Tahoma
	if(carid == 412) return 13600; //Voodoo

	//Category Kendaraan SUVS Cars
	if(carid == 579) return 12700; //Huntley
	if(carid == 400) return 12000; //Landstalker
	if(carid == 500) return 10500; //Mesa
	if(carid == 489) return 22000; //Rancher
	if(carid == 479) return 22200; //Regina
	if(carid == 482) return 10000; //Burrito
	if(carid == 418) return 9500; //Moonbeam
	if(carid == 413) return 10500; //Pony
	if(carid == 442) return 12000; // Romero
	
	//Category Kendaraan Sports
	if(carid == 602) return 30000; //Alpha
	if(carid == 429) return 32000; //Banshee
	if(carid == 562) return 88000; //Elegy
	if(carid == 587) return 44000; //Euros
	if(carid == 565) return 35000; //Flash
	if(carid == 559) return 53000; //Jester
	if(carid == 561) return 39000; //Stratum
	if(carid == 560) return 25000; //Sultan
	if(carid == 506) return 120000; //Super GT
	if(carid == 558) return 60000; //Uranus
	if(carid == 477) return 1200000; //Zr-350
	if(carid == 480) return 3000; //Comet
	if(carid == 420) return 300; //Taxi
	if(carid == 438) return 400; //Cabbie
	if(carid == 403) return 800; //Linerunner
	if(carid == 414) return 400; //Mule
	if(carid == 422) return 5000; //Bobcat
	if(carid == 440) return 400; //Rumpo
	if(carid == 455) return 12000; //Flatbead
	if(carid == 456) return 7000; //Yankee
	if(carid == 478) return 6000; //Walton
	if(carid == 498) return 8000; //Boxville
	if(carid == 499) return 9000; //Benson
	if(carid == 514) return 5000; //Tanker
	if(carid == 515) return 6000; //Roadtrain
	if(carid == 524) return 400; //Cement 
	if(carid == 525) return 450; //Towtruck
	if(carid == 543) return 5000; //Sadler
	if(carid == 552) return 500; //Utility Van
	if(carid == 554) return 5000; //Yosemite
	if(carid == 578) return 400; //DFT-30
	if(carid == 609) return 400; //Boxville
	if(carid == 423) return 400; //Mr Whoopee/Ice cream
	if(carid == 588) return 400; //Hotdog
 	return -1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1042.7394,234.8009,15.5392))
		{
			ShowPlayerDialog(playerid, D_DEALER, DIALOG_STYLE_TABLIST, ""LIGHT_BLUE""SERVER_NAME""WHITE" - Showroom", "Truk Ringan & Vans\n{BABABA}SUV & Wagon\n{FFFFFF}Motor & Sepeda\n{BABABA}Classic & Lowrider\n{FFFFFF}2 Pintu & Compact\n{BABABA}4 Pintu & Luxury\n"RED"(Jual Kendaraan Ke Negara)", "Pilih", "Batal");
		}
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Toggle_Dealer(playerid, bool:toggle)
{
	if(toggle)
	{
		forex(a, 6) TextDrawShowForPlayer(playerid, DealerTD1[a]);
		TextDrawShowForPlayer(playerid, PILIHBATAL);
		TextDrawShowForPlayer(playerid, PILIHBELI);
		TextDrawShowForPlayer(playerid, PILIHKANAN);
		TextDrawShowForPlayer(playerid, PILIHKIRI);
		PlayerTextDrawShow(playerid, DealerTDV2[playerid][0]);
		PlayerTextDrawShow(playerid, DealerTDV2[playerid][1]);
		PlayerTextDrawShow(playerid, DealerTDV2[playerid][2]);
	}
	else
	{
		PlayerDealer[playerid][pClickTruk] = 0;
		PlayerDealer[playerid][pClickMotor] = 0;
		PlayerDealer[playerid][pClickSuv] = 0;
		PlayerDealer[playerid][pClickClassic] = 0;
		PlayerDealer[playerid][pClick2Door] = 0;
		PlayerDealer[playerid][pClick4Door] = 0;

		pData[playerid][pSelectTruk] = 0;
		pData[playerid][pSelectSuv] = 0;
		pData[playerid][pSelectMotor] = 0;
		pData[playerid][pSelectClassic] = 0;
		pData[playerid][pSelect2Door] = 0;
		pData[playerid][pSelect4Door] = 0;

		forex(a, 6) TextDrawHideForPlayer(playerid, DealerTD1[a]);
		TextDrawHideForPlayer(playerid, PILIHBATAL);
		TextDrawHideForPlayer(playerid, PILIHBELI);
		TextDrawHideForPlayer(playerid, PILIHKANAN);
		TextDrawHideForPlayer(playerid, PILIHKIRI);
		PlayerTextDrawHide(playerid, DealerTDV2[playerid][0]);
		PlayerTextDrawHide(playerid, DealerTDV2[playerid][1]);
		PlayerTextDrawHide(playerid, DealerTDV2[playerid][2]);
	}
	return 1;
}

Dialog:D_DEALER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 0));
			SetPlayerCameraPos(playerid, 1033.1617,244.1283,15.5392);
			SetPlayerCameraLookAt(playerid, 1041.6479,248.4764,15.6093);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelectTruk] = 1;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerDealer[playerid][pClickTruk]++;
			if(PlayerDealer[playerid][pClickTruk] >= sizeof MenuTruk) PlayerDealer[playerid][pClickTruk] = 0;

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuTruk[PlayerDealer[playerid][pClickTruk]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuTruk[PlayerDealer[playerid][pClickTruk]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/06", PlayerDealer[playerid][pClickTruk]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(MenuTruk[PlayerDealer[playerid][pClickTruk]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 1)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 0));
			SetPlayerCameraPos(playerid, 1033.1617,244.1283,15.5392);
			SetPlayerCameraLookAt(playerid, 1041.6479,248.4764,15.6093);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelectSuv] = 1;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerDealer[playerid][pClickSuv]++;
			if(PlayerDealer[playerid][pClickSuv] >= sizeof MenuSuv) PlayerDealer[playerid][pClickSuv] = 0;

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", GetVehicleNameEx(MenuSuv[PlayerDealer[playerid][pClickSuv]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%s", FormatNumber(GetVehicleCost(MenuSuv[PlayerDealer[playerid][pClickSuv]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%02d/05", PlayerDealer[playerid][pClickSuv]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(MenuSuv[PlayerDealer[playerid][pClickSuv]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 2)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 0));
			SetPlayerCameraPos(playerid, 1033.1617,244.1283,15.5392);
			SetPlayerCameraLookAt(playerid, 1041.6479,248.4764,15.6093);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelectMotor] = 1;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerDealer[playerid][pClickMotor]++;
			if(PlayerDealer[playerid][pClickMotor] >= sizeof MenuMotor) PlayerDealer[playerid][pClickMotor] = 0;

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", GetVehicleNameEx(MenuMotor[PlayerDealer[playerid][pClickMotor]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%s", FormatNumber(GetVehicleCost(MenuMotor[PlayerDealer[playerid][pClickMotor]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%02d/07", PlayerDealer[playerid][pClickMotor]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(MenuMotor[PlayerDealer[playerid][pClickMotor]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 3)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 0));
			SetPlayerCameraPos(playerid, 1035.6553,240.4212,15.5392);
			SetPlayerCameraLookAt(playerid, 1027.1300,236.3517,15.6393);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelectClassic] = 1;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerDealer[playerid][pClickClassic]++;
			if(PlayerDealer[playerid][pClickClassic] >= sizeof MenuClassic) PlayerDealer[playerid][pClickClassic] = 0;

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", GetVehicleNameEx(MenuClassic[PlayerDealer[playerid][pClickClassic]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%s", FormatNumber(GetVehicleCost(MenuClassic[PlayerDealer[playerid][pClickClassic]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%02d/06", PlayerDealer[playerid][pClickClassic]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(MenuClassic[PlayerDealer[playerid][pClickClassic]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 4)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 1000));
			SetPlayerCameraPos(playerid, 1035.6553,240.4212,15.5392);
			SetPlayerCameraLookAt(playerid, 1027.1300,236.3517,15.6393);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelect2Door] = 1;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerDealer[playerid][pClick2Door]++;
			if(PlayerDealer[playerid][pClick2Door] >= sizeof Menu2Door) PlayerDealer[playerid][pClick2Door] = 0;

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", GetVehicleNameEx(Menu2Door[PlayerDealer[playerid][pClick2Door]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%s", FormatNumber(GetVehicleCost(Menu2Door[PlayerDealer[playerid][pClick2Door]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%02d/22", PlayerDealer[playerid][pClick2Door]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(Menu2Door[PlayerDealer[playerid][pClick2Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 5)
		{
			SetPlayerVirtualWorldEx(playerid, (playerid + 1000));
			SetPlayerCameraPos(playerid, 1035.6553,240.4212,15.5392);
			SetPlayerCameraLookAt(playerid, 1027.1300,236.3517,15.6393);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pSelect4Door] = 1;

			PlayerDealer[playerid][pClick4Door]++;
			if(PlayerDealer[playerid][pClick4Door] >= sizeof Menu4Door) PlayerDealer[playerid][pClick4Door] = 0;

			Toggle_Dealer(playerid, true);
			SelectTextDraw(playerid, COLOR_JUNAI);

			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", GetVehicleNameEx(Menu4Door[PlayerDealer[playerid][pClick4Door]])));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%s", FormatNumber(GetVehicleCost(Menu4Door[PlayerDealer[playerid][pClick4Door]]))));
			PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%02d/17", PlayerDealer[playerid][pClick4Door]));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			VehicleDealer[playerid] = CreateVehicle(Menu4Door[PlayerDealer[playerid][pClick4Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
			SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
			LinkVehicleToInterior(VehicleDealer[playerid], 0);
		}
		if(listitem == 6)
		{
			new bool:have, str[1502];
		 	format(str, sizeof(str), "VID\tModel(Database ID)\tPlate(Masa Berlaku)\t/Rental/Status/\n");
		 	foreach(new i : PlayerVehicle)
		 	{
		 		if(Vehicle_IsOwner(playerid, i))
		 		{
		 		    if(VehicleData[i][cInsuranced])
		 		    {
		                format(str, sizeof(str), "%s"RED"[Despawned]"WHITE"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki "WHITE"/Insurance/\n", str, GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate]);
		 			}
					else if(VehicleData[i][cPark] != -1)
					{
						format(str, sizeof(str), "%s"RED"[Despawned]"WHITE"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki "WHITE"/Garkot (%s)/\n", str, GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate], GetLocation(ParkInfo[VehicleData[i][cPark]][parkX], ParkInfo[VehicleData[i][cPark]][parkY], ParkInfo[VehicleData[i][cPark]][parkZ]));
					}
					else if(VehicleData[i][cGarage] != 0)
					{
						format(str, sizeof(str), "%s"RED"[Despawned]"WHITE"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki "WHITE"/Garasi Pribadi/\n", str, GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate]);
					}
					else if(VehicleData[i][cImpounded] >= 1)
					{
						format(str, sizeof(str), "%s"RED"[Despawned]"WHITE"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki "WHITE"/Impounded/\n", str, GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate]);
					}
					else if(IsValidVehicle(VehicleData[i][cVehicle]))
		 			{
		 		        format(str, sizeof(str), "%s"SKYBLUE"VID:"YELLOW"%d"LIGHT_GREY"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki"WHITE"/Spawned/\n", str, VehicleData[i][cVehicle], GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate]);
		 			}
					else
					{
						format(str, sizeof(str), "%s"RED"[Despawned]"WHITE"\t%s [%d]\t%s\t/"LIGHTGREEN"Dimiliki "WHITE"/Force Dewspawn/\n", str, GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cID], VehicleData[i][cPlate]);
					}
		 			
		 			have = true;
		 		}
		 	}
		 	if(have)
		 		ShowPlayerDialog(playerid, D_SELLCARTOSERVER, DIALOG_STYLE_TABLIST_HEADERS, ""LIGHT_BLUE""SERVER_NAME""WHITE" - Kepemilikan kendaraan", str, "Select", "Close");
		 	else
		 	    SendErrorTD(playerid, "Kamu tidak memiliki kendaraan apapuns!");
		}
	}
	return 1;
}

hook OnClickDynamicTextDraw(playerid, Text:textid)
{
	if(textid == PILIHKANAN)
	{
		if(pData[playerid][pSelectTruk] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickTruk]++;
				if(PlayerDealer[playerid][pClickTruk] >= sizeof MenuTruk) PlayerDealer[playerid][pClickTruk] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuTruk[PlayerDealer[playerid][pClickTruk]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuTruk[PlayerDealer[playerid][pClickTruk]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/06", PlayerDealer[playerid][pClickTruk]));

				VehicleDealer[playerid] = CreateVehicle(MenuTruk[PlayerDealer[playerid][pClickTruk]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectSuv] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickSuv]++;
				if(PlayerDealer[playerid][pClickSuv] >= sizeof MenuSuv) PlayerDealer[playerid][pClickSuv] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuSuv[PlayerDealer[playerid][pClickSuv]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuSuv[PlayerDealer[playerid][pClickSuv]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/05", PlayerDealer[playerid][pClickSuv]));

				VehicleDealer[playerid] = CreateVehicle(MenuSuv[PlayerDealer[playerid][pClickSuv]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectMotor] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickMotor]++;
				if(PlayerDealer[playerid][pClickMotor] >= sizeof MenuMotor) PlayerDealer[playerid][pClickMotor] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuMotor[PlayerDealer[playerid][pClickMotor]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuMotor[PlayerDealer[playerid][pClickMotor]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/07", PlayerDealer[playerid][pClickMotor]));

				VehicleDealer[playerid] = CreateVehicle(MenuMotor[PlayerDealer[playerid][pClickMotor]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectClassic] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickClassic]++;
				if(PlayerDealer[playerid][pClickClassic] >= sizeof MenuClassic) PlayerDealer[playerid][pClickClassic] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuClassic[PlayerDealer[playerid][pClickClassic]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuClassic[PlayerDealer[playerid][pClickClassic]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/06", PlayerDealer[playerid][pClickClassic]));

				VehicleDealer[playerid] = CreateVehicle(MenuClassic[PlayerDealer[playerid][pClickClassic]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelect2Door] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClick2Door]++;
				if(PlayerDealer[playerid][pClick2Door] >= sizeof Menu2Door) PlayerDealer[playerid][pClick2Door] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(Menu2Door[PlayerDealer[playerid][pClick2Door]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(Menu2Door[PlayerDealer[playerid][pClick2Door]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/22", PlayerDealer[playerid][pClick2Door]));

				VehicleDealer[playerid] = CreateVehicle(Menu2Door[PlayerDealer[playerid][pClick2Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelect4Door] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClick4Door]++;
				if(PlayerDealer[playerid][pClick4Door] >= sizeof Menu4Door) PlayerDealer[playerid][pClick4Door] = 0;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(Menu4Door[PlayerDealer[playerid][pClick4Door]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(Menu4Door[PlayerDealer[playerid][pClick4Door]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/17", PlayerDealer[playerid][pClick4Door]));

				VehicleDealer[playerid] = CreateVehicle(Menu4Door[PlayerDealer[playerid][pClick4Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
	}
	if(textid == PILIHKIRI)
	{
		if(pData[playerid][pSelectTruk] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickTruk]--;
				if(PlayerDealer[playerid][pClickTruk] < 0) PlayerDealer[playerid][pClickTruk] = sizeof MenuTruk - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuTruk[PlayerDealer[playerid][pClickTruk]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuTruk[PlayerDealer[playerid][pClickTruk]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/06", PlayerDealer[playerid][pClickTruk]));

				VehicleDealer[playerid] = CreateVehicle(MenuTruk[PlayerDealer[playerid][pClickTruk]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectSuv] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickSuv]--;
				if(PlayerDealer[playerid][pClickSuv] < 0) PlayerDealer[playerid][pClickSuv] = sizeof MenuSuv - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuSuv[PlayerDealer[playerid][pClickSuv]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuSuv[PlayerDealer[playerid][pClickSuv]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/05", PlayerDealer[playerid][pClickSuv]));

				VehicleDealer[playerid] = CreateVehicle(MenuSuv[PlayerDealer[playerid][pClickSuv]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectMotor] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickMotor]--;
				if(PlayerDealer[playerid][pClickMotor] < 0) PlayerDealer[playerid][pClickMotor] = sizeof MenuMotor - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuMotor[PlayerDealer[playerid][pClickMotor]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuMotor[PlayerDealer[playerid][pClickMotor]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/07", PlayerDealer[playerid][pClickMotor]));

				VehicleDealer[playerid] = CreateVehicle(MenuMotor[PlayerDealer[playerid][pClickMotor]], 1041.2303,248.1330,15.5986,138.6955, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelectClassic] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClickClassic]--;
				if(PlayerDealer[playerid][pClickClassic] < 0) PlayerDealer[playerid][pClickClassic] = sizeof MenuClassic - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(MenuClassic[PlayerDealer[playerid][pClickClassic]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(MenuClassic[PlayerDealer[playerid][pClickClassic]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/06", PlayerDealer[playerid][pClickClassic]));

				VehicleDealer[playerid] = CreateVehicle(MenuClassic[PlayerDealer[playerid][pClickClassic]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelect2Door] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClick2Door]--;
				if(PlayerDealer[playerid][pClick2Door] < 0) PlayerDealer[playerid][pClick2Door] = sizeof Menu2Door - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(Menu2Door[PlayerDealer[playerid][pClick2Door]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(Menu2Door[PlayerDealer[playerid][pClick2Door]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/22", PlayerDealer[playerid][pClick2Door]));

				VehicleDealer[playerid] = CreateVehicle(Menu2Door[PlayerDealer[playerid][pClick2Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
		if(pData[playerid][pSelect4Door] == 1)
		{
			if(IsValidVehicle(VehicleDealer[playerid]))
			{
				DestroyVehicle(VehicleDealer[playerid]);
				VehicleDealer[playerid] = INVALID_VEHICLE_ID;

				SetPlayerVirtualWorld(playerid, (playerid + 0));

				PlayerDealer[playerid][pClick4Door]--;
				if(PlayerDealer[playerid][pClick4Door] < 0) PlayerDealer[playerid][pClick4Door] = sizeof Menu4Door - 1;

				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][0], sprintf("%s", GetVehicleNameEx(Menu4Door[PlayerDealer[playerid][pClick4Door]])));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][1], sprintf("%s", FormatNumber(GetVehicleCost(Menu4Door[PlayerDealer[playerid][pClick4Door]]))));
				PlayerTextDrawSetString(playerid, DealerTDV2[playerid][2], sprintf("%02d/17", PlayerDealer[playerid][pClick4Door]));

				VehicleDealer[playerid] = CreateVehicle(Menu4Door[PlayerDealer[playerid][pClick4Door]], 1027.2516,236.8326,15.3447,325.1264, -1, -1, -1);
				SetVehicleVirtualWorld(VehicleDealer[playerid], (playerid + 0));
				LinkVehicleToInterior(VehicleDealer[playerid], 0);
			}
		}
	}
	if(textid == PILIHBATAL)
	{
		Toggle_Dealer(playerid, false);
		CancelSelectTextDraw(playerid);

		DestroyVehicle(VehicleDealer[playerid]);
		VehicleDealer[playerid] = INVALID_VEHICLE_ID;

		SetPlayerFacingAngle(playerid, 90.6407);
		SetPlayerVirtualWorldEx(playerid, 0);
		SetPlayerInteriorEx(playerid, 0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 1);
	}
	if(textid == PILIHBELI)
	{
		if(Vehicle_GetCount(playerid) >= 4 && pData[playerid][pVIP] == 0)
			return SendErrorTD(playerid, "Kamu hanya dapat memiliki 4 kendaraan");

		if(Vehicle_GetCount(playerid) >= 5 && pData[playerid][pVIP] == 1)
			return SendErrorTD(playerid, "Kamu hanya dapat memiliki 5 kendaraan");

		if(Vehicle_GetCount(playerid) >= 6 && pData[playerid][pVIP] == 2)
			return SendErrorTD(playerid, "Kamu hanya dapat memiliki 6 kendaraan");

		if(Vehicle_GetCount(playerid) >= 7 && pData[playerid][pVIP] == 3)
			return SendErrorTD(playerid, "Kamu hanya dapat memiliki 7 kendaraan");

		if(pData[playerid][pSelectTruk] == 1)
		{
			new modelid = MenuTruk[PlayerDealer[playerid][pClickTruk]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}
		if(pData[playerid][pSelectSuv] == 1)
		{
			new modelid = MenuSuv[PlayerDealer[playerid][pClickSuv]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}
		if(pData[playerid][pSelectMotor] == 1)
		{
			new modelid = MenuMotor[PlayerDealer[playerid][pClickMotor]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}
		if(pData[playerid][pSelectClassic] == 1)
		{
			new modelid = MenuClassic[PlayerDealer[playerid][pClickClassic]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}
		if(pData[playerid][pSelect2Door] == 1)
		{
			new modelid = Menu2Door[PlayerDealer[playerid][pClick2Door]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}
		if(pData[playerid][pSelect4Door] == 1)
		{
			new modelid = Menu4Door[PlayerDealer[playerid][pClick4Door]];
			new harga = GetVehicleCost(modelid);
			if(harga > GetMoney(playerid)) return SendErrorTD(playerid, "Uang kamu tidak cukup untuk membeli kendaraan ini");

			TakeMoney(playerid, harga, sprintf("Membeli mobil: %s dari dealer", GetVehicleNameEx(modelid)));

			if(VehicleDealer[playerid] != INVALID_VEHICLE_ID)
				DestroyVehicle(VehicleDealer[playerid]), VehicleDealer[playerid] = INVALID_VEHICLE_ID;

			SetPlayerFacingAngle(playerid, 90.6407);
			SetPlayerVirtualWorldEx(playerid, 0);
			SetPlayerInteriorEx(playerid, 0);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);

	        Vehicle_Create(playerid, pData[playerid][pID], modelid, 544.2508, -1269.8116, 17.1995, 219.4500, RandomEx(1, 100), RandomEx(1, 100), true);
			Toggle_Dealer(playerid, false);
			CancelSelectTextDraw(playerid);
		}		
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog:D_SELLCARTOSERVER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new count = 0;
		pData[playerid][pListitem] = listitem;
		foreach(new i : PlayerVehicle)
		{
			if(VehicleData[i][cOwner] == pData[playerid][pID] && count++== listitem)
			{
				if(VehicleData[i][cVehicle] == INVALID_VEHICLE_ID) return SendErrorTD(playerid, "Tidak dapat menjual kendaraan yang dalam status despawned");
				new harga = GetVehicleCost(VehicleData[i][cModel]) / 2;				
				new str[600];
				format(str, sizeof(str), ""WHITE"VID (Database): "YELLOW"%d\n"WHITE"Vehicle: "SKYBLUE"%s\n"WHITE"Plate: "LIGHTGREEN"%s\n"WHITE"\nUpgrades:\n- "LIGHTGREEN"None\n- "LIGHTGREEN"None\n"WHITE"apakah kamu yakin ingin menjual ke negara dengan harga %s", VehicleData[i][cID], GetVehicleNameEx(VehicleData[i][cModel]), VehicleData[i][cPlate], FormatNumber(harga));
				ShowPlayerDialog(playerid, D_SELLCARDEALER, DIALOG_STYLE_INPUT, sprintf("%s's sell vehicle (price)", GetVehicleNameEx(VehicleData[i][cModel])), str, "Select", "Close");
				SetPVarInt(playerid, "HargaJual", harga);
			}
		}
	}
	return 1;
}

Dialog:D_SELLCARDEALER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new total = GetPVarInt(playerid, "HargaJual");
		new vid = 0, count = 0;
		foreach(new i : PlayerVehicle)
		{
			if(VehicleData[i][cOwner] == pData[playerid][pID] && count++== pData[playerid][pListitem])
			{	
				vid = Vehicle_GetID(VehicleData[i][cVehicle]);
				GiveMoney(playerid, total);
				Vehicle_Delete(vid);
				SendSuksesTD(playerid, "Berhasil Menjual Kendaraan");
			}
		}
	}
	return 1;
}