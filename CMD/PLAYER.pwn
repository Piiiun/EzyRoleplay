//-------------[ Player Commands ]-------------//
CMD:help(playerid, params[])
{
	new str[512], info[512];
	format(str, sizeof(str), "Pengguna Akun\nGeneral\nSistem Kendaraan\nPekerjaan\nFaction/Family\nAuto RP\nBusiness System\nHouse System\nDonate\nServer Credits\n");
	strcat(info, str);
	if(pData[playerid][pRobLeader] > 1 || pData[playerid][pMemberRob] > 1)
	{
		format(str, sizeof(str), "Robbery Help");
		strcat(info, str);	
	}
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Help Menu", info, "Select", "Close");
	return 1;
}

CMD:destroycp(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pSideJob] > 1 || pData[playerid][pCP] > 1)
		return ErrorMsg(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	Servers(playerid, "Menghapus Checkpoint Sukses");
	return 1;
}

CMD:credits(playerid)
{
	new line1[1200], line2[300], line3[500];
	strcat(line3, ""LB_E"OWNER: "YELLOW_E"ZiroHamz for Update\n");
	strcat(line3, ""LB_E"Co Owner: "YELLOW_E"Bapak E Ziro\n");
	strcat(line3, ""LB_E"Bot Kota: "YELLOW_E"Ian (ZiroGanteng)\n");
	strcat(line3, ""LB_E"Support Mapper: "YELLOW_E"ZiroHamz\n");
	strcat(line3, ""LB_E"Support Website: "YELLOW_E"Ziro\n");
	format(line2, sizeof(line2), ""LB_E"Server Support: "YELLOW_E"%s & All SA-MP Team\n\n\
	"GREEN_E"Terima kasih telah bergabung dengan kami! Warga Kota | #BersamaKitaBisa", pData[playerid][pName]);
	format(line1, sizeof(line1), "%s%s", line3, line2);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Server Credits", line1, "OK", "");
	return 1;
}

CMD:vip(playerid)
{
	new longstr2[3500];
	strcat(longstr2, ""YELLOW_E"Looking for bonus features and commands? Get PREMIUM status today!\n\n"RED_E"PREMIUM features:\n\
	"dot""GREEN_E"REGULAR(1) "PINK_E"Rp.30.000/month"RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"20 "WHITE_E"VIP Gold.\n");
	strcat(longstr2, ""YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n");

	strcat(longstr2, ""YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.\n\
	"YELLOW_E"4) "WHITE_E"Mempunya "LB_E"4 "WHITE_E"slot untuk kendaraan pribadi.\n\
	"YELLOW_E"5) "WHITE_E"Mempunya "LB_E"2 "WHITE_E"Slot untuk rumah.\n");
	strcat(longstr2, ""YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"2 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".\n");
	strcat(longstr2, ""YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"5% "WHITE_E"lebih cepat.\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"10% "WHITE_E"bunga bank setiap kali paycheck.");


	strcat(longstr2, "\n\n"dot""YELLOW_E"PREMIUM(2) "PINK_E"Rp.50,000/month "RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"30"WHITE_E" VIP Gold.\n\
	"YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n");
	strcat(longstr2, ""YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.\n\
	"YELLOW_E"4) "WHITE_E"Mempunyai "LB_E"5 "WHITE_E"slot untuk kendaraan pribadi.");

	strcat(longstr2, "\n"YELLOW_E"5) "WHITE_E"Mempunyai "LB_E"3 "WHITE_E"Slot untuk rumah.\n\
	"YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"3 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".\n");
	strcat(longstr2, ""YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"10% "WHITE_E"lebih cepat\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"15% "WHITE_E"bunga bank setiap kali paycheck.");

	strcat(longstr2, "\n\n"dot""PURPLE_E"DIAMOND(3) "PINK_E"Rp.80,000/month "RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"40 "WHITE_E"VIP Gold.\n\
	"YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n\
	"YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.");
	strcat(longstr2, "\n"YELLOW_E"4) "WHITE_E"Mempunyai "LB_E"6 "WHITE_E"slot untuk kendaraan pribadi.\n\
	"YELLOW_E"5) "WHITE_E"Mempunyai "LB_E"4 "WHITE_E"Slot untuk rumah.\n\
	"YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"4 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".");
	strcat(longstr2, "\n"YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"15% "WHITE_E"lebih cepat.\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"20% "WHITE_E"bunga bank setiap kali paycheck.");

	strcat(longstr2, "\n\n"LB_E"Pembayaran Via Dana. "LB2_E"Harga VIP Gold "LB_E"Rp.1,000/gold.\n\
	"YELLOW_E"Untuk informasi selengkapnya hubungin ZiroHamz/Albengbeng (Founder)!");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - VIP SYSTEM", longstr2, "Close", "");
	return 1;
}

CMD:donate(playerid)
{
    new line3[3500];
    strcat(line3, ""RED_E"...:::... "DOOM_"Donate List Warga Kota "RED_E"...:::...\n");
    strcat(line3, ""RED_E"..:.. "DOOM_"GOLD(OOC) "RED_E"..:..\n\n");

    strcat(line3, ""DOOM_"1. 250 Gold >> "RED_E"Rp 15.000\n");
    strcat(line3, ""DOOM_"2. 525 Gold >> "RED_E"Rp 25.000\n");
	strcat(line3, ""DOOM_"3. 1125 Gold >> "RED_E"Rp 50.000\n");
    strcat(line3, ""DOOM_"4. 2150 Gold >> "RED_E"Rp 100.000\n");
	strcat(line3, ""DOOM_"5. 3125 Gold >> "RED_E"Rp 150.000\n");
    strcat(line3, ""DOOM_"6. 4200 Gold >> "RED_E"Rp 200.000\n\n");

    strcat(line3, ""RED_E"..:.. "PINK_E"RP BOOSTER "RED_E"..:..\n\n");

    strcat(line3, ""DOOM_"1. 7 Days >> "RED_E"Rp 15.000\n");
    strcat(line3, ""DOOM_"2. 14 Days >> "RED_E"Rp 25.000\n");
	strcat(line3, ""DOOM_"3. 30 Days >> "RED_E"Rp 50.000/Boost Discord\n");
    strcat(line3, ""DOOM_"4. 60 Days >> "RED_E"Rp 100.000/Boost Discord\n");
	strcat(line3, ""DOOM_"5. 80 Days >> "RED_E"Rp 150.000/Boost Discord\n");
    strcat(line3, ""DOOM_"6. 130 Days >> "RED_E"Rp 200.000/Boost Discord\n\n");

	strcat(line3, ""RED_E"..::.. "DOOM_"DIAMOND"RED_E"..::..\n\n");
	
    strcat(line3, ""DOOM_"1. VIP REGULAR(1 Month) >> "RED_E"500 Gold\n");
    strcat(line3, ""DOOM_"2. VIP PREMIUM(1 Month) >> "RED_E"900 Gold\n");
    strcat(line3, ""DOOM_"3. VIP DIAMOND(1 Month) >> "RED_E"1200 Gold\n\n");

	strcat(line3, ""RED_E"..:::.. "DOOM_"SERVER FEATURE "RED_E"..:::..\n\n");
    strcat(line3, ""DOOM_"1. Mapping(per object) >> "RED_E"60 Gold\n");
	strcat(line3, ""DOOM_"2. Private Door >> "RED_E"100 Gold\n");
	strcat(line3, ""DOOM_"3. Private Gate >> "RED_E"200 Gold\n");
	strcat(line3, ""DOOM_"4. Bisnis >> "RED_E"(Tergantung Lokasi)\n");
	strcat(line3, ""DOOM_"5. House >> "RED_E"(Tergantung Lokasi dan Type)\n");
	strcat(line3, ""DOOM_"6. Custom House Interior >> "RED_E"(Tergantung Interior)\n\n");
	
	strcat(line3, ""RED_E"..::::.. "DOOM_"SERVER VEHICLE "RED_E"..:::::..\n\n");
    strcat(line3, ""DOOM_"1. VEHICLE IN DEALER >> "RED_E"1200 Gold\n");
	strcat(line3, ""DOOM_"2. VEHICLE NON DEALER >> "RED_E"1800 Gold\n");
	strcat(line3, ""DOOM_"3. BOAT / HELI >> "RED_E"2300 Gold\n\n");

    strcat(line3, ""RED_E"..::.. "WHITE_E"CONTACT INFO "RED_E"..::..\n");
    strcat(line3, ""WHITE_E"1. NAMA : "RED_E"ZiroHamz\n");
    strcat(line3, ""WHITE_E"- Support Server Dengan Donate? Bisa Langsung PM/DM Di DC"RED_E"@albengbeng\n\n");
	
    strcat(line3, ""WHITE_E"2. Owner : "RED_E"ZiroHamz)\n");
    strcat(line3, ""WHITE_E"- Donate Hanya Di Owner : "RED_E"@albengbeng / Owner ZiroHamz\n\n");

    strcat(line3, ""RED_E"..::.. "WHITE_E"NOTE "RED_E"..::..\n");
    strcat(line3, ""WHITE_E"Note: "RED_E"Pembayaran Melewati Dana!\n\n");

	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - DONATE LIST", line3, "Okay", "");
	return 1;
}

CMD:togphone(playerid)
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel!");
	if(pData[playerid][pPhoneStatus] == 1)
	{
		pData[playerid][pPhoneStatus] = 0;
		pData[playerid][pTogPhone] = 0;
		Servers(playerid, "Berhasil mematikan Handphone");
		return 0;
	}
	if(pData[playerid][pPhoneStatus] == 0)
	{
		pData[playerid][pPhoneStatus] = 1;
		Servers(playerid, "Berhasil menyalakan Handphone");
		return 0;
	}
	return 1;
}

CMD:email(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu harus login!");

	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, ""WHITE_E"Set Email", ""WHITE_E"Masukkan Email.\nIni akan digunakan sebagai ganti kata sandi.\n\n"RED_E"* "WHITE_E"Email mu tidak akan termunculkan untuk Publik\n"RED_E"* "WHITE_E"Email hanya berguna untuk verifikasi Password yang terlupakan dan berita lainnya\n\
	"RED_E"* "WHITE_E"Be sure to double-check and enter a valid email address!", "Enter", "Exit");
	return 1;
}

CMD:changepass(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu harus login sebelum menggantinya!");

	ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_INPUT, ""WHITE_E"Change your password", "Masukkan Password untuk menggantinya!", "Change", "Exit");
	InfoTD_MSG(playerid, 3000, "~g~~h~Masukkan password yang sebelum nya anda pakai!");
	return 1;
}

CMD:savestats(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu belum login!");
		
	UpdatePlayerData(playerid);
	Servers(playerid, "Statistik Anda sukses disimpan kedalam Database!");
	return 1;
}

CMD:gshop(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Gold Shop\tPrice\n\
	Instant Change Name\t500 Gold\n");
	format(Dstring, sizeof(Dstring), "%sClear Warning\t1000 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 1(7 Days)\t150 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 2(7 Days)\t250 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 3(7 Days)\t500 Gold\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_GOLDSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Gold Shop", Dstring, "Buy", "Cancel");
	return 1;
}

CMD:mypos(playerid, params[])
{
	new int, Float:px,Float:py,Float:pz, Float:a;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, a);
	int = GetPlayerInterior(playerid);
	new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, zone, sizeof(zone));
	SendClientMessageEx(playerid, COLOR_WHITE, "Lokasi Anda Saat Ini: %s (%0.2f, %0.2f, %0.2f, %0.2f) Int = %d", zone, px, py, pz, a, int);
	return 1;
}

CMD:gps(playerid, params[])
{
	if(pData[playerid][pGPS] < 1) return ErrorMsg(playerid, "Anda tidak memiliki GPS.");
	ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
	return 1;
}

CMD:death(playerid, params[])
{
	if(pData[playerid][pMoney] < 500)
		return ErrorMsg(playerid, "Kamu harus punya 500$.");
		
    if(pData[playerid][pInjured] == 0)
        return ErrorMsg(playerid, "Kamu belum injured.");
		
	if(pData[playerid][pJail] > 0)
		return ErrorMsg(playerid, "Kamu tidak bisa menggunakan ini saat diJail!");
		
	if(pData[playerid][pArrest] > 0)
		return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini saat tertangkap polisi!");

    if((gettime()-GetPVarInt(playerid, "GiveUptime")) < 100)
        return ErrorMsg(playerid, "Kamu harus menunggu 3 menit untuk kembali kerumah sakit");
        
	/*if(pMatiPukul[playerid] == 1)
	{
	    SetPlayerHealthEx(playerid, 50.0);
	    ClearAnimations(playerid);
	    pData[playerid][pInjured] = 0;
	    pMatiPukul[playerid] = 0;
    	Servers(playerid, "You have wake up and accepted death in your position.");
    	return 1;
	}*/
    Servers(playerid, "Kamu telah terbangun dari pingsan.");
	pData[playerid][pHospitalTime] = 0;
	pData[playerid][pHospital] = 1;
    return 1;
}

/*CMD:piss(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

    if(pData[playerid][pInjured] == 1)
        return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
        
	new time = (100 - pData[playerid][pBladder]) * (300);
    SetTimerEx("UnfreezePee", time, 0, "i", playerid);
    SetPlayerSpecialAction(playerid, 68);
    return 1;
}

CMD:kencing(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

    if(pData[playerid][pInjured] == 1)
        return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
        
	new time = (100 - pData[playerid][pBladder]) * (300);
    SetTimerEx("UnfreezePee", time, 0, "i", playerid);
    SetPlayerSpecialAction(playerid, 68);
    return 1;
}*/

CMD:health(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new hstring[512], info[512];
	new hh = pData[playerid][pHead];
	new hp = pData[playerid][pPerut];
	new htk = pData[playerid][pRHand];
	new htka = pData[playerid][pLHand];
	new hkk = pData[playerid][pRFoot];
	new hkka = pData[playerid][pLFoot];
	format(hstring, sizeof(hstring),"Bagian Tubuh\tKondisi\n{ffffff}Kepala\t{7fffd4}%d.0%\n{ffffff}Perut\t{7fffd4}%d.0%\n{ffffff}Tangan Kanan\t{7fffd4}%d.0%\n{ffffff}Tangan Kiri\t{7fffd4}%d.0%\n",hh,hp,htk,htka);
	strcat(info, hstring);
    format(hstring, sizeof(hstring),"{ffffff}Kaki Kanan\t{7fffd4}%d.0%\n{ffffff}Kaki Kiri\t{7fffd4}%d.0%\n",hkk,hkka);
    strcat(info, hstring);
    ShowPlayerDialog(playerid, DIALOG_HEALTH, DIALOG_STYLE_TABLIST_HEADERS,"Health Condition",info,"Oke","");
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pInjured] == 1)
        return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
	
	if(pData[playerid][pInHouse] == -1)
		return ErrorMsg(playerid, "Kamu tidak berada didalam rumah.");
	
	InfoTD_MSG(playerid, 10000, "Sleeping... Harap Tunggu");
	TogglePlayerControllable(playerid, 0);
	new time = (100 - pData[playerid][pEnergy]) * (400);
    SetTimerEx("UnfreezeSleep", time, 0, "i", playerid);
	switch(random(6))
	{
		case 0: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_L",4.1,0,0,0,1,1);
		case 1: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_R",4.1,0,0,0,1,1);
		case 2: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_L",4.1,1,0,0,1,1);
		case 3: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_R",4.1,1,0,0,1,1);
		case 4: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_L",4.1,0,1,1,0,0);
		case 5: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_R",4.1,0,1,1,0,0);
	}
	return 1;
}

/*CMD:salary(playerid, params[])
{
	new query[256], count;
	format(query, sizeof(query), "SELECT * FROM salary WHERE owner='%d'", pData[playerid][pID]);
	new Cache:result = mysql_query(g_SQL, query);
	new rows = cache_num_rows();
	if(rows) 
	{
		new str[2048];
		for(new i; i < rows; i++)
		{
			new info[64];
			cache_get_value_int(i, "id", pSalary[playerid][i][salaryId]);
			cache_get_value_int(i, "money", pSalary[playerid][i][salaryMoney]);
			cache_get_value(i, "info", info);
			format(pSalary[playerid][i][salaryInfo], 64, "%s", info);
			cache_get_value_int(i, "date", pSalary[playerid][i][salaryDate]);
			
			format(str, sizeof(str), "%s%s\t%s\t%s\n", str, ReturnDate(pSalary[playerid][i][salaryDate]), pSalary[playerid][i][salaryInfo], FormatMoney(pSalary[playerid][i][salaryMoney]));
			count++;
			if(count >= 10) break;
		}
		format(str, sizeof(str), "Date\tInfo\tCash\n", str);
		if(count >= 10)
		{
			format(str, sizeof(str), "%s\nNext >>>", str);
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Salary Details", str, "Close", "");
	}
	else 
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Notice", "Kamu tidak memiliki salary saat ini!", "Ok", "");
	}
	cache_delete(result);
	return 1;
}*/

CMD:time(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu harus login!");
		
	new line2[1200];
	new paycheck = 3600 - pData[playerid][pPaycheck];
	if(paycheck < 1)
	{
		paycheck = 0;
	}
	
	format(line2, sizeof(line2), ""WHITE_E"Paycheck Time: "YELLOW_E"%d remaining\n"WHITE_E"Delay Job: "RED_E"%d Detik\n"WHITE_E"Delay Side Job: "RED_E"%d Detik\n"WHITE_E"Plant Time(Farmer): "RED_E"%d Detik\n"WHITE_E"Arrest Time: "RED_E"%d Detik\n"WHITE_E"Jail Time: "RED_E"%d Detik\n", paycheck, pData[playerid][pJobTime], pData[playerid][pSideJobTime], pData[playerid][pPlantTime], pData[playerid][pArrestTime], pData[playerid][pJailTime]);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Time", line2, "Oke", "");
	return 1;
}
/*
CMD:idcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki id card!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[ID-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	return 1;
}*/


CMD:giveidcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki id card!");	

	new otherid;
	if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/giveidcard [playerid/PartOfName]");
	
	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police Warga Kota";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment Warga Kota";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = " Medic Warga Kota";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News Warga Kota";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang Warga Kota";
	}
	else
	{
		fac = "Pengangguran";
	}

	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(otherid, IDCard[playerid][17], strings);
	// Set birtdate
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(otherid, IDCard[playerid][18], strings);
	// Set Job
	format(strings, sizeof(strings), "%s", fac);
	PlayerTextDrawSetString(otherid, IDCard[playerid][20], strings);
	// Set Expired IDCARD
	format(strings, sizeof(strings), "%s", ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	PlayerTextDrawSetString(otherid, IDCard[playerid][12], strings);	
	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "ktp_skin"))
	{
		PlayerTextDrawSetPreviewModel(otherid, IDCard[playerid][24], GetPlayerSkin(playerid));
		PlayerTextDrawShow(otherid, IDCard[playerid][24]);
		SetPVarInt(playerid, "ktp_skin", GetPlayerSkin(playerid));
	}		

	
	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawShow(otherid, IDCard[playerid][txd]);
		SelectTextDraw(otherid, COLOR_LBLUE);
	}
	return 1;
}

CMD:hideidcard(playerid, params[])
{
	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawHide(playerid, IDCard[playerid][txd]);
	}	
	return 1;
}

CMD:showidcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki id card!");

	/*new married[20];
	strmid(married, pData[playerid][pMarriedTo], 0, strlen(pData[playerid][pMarriedTo]), 255);
	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police Warga Kota";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment Warga Kota";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = "Medic Warga Kota";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News Warga Kota";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang Warga Kota";
	}
	else
	{
		fac = "Pengangguran";
	}

	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, IDCard[playerid][17], strings);
	// Set birtdate
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, IDCard[playerid][18], strings);
	// Set Job
	format(strings, sizeof(strings), "%s", fac);
	PlayerTextDrawSetString(playerid, IDCard[playerid][20], strings);
	// Set Expired IDCARD
	format(strings, sizeof(strings), "%s", ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	PlayerTextDrawSetString(playerid, IDCard[playerid][12], strings);	
	// Set Expired married
	format(strings, sizeof(strings), "%s", married);
	PlayerTextDrawSetString(playerid, IDCard[playerid][19], strings);
	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "ktp_skin"))
	{
		PlayerTextDrawSetPreviewModel(playerid, IDCard[playerid][24], GetPlayerSkin(playerid));
		PlayerTextDrawShow(playerid, IDCard[playerid][24]);
		SetPVarInt(playerid, "ktp_skin", GetPlayerSkin(playerid));
	}		

	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawShow(playerid, IDCard[playerid][txd]);
		SelectTextDraw(playerid, COLOR_LBLUE);
	}*/
	callcmd::ktpsatrio(playerid, "");
	return 1;
}

CMD:drivelic(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Driving License/SIM!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[Drive-Lic] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
	return 1;
}

CMD:newidcard(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1393.3154,-12.7873,1000.9166)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
	if(pData[playerid][pIDCard] != 0) return ErrorMsg(playerid, "Anda sudah memiliki ID Card!");
	if(GetPlayerMoney(playerid) < 50) return ErrorMsg(playerid, "Anda butuh $50 untuk membuat ID Card");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
	pData[playerid][pIDCard] = 1;
	pData[playerid][pIDCardTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -50);
	Server_AddMoney(25);
	return 1;
}

CMD:newage(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1392.77, -22.25, 1000.97)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
	//if(pData[playerid][pIDCard] != 0) return ErrorMsg(playerid, "Anda sudah memiliki ID Card!");
	if(GetPlayerMoney(playerid) < 300) return ErrorMsg(playerid, "Anda butuh $300 untuk mengganti tgl lahir anda!");
	if(pData[playerid][IsLoggedIn] == false) return ErrorMsg(playerid, "Anda harus login terlebih dahulu!");
	ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Change", "Cancel");
	return 1;
}

CMD:newdrivelic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1491.6233,1305.2896,1093.2964)) return Error(playerid, "Anda harus berada di SAPD!");
	if(pData[playerid][pDriveLic] != 0) return Error(playerid, "Anda sudah memiliki Driving License!");
	if(GetPlayerMoney(playerid) < 70) return Error(playerid, "Anda butuh $70 untuk membuat Driving License.");
	Info(playerid, "Silahkan masuki salah satu mobil untuk mengikuti tes mengemudi");
	pData[playerid][pDriveLicApp] = 1;
	pData[playerid][pCheckPoint] = CHECKPOINT_DRIVELIC;
	return 1;
}

/*CMD:buyplate(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 240.80, 112.95, 1003.21)) return ErrorMsg(playerid, "Anda harus berada di SAPD!");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tPlate\tPlate Time\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			if(strcmp(pvData[i][cPlate], "NoHave"))
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				found = true;
			}
			else
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s\t%s\tNone\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_BUYPLATE, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles Plate", msg2, "Buy", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles Plate", "Anda tidak memeliki kendaraan", "Close", "");
			
	return 1;
}*/

CMD:payticket(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1400.9375,1109.9957,23233.0859)) return ErrorMsg(playerid, "Anda harus berada di kantor SAPD!");
	
	new vehid;
	if(sscanf(params, "d", vehid))
		return SyntaxMsg(playerid, "/payticket [vehid] | /v my(/mypv) - for find vehid");
		
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return ErrorMsg(playerid, "Invalid id");
		
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new ticket = pvData[i][cTicket];
				
				if(ticket > GetPlayerMoney(playerid))
					return ErrorMsg(playerid, "Not enough money! check your ticket in /v insu.");
					
				if(ticket > 0)
				{
					GivePlayerMoneyEx(playerid, -ticket);
					pvData[i][cTicket] = 0;
					Info(playerid, "Anda telah berhasil membayar ticket tilang kendaraan %s(id: %d) sebesar "RED_E"%s", GetVehicleName(vehid), vehid, FormatMoney(ticket));
					return 1;
				}
			}
			else return ErrorMsg(playerid, "Kendaraan ini bukan milik anda! /v my(/mypv) - for find vehid");
		}
	}
	return 1;
}

CMD:buyplate(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1401.0576,1115.8191,23233.0859)) return ErrorMsg(playerid, "Anda harus berada di SAPD!");
		
	new vehid;
	if(sscanf(params, "d", vehid)) return SyntaxMsg(playerid, "/buyplate [vehid] | /v my(/mypv) - for find vehid");
	
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return ErrorMsg(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk membeli Plate baru.");
				GivePlayerMoneyEx(playerid, -500);
				new rand = RandomEx(1111, 9999);
				format(pvData[i][cPlate], 32, "LP-%d", rand);
				SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
				pvData[i][cPlateTime] = gettime() + (15 * 86400);
				Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
			}
			else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:buyinsu(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1299.5710,-1267.5194,13.5939)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
		
	new vehid;
	if(sscanf(params, "d", vehid)) return SyntaxMsg(playerid, "/buyinsu [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID] && pvData[i][cClaim] == 0)
			{
				if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk membeli Insurance.");
				GivePlayerMoneyEx(playerid, -500);
				pvData[i][cInsu]++;
				Info(playerid, "Model: %s || Total Insurance: %d || Insurance Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cInsu]);
			}
			else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:claimpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1299.5710,-1267.5194,13.5939)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
	new found = 0;
	foreach(new i : PVehicles)
	{
		if(pvData[i][cClaim] == 1 && pvData[i][cClaimTime] == 0)
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				pvData[i][cClaim] = 0;
				
				OnPlayerVehicleRespawn(i);
				pvData[i][cPosX] = 1327.7679;
				pvData[i][cPosY] = -1238.2716;
				pvData[i][cPosZ] = 13.4189;
				pvData[i][cPosA] = 270.9286;
				SetValidVehicleHealth(pvData[i][cVeh], 1500);
				SetVehiclePos(pvData[i][cVeh], 1327.7679, -1238.2716, 13.4189);
				SetVehicleZAngle(pvData[i][cVeh], 183.05);
				SetVehicleFuel(pvData[i][cVeh], 100);
				found++;
				Info(playerid, "Anda telah mengclaim kendaraan %s anda.", GetVehicleModelName(pvData[i][cModel]));
			}
			//else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	if(found == 0)
	{
		InfoMsg(playerid, "Sekarang belum saatnya anda mengclaim kendaraan anda!");
	}
	else
	{
		Info(playerid, "Anda berhasil mengclaim %d kendaraan anda!", found);
	}
	return 1;
}

CMD:sellpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1299.5710,-1267.5194,13.5939)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
	
	new vehid;
	if(sscanf(params, "d", vehid)) return SyntaxMsg(playerid, "/sellpv [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(!IsValidVehicle(pvData[i][cVeh])) return ErrorMsg(playerid, "Your vehicle is not spanwed!");
				if(pvData[i][cRent] != 0) return ErrorMsg(playerid, "You can't sell rental vehicle!");
				new pay = pvData[i][cPrice] / 2;
				GivePlayerMoneyEx(playerid, pay);
				
				Info(playerid, "Anda menjual kendaraan model %s(%d) dengan seharga "LG_E"%s", GetVehicleName(vehid), GetVehicleModel(vehid), FormatMoney(pay));
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
				pvData[i][cVeh] = INVALID_VEHICLE_ID;
				Iter_SafeRemove(PVehicles, i, i);
			}
			else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:newrek(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 186.3593,-91.4849,1031.4844)) return ErrorMsg(playerid, "Anda harus berada di Bank!");
	if(GetPlayerMoney(playerid) < 50) return ErrorMsg(playerid, "Not enough money!");
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	InfoMsg(playerid, "New rekening bank!");
	GivePlayerMoneyEx(playerid, -50);
	Server_AddMoney(50);
	return 1;
}

CMD:bank(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 193.0425,-91.0659,1031.4844)) return ErrorMsg(playerid, "Anda harus berada di bank point!");
	new tstr[128];
	format(tstr, sizeof(tstr), ""ORANGE_E"No Rek: "LB_E"%d", pData[playerid][pBankRek]);
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, tstr, "Deposit Money\nWithdraw Money\nCheck Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
	return 1;
}

CMD:pay(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new money, otherid, mstr[128];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/pay <ID/Name> <amount>");
	    return true;
	}
	
	if(pData[playerid][pLevel] < 2)
		return ErrorMsg(playerid, "You must level 2 to pay!");

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return ErrorMsg(playerid, "Player disconnect atau tidak berada didekat anda.");

 	if(otherid == playerid)
		return ErrorMsg(playerid, "You can't send yourself money!");
	if(pData[playerid][pMoney] < money)
		return ErrorMsg(playerid, "You don't have enough money to send!");
	if(money > 1000000 && pData[playerid][pAdmin] == 0)
		return ErrorMsg(playerid, "You can't send more than $1,000,000 at once!");
	if(money < 1)
		return ErrorMsg(playerid, "You can't send anyone less than $1!");
		
	/*GivePlayerMoneyEx(otherid, money);
	GivePlayerMoneyEx(playerid, -money);

	format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", pName[otherid], otherid, FormatMoney(money));
	SendClientMessage(playerid, COLOR_GREY, mstr);
	format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", pName[playerid], playerid, FormatMoney(money));
	SendClientMessage(otherid, COLOR_GREY, mstr);
	InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
	InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
	ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	
	new OtherIP[16];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	GetPlayerIp(otherid, OtherIP, sizeof(OtherIP));
	SendStaffMessage(COLOR_RED, "[PAYINFO] "WHITE_E"%s(%d)[IP: %d] pay to %s(%d)[IP: %d] ammount "GREEN_E"%s", pName[playerid], playerid, PlayerIP, pName[otherid], otherid, OtherIP, FormatMoney(money));*/
	format(mstr, sizeof(mstr), ""WHITEP_E"Are you sure you want to send %s(%d) "GREEN_E"%s?", ReturnName(otherid), otherid, FormatMoney(money));
	ShowPlayerDialog(playerid, DIALOG_PAY, DIALOG_STYLE_MSGBOX, ""GREEN_E"Send Money", mstr, "Send", "Cancel");

	SetPVarInt(playerid, "gcAmount", money);
	SetPVarInt(playerid, "gcPlayer", otherid);
	return 1;
}

CMD:togtw(playerid, params[])
{
	if(pData[playerid][pPhone] < 1)
		return ErrorMsg(playerid, "Anda belum memiliki Ponsel");

	if(pData[playerid][pPhoneStatus] < 1)
		return ErrorMsg(playerid, "Anda belum menyalakan Ponsel");

	if(pData[playerid][pTwitter] < 1)
		return ErrorMsg(playerid, "Anda belum memiliki Twitter, harap download!");

	if(pData[playerid][pTogPhone] == 1)
	{
		pData[playerid][pTogPhone] = 0;
		Servers(playerid, "Berhasil menutup Twitter");
	}
	else if(pData[playerid][pTogPhone] == 0)
	{
		if(pData[playerid][pKuota] < 20)
			return Error(playerid, "Kuota anda sisa %d, harap isi ulang", pData[playerid][pKuota]);

		pData[playerid][pTogPhone] = 1;
		Servers(playerid, "Berhasil membuka Twitter");
	}
	return 1;
}

CMD:tw(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Sistem Ini tidak dapat digunakan di OOC Zone");

	if(pData[playerid][pPhone] < 1)
		return ErrorMsg(playerid, "Anda belum memiliki Ponsel");

	if(pData[playerid][pPhoneStatus] < 1)
		return ErrorMsg(playerid, "Ponsel anda sedang mati");

	if(pData[playerid][pTwitter] < 1)
		return ErrorMsg(playerid, "Anda belum memiliki Twitter, harap download!");

	if(pData[playerid][pTogPhone] < 1)
		return ErrorMsg(playerid, "Anda belum membuka twitter [/togtw]");

    if(!strcmp(pData[playerid][pTwittername], "None"))
		return ErrorMsg(playerid, "Kamu harus setting Nama oleh Admin mu!");

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/tw <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	new payout = strlen(params) * 7;
	new kuotamb = pData[playerid][pKuota]/1000;
	if(pData[playerid][pKuota] < payout)
		return Error(playerid, "Kuota anda sisa %dmb untuk mengirim %d Character", kuotamb, strlen(params));

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
	format(mstr, sizeof(mstr), "{1e90ff}[TWITTER] {7fffd4}@%s :{ffffff}%s", pData[playerid][pTwittername], params);
	pData[playerid][pKuota] -= payout;
	foreach(new ii : Player) 
	{
		if(pData[ii][pTogPhone] > 0)
		{
			SendClientMessage(ii, COLOR_LB, mstr);	
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pTogPhone] > 0)
			{
				SendClientMessage(ii, COLOR_LB, line);
			}
		}
	}
	if(pData[playerid][pKuota] < 20)
    {
    	pData[playerid][pTogPhone] = 0;
    }
	return true;
}

CMD:stats(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    ErrorMsg(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	DisplayStats(playerid, playerid);
	return 1;
}

CMD:settings(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    ErrorMsg(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	new str[1024], hbemode[64], togpm[64], toglog[64], togads[64], togwt[64];
	if(pData[playerid][pHBEMode] == 1)
	{
		hbemode = ""LG_E"Simple";
	}
	else if(pData[playerid][pHBEMode] == 2)
	{
		hbemode = ""LG_E"Modern";
	}
	else
	{
		hbemode = ""RED_E"Disable";
	}
	
	if(pData[playerid][pTogPM] == 0)
	{
		togpm = ""RED_E"Disable";
	}
	else
	{
		togpm = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogLog] == 0)
	{
		toglog = ""RED_E"Disable";
	}
	else
	{
		toglog = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogAds] == 0)
	{
		togads = ""RED_E"Disable";
	}
	else
	{
		togads = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogWT] == 0)
	{
		togwt = ""RED_E"Disable";
	}
	else
	{
		togwt = ""LG_E"Enable";
	}
	
	format(str, sizeof(str), "Settings\tStatus\n"WHITEP_E"Email:\t"GREY3_E"%s\n"WHITEP_E"Change Password\n"WHITEP_E"HUD HBE Mode:\t%s\n"WHITEP_E"Toggle PM:\t%s\n"WHITEP_E"Toggle Log Server:\t%s\n"WHITEP_E"Toggle Ads:\t%s\n"WHITEP_E"Toggle WT:\t%s",
	pData[playerid][pEmail], 
	hbemode, 
	togpm,
	toglog,
	togads,
	togwt
	);
	
	ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Settings", str, "Set", "Close");
	return 1;
}

CMD:items(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    ErrorMsg(playerid, "You must be logged in to check items!");
	    return true;
	}
	DisplayItems(playerid, playerid);
	return 1;
}

CMD:getjob(playerid, params[])
{
	if(pData[playerid][pIDCard] <= 0)
		return ErrorMsg(playerid, "Anda tidak memiliki ID-Card.");
		
	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
		{
			if(pData[playerid][pJob] == 0)
			{
				if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
				{
					pData[playerid][pGetJob] = 1;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Taxi. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2279.5249, -2356.6936, 13.55693))
				{
					pData[playerid][pGetJob] = 2;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Mechanic. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -1448.7006, -1530.6364, 101.7578))
				{
					pData[playerid][pGetJob] = 3;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Lumber jack. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
				{
					pData[playerid][pGetJob] = 4;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Trucker. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
				{
					pData[playerid][pGetJob] = 5;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Miner. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
				{
					pData[playerid][pGetJob] = 6;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Production. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
				{
					pData[playerid][pGetJob] = 7;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Farmer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 988.890563, -1349.136962, 13.545228))
				{
					pData[playerid][pGetJob] = 8;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Kurir. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 977.34, -771.49, 112.20))
				{
					if(pData[playerid][pLevel] < 5) return Error(playerid, "Anda harus menjadi lv5 untuk memasuki job ini");
					pData[playerid][pGetJob] = 9;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Smuggler. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2060.2942, -2220.8250, 13.5469))
				{
					pData[playerid][pGetJob] = 10;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Baggage. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 921.77, -1287.54, 14.40))
				{
					pData[playerid][pGetJob] = 11;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Pemotong Ayam. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1227.8773, 181.8018, 20.3798))
				{
					pData[playerid][pGetJob] = 12;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Merchant Filler. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else if(pData[playerid][pJob2] == 0)
			{
				if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
				{
					pData[playerid][pGetJob2] = 1;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Taxi. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2279.4944, -2356.6628, 13.5569))
				{
					pData[playerid][pGetJob2] = 2;
					Info(playerid, "Anda telah berhasil mendaftarkan Job mechanic. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -1448.7006, -1530.6364, 101.7578))
				{
					pData[playerid][pGetJob2] = 3;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Lumber jack. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
				{
					pData[playerid][pGetJob2] = 4;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Trucker. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
				{
					pData[playerid][pGetJob2] = 5;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Miner. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
				{
					pData[playerid][pGetJob2] = 6;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Production. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
				{
					pData[playerid][pGetJob2] = 7;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Farmer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 988.890563, -1349.136962, 13.545228))
				{
					pData[playerid][pGetJob2] = 8;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Kurir. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 977.34, -771.49, 112.20))
				{
					if(pData[playerid][pLevel] < 5) return Error(playerid, "Anda harus menjadi lv5 untuk memasuki job ini");
					pData[playerid][pGetJob2] = 9;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Smuggler. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2060.2942, -2220.8250, 13.5469))
				{
					pData[playerid][pGetJob] = 10;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Baggage. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 921.77, -1287.54, 14.40))
				{
					pData[playerid][pGetJob2] = 11;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Pemotong Ayam. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1227.8773, 181.8018, 20.3798))
				{
					pData[playerid][pGetJob2] = 12;
					Info(playerid, "Anda telah berhasil mendaftarkan Job Merchant Filler. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
		}
		else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
	}
	else
	{
		if(pData[playerid][pJob] > 0)
			return Error(playerid, "Anda hanya bisa memiliki 1 pekerjaan!");
			
		if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
		{
			pData[playerid][pGetJob] = 1;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Taxi. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2279.4944, -2356.6628, 13.5569))
		{
			pData[playerid][pGetJob] = 2;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Mechanic. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -1448.7006, -1530.6364, 101.7578))
		{
			pData[playerid][pGetJob] = 3;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Lumber jack. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
		{
			pData[playerid][pGetJob] = 4;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Trucker. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
		{
			pData[playerid][pGetJob] = 5;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Miner. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
		{
			pData[playerid][pGetJob] = 6;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Production. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
		{
			pData[playerid][pGetJob] = 7;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Farmer. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 988.890563, -1349.136962, 13.545228))
		{
			pData[playerid][pGetJob] = 8;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Kurir. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 5.0, 977.34, -771.49, 112.20))
		{
			if(pData[playerid][pLevel] < 5) return Error(playerid, "Anda harus menjadi lv5 untuk memasuki job ini");
			pData[playerid][pGetJob] = 9;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Smuggler. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2060.2942, -2220.8250, 13.5469))
		{
			pData[playerid][pGetJob] = 10;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Baggage. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 921.77, -1287.54, 14.40))
		{
			pData[playerid][pGetJob] = 11;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Pemotong Ayam. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1227.8773, 181.8018, 20.3798))
		{
			pData[playerid][pGetJob] = 12;
			Info(playerid, "Anda telah berhasil mendaftarkan Job Merchant Filler. /accept job untuk konfirmasi.");
		}
		else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	}
	return 1;
}

CMD:frisk(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/frisk [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pFriskOffer] = playerid;

    Info(otherid, "%s has offered to frisk you (type \"/accept frisk or /deny frisk\").", ReturnName(playerid));
    Info(playerid, "You have offered to frisk %s.", ReturnName(otherid));
	return 1;
}

CMD:inspect(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/inspect [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pInsOffer] = playerid;

    Info(otherid, "%s has offered to inspect you (type \"/accept inspect or /deny inspect\").", ReturnName(playerid));
    Info(playerid, "You have offered to inspect %s.", ReturnName(otherid));
	return 1;
}

CMD:reqloc(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/reqloc [playerid/PartOfName]");

    if(pData[playerid][pPhone] < 1)
    	return ErrorMsg(playerid, "Anda tidak memiliki Handphone");

    if(pData[playerid][pPhoneStatus] == 0)
    	return ErrorMsg(playerid, "Ponsel anda masih offline");

    if(pData[otherid][pPhone] < 1)
    	return ErrorMsg(playerid, "Tujuan tidak memiliki Handphone");

    if(pData[otherid][pPhoneStatus] == 0)
    	return ErrorMsg(playerid, "Ponsel yang anda tuju masih offline");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Kamu tidak bisa meminta lokasi kepada anda sendiri.");

	if(GetSignalNearest(playerid) == 0)
		return ErrorMsg(playerid, "Ponsel anda tidak mendapatkan sinyal di wilayah ini.");

	if(GetSignalNearest(otherid) == 0)
		return ErrorMsg(playerid, "Ponsel tersebut sedang mengalami gangguan sinyal.");


    pData[otherid][pLocOffer] = playerid;

    Info(otherid, "%s has offered to request share his location (type \"/accept reqloc or /deny reqloc\").", ReturnName(playerid));
    Info(playerid, "You have offered to share your location %s.", ReturnName(otherid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "SyntaxMsg: /accept [name]");
            InfoMsg(playerid, "Names: faction, family, drag, frisk, inspect, job, reqloc, rob");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFacOffer])) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
                    pData[playerid][pFaction] = pData[playerid][pFacInvite];
					pData[playerid][pFactionRank] = 1;
					Info(playerid, "Anda telah menerima invite faction dari %s", pData[pData[playerid][pFacOffer]][pName]);
					Info(pData[playerid][pFacOffer], "%s telah menerima invite faction yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					ErrorMsg(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                ErrorMsg(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		if(strcmp(params,"family",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFamOffer])) 
			{
                if(pData[playerid][pFamInvite] > -1) 
				{
                    pData[playerid][pFamily] = pData[playerid][pFamInvite];
					pData[playerid][pFamilyRank] = 1;
					Info(playerid, "Anda telah menerima invite family dari %s", pData[pData[playerid][pFamOffer]][pName]);
					Info(pData[playerid][pFamOffer], "%s telah menerima invite family yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFamInvite] = 0;
					pData[playerid][pFamOffer] = -1;
				}
				else
				{
					ErrorMsg(playerid, "Invalid family id!");
					return 1;
				}
            }
            else 
			{
                ErrorMsg(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return ErrorMsg(playerid, "Player itu Disconnect.");
        
			if(!NearPlayer(playerid, dragby, 5.0))
				return ErrorMsg(playerid, "Kamu harus didekat Player.");
        
			pData[playerid][pDragged] = 1;
			pData[playerid][pDraggedBy] = dragby;

			pData[playerid][pDragTimer] = SetTimerEx("DragUpdate", 1000, true, "ii", dragby, playerid);
			SendNearbyMessage(dragby, 30.0, COLOR_PURPLE, "* %s grabs %s and starts dragging them, (/undrag).", ReturnName(dragby), ReturnName(playerid));
			return true;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pFriskOffer], 5.0))
				return ErrorMsg(playerid, "Kamu harus didekat Player.");
				
			DisplayItems(pData[playerid][pFriskOffer], playerid);
			Servers(playerid, "Anda telah berhasil menaccept tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pInsOffer], 5.0))
				return ErrorMsg(playerid, "Kamu harus didekat Player.");
				
			new hstring[512], info[512];
			new hh = pData[playerid][pHead];
			new hp = pData[playerid][pPerut];
			new htk = pData[playerid][pRHand];
			new htka = pData[playerid][pLHand];
			new hkk = pData[playerid][pRFoot];
			new hkka = pData[playerid][pLFoot];
			format(hstring, sizeof(hstring),"Bagian Tubuh\tKondisi\n{ffffff}Kepala\t{7fffd4}%d.0%\n{ffffff}Perut\t{7fffd4}%d.0%\n{ffffff}Tangan Kanan\t{7fffd4}%d.0%\n{ffffff}Tangan Kiri\t{7fffd4}%d.0%\n",hh,hp,htk,htka);
			strcat(info, hstring);
			format(hstring, sizeof(hstring),"{ffffff}Kaki Kanan\t{7fffd4}%d.0%\n{ffffff}Kaki Kiri\t{7fffd4}%d.0%\n",hkk,hkka);
			strcat(info, hstring);
			ShowPlayerDialog(pData[playerid][pInsOffer],DIALOG_HEALTH,DIALOG_STYLE_TABLIST_HEADERS,"Health Condition",info,"Oke","");
			Servers(playerid, "Anda telah berhasil menaccept tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"job",true) == 0) 
		{
			if(pData[playerid][pGetJob] > 0)
			{
				pData[playerid][pJob] = pData[playerid][pGetJob];
				InfoMsg(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 86400);
			}
			else if(pData[playerid][pGetJob2] > 0)
			{
				pData[playerid][pJob2] = pData[playerid][pGetJob2];
				InfoMsg(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob2] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 86400);
			}
		}
		else if(strcmp(params,"reqloc",true) == 0)
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
				
			new Float:sX, Float:sY, Float:sZ;
			GetPlayerPos(playerid, sX, sY, sZ);
			SetPlayerCheckpoint(pData[playerid][pLocOffer], sX, sY, sZ, 5.0);
			Servers(playerid, "Anda telah berhasil menaccept tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			Servers(pData[playerid][pLocOffer], "Lokasi %s telah tertandai.", ReturnName(playerid));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"rob",true) == 0)
		{
			if(pData[playerid][pRobOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pRobOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			Servers(playerid, "Anda telah berhasil menaccept tawaran bergabung kedalam Robbery %s.", ReturnName(pData[playerid][pRobOffer]));
			Servers(pData[playerid][pRobOffer], "%s Menerima ajakan Robbing anda.", ReturnName(playerid));
			pData[playerid][pRobOffer] = INVALID_PLAYER_ID;
			pData[playerid][pMemberRob] = 1;
			pData[pData[playerid][pRobOffer]][pRobMember] += 1;
			RobMember += 1;
		}
	}
	return 1;
}

CMD:deny(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "SyntaxMsg: /deny [name]");
            InfoMsg(playerid, "Names: faction, drag, frisk, inspect, job1, job2, reqloc, rob");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(pData[playerid][pFacOffer] > -1) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
					Info(playerid, "Anda telah menolak faction dari %s", ReturnName(pData[playerid][pFacOffer]));
					Info(pData[playerid][pFacOffer], "%s telah menolak invite faction yang anda tawari", ReturnName(playerid));
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					ErrorMsg(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                ErrorMsg(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return ErrorMsg(playerid, "Player itu Disconnect.");

			InfoMsg(playerid, "Anda telah menolak drag.");
			Info(dragby, "Player telah menolak drag yang anda tawari.");
			
			DeletePVar(playerid, "DragBy");
			pData[playerid][pDragged] = 0;
			pData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pInsOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"job1",true) == 0) 
		{
			if(pData[playerid][pJob] == 0) return ErrorMsg(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pJob] != 0)
			{
				pData[playerid][pJob] = 0;
				InfoMsg(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
		else if(strcmp(params,"job2",true) == 0) 
		{
			if(pData[playerid][pJob2] == 0) return ErrorMsg(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pJob2] != 0)
			{
				pData[playerid][pJob2] = 0;
				InfoMsg(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
		else if(strcmp(params,"reqloc",true) == 0) 
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"rob",true) == 0) 
		{
			if(pData[playerid][pRobOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pRobOffer]))
				return ErrorMsg(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Rob kepada %s.", ReturnName(pData[playerid][pRobOffer]));
			pData[playerid][pRobOffer] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

CMD:give(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			SyntaxMsg(playerid, "/give [playerid] [name] [ammount]");
			InfoMsg(playerid, "Names: bandage, medicine, snack, sprunk, material, component, marijuana, obat, gps");
			return 1;
		}
		if(otherid == INVALID_PLAYER_ID || otherid == playerid || !NearPlayer(playerid, otherid, 3.0))
			return ErrorMsg(playerid, "Invalid playerid!");
			
		if(strcmp(name,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pBandage] -= ammount;
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan perban kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"medicine",true) == 0) 
		{
			if(pData[playerid][pMedicine] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pMedicine] -= ammount;
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medicine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan medicine kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			if(pData[playerid][pSnack] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pSnack] -= ammount;
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan snack kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pSprunk] -= ammount;
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"material",true) == 0) 
		{
			if(pData[playerid][pMaterial] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return ErrorMsg(playerid, "Invalid ammount 1 - 500");
			
			new maxmat = pData[otherid][pMaterial] + ammount;
			
			if(maxmat > 500)
				return ErrorMsg(playerid, "That player already have maximum material!");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pMaterial] -= ammount;
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Material kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"component",true) == 0) 
		{
			if(pData[playerid][pComponent] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return ErrorMsg(playerid, "Invalid ammount 1 - 500");
			
			new maxcomp = pData[otherid][pComponent] + ammount;
			
			if(maxcomp > 500)
				return ErrorMsg(playerid, "That player already have maximum component!");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pComponent] -= ammount;
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Component kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			if(pData[playerid][pMarijuana] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pMarijuana] -= ammount;
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"obat",true) == 0) 
		{
			if(pData[playerid][pObat] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pObat] -= ammount;
			pData[otherid][pObat] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Obat kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Obat kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			if(pData[playerid][pGPS] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");
			
			pData[playerid][pGPS] -= ammount;
			pData[otherid][pGPS] += ammount;
			Info(playerid, "Anda telah berhasil memberikan GPS kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan GPS kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

CMD:use(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "SyntaxMsg: /use [name]");
            InfoMsg(playerid, "Names: bandage, snack, sprunk, gas, medicine, marijuana, obat");
            return 1;
        }
		if(strcmp(params,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki perban.");
			
			new Float:darah;
			GetPlayerHealth(playerid, darah);
			pData[playerid][pBandage]--;
			SetPlayerHealthEx(playerid, darah+5);
			InfoMsg(playerid, "Anda telah berhasil menggunakan perban.");
			InfoTD_MSG(playerid, 3000, "Restore +5 Health");
		}
		else if(strcmp(params,"snack",true) == 0) 
		{
			if(pData[playerid][pSnack] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki snack.");
			
			pData[playerid][pSnack]--;
			pData[playerid][pHunger] += 5;
			InfoMsg(playerid, "Anda telah berhasil menggunakan snack.");
			InfoTD_MSG(playerid, 3000, "Restore +5 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki sprunk.");
			
			pData[playerid][pSprunk]--;
			pData[playerid][pEnergy] += 5;
			InfoMsg(playerid, "Anda telah berhasil meminum sprunk.");
			InfoTD_MSG(playerid, 3000, "Restore +5 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		/*else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki snack.");
			
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
			//SendNearbyMessage(playerid, 10.0, COLOR_PURPLE,"* %s opens a can of sprunk.", ReturnName(playerid));
			SetPVarInt(playerid, "UsingSprunk", 1);
			pData[playerid][pSprunk]--;
		}*/
		else if(strcmp(params,"gas",true) == 0) 
		{
			if(pData[playerid][pGas] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki gas.");
				
			if(IsPlayerInAnyVehicle(playerid))
				return ErrorMsg(playerid, "Anda harus berada diluar kendaraan!");
			
			if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			
			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(IsValidVehicle(vehicleid))
			{
				new fuel = GetVehicleFuel(vehicleid);
			
				if(GetEngineStatus(vehicleid))
					return ErrorMsg(playerid, "Turn off vehicle engine.");
			
				if(fuel >= 999.0)
					return ErrorMsg(playerid, "This vehicle gas is full.");
			
				if(!IsEngineVehicle(vehicleid))
					return ErrorMsg(playerid, "This vehicle can't be refull.");

				if(!GetHoodStatus(vehicleid))
					return ErrorMsg(playerid, "The hood must be opened before refull the vehicle.");

				pData[playerid][pGas]--;
				InfoMsg(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				/*InfoTD_MSG(playerid, 10000, "Refulling...");
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s starts to refulling the vehicle.", ReturnName(playerid));*/
				return 1;
			}
		}
		else if(strcmp(params,"medicine",true) == 0) 
		{
			if(pData[playerid][pMedicine] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki medicine.");
			
			pData[playerid][pMedicine]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			InfoMsg(playerid, "Anda menggunakan medicine.");
			
			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"obat",true) == 0) 
		{
			if(pData[playerid][pObat] < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki Obat Myricous.");
			
			pData[playerid][pObat]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			pData[playerid][pHead] = 100;
			pData[playerid][pPerut] = 100;
			pData[playerid][pRHand] = 100;
			pData[playerid][pLHand] = 100;
			pData[playerid][pRFoot] = 100;
			pData[playerid][pLFoot] = 100;
			SetPlayerDrunkLevel(playerid, 0);
			InfoMsg(playerid, "Anda menggunakan Obat Myricous.");
			
			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"marijuana",true) == 0) 
		{
			if(pData[playerid][pMarijuana] < 1)
				return ErrorMsg(playerid, "You dont have marijuana.");
			
			new Float:armor;
			GetPlayerArmour(playerid, armor);
			if(armor+10 > 90) return ErrorMsg(playerid, "Over dosis!");
			
			pData[playerid][pMarijuana]--;
			SetPlayerArmourEx(playerid, armor+10);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
	}
	return 1;
}


CMD:enter(playerid, params[])
{
	if(pData[playerid][pInjured] == 0)
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return ErrorMsg(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return ErrorMsg(playerid, "Bangunan ini di Kunci untuk sementara.");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "Pintu ini hanya untuk fraksi.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return ErrorMsg(playerid, "Pintu ini hanya untuk Family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return ErrorMsg(playerid, "VIP Level mu tidak cukup.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return ErrorMsg(playerid, "Admin level mu tidak cukup.");
						
					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return ErrorMsg(playerid, "Password Salah.");
						
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
				else
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return ErrorMsg(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return ErrorMsg(playerid, "Pintu ini ditutup sementara");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "Pintu ini hanya untuk faction.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return ErrorMsg(playerid, "Pintu ini hanya untuk family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return ErrorMsg(playerid, "Your VIP level not enough to enter this door.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return ErrorMsg(playerid, "Your admin level not enough to enter this door.");

					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return ErrorMsg(playerid, "Invalid door password.");
						
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "Pintu ini hanya untuk faction.");
					}
				
					if(dData[did][dCustom])
					{
						SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					else
					{
						SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
				else
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "Pintu ini hanya untuk faction.");
					}
					
					if(dData[did][dCustom])
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);

					else
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
			}
        }
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return ErrorMsg(playerid, "Rumah ini terkunci!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);

			pData[playerid][pInHouse] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return ErrorMsg(playerid, "Bisnis ini Terkunci!");
					
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			pData[playerid][pInBiz] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have registered for this door!");
					
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	return 1;
}

CMD:drag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/drag [playerid/PartOfName] || /undrag [playerid]");

    if(otherid == INVALID_PLAYER_ID)
        return ErrorMsg(playerid, "Player itu Disconnect.");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Kamu tidak bisa menarik diri mu sendiri.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "Kamu harus didekat Player.");

    if(!pData[otherid][pInjured])
        return ErrorMsg(playerid, "kamu tidak bisa drag orang yang tidak mati.");

    SetPVarInt(otherid, "DragBy", playerid);
    Info(otherid, "%s Telah menawari drag kepada anda, /accept drag untuk menerimanya /deny drag untuk membatalkannya.", ReturnName(playerid));
	Info(playerid, "Anda berhasil menawari drag kepada player %s", ReturnName(otherid));
    return 1;
}

CMD:undrag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/undrag [playerid]");
	if(pData[otherid][pDragged])
    {
        DeletePVar(playerid, "DragBy");
        DeletePVar(otherid, "DragBy");
        pData[otherid][pDragged] = 0;
        pData[otherid][pDraggedBy] = INVALID_PLAYER_ID;

        KillTimer(pData[otherid][pDragTimer]);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s releases %s from their grip.", ReturnName(playerid), ReturnName(otherid));
    }
    return 1;
}

CMD:mask(playerid, params[])
{
	if(pData[playerid][pMask] <= 0)
		return ErrorMsg(playerid, "Anda tidak memiliki topeng!");
		
	switch (pData[playerid][pMaskOn])
    {
        case 0:
        {
        	new sstring[64];
        	new Float:pX, Float:pY, Float:pZ;
        	GetPlayerPos(playerid, pX, pY, pZ);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s takes out a mask and puts it on.", ReturnName(playerid));
            pData[playerid][pMaskOn] = 1;
            format(sstring, sizeof(sstring), "%s", ReturnName(playerid));
		    pData[playerid][pMaskLabel] = Create3DTextLabel(sstring, -1, 0, 0, -0.25, 25, playerid, 10);
		    Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
			//SetPlayerAttachedObject(playerid, 9, 18911, 2,0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
        }
        case 1:
        {
        	Delete3DTextLabel(pData[playerid][pMaskLabel]);
            pData[playerid][pMaskOn] = 0;
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s takes their mask off and puts it away.", ReturnName(playerid));
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 1);
			}
			//RemovePlayerAttachedObject(playerid, 9);
        }
    }
	return 1;
}

CMD:stuck(playerid)
{
	if(pData[playerid][pFreeze] == 1)
		return ErrorMsg(playerid, "Anda sedang di Freeze oleh staff, tidak dapat menggunakan ini");

	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	ShowPlayerDialog(playerid, DIALOG_STUCK, DIALOG_STYLE_LIST,"Stuck Options","Tersangkut DiGedung\nTersangkut setelah masuk/keluar Interior\nTersangkut diKendaraan","Pilih","Batal");
	return 1;
}
//Text and Chat Commands
CMD:try(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/try [action]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s, %s", params[64], (random(2) == 0) ? ("and success") : ("but fail"));
    }
    else {
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s, %s", ReturnName(playerid), params, (random(2) == 0) ? ("and success") : ("but fail"));
    }
	printf("[TRY] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ado(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        SyntaxMsg(playerid, "/ado [text]");
		InfoMsg(playerid, "Use /ado off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return ErrorMsg(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pAdoActive])
            return ErrorMsg(playerid, "You're not actived your 'ado' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

        Servers(playerid, "You're removed your ado text.");
        pData[playerid][pAdoActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pAdoActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pAdoTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pAdoActive] = true;
        pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[ADO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ab(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        SyntaxMsg(playerid, "/ab [text]");
		InfoMsg(playerid, "Use /ab off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return ErrorMsg(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pBActive])
            return ErrorMsg(playerid, "You're not actived your 'ab' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);

        Servers(playerid, "You're removed your ab text.");
        pData[playerid][pBActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( OOC : %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pBActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pBTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pBActive] = true;
        pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[AB] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ame(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164];

    if(isnull(params))
        return SyntaxMsg(playerid, "/ame [action]");

    if(strlen(params) > 128)
        return ErrorMsg(playerid, "Max action can only maximmum 128 characters.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    format(flyingtext, sizeof(flyingtext), "* %s %s*", ReturnName(playerid), params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_PURPLE, 10.0, 10000);
	printf("[AME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:me(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/me [action]");
	
	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid), params);
    }
	printf("[ME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:do(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/do [description]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s (( %s ))", params[64], ReturnName(playerid));
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid));
    }
	printf("[DO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:toglog(playerid)
{
	if(!pData[playerid][pTogLog])
	{
		pData[playerid][pTogLog] = 1;
		InfoMsg(playerid, "Anda telah menonaktifkan log server.");
	}
	else
	{
		pData[playerid][pTogLog] = 0;
		InfoMsg(playerid, "Anda telah mengaktifkan log server.");
	}
	return 1;
}

CMD:togpm(playerid)
{
	if(!pData[playerid][pTogPM])
	{
		pData[playerid][pTogPM] = 1;
		InfoMsg(playerid, "Anda telah menonaktifkan PM");
	}
	else
	{
		pData[playerid][pTogPM] = 0;
		InfoMsg(playerid, "Anda telah mengaktifkan PM");
	}
	return 1;
}

CMD:togads(playerid)
{
	if(!pData[playerid][pTogAds])
	{
		pData[playerid][pTogAds] = 1;
		InfoMsg(playerid, "Anda telah menonaktifkan Ads/Iklan.");
	}
	else
	{
		pData[playerid][pTogAds] = 0;
		InfoMsg(playerid, "Anda telah mengaktifkan Ads/Iklan.");
	}
	return 1;
}

CMD:togwt(playerid)
{
	if(!pData[playerid][pTogWT])
	{
		pData[playerid][pTogWT] = 1;
		InfoMsg(playerid, "Anda telah menonaktifkan Walkie Talkie.");
	}
	else
	{
		pData[playerid][pTogWT] = 0;
		InfoMsg(playerid, "Anda telah mengaktifkan Walkie Talkie.");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
    static text[128], otherid;
    if(sscanf(params, "us[128]", otherid, text))
        return SyntaxMsg(playerid, "/pm [playerid/PartOfName] [message]");

    /*if(pData[playerid][pTogPM])
        return ErrorMsg(playerid, "You must enable private messaging first.");*/

    /*if(pData[otherid][pAdminDuty])
        return ErrorMsg(playerid, "You can't pm'ing admin duty now!");*/
		
	if(otherid == INVALID_PLAYER_ID)
        return ErrorMsg(playerid, "Player yang anda tuju tidak valid.");

    if(otherid == playerid)
        return ErrorMsg(playerid, "Tidak dapan PM diri sendiri.");

    if(pData[otherid][pTogPM] && pData[playerid][pAdmin] < 1)
        return ErrorMsg(playerid, "Player tersebut menonaktifkan pm.");

    if(IsPlayerInRangeOfPoint(otherid, 50, 2184.32, -1023.32, 1018.68))
				return ErrorMsg(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

    //GameTextForPlayer(otherid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
    PlayerPlaySound(otherid, 1085, 0.0, 0.0, 0.0);

    SendClientMessageEx(otherid, COLOR_YELLOW, "(( PM from %s (%d): %s ))", pData[playerid][pName], playerid, text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM to %s (%d): %s ))", pData[otherid][pName], otherid, text);
	//Info(otherid, "/togpm for tog enable/disable PM");

    foreach(new i : Player) if((pData[i][pAdmin]) && pData[playerid][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SPY PM] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:whisper(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new text[128], otherid;
    if(sscanf(params, "us[128]", otherid, text))
        return SyntaxMsg(playerid, "/(w)hisper [playerid/PartOfName] [text]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "Player itu Disconnect or not near you.");

    if(otherid == playerid)
        return ErrorMsg(playerid, "You can't whisper yourself.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(text) > 64) 
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %.64s", ReturnName(playerid), playerid, text);
        SendClientMessageEx(otherid, COLOR_YELLOW, "...%s **", text[64]);

        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %.64s", ReturnName(otherid), otherid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "...%s **", text[64]);
    }
    else 
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %s **", ReturnName(playerid), playerid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %s **", ReturnName(otherid), otherid, text);
    }
    SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s mutters something in %s's ear.", ReturnName(playerid), ReturnName(otherid));
	
	foreach(new i : Player) if((pData[i][pAdmin]) && pData[i][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_YELLOW2, "[SPY Whisper] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:l(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/(l)ow [low text]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
	if(IsPlayerInAnyVehicle(playerid))
	{
		foreach(new i : Player)
		{
			if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
			{
				if(strlen(params) > 64) 
				{
					SendClientMessageEx(i, COLOR_WHITE, "[car] %s says: %.64s ..", ReturnName(playerid), params);
					SendClientMessageEx(i, COLOR_WHITE, "...%s", params[64]);
				}
				else 
				{
					SendClientMessageEx(i, COLOR_WHITE, "[car] %s says: %s", ReturnName(playerid), params);
				}
				printf("[CAR] %s(%d) : %s", pData[playerid][pName], playerid, params);
			}
		}
	}
	else
	{
		if(strlen(params) > 64) 
		{
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %.64s ..", ReturnName(playerid), params);
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "...%s", params[64]);
		}
		else 
		{
			SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %s", ReturnName(playerid), params);
		}
		printf("[LOW] %s(%d) : %s", pData[playerid][pName], playerid, params);
	}
    return 1;
}

CMD:s(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/(s)hout [shout text] /ds for in the door");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 40.0, COLOR_WHITE, "%s shouts: %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 40.0, COLOR_WHITE, "...%s!", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %s!", ReturnName(playerid), params);
    }
	new flyingtext[128];
	format(flyingtext, sizeof(flyingtext), "%s!", params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_WHITE, 10.0, 10000);
	printf("[SHOUTS] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:b(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "OOC Zone, Ketik biasa saja");

    if(isnull(params))
        return SyntaxMsg(playerid, "/b [local OOC]");
		
	if(pData[playerid][pAdminDuty] == 1)
    {
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	else
	{
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:t(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(isnull(params))
		return SyntaxMsg(playerid, "/t [typo text]");

	if(strlen(params) < 10)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s : %.10s*", ReturnName(playerid), params);
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:number(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pPhoneBook] == 0)
		return ErrorMsg(playerid, "You dont have a phone book.");
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/number [playerid]");
	
	if(!IsPlayerConnected(otherid))
		return ErrorMsg(playerid, "That player is not listed in phone book.");
		
	if(pData[otherid][pPhone] == 0)
		return ErrorMsg(playerid, "That player is not listed in phone book.");
	
	SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] Name: %s | Ph: %d.", ReturnName(otherid), pData[otherid][pPhone]);
	return 1;
}


CMD:setfreq(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pWT] == 0)
		return ErrorMsg(playerid, "You dont have walkie talkie!");
	
	new channel;
	if(sscanf(params, "d", channel))
		return SyntaxMsg(playerid, "/setfreq [channel 1 - 1000]");
	
	if(pData[playerid][pTogWT] == 1) return ErrorMsg(playerid, "Your walkie talkie is turned off.");
	if(channel == pData[playerid][pWT]) return ErrorMsg(playerid, "You are already in this channel.");
	
	if(channel > 0 && channel <= 1000)
	{
		foreach(new i : Player)
		{
		    if(pData[i][pWT] == channel)
		    {
				SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s has joined in to this channel!", ReturnName(playerid));
		    }
		}
		Info(playerid, "You have set your walkie talkie channel to "LIME_E"%d", channel);
		pData[playerid][pWT] = channel;
	}
	else
	{
		ErrorMsg(playerid, "Invalid channel id! 1 - 1000");
	}
	return 1;
}

CMD:wt(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pWT] == 0)
		return ErrorMsg(playerid, "You dont have walkie talkie!");
		
	if(pData[playerid][pTogWT] == 1)
		return ErrorMsg(playerid, "Your walkie talkie is turned off!");

	if(GetSignalNearest(playerid) == 0)
		return ErrorMsg(playerid, "Perangkat anda tidak mendapatkan sinyal di wilayah ini.");
	
	new msg[128];
	if(sscanf(params, "s[128]", msg)) return SyntaxMsg(playerid, "/wt [message]");
	foreach(new i : Player)
	{
	    if(pData[i][pTogWT] == 0)
	    {
	        if(pData[i][pWT] == pData[playerid][pWT])
	        {
				SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s: %s", ReturnName(playerid), msg);
	        }
	    }
	}
	return 1;
}

/*CMD:savestats(playerid, params[])
{
	UpdateWeapons(playerid);
	UpdatePlayerData(playerid);
	InfoMsg(playerid, "Your data have been saved!");
	return 1;
}*/

//------------------[ Bisnis and Buy Commands ]-------
CMD:buy(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");
	//trucker product
	if(IsPlayerInRangeOfPoint(playerid, 3.5, -279.67, -2148.42, 28.54))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah product:\nProduct Stock: "GREEN_E"%d\n"WHITE_E"Product Price"GREEN_E"%s / item", Product, FormatMoney(ProductPrice));
				ShowPlayerDialog(playerid, DIALOG_PRODUCT, DIALOG_STYLE_INPUT, "Buy Product", mstr, "Buy", "Cancel");
			}
			else return ErrorMsg(playerid, "You are not in vehicle trucker.");
		}
		else return ErrorMsg(playerid, "You are not trucker job.");
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 336.70, 895.54, 20.40))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah liter gasoil:\nGasOil Stock: "GREEN_E"%d\n"WHITE_E"GasOil Price"GREEN_E"%s / liters", GasOil, FormatMoney(GasOilPrice));
				ShowPlayerDialog(playerid, DIALOG_GASOIL, DIALOG_STYLE_INPUT, "Buy GasOil", mstr, "Buy", "Cancel");
			}
			else return ErrorMsg(playerid, "You are not in vehicle trucker.");
		}
		else return ErrorMsg(playerid, "You are not trucker job.");
	}
	//Ayamfill
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 399.3665, -1818.9941, 7.9219))
	{
		if(pData[playerid][AyamFillet] >= 100) return ErrorMsg(playerid, "Anda sudah membawa 100 kg AyamFillet!");

		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah ayam:\nAyam Stock: "GREEN_E"%d\n"WHITE_E"Ayam Price"GREEN_E"%s / item", AyamFill, FormatMoney(AyamFillPrice));
		ShowPlayerDialog(playerid, DIALOG_AYAMFILL, DIALOG_STYLE_INPUT, "Buy Ayam", mstr, "Buy", "Cancel");
	}
	//Material
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -258.54, -2189.92, 28.97))
	{
		if(pData[playerid][pMaterial] >= 500) return ErrorMsg(playerid, "Anda sudah membawa 500 Material!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah material:\nMaterial Stock: "GREEN_E"%d\n"WHITE_E"Material Price"GREEN_E"%s / item", Material, FormatMoney(MaterialPrice));
		ShowPlayerDialog(playerid, DIALOG_MATERIAL, DIALOG_STYLE_INPUT, "Buy Material", mstr, "Buy", "Cancel");
	}
	//Component
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 854.53, -605.20, 18.42))
	{
		if(pData[playerid][pComponent] >= 500) return ErrorMsg(playerid, "Anda sudah membawa 500 Component!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah component:\nComponent Stock: "GREEN_E"%d\n"WHITE_E"Component Price"GREEN_E"%s / item", Component, FormatMoney(ComponentPrice));
		ShowPlayerDialog(playerid, DIALOG_COMPONENT, DIALOG_STYLE_INPUT, "Buy Component", mstr, "Buy", "Cancel");
	}
	//Apotek
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1435.34, -23.91, 1000.92))
	{
		if(pData[playerid][pFaction] != 3)
			return ErrorMsg(playerid, "Medical only!");
			
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Medicine\t"GREEN_E"%s\n\
		Medkit\t"GREEN_E"%s\n\
		Bandage\t"GREEN_E"$100\n\
		", FormatMoney(MedicinePrice), FormatMoney(MedkitPrice));
		ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_TABLIST_HEADERS, "Apotek", mstr, "Buy", "Cancel");
	}
	//Food and Seed
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -381.44, -1426.13, 25.93))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Food\t"GREEN_E"%s\n\
		Seed\t"GREEN_E"%s\n\
		", FormatMoney(FoodPrice), FormatMoney(SeedPrice));
		ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Food", mstr, "Buy", "Cancel");
	}
	//Drugs
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -3811.65, 1313.72, 71.42))
	{
		if(pData[playerid][pMarijuana] >= 100) return ErrorMsg(playerid, "Anda sudah membawa 100 kg Marijuana!");
		
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah marijuana:\nMarijuana Stock: "GREEN_E"%d\n"WHITE_E"Marijuana Price"GREEN_E"%s / item", Marijuana, FormatMoney(MarijuanaPrice));
		ShowPlayerDialog(playerid, DIALOG_DRUGS, DIALOG_STYLE_INPUT, "Buy Drugs", mstr, "Buy", "Cancel");
	}
	// Obat Myr
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1449.57, -11.44, 1000.92))
	{
		if(pData[playerid][pObat] >= 5) return ErrorMsg(playerid, "Anda sudah membawa 5 Obat Myr!");
		
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Obat:\nObat Stock: "GREEN_E"%d\n"WHITE_E"Obat Price"GREEN_E"%s / item", ObatMyr, FormatMoney(ObatPrice));
		ShowPlayerDialog(playerid, DIALOG_OBAT, DIALOG_STYLE_INPUT, "Buy Obat", mstr, "Buy", "Cancel");
	}
	//Buy House
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(hData[hid][hPrice] > GetPlayerMoney(playerid)) return ErrorMsg(playerid, "Not enough money, you can't afford this houses.");
			if(strcmp(hData[hid][hOwner], "-")) return ErrorMsg(playerid, "Someone already owns this house.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 2) return ErrorMsg(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 3) return ErrorMsg(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 4) return ErrorMsg(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 1) return ErrorMsg(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
			Server_AddMoney(hData[hid][hPrice]);
			GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
			hData[hid][hVisit] = gettime();
			
			House_Refresh(hid);
			House_Save(hid);
		}
	}
	//Buy Bisnis
	foreach(new bid : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(bData[bid][bPrice] > GetPlayerMoney(playerid)) return ErrorMsg(playerid, "Not enough money, you can't afford this bisnis.");
			if(strcmp(bData[bid][bOwner], "-")) return ErrorMsg(playerid, "Someone already owns this bisnis.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 2) return ErrorMsg(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 3) return ErrorMsg(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 4) return ErrorMsg(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 1) return ErrorMsg(playerid, "Anda tidak dapat membeli bisnis lagi.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -bData[bid][bPrice]);
			Server_AddMoney(-bData[bid][bPrice]);
			GetPlayerName(playerid, bData[bid][bOwner], MAX_PLAYER_NAME);
			bData[bid][bVisit] = gettime();
			
			Bisnis_Refresh(bid);
			Bisnis_Save(bid);
		}
	}
	//Buy Workshop
	foreach(new wid : Workshop)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]))
			{
				if(wsData[wid][wPrice] > GetPlayerMoney(playerid))
					return ErrorMsg(playerid, "Not enough money, you can't afford this workshop.");
				if(wsData[wid][wOwnerID] != 0 || strcmp(wsData[wid][wOwner], "-")) 
					return ErrorMsg(playerid, "Someone already owns this workshop.");

				#if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more workshop.");
				#endif

				GivePlayerMoneyEx(playerid, -wsData[wid][wPrice]);
				Server_AddMoney(wsData[wid][wPrice]);
				GetPlayerName(playerid, wsData[wid][wOwner], MAX_PLAYER_NAME);
				wsData[wid][wOwnerID] = pData[playerid][pID];
				new str[150];
				format(str,sizeof(str),"[WS]: %s membeli workshop id %d seharga %s!", NormalName(playerid), wid, FormatMoney(wsData[wid][wPrice]));

				Workshop_Refresh(wid);
				Workshop_Save(wid);
			}
		}
	//Buy Bisnis menu
	if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
	{
		Bisnis_BuyMenu(playerid, pData[playerid][pInBiz]);
	}
	//Buy Vending Machine
	foreach(new vid : Vendings)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]))
		{
			if(VendingData[vid][vendingPrice] > GetPlayerMoney(playerid)) 
				return Error(playerid, "Not enough money, you can't afford this Vending.");

			if(strcmp(VendingData[vid][vendingOwner], "-") || VendingData[vid][vendingOwnerID] != 0) 
				return Error(playerid, "Someone already owns this Vending.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}

			SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to vending id %d", vid);
			GivePlayerMoneyEx(playerid, -VendingData[vid][vendingPrice]);
			Server_AddMoney(VendingData[vid][vendingPrice]);
			GetPlayerName(playerid, VendingData[vid][vendingOwner], MAX_PLAYER_NAME);
			VendingData[vid][vendingOwnerID] = pData[playerid][pID];
			//new str[150];
			//format(str,sizeof(str),"[VEND]: %s membeli vending id %d seharga %s!", GetRPName(playerid), vid, FormatMoney(VendingData[vid][vendingPrice]));
			//LogServer("Property", str);
			
			Vending_RefreshText(vid);
			Vending_Save(vid);
		}
	}
	return 1;
}

forward Revive(playerid);
public Revive(playerid)
{
	new otherid = GetPVarInt(playerid, "gcPlayer");
	TogglePlayerControllable(playerid,1);
	Servers(playerid, "Sukses revive");
	pData[playerid][pObat] -= 1;
    pData[otherid][pInjured] = 0;
    pData[otherid][pHospital] = 0;
    pData[otherid][pSick] = 0;
    pData[otherid][pHead] = 100;
    pData[otherid][pPerut] = 100;
    pData[otherid][pRHand] = 100;
    pData[otherid][pLHand] = 100;
    pData[otherid][pRFoot] = 100;
    pData[otherid][pLFoot] = 100;
}

forward DownloadTwitter(playerid);
public DownloadTwitter(playerid)
{
	pData[playerid][pTwitter] = 1;
	pData[playerid][pKuota] -= 38000;
	Servers(playerid, "Twitter berhasil di Download");
}

//new


CMD:selfie(playerid,params[])
{
	if(takingselfie[playerid] == 0)
	{
	    GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		static Float: n1X, Float: n1Y;
		if(Degree[playerid] >= 360) Degree[playerid] = 0;
		Degree[playerid] += Speed;
		n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		takingselfie[playerid] = 1;
		//HideHpLenz(playerid);
		ApplyAnimation(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
    if(takingselfie[playerid] == 1)
	{
	    TogglePlayerControllable(playerid,1);
		SetCameraBehindPlayer(playerid);
	    takingselfie[playerid] = 0;
	    ApplyAnimation(playerid, "PED", "ATM", 4.1, 0, 1, 1, 0, 1, 1);
	    return 1;
	}
    return 1;
}

CMD:eatkebab(playerid, params[])
{
    if(pData[playerid][pKebab] < 1) return ErrorMsg(playerid,"Anda tidak memiliki kebab!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pKebab]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Kebab", "Removed_1x", 2769, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Kebab..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan Kebab..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
		pData[playerid][pHunger] += 30;
	    return 1;
    }
}
CMD:eatroti(playerid, params[])
{
    if(pData[playerid][pRoti] < 1) return ErrorMsg(playerid,"Anda tidak memiliki roti!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pRoti]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Roti", "Removed_1x", 19883, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Roti..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan Roti..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    //SetPlayerAttachedObject(playerid, 3, 19883, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 25;
	    return 1;
    }
}
CMD:eatsnack(playerid, params[])
{
    if(pData[playerid][pSnack] < 1) return ErrorMsg(playerid,"Anda tidak memiliki snack!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pSnack]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Snack", "Removed_1x", 2821, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Snack..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 2821, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 5;
	    return 1;
    }
}
CMD:chiken(playerid, params[])
{
    if(pData[playerid][pChiken] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Cappucino!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pChiken]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Chiken", "Removed_1x", 19847, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Memakan Chiken..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Memakan chiken..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    //SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 10;
	    return 1;
    }
}
CMD:steak(playerid, params[])
{
    if(pData[playerid][pSteak] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Steak!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pSteak]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "steak", "Removed_1x", 19811, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Memakan Steak..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Memakan Steak..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 40;
	    return 1;
    }
}
CMD:drinkcappucino(playerid, params[])
{
    if(pData[playerid][pCappucino] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Cappucino!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pCappucino]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Cappucino", "Removed_1x", 19835, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Minum Cappucino..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Cappucino..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 40;
	    return 1;
    }
}
CMD:drinkwater(playerid, params[])
{
    if(pData[playerid][pSprunk] < 1) return ErrorMsg(playerid,"Anda tidak memiliki water!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pSprunk]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Water", "Removed_1x", 2958, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 2958, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 5;
	    return 1;
    }
}
CMD:drinkstarling(playerid, params[])
{
    if(pData[playerid][pStarling] < 1) return ErrorMsg(playerid,"Anda tidak memiliki starling!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pStarling]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Starling", "Removed_1x", 1455, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Starling..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Starling..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	  //  SetPlayerAttachedObject(playerid, 3, 1455, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}
CMD:drinkmilk(playerid, params[])
{
    if(pData[playerid][pMilxMax] < 1) return ErrorMsg(playerid,"Anda tidak memiliki milk!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pMilxMax]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Milk_Max", "Removed_1x", 19570, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Susu..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum MilxMax..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	   // SetPlayerAttachedObject(playerid, 3, 19570, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}
CMD:i(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	Inventory_Show(playerid);
	return 1;
}
/*
CMD:tweet(playerid,  params[])
{
	static text[270];
	if(sscanf(params, "s[270]", text))
		return SendClientMessage(playerid, -1, "/twiter [text]");

	for(new i = 0; i <18; i++)
	{
		static szString[2777];
		format(szString, sizeof(szString), "[POST] %s", text);
		TextDrawShowForAll(PublicTD[i]);
		TextDrawSetString(PublicTD[17], szString);
		TextDrawSetString(PublicTD[15], pData[playerid][pName]);
		SetTimerEx("TextDrawHide", 10000, false, "d");
	}
	return 1;
}*/

forward TextDrawHide(playerid);
public TextDrawHide(playerid)
{
	for(new i = 0; i <18; i++)
	{
		TextDrawHideForAll(PublicTD[i]);
	}
	//TextdrawHideForPlayer(playerid, VoiceTD[playerid][0]);
	//TextdrawHideForPlayer(playerid, VoiceTD[playerid][1]);
}

/*
CMD:tweet(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	new text[128];

	if(sscanf(params, "s[128]", text))
	return SendClientMessage(playerid, -1, "{C6E2FF}SYNTAX:{FFFFFF} /tweet [pesan]");

	TextDrawSetString(PublicTD[15], GetPlayerName(playerid));
	TextDrawSetString(PublicTD[17], text);
	ShowNotifTweet(playerid);
	PlayerTextDrawSetString(PublicTD[15], pData[playerid][pName]);
	PlayerTextDrawSetString(PublicTD[17], sprintf("%d", text));
	SetTimer("NotifTweetHilang", 10000, 0);
	return 1;
}*/

CMD:ktp(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ktp!");
	callcmd::ktpsatrio(playerid, "");
	/*new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "[ID-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));*/
	return 1;
}

CMD:ktpsatrio(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ktp!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police Warga Kota";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment Warga Kota";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = "Medic Warga Kota";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News Warga Kota";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang Warga Kota";
	}
	else
	{
		fac = "Pengangguran";
	}
	ShowTDKTPBaru(playerid);
	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, TDKTPNew[playerid][16], strings);
	//age
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, TDKTPNew[playerid][17], strings);
	//gender
	format(strings, sizeof(strings), "%s", sext);
	PlayerTextDrawSetString(playerid, TDKTPNew[playerid][18], strings);
	//faction
	format(strings, sizeof(strings), "%s", fac);
	PlayerTextDrawSetString(playerid, TDKTPNew[playerid][19], strings);
	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "ktp_skin"))
	{
		PlayerTextDrawSetPreviewModel(playerid, TDKTPNew[playerid][20], GetPlayerSkin(playerid));
		PlayerTextDrawShow(playerid, TDKTPNew[playerid][20]);
		SetPVarInt(playerid, "ktp_skin", GetPlayerSkin(playerid));
	}
	SelectTextDraw(playerid, COLOR_LBLUE);	
	return 1;
}	

CMD:dice(playerid, params[])
{
	new cdadu = RandomEx(6, 11);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s melempar sebuah dadu ke udara, dan dadu tersebut menunjukkan nilai {FF0000}%d", ReturnName(playerid), cdadu);
	return 1;
}


CMD:livestream(playerid, params[])
{
    foreach(new i : Player)
    {
        new count = 0, string[256];
        if(pData[i][pLiveChannel] && pData[i][pLiveText])
        {
            count++;
        }
        if(count)
        {
			format(string, sizeof(string), "{C6E2FF}[ID:%d] {B897FF}%s {FFFFFF}| Channel: {B897FF}@%s{FFFFFF} | Note:{B897FF}%s", i, SGetName(i), pData[i][pLiveChannel], pData[i][pLiveText]);
			SendClientMessage(playerid, -1, string);
        }
    }
    return 1;
}

CMD:livemode(playerid, params[])
{
    new livetext[256], livechanel[256];

    if(sscanf(params, "ss", livechanel, livetext))
        return SendClientMessage(playerid, -1, "{C6E2FF}SYNTAX:{FFFFFF} /livemode [channel] [note/title]"), InfoMsg(playerid, "Your live text will visible at {B897FF}'/livestream'{FFFFFF} command");

    if(strfind(livetext, "", true) != -1)
        return ErrorMsg(playerid, "Please enter the valid live text!");

    if(strfind(livechanel, "", true) != -1)
        return ErrorMsg(playerid, "Please enter the valid live text!");		

    format(pData[playerid][pLiveText], 256, livetext);
    format(pData[playerid][pLiveChannel], 256, livechanel);	
    Info(playerid, "You has set your live text to: {B897FF}@%s {FFFFFF}|{B897FF} %s{FFFFFF}", livechanel, livetext);
    return 1;
}

CMD:v(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_VOICE, DIALOG_STYLE_LIST, "Voice Settings | {B897FF}Warga Kota", "Berbisik\nNormal\nTeriak", "Pilih", "Kembali");
	return 1;
}

//vip

CMD:vips(playerid, params[])
{
	new str[345];
	format(str, sizeof(str), "Name\tRank\n");
	foreach(new i : Player)
	{
		if(pData[i][pVip] > 0)
		{
			format(str, sizeof(str), "%s%s\t%s\n", str, GetName(i), GetVipRank(i));
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vip Player's", str, "Close", "");
}
CMD:vchat(playerid, params[])
{
	if(pData[playerid][pVip] < 1)
	    return ErrorMsg(playerid, "You're not a VIP Player.");

	if(pData[playerid][pTogVip])
	    return ErrorMsg(playerid, "You must enabled your VIP Chats.");

	if(isnull(params))
	    return SyntaxMsg(playerid, "/vc [vip chat message]");

	foreach(new i : Player) if(pData[i][pVip] > 0 && !pData[playerid][pTogVip])
	{
	    SendClientMessageEx(i, COLOR_SERVER, "[VIP] %s %s: {FFFFFF}%s", GetVipRank(playerid), GetName(playerid), params);
	}
	return 1;
}

CMD:dweb(playerid, params[])
{
	new teks[120];
    if(pData[playerid][pFamily] != -1) 
    {
    	if(sscanf(params, "s[120]", teks))
			return SyntaxMsg(playerid, "/dweb [pesan]");	

		new lstr[1024];
		format(lstr, sizeof(lstr), "DARKWEB | MASKMAN :{FFFFFF} %s", params);
		SendClientMessageToAll(COLOR_DARK, lstr);
		SendStaffMessage(COLOR_PURPLE, "[LOGS PLAYER DWEB] {FFFFFF}%s.", pData[playerid][pName]);
    }
	else
	{
		ErrorMsg(playerid, "Anda bukan anggota family");
	}
	return 1;
}

GetFactionCount(FACTION_ID)
{
    new count;
    for (new i; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (pData[i][pFaction] == FACTION_ID) count++;
    }
    return count;
}

GetMechanicCount()
{
    new count;
    for (new i; i < MAX_PLAYERS; i++)
    {
        if (!IsPlayerConnected(i)) continue;
        if (pData[i][pMechDuty] == 1) count++;
    }
    return count;
}

CMD:onlines(playerid, params[])
{
    new string[658] = "No. Fraksi\tCheck F.Online\n", tmp_string[128];
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}1. "BLUE_E"SAPD\t(%d online)\n", GetFactionCount(1));
    strcat(string, tmp_string);
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}2. "LB_E"SAGS\t(%d online)\n", GetFactionCount(2));
    strcat(string, tmp_string);
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}3. "PINK_E"SAMD\t(%d online)\n", GetFactionCount(3));
    strcat(string, tmp_string);
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}4. "ORANGE_E"SANEWS\t(%d online)\n", GetFactionCount(4));
    strcat(string, tmp_string);
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}5. "YELLOW_E"PEDAGANG\t(%d online)\n", GetFactionCount(5));
    strcat(string, tmp_string);
    format(tmp_string, sizeof(tmp_string), "{FFFFFF}6. "GREEN_E"MECHANIC\t(%d online)", GetMechanicCount());
    strcat(string, tmp_string);
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} - Fraksi Online List", string, "Close", "");
}

CMD:e(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_ANIM, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota {FFFFFF}- Anim List", "No\tNama Anim\n1\tJoget\n2\tJoget2\n3\tJoget3\n4\tJoget4\n5\tAngkat tangan\n6\tangkat hp\n7\tduduk\n8\tTutup Telepon\n9\tbebek\n10\tmasuk mobil\n11\tkeluar mobil\n12\tminum beer\n13\tngerokok\n14\tminum sprunk\n15\tsurrender\n16\tthrowbarl\n17\tstepsitin\n18\tstepsitloop\n19\tstepsitout\n20\tbar1\n21\tbar2\n22\tbar3\n23\tbar4\n24\tbar5\n25\tbar6\n26\tbar7\n27\tbar8\n28\tbar9\n29\tbar10\n30\tbaseball\n31\tbaseball2\n32\tbaseball3\n33\tbaseball4\n34\tbat\n35\tbat2\n36\tbathit2\n37\tbathit\n38\tbatidle\n39\tbatm\n40\tbatpart\n41\tfire\n42\tfire2\n43\tfire3\n44\twave\n45\tpanic\n46\tpanic2\n47\tpanic3\n48\tpanic4\n49\tpanicloop\n50\tgirlkiss\n51\tboykiss\n52\tbather\n53\tlayloop\n54\tparksit\n55\tparksit2\n56\tsitwait\n57\tcelebrate\n58\tdown\n59\tgeton\n60\tup\n61\tup2\n62\tsmooth\n63\trhs\n64\tlhs\n65\trhs2\n66\tbikedback\n67\tdriveby\n68\tdriveby2\n69\tdriveby3\n70\tfwd\n71\tgetoffback\n72\tgetofflhs\n73\tgetoffrhs\n74\tbikehit\n75\tbikejump\n76\tbikejump2\n77\tbikekick\n78\tbikeleft\n79\tbjcouch\n80\tbjcouch2\n81\tbjstart\n82\tbjloop\n83\tbjloop2\n84\tbjend\n85\tbjs1\n86\tbjs2\n87\tbjs3\n88\tbjs4\n89\tbjs5\n90\tbbalbat", "Lakukan", "Tutup");
    return 1;
}

CMD:ngamen(playerid)
{
	SetPlayerAttachedObject(playerid, 4, 19317, 6, -0.007, 0.079, -0.346, 6.300, 11.300, -173.699);
	ApplyAnimation(playerid, "DILDO", "DILDO_IDLE", 4.1, 1, 1, 1, 1, 1, 1);
	Servers(playerid, "Gunakan /offngamen Untuk selesai mengamen.");
	return 1;
}
CMD:offngamen(playerid)
{
	Servers(playerid, "Anda selesai mengamen.");
    RemovePlayerAttachedObject(playerid, 4);
    return 1;
}

CMD:drone(playerid, params[])
{
	if(pData[playerid][pVip] < 1)
	    return ErrorMsg(playerid, "You're not a VIP Player.");

	new str[128];
 	if( sscanf( params, "s", str ) ) return SendClientMessage( playerid, COLOR_RED, "SyntaxMsg: /drone [spawn/end]" );

  	if( strcmp( str, "spawn" ) == 0 ) {
  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 0 ) {
  	        new Float:Health;
  	        GetPlayerHealth( playerid, Health );

  	        if(Health != 0) {
	  	        new Float:PosX, Float:PosY, Float:PosZ;
	  	        GetPlayerPos( playerid, PosX, PosY, PosZ );
	            SetPVarFloat( playerid, "OldPosX", PosX );
				SetPVarFloat( playerid, "OldPosY", PosY );
				SetPVarFloat( playerid, "OldPosZ", PosZ );
		 	    SetPVarInt( playerid, "DroneSpawned", 1 );
		 	    SendClientMessage( playerid, COLOR_GREEN, "You have successfully spawned a drone." );
		 	    Drones[playerid] = CreateVehicle( 465, PosX, PosY, PosZ + 20, 0, 0, 0, 0, -1 );
		 	    PutPlayerInVehicle( playerid, Drones[playerid], 0 );
			}
	  	} else {
	  	    SendClientMessage( playerid, COLOR_RED, "You already have a drone spawned in!" );
	  	}
 	} else {
 	    if( strcmp( str, "ex" ) == 0 ) {
	  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) {
	  	        new Float:PosX, Float:PosY, Float:PosZ;
	  	        GetVehiclePos( Drones[playerid], PosX, PosY, PosZ );

		 	    SetPVarInt( playerid, "DroneSpawned", 0 );
		 	    SendClientMessage( playerid, COLOR_GREEN, "Drone successfully detonated." );
				DestroyVehicle( Drones[playerid] );

				CreateExplosion( PosX, PosY, PosZ, 7, 25 );

				SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
		  	} else {
		  	    SendClientMessage( playerid, COLOR_RED, "You need to have a drone spawned in!" );
		  	}
	 	} else {
	 	    if( strcmp( str, "end" ) == 0 ) {
		  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) {
			 	    SetPVarInt( playerid, "DroneSpawned", 0 );
			 	    SendClientMessage( playerid, COLOR_GREEN, "You have shut your drone down." );
			 	    DestroyVehicle( Drones[playerid] );

			 	    SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
			  	} else {
			  	    SendClientMessage( playerid, COLOR_RED, "You need to have a drone spawned in!" );
			  	}
		 	}
	 	}
 	}
 	return 1;
}

CMD:teriak(playerid, params[])
{
    if(GetPVarInt(playerid, "marjun") > gettime())
		return ErrorMsg(playerid, "Mohon Tunggu 60 Detik Untuk Menggunakan kembali (Don't Spam).");
	if(!pData[playerid][pInjured])
        return ErrorMsg(playerid, "That player is not injured.");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	InfoMsg(playerid, "Sinyal kamu Sudah berasil di sampaikan Silakan Tunggu Ems Datang!");
	SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY DOWN] "WHITE_E"%s NOMER INI MENGIRIM SINYAL! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	SetPVarInt(playerid, "marjun", gettime() + 60);
	return 1;
}

CMD:shareloc(playerid, params[])
{
    if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "You dont have phone!");
	if(pData[playerid][pInjured] != 0)
		return ErrorMsg(playerid, "You cant do that in this time.");

	new ph;
	if(sscanf(params, "d", ph))
	{
		SyntaxMsg(playerid, "/shareloc [phone number]");
		return 1;
	}
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii) || pData[playerid][pPhoneOff] == 1) return ErrorMsg(playerid, "This number is not actived!");

			Servers(playerid, "Send Your location to phone number  %d", ph);
			InfoMsg(ii, "Anda Dikirimi Lokasi Oleh Seseorang");

			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s mengirimkan lokasinya kepada seseorang", ReturnName(playerid));

			new
				Float: X,
				Float: Y,
				Float: Z;

			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerCheckpoint(ii, X, Y, Z, 5.0);
			return 1;
		}
	}
	return 1;
}

CMD:checkid(playerid, params[])
{	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/checkid [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
		return ErrorMsg(playerid, "No player online or name is not found!");
	
	new string[128];
	GetPlayerVersion(otherid, string, sizeof string);	
	
	Servers(playerid, "(ID: %d) - (UCP:%s) - Name: %s - (Level:%d) - (Ping:%d) - (Packetloss:%.2f) - Version: %s", otherid, pData[otherid][pUCP], ReturnName(otherid), pData[otherid][pLevel], GetPlayerPing(otherid), NetStats_PacketLossPercent(otherid), string);
	return 1;
}

//hp


CMD:phone(playerid, params[])
{
	if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel!");
    if(pData[playerid][pInjured] == 1) return ErrorMsg(playerid, "Anda sedang pingsan!");
    if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ponsel");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    SetPlayerChatBubble(playerid,"> Membuka hpnya..",COLOR_PURPLE,30.0,10000);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}%s Telah membuka HPMiliknya", pData[playerid][pName]);

    PlayerPlaySound(playerid, 3600, 0,0,0);
    SetPlayerAttachedObject(playerid, 9, 18871, 5, 0.056, 0.039, -0.015, -18.100, -108.600, 93.000, 1,1,1);
	if(!IsPlayerInAnyVehicle(playerid) && !PlayerData[playerid][pInjured] && !PlayerData[playerid][pLoopAnim])
	{
		ApplyAnimation(playerid,"ped","Jetpack_Idle",4.0, 1, 0, 0, 0, 0, 1); // anim jancok
	}    
	if(ToggleCall[playerid] == 1)
	{
	    return SelectTextDraw(playerid, COLOR_LBLUE);
	}
    if(TogglePhone[playerid] == 0)
	{
		for(new i = 0; i < 25; i++) {
			PlayerTextDrawShow(playerid, fingerhp[playerid][i]);
		}
		SelectTextDraw(playerid, COLOR_LBLUE);
		TogglePhone[playerid] = 1;
	}
 	else if(TogglePhone[playerid] == 1)
	{
		for(new i = 0; i < 25; i++) {
			PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
		}
		HideHpLenz(playerid);
		TogglePhone[playerid] = 0;
		CancelSelectTextDraw(playerid);
	}
	//HideRadialLenz(playerid);
	return 1;
}

CMD:p(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
		return ErrorMsg(playerid, "Anda sudah sedang menelpon seseorang!");
		
	if(pData[playerid][pInjured] != 0)
		return ErrorMsg(playerid, "You cant do that in this time.");
		
	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[ii][pPhoneCredit]--;
			
			pData[playerid][pCall] = ii;
			//SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");

			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawShow(ii, CallHpLenz[playerid][i]);
			}
			CancelSelectTextDraw(ii);
			//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");

			
			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
			ToggleCall[playerid] = 1;
			ToggleCall[ii] = 1;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s answers their cellphone.", ReturnName(playerid));
			
			DetikCall[playerid] = 0;
			MenitCall[playerid] = 0;
			JamCall[playerid] = 0;
			
			DetikCall[ii] = 0;
			MenitCall[ii] = 0;
			JamCall[ii] = 0;
			
			KillTimer(CallTimer[playerid]);
			KillTimer(CallTimer[ii]);
			
			CallTimer[playerid] = SetTimerEx("TambahDetikCall", 1000, true, "i", playerid);
			CallTimer[ii] = SetTimerEx("TambahDetikCall", 1000, true, "i", ii);
			////////////////////////////////////////
   			new targetid = pData[playerid][pCall];

			OnPhone[targetid] = SvCreateGStream(0xFFA200FF, "Telepon");

		    if (OnPhone[targetid])
			{
		        SvAttachListenerToStream(OnPhone[targetid], targetid);
		        SvAttachListenerToStream(OnPhone[targetid], playerid);
		    }
		    if (OnPhone[targetid] && pData[playerid][pCall] != INVALID_PLAYER_ID)
			{
		        SvAttachSpeakerToStream(OnPhone[targetid], playerid);
		    }

		    if(OnPhone[targetid] && pData[targetid][pCall] != INVALID_PLAYER_ID)
			{
		        SvAttachSpeakerToStream(OnPhone[targetid], targetid);
		    }
		}
	}
	return 1;
}
CMD:hu(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new caller = pData[playerid][pCall];

	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		pData[caller][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
		for(new i = 0; i < 21; i++)
		{
			PlayerTextDrawHide(caller, CallHpLenz[playerid][i]);
		}
		CancelSelectTextDraw(caller);
		ToggleCall[caller] = 0;
		TogglePhone[caller] = 0;
		DetikCall[caller] = 0;
		MenitCall[caller] = 0;
		JamCall[caller] = 0;
		
		//SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
		for(new i = 0; i < 21; i++)
		{
			PlayerTextDrawHide(playerid, CallHpLenz[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
		ToggleCall[playerid] = 0;
		TogglePhone[playerid] = 0;
		DetikCall[playerid] = 0;
		MenitCall[playerid] = 0;
		JamCall[playerid] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
		pData[playerid][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

  		if (OnPhone[caller] && pData[caller][pCall] != INVALID_PLAYER_ID)
	 	{
            SvDetachSpeakerFromStream(OnPhone[caller], caller);
        }

        if(OnPhone[caller] && pData[playerid][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[caller], playerid);
        }

        if(OnPhone[caller])
		{
            SvDetachListenerFromStream(OnPhone[caller], caller);
            SvDetachListenerFromStream(OnPhone[caller], playerid);
            SvDeleteStream(OnPhone[caller]);
            OnPhone[caller] = SV_NULL;
        }

		if (OnPhone[playerid] && pData[caller][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[playerid], caller);
        }

        if(OnPhone[playerid] && pData[playerid][pCall] != INVALID_PLAYER_ID)
		{
            SvDetachSpeakerFromStream(OnPhone[playerid], playerid);
        }

        if(OnPhone[playerid])
		{
            SvDetachListenerFromStream(OnPhone[playerid], caller);
            SvDetachListenerFromStream(OnPhone[playerid], playerid);
            SvDeleteStream(OnPhone[playerid]);
            OnPhone[playerid] = SV_NULL;
        }
	}
	return 1;
}
CMD:ofhu(playerid, params[])
{
 	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[playerid][pCall] = ii;
			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawHide(ii, CallHpLenz[playerid][i]);
			}
			pData[ii][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(ii, SPECIAL_ACTION_STOPUSECELLPHONE);
			//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawHide(playerid, CallHpLenz[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
			CancelSelectTextDraw(ii);
			ToggleCall[ii] = 0;
			ToggleCall[playerid] = 0;
			TogglePhone[ii] = 0;
			TogglePhone[playerid] = 0;
			DetikCall[playerid] = 0;
			MenitCall[playerid] = 0;
			JamCall[playerid] = 0;
			DetikCall[ii] = 0;
			MenitCall[ii] = 0;
			JamCall[ii] = 0;
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}
	return 1;
}

CMD:offhu(playerid, params[])
{
 	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[playerid][pCall] = ii;
			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawHide(ii, CallHpLenz[playerid][i]);
			}
			pData[ii][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(ii, SPECIAL_ACTION_STOPUSECELLPHONE);
			//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			for(new i = 0; i < 21; i++)
			{
				PlayerTextDrawHide(playerid, CallHpLenz[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
			CancelSelectTextDraw(ii);
			ToggleCall[ii] = 0;
			ToggleCall[playerid] = 0;
			TogglePhone[ii] = 0;
			TogglePhone[playerid] = 0;
			DetikCall[playerid] = 0;
			MenitCall[playerid] = 0;
			JamCall[playerid] = 0;
			DetikCall[ii] = 0;
			MenitCall[ii] = 0;
			JamCall[ii] = 0;
			pData[playerid][pCall] = INVALID_PLAYER_ID;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}
	return 1;
}

CMD:mekaph(playerid, params[])
{
	foreach(new ii : Player)
	{	
		if(pData[ii][pMechDuty] == 1)
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
		}
	}
	return 1;
}

CMD:taxiph(playerid, params[])
{
	foreach(new ii : Player)
	{	
		if(pData[ii][pTaxiDuty] == 1)
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Taxi Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
		}
	}
	return 1;
}

CMD:call(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new ph;
	if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel!");
	if(pData[playerid][pPhoneStatus] == 0) return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
	if(pData[playerid][pPhoneCredit] <= 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel credits!");
	
	if(GetSignalNearest(playerid) == 0)
		return Error(playerid, "Ponsel anda tidak mendapatkan sinyal di wilayah ini.");
	
	if(sscanf(params, "d", ph))
	{
		InfoMsg(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{	
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
		SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 933)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Your calling has sent to the taxi driver. please wait for respon!");
		pData[playerid][pCallTime] = gettime() + 60;
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_YELLOW, "[TAXI CALL] "WHITE_E"%s calling the taxi for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
			}
		}
	}
	if(ph == 955)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Your calling has sent to the cafetaria driver. please wait for respon!");
		pData[playerid][pCallTime] = gettime() + 60;
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_YELLOW, "[CAFE] "WHITE_E"%s calling the Cafe for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
			}
		}
	}
	if(ph == pData[playerid][pPhone]) return ErrorMsg(playerid, "Nomor sedang sibuk!");
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			ErrorMsg(playerid, "Untuk menelpon player lain silahkan menggunakan fitur dari HP!.");
			/*if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return ErrorMsg(playerid, "This number is not actived!");
			if(pData[ii][pPhoneStatus] == 0) return ErrorMsg(playerid, "Tidak dapat menelepon, Ponsel tersebut yang dituju sedang Offline");
			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return ErrorMsg(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				pData[playerid][pCall] = ii;
				
				SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
				SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				return 1;
			}
			else
			{
				ErrorMsg(playerid, "Nomor ini sedang sibuk.");
				return 1;
			}*/
		}
	}
	return 1;
}


CMD:callanyar(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new ph;
	if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel!");
	if(pData[playerid][pPhoneStatus] == 0) return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
	if(pData[playerid][pPhoneCredit] <= 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel credits!");

	if(GetSignalNearest(playerid) == 0)
		return Error(playerid, "Ponsel anda tidak mendapatkan sinyal di wilayah ini.");
	
	if(sscanf(params, "d", ph))
	{
		SyntaxMsg(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{	
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
		SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 955)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Your calling has sent to the cafetaria driver. please wait for respon!");
		pData[playerid][pCallTime] = gettime() + 60;
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_YELLOW, "[CAFE] "WHITE_E"%s calling the Cafe for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
			}
		}
	}
	if(ph == pData[playerid][pPhone])
	{
		for(new i = 0; i < 25; i++) {
			PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
		}
		HideHpLenz(playerid);
		
     	for(new i = 0; i < 21; i++)
		{
			PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
		}
		SelectTextDraw(playerid, COLOR_LBLUE);
	}
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii))
			{
				for(new i = 0; i < 25; i++) {
					PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
				}
				HideHpLenz(playerid);
				for(new i = 0; i < 21; i++)
				{
					PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
				}
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][16], tstr);
				return 1;
			}
			if(pData[ii][pPhoneStatus] == 0)
			{
				for(new i = 0; i < 25; i++) {
					PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
				}
				HideHpLenz(playerid);
				for(new i = 0; i < 21; i++)
				{
					PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
				}
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][16], tstr);
				return 1;
			}
			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return ErrorMsg(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				
				pData[playerid][pCall] = ii;
				
				//njajal
				//SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
				for(new i = 0; i < 25; i++) {
					PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
				}
				HideHpLenz(playerid);
				for(new i = 0; i < 21; i++)
				{
					PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
				}
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][16], tstr);
				new stro[256];
				format(stro, sizeof(stro), "Berdering..");
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][17], stro);
				SelectTextDraw(playerid, COLOR_LBLUE);
				
				//SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
				
				for(new i = 0; i < 25; i++) {
					PlayerTextDrawHide(ii, fingerhp[playerid][i]);
				}				
				for(new i = 0; i < 56; i++) {
					PlayerTextDrawHide(ii, hplenzbaru[playerid][i]);
				}
				PlayerTextDrawHide(ii, adshplenz[playerid]);
				PlayerTextDrawHide(ii, airdrophplenz[playerid]);
				PlayerTextDrawHide(ii, contacthplenz[playerid]);
				PlayerTextDrawHide(ii, camerahplenz[playerid]);
				PlayerTextDrawHide(ii, callhplenz[playerid]);
				PlayerTextDrawHide(ii, jobhplenz[playerid]);
				PlayerTextDrawHide(ii, musichplenz[playerid]);
				PlayerTextDrawHide(ii, gojekhplenz[playerid]);
				PlayerTextDrawHide(ii, bankhplenz[playerid]);
				PlayerTextDrawHide(ii, mapshplenz[playerid]);
				PlayerTextDrawHide(ii, twhplenz[playerid]);
				PlayerTextDrawHide(ii, settinghplenz[playerid]);
				
				for(new i = 0; i < 21; i++)
				{
					PlayerTextDrawShow(ii, CallHpLenz[playerid][i]);
				}
				ToggleCall[ii] = 1;
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				format(tstr, sizeof(tstr), "%s", pData[playerid][pName]);
				PlayerTextDrawSetString(ii, CallHpLenz[playerid][16], tstr);
				//SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				return 1;
			}
			else
			{
				for(new i = 0; i < 25; i++) {
					PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
				}
				HideHpLenz(playerid);
				for(new i = 0; i < 21; i++)
				{
					PlayerTextDrawShow(playerid, CallHpLenz[playerid][i]);
				}
				SelectTextDraw(playerid, COLOR_LBLUE);
				new tstr[256];
				format(tstr, sizeof(tstr), "%s", pData[ii][pName]);
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][16], tstr);
				new stro[256];
				format(stro, sizeof(stro), "Sibuk..");
				PlayerTextDrawSetString(playerid, CallHpLenz[playerid][17], stro);
				return 1;
			}
		}
	}
	return 1;
}

CMD:sms(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return ErrorMsg(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(GetSignalNearest(playerid) == 0)
		return ErrorMsg(playerid, "Perangkat anda tidak mendapatkan sinyal di wilayah ini.");
	

	new ph, text[50];
	if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel!");
	if(pData[playerid][pPhoneCredit] <= 0) return ErrorMsg(playerid, "Anda tidak memiliki Ponsel credits!");
	if(pData[playerid][pInjured] != 0) return ErrorMsg(playerid, "You cant do at this time.");
	
	if(sscanf(params, "ds[50]", ph, text))
        return SyntaxMsg(playerid, "/sms [phone number] [message max 50 text]");
	
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][pPhoneStatus] == 0) return ErrorMsg(playerid, "Tidak dapat SMS, Ponsel tersebut yang dituju sedang Offline");
			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return ErrorMsg(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return ErrorMsg(playerid, "This number is not actived!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", ph, text);
			SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], text);
			Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
			PlayerPlaySound(ii, 6003, 0,0,0);
			pData[ii][pSMS] = pData[playerid][pPhone];
			
			pData[playerid][pPhoneCredit] -= 1;
			return 1;
		}
	}
	return 1;
}


CMD:ad(playerid, params[])
{
	if(pData[playerid][pVip] <= 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1473.3381,-140.0212,1243.9742))
		    return ErrorMsg(playerid, "You only can perform this inside San News!");

		new count;
		foreach(new i : Player)
		{
			if(pData[i][pFaction] == 4 && pData[i][pOnDuty] == 1)
			{
				count++;
			}
		}
		if(count < 1)
		{
			return ErrorMsg(playerid, "Setidaknya harus ada 1+ SaNews Onduty Dikota.");
		}

		if(Advert_CountPlayer(playerid) > 0)
		    return ErrorMsg(playerid, "You already have a pending advertisement, you must wait first.");

		if(pData[playerid][pMoney] < 3000)
		    return ErrorMsg(playerid, "You need at least $3000!");

		if(Advert_Count() >= 100)
			return ErrorMsg(playerid, "The server has reached limit of ads list, comeback later.");

		if(isnull(params))
		    return SyntaxMsg(playerid, "/ad [advertisement]");

		if(strlen(params) > 64)
		    return ErrorMsg(playerid, "Text cannot more than 64 characters.");

		GivePlayerMoneyEx(playerid, -3000);
		Advert_Create(playerid, params);
		SendClientMessage(playerid, COLOR_SERVER, "ADS: {FFFFFF}Your advertisement will be appear 1 minutes from now.");
	}
	else
	{
		if(isnull(params))
		    return SyntaxMsg(playerid, "/ad [advertisement]");

		if(strlen(params) > 82)
		    return ErrorMsg(playerid, "Text cannot more than 82 characters.");

		GivePlayerMoneyEx(playerid, -3000);

	    SendClientMessage(playerid, COLOR_SERVER, "VIP: {FFFFFF}Because you're a VIP Player, you able to create ads everywhere.");
		foreach(new  i: Player)
		{
			if(!pData[i][pTogAds])
			{
				SendClientMessageEx(i, COLOR_GREEN, "Advertisement: %s", params);
				SendClientMessageEx(i, COLOR_GREEN, "Phone: {FF0000}%d {33CC33}| Name: {FF0000}%s", pData[playerid][pPhone], GetName(playerid));
			}
		}
	}
	return 1;
}

CMD:clearchat(playerid, params[])
{
	ClearChat(playerid);
	return 1;
}

CMD:clearallchat(playerid)
{
    if(pData[playerid][pAdmin] < 3)
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	foreach(new i : Player)
	{
	    ClearAllChat(i);
	}
	SendAdminMessage(COLOR_RED, "%s {FFFFFF}telah membersihkan chat box.", pData[playerid][pAdminname]);
	return 1;
}

CMD:ambilkoin(playerid, params[])
{   
    ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1,1);
    SetPlayerAttachedObject(playerid, 9, 1931, 5, 0.105, 0.086, 0.22, -80.3, 3.3, 28.7, 0.35, 0.35, 0.35);
    PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);

    SetPlayerChatBubble(playerid,"Sedang Mengambil koin dari saku",COLOR_PURPLE,30.0,10000);
    SendClientMessage(playerid, COLOR_WHITE, "mengambil koin dari saku.");
}

CMD:lemparkoin(playerid, params[])
{
    RemovePlayerAttachedObject(playerid, 9);
    ClearAnimations(playerid);
    ApplyAnimation(playerid,"BD_FIRE","wash_up",4.0, 0, 0, 0, 0, 0);
    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "** %s Melemparkan koin dan mendapatkan %s.", GetRPName(playerid), (random(2)) ? ("Kepala") : ("Ekor"));
    SetPlayerChatBubble(playerid,"Sedang Melemparkan Koin",COLOR_PURPLE,30.0,10000);
    return 1;
}


CMD:fixvisual(playerid, params[])
{
   SetPlayerInterior(playerid, 0);
   SetPlayerVirtualWorld(playerid, 0);
   SuccesMsg(playerid, "Sukses");
   return 1;
}

CMD:fixstuck(playerid, params[])
{
    pData[playerid][pFreeze] = 0;
    TogglePlayerControllable(playerid, 1);
    SuccesMsg(playerid, "Sukses");
    return 1;
}

CMD:fixinterior(playerid, params[])
{
    pData[playerid][pInDoor] = 1;
    pData[playerid][pInBiz] = 1;
    pData[playerid][pInHouse] = 1;
    SuccesMsg(playerid, "Sukses");
    return 1;
}

CMD:taclight(playerid, params[])
{
	if(!pData[playerid][pFlashlight]) 
		return ErrorMsg(playerid, "Kamu tidak mempunyai senter.");
	if(pData[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 6, 0.25, -0.0175, 0.16, 86.5, -185, 86.5, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 6, 0.2, 0.01, 0.16, 90, -95, 90, 1, 1, 1);
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s attach the flashlight to the gun.", ReturnName(playerid));

		pData[playerid][pUsedFlashlight] = 1;
	}
	else
	{
		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
		pData[playerid][pUsedFlashlight] =0;
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s take the flashlight off the gun.", ReturnName(playerid));
	}
	return 1;
}
CMD:flashlight(playerid, params[])
{
	if(!pData[playerid][pFlashlight])
		return ErrorMsg(playerid, "Kamu tidak mempunyai senter.");

	if(pData[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 5, 0.1, 0.038, -0.01, -90, 180, 0, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s take out the flashlight and turn on the flashlight.", ReturnName(playerid));

		pData[playerid][pUsedFlashlight] =1;
	}
	else
	{
 		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
		pData[playerid][pUsedFlashlight] =0;
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s turn off the flashlight and put it in.", ReturnName(playerid));
	}
	return 1;
}

CMD:propose(playerid, params[])
{
	if(GetPlayerMoney(playerid) < 50000)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "The Marriage & Reception costs $50.000!");
		return 1;
	}
	if(pData[playerid][pMarried] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are already Married!");
		return 1;
	}

	new String[512], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "KEGUNAAN: /propose [playerid]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(pData[giveplayerid][pMarried] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That player is already married!");
			return 1;
		}
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Propose to yourself!"); return 1; }
			format(String, sizeof(String), "* You proposed to %s.", ReturnName(giveplayerid));
			SendClientMessageEx(playerid, COLOR_GREEN, String);
			format(String, sizeof(String), "* %s just proposed to you (type /accept marriage) to accept.", ReturnName(playerid));
			SendClientMessageEx(giveplayerid, COLOR_GREEN, String);
			pData[giveplayerid][pMarriedAccept] = playerid;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That player isn't near you.");
			return 1;
		}

	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		return 1;
	}
	return 1;
}
CMD:cerai(playerid, params[])
{
	if(pData[playerid][pMarried] < 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are already Married!");
		return 1;
	}

	new String[500], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "KEGUNAAN: /cerai [playerid]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(pData[giveplayerid][pMarried] < 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That player is already married!");
			return 1;
		}
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Propose to yourself!"); return 1; }
			format(String, sizeof(String), "* Kamu mengajak cerai/pisah %s.", ReturnName(giveplayerid));
			SendClientMessageEx(playerid, COLOR_BLUE, String);
			format(String, sizeof(String), "* %s Mengajak cerai/pisah kamu (type /accept cerai) to accept.", ReturnName(playerid));
			SendClientMessageEx(giveplayerid, COLOR_BLUE, String);
			pData[giveplayerid][pMarriedCancel] = playerid;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That player isn't near you.");
			return 1;
		}

	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		return 1;
	}
	return 1;
}

CMD:accent(playerid, params[])
{
	if(pData[playerid][pLevel] < 2) 
		return ErrorMsg(playerid, "Untuk menggunakan command ini anda harus level 2 ke atas");

	new length = strlen(params), idx, String[256];
	while ((idx < length) && (params[idx] <= ' '))
	{
		idx++;
	}
	new offset = idx;
	new result[16];
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	{
		result[idx - offset] = params[idx];
		idx++;
	}
	result[idx - offset] = EOS;
	if(!strlen(result))
	{
		SyntaxMsg(playerid, "/accent [name]");
		return 1;
	}
	format(pData[playerid][pAccent], 80, "%s", result);
	format(String, sizeof(String), "ACCENT: {ffffff}Your character's accent has been set to '{ffff00}%s{ffffff}'", pData[playerid][pAccent]);
	SendClientMessageEx(playerid,ARWIN,String);
	SendClientMessageEx(playerid,ARWIN,"NOTE: Jika ingin menghapus accent gunakan command "YELLOW_E"'/offaccent'");
	return 1;
}

CMD:offaccent(playerid, params[])
{
	if(pData[playerid][pLevel] ==  2) 
		return Error(playerid, "Untuk menggunakan command ini anda harus level 5 ke atas");
		
	if(pData[playerid][pTogAccent] == 1)
	{
		SendClientMessageEx(playerid, ARWIN, "ACCENT: "WHITE_E"Accent OFF!");
		pData[playerid][pTogAccent] = 0;
	}	
	return 1;
}

CMD:bin(playerid, params[])
{
	for(new i = 0; i < MAX_Trash; i++)
	{
 		if(IsPlayerInRangeOfPoint(playerid, 2.3, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ])) {

			if(pData[playerid][pBotol] > 30) return ErrorMsg(playerid, "Anda tidak bisa membawa botol melebihi dari 15 botol");
			if(TrashData[i][Sampah] < 1) return ErrorMsg(playerid, "Tidak ada sampah di sini");
			if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
			{
				ShowProgressbar(playerid, "Memulung Sampah..", 1);
				pData[playerid][pBotol]++;
				ShowItemBox(playerid, "Botol", "ADD_1x", 1486, 2);
				Inventory_Update(playerid);
				TrashData[i][Sampah] -= 1;
				new query[64];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE trash SET sampah='%d' WHERE ID='%d'", TrashData[i][Sampah], i);
				mysql_tquery(g_SQL, query);
				Trash_Save(i);
			}
		}
	}
	return 1;
}

//jual botol
CMD:adolbotol(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid,2.0, 919.4504,-1252.1967,16.2109))
	{
		new total = pData[playerid][pBotol];
		if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if( pData[playerid][pBotol] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Botol Bekas");
		ShowProgressbar(playerid, "Menjual Botol..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		new pay = pData[playerid][pBotol] * 2;
		GivePlayerMoneyEx(playerid, pay);
		pData[playerid][pBotol] -= total;
		new str[500];
		format(str, sizeof(str), "Received_%dx", pay);
		ShowItemBox(playerid, "Uang", str, 1212, 4);
		format(str, sizeof(str), "Removed_%dx", total);
		ShowItemBox(playerid, "Botol", str, 1666, 4);
		Inventory_Update(playerid);
	}
	return 1;
}

CMD:cursor(playerid, params[])
{
	SelectTextDraw(playerid, -261923073);
	return 1;
}

CMD:claimsp(playerid, patams[])
{
	if(pData[playerid][pStarterpack] != 0)
				return ErrorMsg(playerid, "Kamu sudah mengambil Sebelumnya!");
	ShowPlayerDialog(playerid, DIALOG_SP, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} // Claim Staterpack", "Apakah anda yakin Untuk Mengclaim Staterpack?", "Claim", "Gajadi");
	return 1;
}

CMD:getcord(playerid, params[])
{
	new int, Float:px,Float:py,Float:pz, Float:a;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, a);
	int = GetPlayerInterior(playerid);
	new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, zone, sizeof(zone));
	SendClientMessageEx(playerid, COLOR_WHITE, "Lokasi Anda Saat Ini: %s (%0.2f, %0.2f, %0.2f, %0.2f) Int = %d", zone, px, py, pz, a, int);
	return 1;
}

CMD:smoke(playerid, params[])
{
	if(pData[playerid][pRokok] < 1) return ErrorMsg(playerid,"Anda tidak memiliki rokok!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");

	pData[playerid][pRokok] -= 1;
	pData[playerid][sampahsaya]++;
	Inventory_Update(playerid);
    Inventory_Close(playerid);
	ShowItemBox(playerid, "Rokok", "Used_1x", 3027, 2);
	ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	ShowProgressbar(playerid, "Menggunakan Rokok..", 5);
    ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0,1);
	pData[playerid][pBladder] += 30.0;

	new string[128];
	format(string, sizeof(string), "> %s Membakar Rokok lalu Menghisapnya.", GetRPName(playerid));
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
	return 1;
}
