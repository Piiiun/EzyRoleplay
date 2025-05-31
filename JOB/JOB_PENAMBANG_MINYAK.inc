enum E_MINYAK
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:NambangMap,
    STREAMER_TAG_MAP_ICON:NambangMapp,
    STREAMER_TAG_MAP_ICON:OlahMap,
	STREAMER_TAG_CP:LockerTambang,
	STREAMER_TAG_CP:Nambang,
	STREAMER_TAG_CP:Nambangg,
	STREAMER_TAG_CP:OlahMinyak,
	STREAMER_TAG_CP:LockerDuty,
	STREAMER_TAG_3D_TEXT_LABEL:Locker3D,
	STREAMER_TAG_3D_TEXT_LABEL:LockerObj,
}
new MinyakArea[MAX_PLAYERS][E_MINYAK];

DeleteMinyakCP(playerid)
{
	if(IsValidDynamicCP(MinyakArea[playerid][LockerTambang]))
	{
		DestroyDynamicCP(MinyakArea[playerid][LockerTambang]);
		MinyakArea[playerid][LockerTambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][LockerDuty]))
	{
		DestroyDynamicCP(MinyakArea[playerid][LockerDuty]);
		MinyakArea[playerid][LockerDuty] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][Nambang]))
	{
		DestroyDynamicCP(MinyakArea[playerid][Nambang]);
		MinyakArea[playerid][Nambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][Nambangg]))
	{
		DestroyDynamicCP(MinyakArea[playerid][Nambangg]);
		MinyakArea[playerid][Nambangg] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][OlahMinyak]))
	{
		DestroyDynamicCP(MinyakArea[playerid][OlahMinyak]);
		MinyakArea[playerid][OlahMinyak] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][LockerMap]);
		MinyakArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][NambangMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][NambangMap]);
		MinyakArea[playerid][NambangMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][NambangMapp]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][NambangMapp]);
		MinyakArea[playerid][NambangMapp] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][OlahMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][OlahMap]);
		MinyakArea[playerid][OlahMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	//if(IsValidDynamic3DTextLabel(MinyakArea[playerid][Locker3D]))
	//{
	//	DestroyDynamic3DTextLabel(MinyakArea[playerid][Locker3D]);
	//	MinyakArea[playerid][Locker3D] = STREAMER_TAG_3D_TEXT_LABEL: -1;
	//}
	///if(IsValidDynamicObject(MinyakArea[playerid][LockerObj]))
	//{
	//	DestroyDynamicObject(MinyakArea[playerid][LockerObj]);
	//	MinyakArea[playerid][LockerObj] = STREAMER_TAG_CP: -1;
	//}
}

RefreshJobTambangMinyak(playerid)
{
	//new str[64];
	//format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Mengakses Locker");
	DeleteMinyakCP(playerid);

	if(pData[playerid][pJob] == 14)
	{
		//MinyakArea[playerid][LockerObj] = CreateDynamicObject(1316, 117.4530,1108.9342,13.6094 -0.5, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
		//MinyakArea[playerid][Locker3D] = CreateDynamic3DTextLabel(str, COLOR_WHITE, 576.9179,1223.8799,11.7113+0.35, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1);
		MinyakArea[playerid][LockerDuty] = CreateDynamicCP(576.9179,1223.8799,11.7113, 2.0, -1, -1, playerid, 30.0);
		MinyakArea[playerid][Nambang] = CreateDynamicCP(435.119323,1264.405517,9.370626, 2.0, -1, -1, playerid, 30.0);
		MinyakArea[playerid][Nambangg] = CreateDynamicCP(490.874359,1294.272338,9.020936, 2.0, -1, -1, playerid, 30.0);
		MinyakArea[playerid][OlahMinyak] = CreateDynamicCP(570.088989,1219.789794,11.711267, 2.0, -1, -1, playerid, 30.0);
		MinyakArea[playerid][NambangMap] = CreateDynamicMapIcon(435.119323,1264.405517,9.370626, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		MinyakArea[playerid][OlahMap] = CreateDynamicMapIcon(570.088989,1219.789794,11.711267, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		MinyakArea[playerid][NambangMapp] = CreateDynamicMapIcon(490.874359,1294.272338,9.020936, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

function Minyak1(playerid)
{
	ShowItemBox(playerid, "Minyak", "Received_5x", 2969, 4);
	pData[playerid][pMinyak] += 5;
	return 1;
}

CMD:kerjaminyak1(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] != 14) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum duty job");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	if(pData[playerid][pMinyak] > 25) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 25");
	ShowProgressbar(playerid, "Mengambil Minyak..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, ""WHITE_E"ACTION: "PURPLE_E"%s sedang mengambil minyak", pData[playerid][pName]);
	SetTimerEx("Minyak1", 10000, false, "d", playerid);
	return 1;
}

CMD:kerjaminyak2(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
    if(pData[playerid][pJob] != 14) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum duty job");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pMinyak] > 25) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 25");
	ShowProgressbar(playerid, "Mengambil Minyak..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, ""WHITE_E"ACTION: "PURPLE_E"%s sedang mengambil minyak", pData[playerid][pName]);
	SetTimerEx("Minyak1", 10000, false, "d", playerid);
	return 1;
}

CMD:saringminyak(playerid, params[])
{
    if(pData[playerid][pJob] != 14) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum duty job");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pMinyak] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 5 Liter Minyak");
    if(pData[playerid][pEssence] > 50) return ErrorMsg(playerid, "Inventory kamu sudah penuh Essence");
    new pay = pData[playerid][pMinyak] * 1;
    new total = pData[playerid][pMinyak];
    pData[playerid][pMinyak] -= total;
	pData[playerid][pEssence] += total;
	pData[playerid][pJobTime] += 480;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Essence", str, 3015, 3);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Minyak", str, 2969, 3);
	ShowProgressbar(playerid, "Mengolah Minyak..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, ""WHITE_E"ACTION: "PURPLE_E"%s sedang menyaring minyak", pData[playerid][pName]);
    Inventory_Update(playerid);
	return 1;
}

CMD:adolminyak(playerid, params[])
{
    new total = pData[playerid][pEssence];
	//if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum duty job");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pEssence] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Essence");
    ShowProgressbar(playerid, "Menjual Minyak..", 6);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pEssence] * 8;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pEssence] -= total;
	GasOil += 30;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 5);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Essence", str, 3015, 5);
    Inventory_Update(playerid);
	return 1;
}
