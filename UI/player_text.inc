public OnPlayerClickDynamicTextdraw(playerid, PlayerText:playertextid)
{
	//radial
	if(playertextid == AERPRADIAL[playerid][7])
	{
		ClosePlayerRadial(playerid);
		callcmd::ktpsatrio(playerid, "");
	}		
	if(playertextid == AERPRADIAL[playerid][2])
	{
		ClosePlayerRadial(playerid);
		Dialog_Show(playerid, DIALOG_VEHMENU, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Vehicle Menu", "Kunci\t\t\n{BEBEBE}Lampu\t\t\nHood buka/tutup\t\t\n{BEBEBE}Trunk buka/tutup\t\t\nBagasi\t\t\n{BEBEBE}Holster", "Pilih", "Batal");
	}		
	if(playertextid == AERPRADIAL[playerid][4])
	{
		ClosePlayerRadial(playerid);
		InfoMsg(playerid, "Fitur dalam Pengembangan");
	    /*new header[256], count = 0;
	    new bool:status = false;
	    format(header, sizeof(header), "No.\tNama Bill\tJumlah\n");
	    foreach(new i: tagihan)
	    {
	        if(i != -1)
	        {
	            if(bilData[i][bilTarget] == pData[playerid][pID])
	            {
	                format(header, sizeof(header), "%s%d.\t%s\t{00ff00}%s\n", header, count, bilData[i][bilName], FormatMoney(bilData[i][bilammount]));
	                count++;
	                status = true;
	            }
	        }
	    }
	    if(status)
	    {
	        ShowPlayerDialog(playerid, DIALOG_PAYBILL, DIALOG_STYLE_TABLIST_HEADERS, "{FF9999}Warga Kota{FFFFFF} - Invoice Belum Dibayar", header, "OK", "Exit");
	    }
		else Dialog_Show(playerid, DIALOG_INVOICEMENU, DIALOG_STYLE_MSGBOX, "{FF9999}Warga Kota {FFFFFF}- Invoice belum terbayar", "Anda tidak memiliki tagihan/invoices apapun.", "Tutup", "");
	*/
	}		
	if(playertextid == AERPRADIAL[playerid][5])
	{
		ClosePlayerRadial(playerid);
		Dialog_Show(playerid, DIALOG_DOKUMENPRIB, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Dokumen Pribadi", "Lihat BPJS\t\t\n{BEBEBE}Perlihatkan BPJS\t\t\nLihat SKCK\t\t\n{BEBEBE}Perlihatkan SKCK\t\t\nLihat SKS\t\t\n{BEBEBE}Perlihatkan SKS", "Pilih", "Batal");
	}		
	if(playertextid == AERPRADIAL[playerid][3])
	{
		ClosePlayerRadial(playerid);
		if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Perintah ini hanya dapat digunakan dengan berjalan kaki, keluar dari kendaraan Anda!");
		if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Anda harus login untuk melampirkan objek ke karakter Anda!");
		new string[350];
		if(pToys[playerid][0][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 1\n");
		}
		else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

		if(pToys[playerid][1][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 2\n");
		}
		else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

		if(pToys[playerid][2][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 3\n");
		}
		else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

		if(pToys[playerid][3][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 4\n");
		}
		else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

		if(pToys[playerid][4][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 5\n");
		}
		else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

		if(pToys[playerid][5][toy_model] == 0)
		{
		    strcat(string, ""dot"Slot 6\n");
		}
		else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");

		strcat(string, ""dot""RED_E"Reset Toys");


		ShowPlayerDialog(playerid, DIALOG_TOY, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Aksesoris", string, "Select", "Cancel");
   		SetCameraBehindPlayer(playerid);		
		//Dialog_Show(playerid, DIALOG_EDITFASHION, DIALOG_STYLE_LIST, "{FF9999}B897FF Roleplay {FFFFFF}- Edit Fashion", "{FFFFFF}Hat/Helmet\n{BEBEBE}Kacamata\n{FFFFFF}Aksesoris\n{BEBEBE}Tas/Koper\n", "Select", "Cancel");
	}		
	if(playertextid == AERPRADIAL[playerid][1])
	{
		ClosePlayerRadial(playerid);
		Inventory_Show(playerid);
	}	
	if(playertextid == AERPRADIAL[playerid][0])
	{
		ClosePlayerRadial(playerid);
		callcmd::phone(playerid, "");
	}	
	if(playertextid == AERPRADIAL[playerid][6])
	{
		ClosePlayerRadial(playerid);
	}
	//akhir dari radial
	//bank/atm
	if(playertextid == AERPATM[playerid][38])
	{
		ShowPlayerDialog(playerid, DIALOG_FTRANSFER, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Fleeca Bank", "Mohon masukkan nomor rekening yang ingin anda transfer:", "Submit", "Batal");
	}	
	if(playertextid == AERPATM[playerid][37])
	{
		ShowPlayerDialog(playerid, DIALOG_FDEPOSIT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Fleeca Bank", "Mohon masukan nerapa jumlah uang yang ingin anda masukkan:", "Submit", "Batal");
	}	
	if(playertextid == AERPATM[playerid][36])
	{
		ShowPlayerDialog(playerid, DIALOG_FWITHDRAW, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Fleeca Bank", "Mohon masukan nerapa jumlah uang yang ingin anda ambil:", "Submit", "Batal");
	}
	if(playertextid == AERPATM[playerid][43])
	{
		forex(ix, 44)
		{
			PlayerTextDrawHide(playerid, AERPATM[playerid][ix]);
		}
		CancelSelectTextDraw(playerid);
	}
	//akhir dari bank/atm
	//Taruh di OnPlayerClickTextDraw
	if(playertextid == MAIN[playerid][5])
	{
		new id = pData[playerid][pSelectItem];

		if(id == -1)
		{
			ErrorMsg(playerid,"[Inventory] Tidak Ada Barang Di Slot Tersebut");
		}
		else
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			new string[64];
			strunpack(string, InventoryData[playerid][id][invItem]);

			if(!PlayerHasItem(playerid, string))
			{
				ErrorMsg(playerid,"[Inventory] Kamu Tidak Memiliki Barang Tersebut");
				Inventory_Show(playerid);
			}
			else
			{
				CallLocalFunction("OnPlayerUseItem", "dds", playerid, id, string);
			}
		}
	}
	else if(playertextid == MAIN[playerid][8])
	{
		Inventory_Close(playerid);
	}
	else if(playertextid == MAIN[playerid][7])
	{
		if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
		new id = pData[playerid][pSelectItem];

		if(id == -1)
		{
			ErrorMsg(playerid,"Pilih Barang Terlebih Dahulu");
		}
		else
		{
		    if(pData[playerid][pGiveAmount] < 1)
				return ErrorMsg(playerid,"Masukan Jumlah Terlebih Dahulu!");

			new itemid = pData[playerid][pSelectItem];
			new value = pData[playerid][pGiveAmount];

			CallLocalFunction("DropPlayerItem", "dds[128]d", playerid, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	/*else if(playertextid == MAIN[playerid][8])
	{
		InfoMsg(playerid, "Fitur ini sedang dalam pengembangan");
	}*/
	else if(playertextid == MAIN[playerid][6])
	{
		new id = pData[playerid][pSelectItem], str[500], count = 0;
		if(id == -1)
		{
			ErrorMsg(playerid,"[Inventory] Pilih Barang Terlebih Dahulu");
		}
		else
		{
			if (pData[playerid][pGiveAmount] < 1)
				return ErrorMsg(playerid,"[Inventory] Masukan Jumlah Terlebih Dahulu");

			foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
				format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
				SetPlayerListitemValue(playerid, count++, i);
			}
			if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
			else ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_LIST, "WKRP - Inventory", str, "Pilih", "Tutup");
		}
	}
	else if(playertextid == MAIN[playerid][4])
	{
		ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Inventory - Jumlah", "Masukan Jumlah:", "Berikan", "Batal");
	}
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		if(playertextid == INDEXTD[playerid][i])
		{
			if(InventoryData[playerid][i][invExists])
			{
				MenuStore_UnselectRow(playerid);
				MenuStore_SelectRow(playerid, i);
				new name[48];
				strunpack(name, InventoryData[playerid][pData[playerid][pSelectItem]][invItem]);
			}
		}
	}
	//hp
	//callvoice
	if(playertextid == CallHpLenz[playerid][20])
	{
        callcmd::p(playerid, "");
        TogglePhone[playerid] = 0;
	}

	if(playertextid == CallHpLenz[playerid][18])
	{
        callcmd::hu(playerid, "");
        TogglePhone[playerid] = 0;
	}
	//hpnyarrr
	if(playertextid == closehplenz[playerid])
	{
		RemovePlayerAttachedObject(playerid, 9);

		if(!IsPlayerInAnyVehicle(playerid) && !PlayerData[playerid][pInjured] && !PlayerData[playerid][pLoopAnim])
		{
			ClearAnimations(playerid);
		}    
		for(new i = 0; i < 25; i++) {
			PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
		}
		HideHpLenz(playerid);
		TogglePhone[playerid] = 0;
		CancelSelectTextDraw(playerid);
	}
 	if(playertextid == fingerhp[playerid][24])//fingerprint
	{
		for(new i = 0; i < 25; i++) {
			PlayerTextDrawHide(playerid, fingerhp[playerid][i]);
		}
		ShowHpLenz(playerid);
		SelectTextDraw(playerid, COLOR_LBLUE);
	}
	if(playertextid == airdrophplenz[playerid]) 
	{
	    if(pData[playerid][pPhoneStatus] == 0)
		{
			return Error(playerid, "Handphone anda sedang dimatikan");
		}
  		new str[500], count = 0;
			//ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_INPUT, "Memberikan Barang", "Kantong Yang Ingin Di Berikan:", "Berikan", "Batal");
		foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
		{
			format(str, sizeof(str), "%sKantong - %s (%d)\n", str, pData[i][pName], i);
			SetPlayerListitemValue(playerid, count++, i);
		}
		if(!count) ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Airdrop", "Tidak ada player disekitarmu", "Tutup", ""), PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		else ShowPlayerDialog(playerid, DIALOG_AIRDROP, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Airdrop", str, "Pilih", "Tutup");
	}
	if(playertextid == callhplenz[playerid]) 
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return Error(playerid, "Handphone anda sedang dimatikan");
		}
		
		ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Masukkan nomor telepon yang mau di telpon disini:", "Call", "Back");
	}
	if(playertextid == adshplenz[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pVip] < 1)
		{
			return ErrorMsg(playerid, "You're not a VIP Player.");
		}
		ShowPlayerDialog(playerid,DIALOG_IKLANHP,DIALOG_STYLE_INPUT,"Iklan Via Phone","Masukkan Iklan Disini","Select", "Cancel");
	}
	if(playertextid == bankhplenz[playerid]) 
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pVip])
		{
			return ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
		}

		ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money", "Select", "Cancel");
	}
	if(playertextid == contacthplenz[playerid]) 
	{
		if (pData[playerid][pPhoneStatus] == 0)
			return ErrorMsg(playerid, "Your phone must be powered on.");

		if(pData[playerid][pPhoneBook] == 0)
			return ErrorMsg(playerid, "You dont have a phone book.");

		ShowContacts(playerid);
	}
	if(playertextid == twhplenz[playerid]) 
	{
		new notif[20];
		if(pData[playerid][pTwitterStatus] == 1)
		{
			notif = "{ff0000}OFF";
		}
		else
		{
			notif = "{3BBD44}ON";
		}

		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		new string[100];
		//format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: {ff0000}MAINTENANCE", pData[playerid][pTwittername]);
		format(string, sizeof(string), "Posting Sesuatu\nGanti Nama Account: ({0099ff}%s{ffffff})\nNotify: %s", pData[playerid][pTwittername], notif);
		ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
	}
	if(playertextid == settinghplenz[playerid])
	{
  		ShowPlayerDialog(playerid, DIALOG_PANELPHONE, DIALOG_STYLE_LIST, "Phone", "Tentang Ponsel\nSettings", "Select", "Back");
	}
	if(playertextid == camerahplenz[playerid])
	{
		callcmd::selfie(playerid, "");
	}
	if(playertextid == mapshplenz[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		callcmd::gps(playerid, "");
	}
	if(playertextid == jobhplenz[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS Jobs & Sidejobs", "{A02BFC}MARKET JOB: {ffffff}TEMPAT PENJUALAN SEMUA HASIL KERJA JOBS\n{15D4ED}JOB: {ffffff}Pemerah Susu\n{15D4ED}JOB: {ffffff}Taxi\n{15D4ED}JOB: {ffffff}Lumber Jack\n{15D4ED}JOB: {ffffff}Trucker\n{15D4ED}JOB: {ffffff}Penambang Batu\n{15D4ED}JOB: {ffffff}Production\n{15D4ED}JOB: {ffffff}Farmer\n{15D4ED}JOB: {ffffff}Baggage Airport\n{15D4ED}JOB: {ffffff}Pemotong Ayam\n{15D4ED}JOB: {ffffff}Merchant Filler\n{15D4ED}JOB: {ffffff}Penambang Minyak\n{D2D2AB}SIDEJOB: {ffffff}Sweeper\n{D2D2AB}SIDEJOB: {ffffff}Bus\n{D2D2AB}SIDEJOB: {ffffff}Forklift", "Select", "Back");
	}
	if(playertextid == gojekhplenz[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		ShowPlayerDialog(playerid,DIALOG_CALLGOCAR,DIALOG_STYLE_INPUT,"Pesan Singkat","Masukkan Pesan Disini","Select", "Cancel");

	}
	if(playertextid == musichplenz[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0) 
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		ShowPlayerDialog(playerid,DIALOG_MUSICHP,DIALOG_STYLE_LIST,"Music","Matikan Musik\nInput Link","Select", "Cancel");
	}
	//ktp
	if(playertextid == IDCard[playerid][25])
    {
        for(new txd; txd < 26; txd++)
        {
            PlayerTextDrawHide(playerid, IDCard[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
	//lockertd
	if(playertextid == LockerTD[playerid][1])
	{
		callcmd::locker(playerid, "");
	}	
	if(playertextid == LockerTD[playerid][11])
    {
        for(new txd; txd < 22; txd++)
        {
            PlayerTextDrawHide(playerid, LockerTD[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
	//menumasak
	/*
	if(playertextid == TDPedagang[playerid][4])
	{
		if(pData[playerid][pFood] < 5)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai memasak!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pChiken] += 5;
		ShowProgressbar(playerid, "Memasak Chiken..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowItemBox(playerid, "Ayam Goreng", "Received_1x", 19847, 4);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 5;
	}	
	if(playertextid == TDPedagang[playerid][5])
	{
		if(pData[playerid][pFood] < 3)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai Kebab!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pKebab] += 5;
		ShowProgressbar(playerid, "Membuat Kebab..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowItemBox(playerid, "Kebab", "Received_1x", 2769, 4);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 3;
	}	
	if(playertextid == TDPedagang[playerid][6])
	{
		if(pData[playerid][pFood] < 2)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai memasak!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pRoti] += 5;
		ShowProgressbar(playerid, "Memasak Roti ..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowItemBox(playerid, "Roti", "Received_1x", 19883, 4);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 2;
	}	
	if(playertextid == TDPedagang[playerid][7])
	{
		if(pData[playerid][pFood] < 4)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai memasak!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pSteak] += 5;
		ShowProgressbar(playerid, "Memasak Steak..", 10);
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowItemBox(playerid, "Steak", "Received_1x", 2769, 4);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 4;
	}	
	if(playertextid == TDPedagang[playerid][2])
    {
        for(new txd; txd < 12; txd++)
        {
            PlayerTextDrawHide(playerid, TDPedagang[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }*/
	if(playertextid == TDPedagang[playerid][4])
	{
		if(pData[playerid][pFood] < 5)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		ShowProgressbar(playerid, "Memasak Kentucky..", 5);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
		InfoMsg(playerid, "Anda Memulai memasak!");
		SetTimerEx("masak1", 5000, false, "d", playerid);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 5;
	}	
	if(playertextid == TDPedagang[playerid][5])
	{
		if(pData[playerid][pFood] < 3)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai Kebab!");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 1);
		ShowProgressbar(playerid, "Membuat Kebab..", 5);
		SetTimerEx("masak2", 5000, false, "d", playerid);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 3;
	}	
	if(playertextid == TDPedagang[playerid][6])
	{
		if(pData[playerid][pFood] < 2)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai memasak!");
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowProgressbar(playerid, "Memasak Roti ..", 5);
		SetTimerEx("masak3", 5000, false, "d", playerid);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 2;
	}	
	if(playertextid == TDPedagang[playerid][7])
	{
		if(pData[playerid][pFood] < 4)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

		InfoMsg(playerid, "Anda Memulai memasak!");
		ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
		ShowProgressbar(playerid, "Memasak Steak..", 5);
		SetTimerEx("masak4", 5000, false, "d", playerid);
		pData[playerid][pEnergy] -= 2;
		pData[playerid][pFood] -= 4;
	}	
	if(playertextid == TDPedagang[playerid][2])
    {
        for(new txd; txd < 12; txd++)
        {
            PlayerTextDrawHide(playerid, TDPedagang[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
	//jual hasil tambang
	if(playertextid == TDjualtambang[playerid][4])
	{
		callcmd::adolminyak(playerid, "");
	}	
	if(playertextid == TDjualtambang[playerid][5])
	{
		callcmd::adolemas(playerid, "");
	}	
	if(playertextid == TDjualtambang[playerid][6])
	{
		callcmd::adolwesi(playerid, "");
	}	
	if(playertextid == TDjualtambang[playerid][7])
	{
		callcmd::adoltembaga(playerid, "");
	}	
	if(playertextid == TDjualtambang[playerid][2])
    {
        for(new txd; txd < 12; txd++)
        {
            PlayerTextDrawHide(playerid, TDjualtambang[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
	//ktpbaru
	if(playertextid == TDKTPNew[playerid][21])
    {
		HideTDKTPBaru(playerid);
		CancelSelectTextDraw(playerid);    
    }
    //===============================================================//
    return 1;
}