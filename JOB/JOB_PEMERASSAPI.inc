/*

	JOB PEMERAS SUSU FIXED BY ARMZ X KIKO REVAA

*/

#include <YSI_Coding\y_hooks>

new cow1,
	cow2,
	cow3,
	cow4,
	cow5,
	cow6,
	cow7,
	cow8,
	cow9,
	cow10,
	cow11,
	cow12,
	cow13,
	cow14;

enum E_PEMERASUSU
{
	STREAMER_TAG_AREA:Dutyarea,
	STREAMER_TAG_CP:Dutycp,
	STREAMER_TAG_MAP_ICON:Iconsapi,
	STREAMER_TAG_AREA:Olahsusu,
	STREAMER_TAG_CP:Olahcp
}
new PemerasArea[MAX_PLAYERS][E_PEMERASUSU];

new pTakingSusuTimer[MAX_PLAYERS] = {-1, ...};

enum E_SUSUSTUFF
{
    STREAMER_TAG_OBJECT:CowObject,
    STREAMER_TAG_AREA:SusuTakeArea,

    bool:DuringTakeSusu,
    LastTakeSusu,
    ActivityTime
}
new PlayerSusuVars[MAX_PLAYERS][E_SUSUSTUFF],
	Iterator:MilkerOnduty<MAX_PLAYERS>;

#define memek   SusuTakeArea

DeleteJobPemerahMap(playerid)
{
	if(IsValidDynamicArea(PemerasArea[playerid][Dutyarea]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Dutyarea]);
		PemerasArea[playerid][Dutyarea] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(PemerasArea[playerid][Olahsusu]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Olahsusu]);
		PemerasArea[playerid][Olahsusu] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Dutycp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Dutycp]);
		PemerasArea[playerid][Dutycp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicMapIcon(PemerasArea[playerid][Iconsapi]))
	{
		DestroyDynamicMapIcon(PemerasArea[playerid][Iconsapi]);
		PemerasArea[playerid][Iconsapi] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshMapJobSapi(playerid)
{
	DeleteJobPemerahMap(playerid);

	if(pData[playerid][pJob] == 15)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
		return 1;
	}
	if(pData[playerid][pJob] == 15)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
	}

	return 1;
}

createladangsapi()
{
	new object_world = -1, object_int = -1;
	cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
	cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
	cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
	cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
	cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
	cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
	cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
	cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
	cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
	cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
	cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 

	return 1;
}

new Float: CowSpawn[][6] = {
	{263.905151, 1127.006591, 9.225789, 0.000000, 0.000000, -27.599998},
	{248.340896, 1071.117919, 15.849369, 12.600029, 0.599999, -155.399993},
	{263.459655, 1072.362792, 16.301292, 0.000000, 0.000000, -2.399977},
	{245.693115, 1141.448974, 10.455798, -3.800003, 2.299999, -120.100021},
	{260.870941, 1054.854614, 20.028551, -8.199966, 0.499998, 49.399993},
	{269.370971, 1040.682861, 23.219772, -8.199966, 0.499998, -60.000011},
	{234.778015, 1132.732421, 11.683193, -3.800003, 2.299999, -28.400012}, 
	{256.602630, 1147.773315, 10.189219, -3.800003, 2.299999, -175.699966}, 
	{230.033813, 1150.527832, 11.658007, -3.800003, 2.299999, -77.400054}, 
	{272.128082, 1087.664062, 13.211290, 0.000000, 0.000000, 21.000024}, 
	{251.121414, 1132.026245, 9.775797, 0.000000, 0.000000, 131.699905},
    {251.489837, 1093.701660, 12.635788, 0.000000, 0.000000, 131.699905}
};

destroyladangsapi()
{
	DestroyDynamicObject(cow1);
	DestroyDynamicObject(cow2);
	DestroyDynamicObject(cow3);
	DestroyDynamicObject(cow4);
	DestroyDynamicObject(cow5);
	DestroyDynamicObject(cow6);
	DestroyDynamicObject(cow7);
	DestroyDynamicObject(cow8);
	DestroyDynamicObject(cow9);
	DestroyDynamicObject(cow10);
	DestroyDynamicObject(cow11);
	DestroyDynamicObject(cow12);
	DestroyDynamicObject(cow13);
	DestroyDynamicObject(cow14);


	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_WALK)
	{
        if(IsPlayerInDynamicArea(playerid, PlayerSusuVars[playerid][SusuTakeArea]))
        {            
			if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5) return ErrorMsg(playerid, "Anda bukan seorang Pemerah Susu!");
            if(!PlayerSusuVars[playerid][DuringTakeSusu]) return ErrorMsg(playerid, "Anda belum memulai pemerahan susu");
            if(pData[playerid][pProgress]) return ErrorMsg(playerid, "Anda masih dalam activity progress");
            pTakingSusuTimer[playerid] = SetTimerEx("TakeSusu", 1000, true, "i", playerid);
            ShowProgressbar(playerid, "MEMERAH SUSU", 4);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0, 1);
        }	
    }
    return 1;
}

forward TakeSusu(playerid);
public TakeSusu(playerid)
{
    if(!IsPlayerConnected(playerid))
    {
        KillTimer(pTakingSusuTimer[playerid]);
        return 0;
    }

    if(!IsValidDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
    {
        KillTimer(pTakingSusuTimer[playerid]);
        pTakingSusuTimer[playerid] = 1;

        ClearAnimations(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        if(DestroyPlayerObject(playerid, PlayerSusuVars[playerid][CowObject]))
        if(DestroyDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
        PlayerSusuVars[playerid][SusuTakeArea] = STREAMER_TAG_AREA:INVALID_STREAMER_ID;                 
        return 0;
    }
    if(PlayerSusuVars[playerid][ActivityTime] == 30)
    {
        KillTimer(pTakingSusuTimer[playerid]);
        pTakingSusuTimer[playerid] = 1;
        PlayerSusuVars[playerid][ActivityTime] = 0;

        ClearAnimations(playerid, 1);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);   

        if(DestroyPlayerObject(playerid, PlayerSusuVars[playerid][CowObject]))
        if(DestroyDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
        PlayerSusuVars[playerid][SusuTakeArea] = STREAMER_TAG_AREA:INVALID_STREAMER_ID;    

		SuccesMsg(playerid,"Silahkan mencari Sapi selanjutnya untuk di perah!!");
        new rand = random(sizeof(CowSpawn));
        PlayerSusuVars[playerid][CowObject] = CreatePlayerObject(playerid, 19833, CowSpawn[rand][0], CowSpawn[rand][1], CowSpawn[rand][2], CowSpawn[rand][3], CowSpawn[rand][4], CowSpawn[rand][5], 300.00);           
        PlayerSusuVars[playerid][SusuTakeArea] = CreateDynamicSphere(CowSpawn[rand][0], CowSpawn[rand][1], CowSpawn[rand][2], 2.0);                           

        new randmilk = RandomEx(1, 4);
        pData[playerid][pSusu] += randmilk;  
		new str[500];
		format(str, sizeof(str), "Received_%dx", randmilk);
		ShowItemBox(playerid, "Susu_Mentah", str, 19570, randmilk);
    }
    else
    {
        PlayerSusuVars[playerid][ActivityTime] += 10;
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    MilkerClear(playerid);
    return 1;
}

stock MilkerClear(playerid)
{
    KillTimer(pTakingSusuTimer[playerid]);
    pTakingSusuTimer[playerid] = 0;


    if(DestroyPlayerObject(playerid, PlayerSusuVars[playerid][CowObject]))
    if(DestroyDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
    PlayerSusuVars[playerid][SusuTakeArea] = STREAMER_TAG_AREA:INVALID_STREAMER_ID;       
    return 1;
}

function spawncow1(playerid)
{
	new object_world = -1, object_int = -1;
    cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow2(playerid)
{
	new object_world = -1, object_int = -1;
    cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow3(playerid)
{
	new object_world = -1, object_int = -1;
    cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow4(playerid)
{
	new object_world = -1, object_int = -1;
    cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow5(playerid)
{
	new object_world = -1, object_int = -1;
    cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow6(playerid)
{
	new object_world = -1, object_int = -1;
    cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow7(playerid)
{
	new object_world = -1, object_int = -1;
    cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow8(playerid)
{
	new object_world = -1, object_int = -1;
    cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow9(playerid)
{
	new object_world = -1, object_int = -1;
    cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow10(playerid)
{
	new object_world = -1, object_int = -1;
    cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow11(playerid)
{
	new object_world = -1, object_int = -1;
    cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow12(playerid)
{
	new object_world = -1, object_int = -1;
    cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow13(playerid)
{
	new object_world = -1, object_int = -1;
    cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow14(playerid)
{
	new object_world = -1, object_int = -1;
    cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 15 || pData[playerid][pJob] == 15 && pData[playerid][pJobmilkduty] == true)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Olahsusu]))
		{
			if(areaid == PemerasArea[playerid][Olahsusu])
			{
				KeyBindInfo(playerid, "[ALT] Olah Susu");
			}
		}
	}
	return 1;
}

CMD:olahsusu(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] == 15 || pData[playerid][pJob2] == 15)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.5888, 1154.6294, 8.5859))
		{
			if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih olah susu!");
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			if(pData[playerid][pSusu] < 1) return ErrorMsg(playerid, "Kamu harus mengambil susu terlebih dahulu!");

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			TogglePlayerControllable(playerid, 0);

			pData[playerid][pLoading] = true;

			pData[playerid][pMilkJobStatus] = 1;
			pData[playerid][pMilkJob] = SetTimerEx("olahsusu", 4000, true, "i", playerid);
			ShowProgressbar(playerid, "Mengolah Susu..", 4);
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
   			pData[playerid][pEnergy] -= 2;
		}
		else return ErrorMsg(playerid, "Kamu tidak berada ditempat pemeras susu");
	}
	else return ErrorMsg(playerid, "Kamu bukan pekerja pemeras susu!");

	return 1;
}

function olahsusu(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pMilkJobStatus] != 1) return 0;
	if(pData[playerid][pJob] == 15 || pData[playerid][pJob2] == 15)
	{
			SuccesMsg(playerid, "Anda telah berhasil mengolah susu");
			ShowItemBox(playerid, "Susu_Olahan", "ADD_1x", 19569, 3);
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pMilkJobStatus] = 0;
			pData[playerid][pProgress] = 0;
			pData[playerid][pLoading] = false;
			pData[playerid][pSusu] --;
			ClearAnimations(playerid);
			pData[playerid][pSusuOlahan]++;
	}
	return 1;
}

CMD:jualsusumamah(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    new total = pData[playerid][pSusuOlahan];
    if(pData[playerid][pSusuOlahan] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Susu Olahan");
    ShowProgressbar(playerid, "Menjual Susu..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pSusuOlahan] * 10;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pSusuOlahan] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Susu_Olahan", str, 19569, total);
    Inventory_Update(playerid);
	return 1;
}
