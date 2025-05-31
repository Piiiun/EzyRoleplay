//----------------[ Dialog System ]--------------

//----------[ Dialog Login Register]----------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("[OnDialogResponse]: %s(%d) has used dialog id: %d Listitem: %d", pData[playerid][pUCP], playerid, dialogid, listitem);
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);

		new hashed_pass[65];
		SHA256_PassHash(inputtext, UcpData[playerid][uSalt], hashed_pass, 128);

		if (strcmp(hashed_pass, UcpData[playerid][uPassword]) == 0)
		{
			UcpData[playerid][uLogged] = 1;
			new query[256];
			format(query, sizeof(query), "SELECT `username` FROM `players` WHERE `ucp` = '%s' LIMIT %d;", UcpData[playerid][uUsername], MAX_CHARACTERS);
			mysql_tquery(g_SQL, query, "OnCharacterLoaded", "d", playerid);

		}
		else
		{
            if (++UcpData[playerid][uLoginAttempts] >= 3) 
            {
                UcpData[playerid][uLoginAttempts] = 0;
                ErrorMsg(playerid, "Anda telah memasukkan password yang salah sebanyak 3 kali.");
                ErrorMsg(playerid, "Anda akan dikick.");
                KickEx(playerid);
            } 
            else 
            {
                new feda[350];
                format(feda, sizeof feda, "{FFFFFF}Selamat datang di {B897FF}Warga Kota\n{FFFFFF}UCP Ini telah terdaftar!\nNama UCP: {B897FF}%s\t\t\t\t\n{FFFFFF}Version: {B897FF}WKRP | v2.0\n{FF0000}(Password salah! Sisa kesempatan: %d / 3 )", GetName(playerid), UcpData[playerid][uLoginAttempts]);
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota {FFFFFF} - UCP Login", feda, "Masuk", "Batal");
            }
            return 1;
		}
        return 1;
	}
	/*if(dialogid == DIALOG_LOGIN) 
    {
        if (!response)
            return KickEx(playerid);

        if (isnull(inputtext))
        {
            new feda[250];
            format(feda, sizeof feda, ""WHITE_E"Selamat datang kembali "YELLOW_E"%s"WHITE_E", silahkan masukkan password Anda dibawah:", GetName(playerid));
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota {FFFFFF}- LOGIN", feda, "Masuk", "Batal");
            return 1;
        }

        new hash[65];
        SHA256_PassHash(inputtext, UcpData[playerid][uSalt], hash, sizeof(hash));

        if(strcmp(hash, UcpData[playerid][uPassword])) 
        {
            if (++UcpData[playerid][uLoginAttempts] >= 3) 
            {
                UcpData[playerid][uLoginAttempts] = 0;
                ErrorMsg(playerid, "Anda telah memasukkan password yang salah sebanyak 3 kali.");
                ErrorMsg(playerid, "Anda akan dikick.");
                KickEx(playerid);
            } 
            else 
            {
                new feda[350];
                format(feda, sizeof feda, ""WHITE_E"Selamat datang kembali "YELLOW_E"%s"WHITE_E", silahkan masukkan password Anda dibawah:\n"RED_E"Password salah! Sisa kesempatan: %d / 3", GetName(playerid), UcpData[playerid][uLoginAttempts]);
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota {FFFFFF}- LOGIN", feda, "Masuk", "Batal");
            }
            return 1;
        }

        UcpData[playerid][uLogged] = 1;
        new query[256];
        format(query, sizeof(query), "SELECT `username` FROM `players` WHERE `ucp` = '%s' LIMIT %d;", UcpData[playerid][uUsername], MAX_CHARACTERS);
        mysql_tquery(g_SQL, query, "OnCharacterLoaded", "d", playerid);
        return 1;
    }*/
    if(dialogid == DIALOG_REGISTER)
    {
        if (!response) return Kick(playerid);

		if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota - {FFFFFF}Registration", "Kata sandi minimal 5 Karakter!\nMohon isi Password dibawah ini:", "Register", "Tolak");

		if(!IsValidPassword(inputtext))
		{
			Error(playerid, "Sandi valid : A-Z, a-z, 0-9, _, [ ], ( )");
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota - {FFFFFF}Registration", "Kata sandi yang anda gunakan mengandung karakter yang valid!\nMohon isi Password dibawah ini:", "Register", "Tolak");
			return 1;
		}

		for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
		SHA256_PassHash(inputtext,  UcpData[playerid][uSalt],  UcpData[playerid][uPassword], 128);

		new query[842], PlayerIP[16];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		pData[playerid][pExtraChar] = 0;
		mysql_format(g_SQL, query, sizeof query, "UPDATE ucp SET password = '%s', salt = '%e', extrac = '%d' WHERE username = '%e'",  UcpData[playerid][uPassword], UcpData[playerid][uSalt],  UcpData[playerid][uExtraChar], UcpData[playerid][uUsername]);
		mysql_tquery(g_SQL, query, "OnCharacterLoaded", "i", playerid);//rung bar
        return 1;
    }
    /*if(dialogid == DIALOG_PASSWORD)
    {
        if(response)
        {
            new hash[65];
            SHA256_PassHash(inputtext, UcpData[playerid][uSalt], hash, sizeof(hash));

            if(strcmp(hash, UcpData[playerid][uPassword]))
                return ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_PASSWORD, "Konfirmasi password anda salah", ""WHITE_E"Masukkan password yang anda masukkan di kolom sebelumnya:\n\n"GREY_E"ErrorMsg: Password tidak sesuai, masukkan ulang password atau anda dapat ...\n... mengubahnya dengan password baru dengan menekan opsi 'Kembali'", "Konfirmasi", "Kembali");

            UcpData[playerid][uRegisterDate] = gettime();

            GetPlayerIp(playerid, UcpData[playerid][uIP], 16);
            GetPlayerName(playerid, UcpData[playerid][uUsername], MAX_PLAYER_NAME + 1);

            new query[500];
            mysql_format(g_SQL, query,sizeof(query), "INSERT INTO ucp ( username, password, salt, ip, registerdate ) VALUES ('%e', '%s', '%e', '%s', '%i')", UcpData[playerid][uUsername], UcpData[playerid][uPassword], UcpData[playerid][uSalt], UcpData[playerid][uIP], UcpData[playerid][uRegisterDate]);
            mysql_query(g_SQL, query);
            // CheckAccount(playerid);
            format(query, sizeof(query), "SELECT `username` FROM `players` WHERE `ucp` = '%s' LIMIT %d;", UcpData[playerid][uUsername], MAX_CHARACTERS);
            mysql_tquery(g_SQL, query, "OnCharacterLoaded", "d", playerid);
        }
        else 
        {
        	new feda[250];
        	format(feda, sizeof feda, ""WHITE_E"Akun dengan nama "YELLOW_E"%s "WHITE_E"tidak terdaftar. Silahkan masukkan password dibawah untuk mendaftar:", GetName(playerid));
        	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota{FFFFFF} - Daftar", feda, "Daftarkan", "Tutup");
   	    }
        return 1;
    }*/
	/*if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				Error(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++)  UcpData[playerid][uSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, UcpData[playerid][uSalt],  UcpData[playerid][uPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE ucp SET password='%s', salt='%e' WHERE username='%e'",  UcpData[playerid][uPassword],  UcpData[playerid][uSalt], UcpData[playerid][uUsername]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}*/
    if(dialogid == DIALOG_SELECTCHAR)
    {
        if (!response)
            return KickEx(playerid);

        /*for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) if(UcpData[i][uUsername][0] != EOS)
        {
            if(!strcmp(UcpData[i][uUsername], GetName(playerid)) && i != playerid)
            {
                Error(playerid, "Seseorang sedang login menggunakan UCP yang sama.");
                KickEx(playerid);
                return 1;
            }
        }*/

        if (CharacterList[playerid][listitem][0] == EOS)
            return ShowPlayerDialog(playerid, DIALOG_CREATECHAR, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Create Character", ""WHITE_E"Masukkan nama karakter, maksimal 24 karakter\n\nContoh: "YELLOW_E"Sean_Rutledge, Eddison_Murphy dan lainnya.", "Create", "Back");

        pData[playerid][pChar] = listitem;
        SetPlayerName(playerid, CharacterList[playerid][listitem]);

        new cQuery[256];
        mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `players` WHERE `username` = '%s' ORDER BY `reg_id` ASC LIMIT 1;", CharacterList[playerid][pData[playerid][pChar]]);
        mysql_tquery(g_SQL, cQuery, "AssignPlayerData", "d", playerid); 
        return 1;
    }
    if(dialogid == DIALOG_CREATECHAR)
    {
        if (!response)
            return ShowCharacterMenu(playerid);

        if (!IsValidRoleplayName(inputtext) || strlen(inputtext) <= 3 && strlen(inputtext) > 24) {
            SendClientMessage(playerid, COLOR_WHITE, "Nama harus sesuai dengan aturan Roleplay, Contoh: Sean_Rutledge, Eddison_Murphy");
            return ShowPlayerDialog(playerid, DIALOG_CREATECHAR, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Create Character", ""WHITE_E"Masukkan nama karakter, maksimal 24 karakter\n\nContoh: "YELLOW_E"Sean_Rutledge, Eddison_Murphy dan lainnya.", "Create", "Back");
        }

        new cQuery[256];
        mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1;", inputtext);
        mysql_tquery(g_SQL, cQuery, "OnCharacterCheck", "is", playerid, inputtext); 
    }
	if(dialogid == DIALOG_AGE)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tahun Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Bulan Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		if(response)
		{
			pData[playerid][pGender] = listitem + 1;
			switch (listitem) 
			{
				case 0: 
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"{B897FF}Server : {FFFFFF}Registrasi Berhasil! Terima kasih telah bergabung ke dalam server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"{B897FF}Server : {FFFFFF}Tanggal Lahir : %s | Gender : Male/Laki-Laki", pData[playerid][pAge]);
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SpawnMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SpawnFemale, "Choose your skin");
					}
				}
				case 1: 
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"{B897FF}Server :{FFFFFF} Registrasi Berhasil! Terima kasih telah bergabung ke dalam server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"{B897FF}Server : {FFFFFF}Tanggal Lahir : %s | Gender : Female/Perempuan", pData[playerid][pAge]);
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SpawnMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SpawnFemale, "Choose your skin");
					}
				}
			}
			pData[playerid][pSkin] = (listitem) ? (233) : (98);
			SetPlayerSkin(playerid,pData[playerid][pSkin]);
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1788.1824,-1877.3479,13.6007,271.4230, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,"{B897FF}Warga Kota{FFFFFF} - PERINTAH PENTING!!","KAMU DIHARUSKAN {FF0000}RELOGIN SEKARANG, SETELAH MEMILIH SKIN{FFFFFF} BIAR DATABASE KAMU TER-SAVE KEDALAM SERVER","OKE","");
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_EMAIL)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				ErrorMsg(playerid, "This field cannot be left empty!");
				callcmd::email(playerid);
				return 1;
			}
			if(!(2 < strlen(inputtext) < 40))
			{
				ErrorMsg(playerid, "Please insert a valid email! Must be between 3-40 characters.");
				callcmd::email(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				ErrorMsg(playerid, "Email can contain only A-Z, a-z, 0-9, _, [ ], ( )  and @");
				callcmd::email(playerid);
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET email='%e' WHERE reg_id='%d'", inputtext, pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your e-mail has been set to "YELLOW_E"%s!"WHITE_E"(relogin for /stats update)", inputtext);
			return 1;
		}
	}
	if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				ErrorMsg(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				ErrorMsg(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET password='%s', salt='%e' WHERE reg_id='%d'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}
	if(dialogid == DIALOG_VERIFYCODE)
	{
		if(response)
		{
			new str[250];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT", UcpData[playerid][uUsername]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota - {FFFFFF}Verify Account", str, "Input", "Batal");
			}
			if(!IsNumeric(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN hanya berisi 6 Digit angka bukan huruf", UcpData[playerid][uUsername]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota - {FFFFFF}Verify Account", str, "Input", "Batal");
			}
			if(strval(inputtext) == UcpData[playerid][uVerifyCode])
			{
			 	//new str[250];
				format(str, sizeof(str), ""WHITE_E"Selamat datang "YELLOW_E"%s"WHITE_E".\n\nMasukkan password untuk mendaftarkan akun: (password minimal 8 sampai dengan 32 karakter)", GetName(playerid));
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{B897FF}Warga Kota - {FFFFFF}Mendaftarkan akun", str, "Daftarkan", "Keluar");
				return 1;
			}

			format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN salah!", UcpData[playerid][uUsername]);
			return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota - {FFFFFF}Verify Account", str, "Input", "Batal");
		}
		else 
		{
			Kick(playerid);
		}
	}
	if(dialogid == DIALOG_STATS)
	{
		if(response)
		{
			return callcmd::settings(playerid);
		}
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::email(playerid);
				}
				case 1:
				{
					return callcmd::changepass(playerid);
				}
				case 2:
				{	
					ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- HBE Mode", ""LG_E"Simple\n"LG_E"Modern\n"RED_E"Disable", "Set", "Close");
				}
				case 3:
				{
					return callcmd::togpm(playerid);
				}
				case 4:
				{
					return callcmd::toglog(playerid);
				}
				case 5:
				{
					return callcmd::togads(playerid);
				}
				case 6:
				{
					return callcmd::togwt(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_HBEMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					HidePlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spenergybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spbladdybar]);
					for(new txd = 12; txd > 11 && txd < 16; txd++)
					{
						TextDrawHideForPlayer(playerid, TDEditor_TD[txd]);
					}
					
					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					HidePlayerProgressBar(playerid, pData[playerid][bladdybar]);
					for(new txd; txd < 5; txd++)
					{
						TextDrawHideForPlayer(playerid, TDEditor_TD[txd]);
					}
					
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);
					HideHbeaufa(playerid);
					TextDrawHideForPlayer(playerid, aerpname[0]);
					pData[playerid][pHBEMode] = 1;
					
					//ShowPlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					//ShowPlayerProgressBar(playerid, pData[playerid][spenergybar]);
					//ShowPlayerProgressBar(playerid, pData[playerid][spbladdybar]);
					TextDrawShowForPlayer(playerid, TextDate);
					TextDrawShowForPlayer(playerid, TextTime);
					//PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
					//PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
					ShowHbeaufaDua(playerid);
					UpdateHBEDua(playerid);
					PlayerTextDrawShow(playerid, NameServer2[playerid]);
				}
				case 1:
				{
					HidePlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spenergybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spbladdybar]);

					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					HidePlayerProgressBar(playerid, pData[playerid][bladdybar]);
					for(new txd; txd < 5; txd++)
					{
						TextDrawHideForPlayer(playerid, TDEditor_TD[txd]);
					}
					
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);
					HideHbeaufaDua(playerid);
					PlayerTextDrawHide(playerid, NameServer2[playerid]);
					pData[playerid][pHBEMode] = 2;

					ShowHbeaufa(playerid);
					UpdateHBE(playerid);
					
					//PlayerTextDrawShow(playerid, NameserverTD[playerid][0]);
					PlayerTextDrawShow(playerid, LOADBARTEXT[playerid]);
					TextDrawShowForPlayer(playerid, aerpname[0]);
					TextDrawShowForPlayer(playerid, TextDate);
					TextDrawShowForPlayer(playerid, TextTime);
				}
				case 2:
				{
					pData[playerid][pHBEMode] = 0;
					
					HidePlayerProgressBar(playerid, pData[playerid][sphungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spenergybar]);
					HidePlayerProgressBar(playerid, pData[playerid][spbladdybar]);
					//UpdateHBE(playerid);
					HideHbeaufa(playerid);
					HideHbeaufaDua(playerid);
					
					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					HidePlayerProgressBar(playerid, pData[playerid][bladdybar]);
					for(new txd; txd < 5; txd++)
					{
						TextDrawHideForPlayer(playerid, TDEditor_TD[txd]);
					}
					
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);
					PlayerTextDrawHide(playerid, VoiceTD[playerid][0]);
					PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
					//PlayerTextDrawHide(playerid, NameserverTD[playerid][0]);
					PlayerTextDrawHide(playerid, LOADBARTEXT[playerid]);
					TextDrawHideForPlayer(playerid, aerpname[0]);
					PlayerTextDrawHide(playerid, NameServer2[playerid]);
				}
			}
		}
	}
	if(dialogid == DIALOG_CHANGEAGE)
    {
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tahun Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Bulan Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Tanggal Lahir", "ErrorMsg! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				Info(playerid, "New Age for your character is "YELLOW_E"%s.", pData[playerid][pAge]);
				GivePlayerMoneyEx(playerid, -300);
				Server_AddMoney(300);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pGold] < 500) return ErrorMsg(playerid, "Not enough gold!");
					ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Change Name", "Input new nickname:\nExample: Charles_Sanders\n", "Change", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pGold] < 1000) return ErrorMsg(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 1000;
					pData[playerid][pWarn] = 0;
					SuccesMsg(playerid, "Warning have been reseted for 1000 gold. Total Warning: 0");
				}
				case 2:
				{
					if(pData[playerid][pGold] < 150) return ErrorMsg(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pVip] = 1;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					SuccesMsg(playerid, "You has bought VIP level 1 for 150 gold(7 days).");
				}
				case 3:
				{
					if(pData[playerid][pGold] < 250) return ErrorMsg(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 250;
					pData[playerid][pVip] = 2;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					SuccesMsg(playerid, "You has bought VIP level 2 for 250 gold(7 days).");
				}
				case 4:
				{
					if(pData[playerid][pGold] < 500) return ErrorMsg(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 500;
					pData[playerid][pVip] = 3;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					SuccesMsg(playerid, "You has bought VIP level 3 for 500 gold(7 days).");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDNAME)
	{
		if(response)
		{
			if(strlen(inputtext) < 4) return ErrorMsg(playerid, "New name can't be shorter than 4 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(strlen(inputtext) > 20) return ErrorMsg(playerid, "New name can't be longer than 20 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(!IsValidRoleplayName(inputtext))
			{
				ErrorMsg(playerid, "Name contains invalid characters, please doublecheck!");
				ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"{B897FF}Warga Kota {FFFFFF}- Change Name", "Enter your new name:", "Enter", "Exit");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeName", "is", playerid, inputtext);
		}
		return 1;
	}
	//-----------[ Bisnis Dialog ]------------
	if(dialogid == DIALOG_SELL_BISNISS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota {FFFFFF}- Sell Bisnis", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_BISNIS)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;
			price = bData[bid][bPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			Bisnis_Reset(bid);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF}Bisnis", "Show Information\nTrack Bisnis", "Select", "Cancel");
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData[bid][bLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(bData[bid][bType] == 1)
				{
					type = "Fast Food";
			
				}
				else if(bData[bid][bType] == 2)
				{
					type = "Market";
				}
				else if(bData[bid][bType] == 3)
				{
					type = "Clothes";
				}
				else if(bData[bid][bType] == 4)
				{
					type = "Equipment";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData[bid][bOwner], bData[bid][bName], FormatMoney(bData[bid][bPrice]), type, lock, bData[bid][bProd]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota {FFFFFF}- Bisnis Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				SuccesMsg(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_MENU)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData[bid][bLocked] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t$%s", bData[bid][bName], lock, bData[bid][bProd], FormatMoney(bData[bid][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData[bid][bName]);
					ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				}
				case 2:
				{
					Bisnis_ProductMenu(playerid, bid);
				}
				case 3:
				{
					Bisnis_ProductMenuName(playerid, bid);
				}
				case 4:
				{
					if(bData[bid][bProd] > 100)
						return Error(playerid, "Bisnis ini masih memiliki cukup produck.");
					new mstr[248];
					format(mstr,sizeof(mstr),""GREEN_E"Masukan Jumlah Product Yang Anda Beli");
					ShowPlayerDialog(playerid, BISNIS_BUYRESTOCK, DIALOG_STYLE_INPUT,"Bisnis Restock", mstr,"Buy","Back");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_URL_BISNIS, DIALOG_STYLE_INPUT, "Radio URL", "Enter music url to play music", "Play", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_BUYRESTOCK)
	{
		if (response)
		{
			new bid = pData[playerid][pInBiz];
		    new idiot = floatround(strval(inputtext));
			new value = idiot * 50, String[212];
			if(bData[bid][bMoney] < value) return Error(playerid, "Uang Di Bisnis anda tidak cukup untuk merestock bisnis");
			bData[bid][bMoney] -= value;
			bData[bid][bProd] += idiot;
			format(String, sizeof(String), "BISNIS: "WHITE_E"Anda telah membeli product bisnis {00FFFF}%d "WHITE_E"unit dengan harga "YELLOW_E"$%s", idiot, FormatMoney(value));
			SendClientMessage(playerid, COLOR_ARWIN, String);
		}
	}
	if(dialogid == BISNIS_INFO)
	{
		if(response)
		{
			return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return ErrorMsg(playerid, "You don't own this bisnis.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"{B897FF}Warga Kota {FFFFFF}- Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"{B897FF}Warga Kota {FFFFFF}- Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			format(bData[bid][bName], 32, ColouredText(inputtext));

			Bisnis_Refresh(bid);
			Bisnis_Save(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData[pData[playerid][pInBiz]][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW, DIALOG_STYLE_INPUT,"{B897FF}Warga Kota {FFFFFF}- Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData[bid][bMoney])
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData[bid][bMoney] -= amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"{B897FF}Warga Kota {FFFFFF}- Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData[bid][bMoney] += amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"{B897FF}Warga Kota {FFFFFF}- Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_URL_BISNIS)
	{
		if(response)
		{
		    if(strlen(inputtext))
		    {
				new bid = pData[playerid][pInBiz];
				format(bData[bid][bStream], 128, inputtext);
				SendClientMessageEx(playerid, COLOR_ARWIN, "BISNIS: "WHITE_E"You have set the radio URL with the URL "YELLOW_E"%s", inputtext);
				new Float:BBCoord[3];
				GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
				PlayStream(playerid, inputtext, BBCoord[0], BBCoord[1], BBCoord[2], 30.0, 1);	
			}
		}
	}
	if(dialogid == BISNIS_BUYPROD)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response && listitem != -1)
		{
			price = bData[bizid][bP][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(bData[bizid][bProd] < 1)
				return Error(playerid, "This business is out of stock product.");
				
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData[bizid][bType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHunger] += 6;
						ShowItemBox(playerid, "Snack", "Received_1x", 2821, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName0], FormatMoney(price));
						
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHunger] += 18;
						ShowItemBox(playerid, "Snack", "Received_1x", 2821, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName1], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHunger] += 32;
						ShowItemBox(playerid, "Snack", "Received_1x", 2821, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName2], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pEnergy] += 45;
						ShowItemBox(playerid, "Water", "Received_1x", 2958, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName3], FormatMoney(price));
					}
				}
			}
			else if(bData[bizid][bType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						if(pData[playerid][pSnack] > 5) return Error(playerid, "maximum bring snacks in invetory 5");
						pData[playerid][pSnack]++;
						ShowItemBox(playerid, "Snack", "Received_1x", 2821, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName0], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSprunk]++;
						ShowItemBox(playerid, "Water", "Received_1x", 2958, 4);
						if(pData[playerid][pSprunk] > 5) return Error(playerid, "maximum bring spurnk in invetory 5");
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName1], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pRokok]++;
						ShowItemBox(playerid, "Rokok", "Received_1x", 3027, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName3], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pRokok]+= 5;
						ShowItemBox(playerid, "Rokok", "Received_5x", 3027, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName9], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 4:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBandage]++;
						ShowItemBox(playerid, "Perban", "Received_1x", 11736, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}%s", bData[bizid][bPName10], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						switch(pData[playerid][pGender])
						{
							case 1: ShowModelSelectionMenu(playerid, MaleSkins, "Choose your skin");
							case 2: ShowModelSelectionMenu(playerid, FemaleSkins, "Choose your skin");
						}
					}
					case 1:
					{
						new string[248];
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

						/*if(pToys[playerid][4][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 5\n");
						}
						else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

						if(pToys[playerid][5][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 6\n");
						}
						else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, ""RED_E"{B897FF} Warga Kota -{FFFFFF} "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						pData[playerid][pMaskID] = random(90000) + 10000;
						ShowItemBox(playerid, "Mask", "Received_1x", 19163, 4);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHelmet] = 1;
						ShowItemBox(playerid, "Helm", "Received_1x", 18977, 4);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName0], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 6, 1);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName1], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName2], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						if(pData[playerid][pFishTool] > 1) return Error(playerid, "Anda masih memiliki pancingan!");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pFishTool] = 100;
						ShowItemBox(playerid, "Pancingan", "Received_1x", 18632, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName3], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 4:
					{
						if(pData[playerid][pMask] > 0) return Error(playerid, "Anda sudah memiliki Mask");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						ShowItemBox(playerid, "Mask", "Received_1x", 18911, 4);
						pData[playerid][pMaskID] = random(9999)+1000+pData[playerid][pMask];
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName4], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 5:
					{
						//if(pData[playerid][pMask] > 0) return Error(playerid, "Anda sudah memiliki Chainsaw");
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 9, 1);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName4], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 5)
			{
				switch(listitem)
				{
					case 0:
					{
						if(pData[playerid][pPhone] > 0) return Error(playerid, "Anda sudah memiliki Handphone");
						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(11111, 99999);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						pData[playerid][pPhone] = 1;
						ShowItemBox(playerid, "Handphone", "Received_1x", 18867, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName0], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}	
					case 1:
					{
						if(pData[playerid][pGPS] > 0) return Error(playerid, "Anda sudah memiliki GPS");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGPS] = 1;
						ShowItemBox(playerid, "GPS", "Received_1x", 18870, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName1], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 1000;
						ShowItemBox(playerid, "Pulsa", "Received_1x", 18867, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName2], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						if(pData[playerid][pWT] > 0) return Error(playerid, "Anda sudah memiliki walkie talkie");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						ShowItemBox(playerid, "WalkieTalkie", "Received_1x", 19942, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName3], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 4:
					{
						if(pData[playerid][pPhoneBook] > 0) return Error(playerid, "Anda sudah memiliki phonebook");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						ShowItemBox(playerid, "PhoneBook", "Received_1x", 19942, 4);
						SendClientMessageEx(playerid, COLOR_PURPLE, "SHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$%s", bData[bizid][bPName4], FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}			
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Business: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::bm(playerid, "\0");
		}
		return 1;
	}

	if(dialogid == BISNIS_EDITNAME)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				//new bid = pData[playerid][pInBiz];
				static
					item[40],
					str[128];

				// Extract product name from the dialog item
				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				
				// Show dialog to edit product name
				format(str, sizeof(str), "Current product name: %s\n\nPlease enter the new product name:", item);
				ShowPlayerDialog(playerid, BISNIS_NAMESET, DIALOG_STYLE_INPUT, 
					"Business: Edit Product Name", 
					str, 
					"Change", 
					"Back");
			}
			else
			{
				return callcmd::bm(playerid, "\0");
			}
		}
    	return 1;
	}

	if(dialogid == BISNIS_NAMESET)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				new bid = pData[playerid][pInBiz];
				new itemid = pData[playerid][pProductModify];
				
				if(isnull(inputtext) || strlen(inputtext) > 128)
				{
					SendClientMessage(playerid, COLOR_RED, "Product name cannot be empty or exceed 128 characters!");
					return callcmd::bm(playerid, "\0");
				}
				
				// Update the product name based on which item was selected
				switch(itemid)
				{
					case 0: format(bData[bid][bPName0], 128, inputtext);
					case 1: format(bData[bid][bPName1], 128, inputtext);
					case 2: format(bData[bid][bPName2], 128, inputtext);
					case 3: format(bData[bid][bPName3], 128, inputtext);
					case 4: format(bData[bid][bPName4], 128, inputtext);
					case 5: format(bData[bid][bPName5], 128, inputtext);
					case 6: format(bData[bid][bPName6], 128, inputtext);
					case 7: format(bData[bid][bPName7], 128, inputtext);
					case 8: format(bData[bid][bPName8], 128, inputtext);
					case 9: format(bData[bid][bPName9], 128, inputtext);
					case 10: format(bData[bid][bPName10], 128, inputtext);
				}
				
				// Save changes
				Bisnis_Save(bid);
				
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have changed product %d name to: %s", itemid, inputtext);
				
				// Show product menu again
				return callcmd::bm(playerid, "\0");
			}
			else
			{
				// Go back to product edit menu
				return callcmd::bm(playerid, "\0");
			}
		}
		return 1;
	}

	if(dialogid == BISNIS_PRICESET)
	{
		static
        item[40];
		new bizid = pData[playerid][pInBiz];
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
				Bisnis_Save(bizid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				return callcmd::bm(playerid, "\0");
			}
			else
			{
				return callcmd::bm(playerid, "\0");
			}
		}
		return 1;
	}
	//-----------[ House Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOUSES)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell house id: %d", GetPVarInt(playerid, "SellingHouse"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota {FFFFFF}- Sell House", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_HOUSE)
	{
		if(response)
		{
			new hid = GetPVarInt(playerid, "SellingHouse"), price;
			price = hData[hid][hPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", hid, FormatMoney(price));
			HouseReset(hid);
			House_Save(hid);
			House_Refresh(hid);
		}
		DeletePVar(playerid, "SellingHouse");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOUSES)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOUSE_INFO, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Houses", "Show Information\nTrack House", "Select", "Cancel");
		return 1;
	}
	if(dialogid == HOUSE_INFO)
	{
		if(!response) return 1;
		new hid = GetPVarInt(playerid, "ClickedHouse");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(hData[hid][hLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(hData[hid][hType] == 1)
				{
					type = "Small";
			
				}
				else if(hData[hid][hType] == 2)
				{
					type = "Medium";
				}
				else if(hData[hid][hType] == 3)
				{
					type = "Big";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "House ID: %d\nHouse Owner: %s\nHouse Address: %s\nHouse Price: %s\nHouse Type: %s\nHouse Status: %s",
				hid, hData[hid][hOwner], hData[hid][hAddress], FormatMoney(hData[hid][hPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota {FFFFFF}- House Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackHouse] = 1;
				SetPlayerRaceCheckpoint(playerid,1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				InfoMsg(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_STORAGE)
	{
		new hid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			if(listitem == 0) 
			{
				House_WeaponStorage(playerid, hid);
			}
			else if(listitem == 1) 
			{
				ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_WEAPONS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return ErrorMsg(playerid, "You don't own this house.");
				
		if(response)
		{
			if(hData[houseid][hWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, hData[houseid][hWeapon][listitem], hData[houseid][hAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(hData[houseid][hWeapon][listitem]));

				hData[houseid][hWeapon][listitem] = 0;
				hData[houseid][hAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return ErrorMsg(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return ErrorMsg(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return ErrorMsg(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				hData[houseid][hWeapon][listitem] = weaponid;
				hData[houseid][hAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
			House_OpenStorage(playerid, houseid);
		}
		return 1;
	}
	if(dialogid == HOUSE_MONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMoney])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {FFFFFF}- Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//------------[ Private Player Vehicle Dialog ]--------
	if(dialogid == DIALOG_FINDVEH)
	{
		if(response) 
		{
			ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Find Veh", "Enter your own vehicle id:", "Find", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACKVEH)
	{
		if(response) 
		{	
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			foreach(new veh : PVehicles)
			{
				if(pvData[veh][cVeh] == carid)
				{
					if(IsValidVehicle(pvData[veh][cVeh]))
					{
						if(pvData[veh][cOwner] == pData[playerid][pID])
						{
							GetVehiclePos(carid, posisiX, posisiY, posisiZ);
							pData[playerid][pTrackCar] = 1;
							//SetPlayerCheckpoint(playerid, posisi[0], posisi[1], posisi[2], 4.0);
							SetPlayerRaceCheckpoint(playerid,1, posisiX, posisiY, posisiZ, 0.0, 0.0, 0.0, 3.5);
							Info(playerid, "Your car waypoint was set to \"%s\" (marked on radar).", GetLocation(posisiX, posisiY, posisiZ));
						}
						else return ErrorMsg(playerid, "Id kendaraan ini bukan milik anda!");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOTOVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetVehiclePos(carid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_GETVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
		}
		return 1;
	}
	if(dialogid == DIALOG_DELETEVEH)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)			
			{
				if(carid == pvData[i][cVeh])
				{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					DestroyVehicle(pvData[i][cVeh]);
					pvData[i][cVeh] = INVALID_VEHICLE_ID;
					Iter_SafeRemove(PVehicles, i, i);
					Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", pvData[i][cVeh], pvData[i][cID]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPLATE)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk membeli Plate baru.");
					GivePlayerMoneyEx(playerid, -500);
					new rand = RandomEx(1111, 9999);
					format(pvData[i][cPlate], 32, "Warga Kota-%d", rand);
					SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
					pvData[i][cPlateTime] = gettime() + (15 * 86400);
					Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				}
			}
		}
		return 1;
	}
	//--------------[ Player Toy Dialog ]-------------
	if(dialogid == DIALOG_TOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"{B897FF} Warga Kota -{FFFFFF} "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"{B897FF} Warga Kota -{FFFFFF} "WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 4:
				{
					if(pData[playerid][PurchasedToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							pToys[playerid][i][toy_model] = 0;
							pToys[playerid][i][toy_bone] = 1;
							pToys[playerid][i][toy_x] = 0.0;
							pToys[playerid][i][toy_y] = 0.0;
							pToys[playerid][i][toy_z] = 0.0;
							pToys[playerid][i][toy_rx] = 0.0;
							pToys[playerid][i][toy_ry] = 0.0;
							pToys[playerid][i][toy_rz] = 0.0;
							pToys[playerid][i][toy_sx] = 1.0;
							pToys[playerid][i][toy_sy] = 1.0;
							pToys[playerid][i][toy_sz] = 1.0;
							
							if(IsPlayerAttachedObjectSlotUsed(playerid, i))
							{
								RemovePlayerAttachedObject(playerid, i);
							}
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toys WHERE Owner = '%s'", pData[playerid][pName]);
						mysql_tquery(g_SQL, string);
						pData[playerid][PurchasedToy] = false;
						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				/*case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}*/
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					//if(IsPlayerAndroid(playerid))
					//	return ErrorMsg(playerid, "You're connected from android. This feature only for PC users!");
						
					EditAttachedObject(playerid, pData[playerid][toySelected]);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing your toy.");
				}
				case 1: // change bone
				{
					new finstring[750];

					strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
					strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");

					ShowPlayerDialog(playerid, DIALOG_TOYPOSISI, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Player Toys", finstring, "Select", "Cancel");
				}
				case 2: // remove toy
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
					}
					pToys[playerid][pData[playerid][toySelected]][toy_model] = 0;
					GameTextForPlayer(playerid, "~r~~h~Toy Removed~y~!", 3000, 4);
					SetPVarInt(playerid, "UpdatedToy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 3:	//share toy pos
				{
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[TOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
				}
				case 4: //Pos X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_x]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSX, DIALOG_STYLE_INPUT, "Toy PosX", mstr, "Edit", "Cancel");
				}
				case 5: //Pos Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_y]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSY, DIALOG_STYLE_INPUT, "Toy PosY", mstr, "Edit", "Cancel");
				}
				case 6: //Pos Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_z]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSZ, DIALOG_STYLE_INPUT, "Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 7: //Pos RX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 8: //Pos RY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_ry]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 9: //Pos RZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISI)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
			{
				RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
			}
			listitem = pData[playerid][toySelected];
			SetPlayerAttachedObject(playerid,
					listitem,
					pToys[playerid][listitem][toy_model],
					pToys[playerid][listitem][toy_bone],
					pToys[playerid][listitem][toy_x],
					pToys[playerid][listitem][toy_y],
					pToys[playerid][listitem][toy_z],
					pToys[playerid][listitem][toy_rx],
					pToys[playerid][listitem][toy_ry],
					pToys[playerid][listitem][toy_rz],
					pToys[playerid][listitem][toy_sx],
					pToys[playerid][listitem][toy_sy],
					pToys[playerid][listitem][toy_sz]);
			GameTextForPlayer(playerid, "~g~~h~Bone Changed~y~!", 3000, 4);
			SetPVarInt(playerid, "UpdatedToy", 1);
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISIBUY)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			SetPlayerAttachedObject(playerid, pData[playerid][toySelected], pToys[playerid][pData[playerid][toySelected]][toy_model], listitem);
			//EditAttachedObject(playerid, pData[playerid][toySelected]);
			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota -{FFFFFF} Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYVIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_x] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_y] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_z] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_ry] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);
			
			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			
			pToys[playerid][pData[playerid][toySelected]][toy_rz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- Player Toys", string, "Select", "Cancel");
		}
	}
	//-----------[ Player Commands Dialog ]----------
	if(dialogid == DIALOG_HELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{7fffd4}PLAYER: {7fff00}/help /afk /drag /undrag /pay /stats /items /frisk /use /give /idcard /drivelic /togphone /reqloc\n");
				strcat(str, "{7fffd4}PLAYER: {7fff00}/weapon /settings /ask /answer /mask /helmet /death /accept /deny /revive /buy /health /destroycp /phone\n");
				strcat(str, "{7fffd4}TWITTER: {7fff00}/togtw /tw\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Player", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, ""LG_E"CHAT: /b /l /t /s /pm /togpm /w /o /me /ame /do /ado /try /ab\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Chat", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, ""LG_E"VEHICLE: /en - Toggle Engine || /light - Toggle lights\n");
				strcat(str, ""LB_E"VEHICLE: /hood - Toggle Hood || /trunk - Toggle Trunk\n");
				strcat(str, ""LG_E"VEHICLE: /lock - Toggle Lock || /unlock - Toggle Unlock\n");
				strcat(str, ""LB_E"VEHICLE: /tow - Tow Vehicle || /untow - Untow Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /park - Save Park || /my(/mypv) - List Private Vehicle\n");
				strcat(str, ""LG_E"VEHICLE: /myinsu - Vehicle Insurance || /claimpv - Claim Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /buyplate - Buy Plate || /buyinsu - Buy Insurance\n");
				strcat(str, ""LG_E"VEHICLE: /eject\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Vehicle", str, "Close", "");
			}
			case 3:
			{
				new line3[500];
				strcat(line3, "{ffffff}Taxi\nMechanic\nLumberjack\nTrucker\nPenambang\nProduct\nFarmer\nCourier\nBaggage Airport\nPemotong Ayam\nSmuggler[ilegal]\nMerchant Filler\nPenambang Minyak");
				//strcat(line3, "{ffffff}Taxi\nMechanic\nLumberjack\nTrucker\nMiner\nProduct\nFarmer\nKurir");
				ShowPlayerDialog(playerid, DIALOG_JOB, DIALOG_STYLE_LIST, "Job Help", line3, "Pilih", "Batal");
				return 1;
			}
			case 4:
			{
				return callcmd::factionhelp(playerid);
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpgun rpcrash rpfall rprob rpfish rpmad rpcj rpdrink\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpwar rpdie rpfixmeka rpcheckmeka rpfight rpcry rpeat\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpfear rpdropgun rpgivegun rptakegun rprun rpnodong\n");
				strcat(str, "{7fffd4}AUTO RP: {ffffff}rpshy rpnusuk rplock rpharvest rplockhouse rplockcar\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"{B897FF} Warga Kota {FFFFFF}- AUTO RP", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, ""LG_E"BISNIS: /buy /bm /lockbisnis /unlockbisnis /mybis\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Chat", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, ""LG_E"HOUSE: /buy /storage /lockhouse /unlockhouse /myhouse\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Chat", str, "Close", "");
			}
			case 8:
			{
				return callcmd::donate(playerid);
			}
			case 9:
			{
				return callcmd::credits(playerid);
			}
			case 10:
			{
				new str[3500];
				strcat(str, ""LG_E"ROBBERY: /setrobbery /inviterob /rob\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Robbery Help", str, "Close", "");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_JOB)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Unity Station\n\n{7fffd4}CMDS: /taxiduty /fare\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Taxi Job", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Idlewood\n\n{7fffd4}CMDS: /mechduty /service\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Mechanic Job", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini khusus untuk Lumber Profesional\n\n{7fffd4}CMDS: /(lum)ber\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Lumber Job", str, "Close", "");
			}
			case 3:
			{
				//new str[3500];
				//strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /mission /storeproduct /storegas /storestock /gps /shipments /cargo buy /cargo load /cargo unload /cargo pickup /cargo sell\n");
				new String[1500], S3MP4K[10000];
				format(String, sizeof(String), "{B897FF}Welcome To in Trucker Jobs Tutorial Help For Civilianz\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Anda bisa mendapatkan pekerjaan Trucker/Hauling yang lokasi nya ada dan tertera di GPS\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Perkerjaan ini sangat menguntungkan dan sangat berguna untuk pengisian Bisnis berupa(Dealer,Pom bensin,Bisnis) Dan lainnya untuk para Player yang memilikinya\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Pekerjaan ini di perbolehkan Bebas bila Anda memiliki Licensi Trucker dan anda harus memiliki Kendaraan Trucker & sejenisnya untuk restock\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Anda dapat mengakses Command yang tertera di bawah ini untuk Berkerja sebagai Trucker/Hauling\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/mission\n- "WHITE_E"Untuk melihat daftar list beberapa Bisnis,Dealership,Gas Stasion atau pun Pemuatan Crates\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/storeproduct\n- "WHITE_E"Untuk menyetor pesanan bisnis kepada bisnis tersebut yang sedang kehabisan stock\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/storegas\n- "WHITE_E"Untuk merestock Gas Stasion Atau Pom Bensin yang sedang kekosongan/kehabisan Stock\n"); // 0
				//strcat(S3MP4K, String);
				//format(String, sizeof(String), ""YELLOW_E"/storedealership\n- "WHITE_E"Untuk me restock business Dealership\n\n"); // 0
				//strcat(S3MP4K, String);
				//format(String, sizeof(String), ""YELLOW_E"/storeveh\n- "WHITE_E"Sama dengan /storedeslership command ini juga untuk merestock bisnis dealership\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/getcrate\n- "WHITE_E"Untuk mengambil crate di gudang component(miner),fish factory dan di gudang material\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/loadfish\n- "WHITE_E"Untuk menaruh crate fish yang sudah anda ambil dari gudang ke dalam mobil anda\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/loadcompo\n- "WHITE_E"Untuk menaruh crate component yang sudah anda ambil dari gudang ke dalam mobil anda\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/loadmats\n- "WHITE_E"Untuk menaruh crate material yang sudah anda ambil dari gudang ke dalam mobil anda\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/unloadfish\n- "WHITE_E"Untuk mengambil crate fish yang anda simpan di mobil anda, bila anda menyimpannya\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/unloadcompo\n- "WHITE_E"Untuk mengambil crate component yang anda simpan di mobil anda, bila anda menyimpannya\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/unloadmats\n- "WHITE_E"Untuk mengambil crate material yang anda simpan di mobil anda, bila anda menyimpannya\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/sellcrate\n- "WHITE_E"Hal ini untuk anda menjual sebuah crate ke gudang import crates yang ada di beberapa tempat.\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/dropcrate[compo/fish/mats]\n- "WHITE_E"Untuk menaruh sebuah crates, crates anda bisa di ambil dengan player lain, berhati hati lah\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/takecrate[compo/fish/mats]\n- "WHITE_E"Untuk mengambil sebuah crate yang di /dropcrate oleh player lain \n"); // 0
				strcat(S3MP4K, String);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Trucker Job", S3MP4K, "Close", "");
			}
			case 4:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan balaikota dan bisa kalian cari di gps\n\n{7fffd4}Key ALT Untuk Mengakses Job Ini");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Penambang Batu Job", str, "Close", "");
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country arah Angel Pine\n\n{7fffd4}CMDS: /createproduct /sellproduct\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Production Job", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /plant /price /berry (press N) /offer\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Farmer Job", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Market\n\n{7fffd4}CMDS: /startkurir /stopkurir /angkatbox\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Courier Job", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Bandara Los Santos\n\n{7fffd4}CMDS: /startbg\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Baggage Job", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Market Los Santos\n\n{7fffd4}CMDS: /aboutayam\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Pemotong Job", str, "Close", "");
			}
			case 10:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: DrugSmugller Job berada didaerah blackmarket\nAmbil Packet dan jual ke Blackmarket!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /pickuppacket /trackpacket /droppacket \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Smuggler Job", str, "Close", "");
			}
			case 11:
			{
				new String[1500], S3MP4K[10000];
				format(String, sizeof(String), "{B897FF}Welcome To in Merchant Filler Jobs Tutorial Help For Civilianz\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Anda bisa mendapatkan pekerjaan Merchant Filler yang lokasi nya ada dan tertera di GPS\n"); // 1
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Perkerjaan ini sangat menguntungkan dan sangat berguna untuk pengisian stock pedagang\n"); // 1
				strcat(S3MP4K, String);
				//format(String, sizeof(String), ""WHITE_E"Pekerjaan ini di perbolehkan Bebas bila Anda memiliki Licensi Trucker dan anda harus memiliki Kendaraan Trucker & sejenisnya untuk restock\n"); // 1
				//strcat(S3MP4K, String);
				format(String, sizeof(String), ""WHITE_E"Anda dapat mengakses Command yang tertera di bawah ini untuk Berkerja sebagai Merchant Filler\n"); // 1
				strcat(S3MP4K, String);
				//format(String, sizeof(String), ""YELLOW_E"/mfhelp\n- "WHITE_E"Untuk melihat daftar list beberapa tempat yang harus di temui\n"); // 0
				//strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/box sell\n- "WHITE_E"Untuk menyetor pesanan merchant ke pedagang\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/box take\n- "WHITE_E"Untuk mengambil box untuk dimasukkan ke mobil box\n"); // 0
				//strcat(S3MP4K, String);
				//format(String, sizeof(String), ""YELLOW_E"/storedealership\n- "WHITE_E"Untuk me restock business Dealership\n\n"); // 0
				//strcat(S3MP4K, String);
				//format(String, sizeof(String), ""YELLOW_E"/storeveh\n- "WHITE_E"Sama dengan /storedeslership command ini juga untuk merestock bisnis dealership\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/box list\n- "WHITE_E"Untuk melihat list box di kendaraan merchant filler\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/box load\n- "WHITE_E"Untuk menaruh merchant box yang sudah anda ambil dari gudang ke dalam mobil anda\n"); // 0
				strcat(S3MP4K, String);
				format(String, sizeof(String), ""YELLOW_E"/box unload\n- "WHITE_E"Untuk mengambil merchant box yang berada di dalam mobil anda\n"); // 0
				strcat(S3MP4K, String);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Merchant Box Job", S3MP4K, "Close", "");
			}
			case 12:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di balaikota\n\n{7fffd4}Otot Alt Untuk Mengakses Job Ini");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Penambang Minyak", str, "Close", "");
			}
		}
		return 1;
	}			
	if(dialogid == DIALOG_GPS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pCP] > 1 || pData[playerid][pSideJob] > 1)
						return Error(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_GENERAL, DIALOG_STYLE_LIST, "GPS General", "Bank Los Santos\nCity Hall\nPolice Departement\nASGH Hospital\nNews Agency\nCafetaria", "Select", "Back");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PUBLIC, DIALOG_STYLE_LIST, "GPS Public", "Business\nWorkshop\nATM\nGarasi Kota\nDealership\nPembuatan SIM\nInsurance Center\nMechanic\nComponent Shop\nImport Crate Fish\nImport Crate Component\nImport Crate Material\nPenjualan Pertambangan", "Select", "Back");
				}
				case 3:
				{
					//ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS Jobs & Sidejobs", "{15D4ED}JOB: {ffffff}Taxi\n{15D4ED}JOB: {ffffff}Lumber Jack\n{15D4ED}JOB: {ffffff}Trucker\n{15D4ED}JOB: {ffffff}Penambang Batu\n{15D4ED}JOB: {ffffff}Production\n{15D4ED}JOB: {ffffff}Farmer\n{15D4ED}JOB: {ffffff}Baggage Airport\n{15D4ED}JOB: {ffffff}Pemotong Ayam\n{15D4ED}JOB: {ffffff}Merchant Filler\n{15D4ED}JOB: {ffffff}Penambang Minyak\n{D2D2AB}SIDEJOB: {ffffff}Sweeper\n{D2D2AB}SIDEJOB: {ffffff}Bus\n{D2D2AB}SIDEJOB: {ffffff}Forklift\n{D2D2AB}SIDEJOB: {ffffff}Mower\n{D2D2AB}SIDEJOB: {ffffff}Pizza\n{D2D2AB}SIDEJOB: {ffffff}Petani Micin\n{D2D2AB}SIDEJOB: {ffffff}Petani Markisa", "Select", "Back");
					ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS Jobs & Sidejobs", "{A02BFC}MARKET JOB: {ffffff}TEMPAT PENJUALAN SEMUA HASIL KERJA JOBS\n{15D4ED}JOB: {ffffff}Pemerah Susu\n{15D4ED}JOB: {ffffff}Taxi\n{15D4ED}JOB: {ffffff}Lumber Jack\n{15D4ED}JOB: {ffffff}Trucker\n{15D4ED}JOB: {ffffff}Penambang Batu\n{15D4ED}JOB: {ffffff}Production\n{15D4ED}JOB: {ffffff}Farmer\n{15D4ED}JOB: {ffffff}Baggage Airport\n{15D4ED}JOB: {ffffff}Pemotong Ayam\n{15D4ED}JOB: {ffffff}Merchant Filler\n{15D4ED}JOB: {ffffff}Penambang Minyak\n{D2D2AB}SIDEJOB: {ffffff}Sweeper\n{D2D2AB}SIDEJOB: {ffffff}Bus\n{D2D2AB}SIDEJOB: {ffffff}Forklift", "Select", "Back");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PROPERTIES, DIALOG_STYLE_LIST, "GPS My Properties", "My House\nMy Business\nMy Vending Machine\nMy Vehicle", "Select", "Close");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_MISSION, DIALOG_STYLE_LIST, "GPS My Mission", "My Mission (Trucker)\nMy Hauling (Trucker)", "Select", "Back");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_JOB)
	{
		if(response)
		{
			switch(listitem)
			{
				//MARKET
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 896.9470,-1216.8611,16.9766, 0.0,0.0,0.0, 3.5); //MARKET
					Gps(playerid, "Active!");
				}
				//SUSU
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 300.121429,1141.311645,9.137485, 0.0,0.0,0.0, 3.5); //SUSU
					Gps(playerid, "Active!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1772.0220,-1908.7512,13.5536, 0.0,0.0,0.0, 3.5); //Taxi
					Gps(playerid, "Active!");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1448.7006, -1530.6364, 101.7578, 0.0, 0.0, 0.0, 3.5); //Lumber
					Gps(playerid, "Active!");
					
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.38, -1136.52, 1.07, 0.0, 0.0, 0.0, 3.5); //Trucker
					Gps(playerid, "Active!");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, -397.3630, 1263.2987, 7.1776, 0.0, 0.0, 0.0, 3.5); //Miner
					Gps(playerid, "Active!");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, -265.7898,-2157.9124,28.8604, 0.0, 0.0, 0.0, 3.5); //Production
					Gps(playerid, "Active!");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, -382.68, -1438.80, 26.13, 0.0, 0.0, 0.0, 3.5); //Farmer
					Gps(playerid, "Active!");
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2060.2942, -2220.8250, 13.5469, 0.0, 0.0, 0.0, 3.5); //Baggage
					Gps(playerid, "Active!");
					
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid,1, 169.8492,-1491.3409,12.5124, 0.0, 0.0, 0.0, 3.5); //ayam
					Gps(playerid, "Active!");
					
				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1227.8773, 181.8018, 20.3798, 0.0, 0.0, 0.0, 3.5); //merchant
					Gps(playerid, "Active!");
					
				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, 576.9179,1223.8799,11.7113, 0.0, 0.0, 0.0, 3.5); //minyak
					Gps(playerid, "Active!");
					
				}
				case 12:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1296.80, -1870.97, 13.54, 0.0, 0.0, 0.0, 3.5); //Swpper
					Gps(playerid, "Active!");
					
				}
				case 13:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1760.4087,-1866.5735,13.5996, 0.0, 0.0, 0.0, 3.5); //Bus
					Gps(playerid, "Active!");
					
				}
				case 14:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2749.74,-2385.79, 13.64, 0.0, 0.0, 0.0, 3.5); //Forklift
					Gps(playerid, "Active!");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_PROPERTIES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::myhouse(playerid);
				}
				case 1:
				{
					return callcmd::bm(playerid, "");
				}
				case 2:
				{
					return callcmd::myvending(playerid);
				}
				case 3:
				{
					return callcmd::mv(playerid, "");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_MISSION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pMission] == -1) return Error(playerid, "You dont have mission.");
					new bid = pData[playerid][pMission];
					Gps(playerid, "Follow the mission checkpoint to find your bisnis mission location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				}
				case 1:
				{
					if(pData[playerid][pHauling] == -1) return Error(playerid, "You dont have hauling.");
					new id = pData[playerid][pHauling];
					Gps(playerid, "Follow the hauling checkpoint to find your gas station location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ], 0.0, 0.0, 0.0, 3.5);
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_GPS_GENERAL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1464.98, -1011.79, 26.84, 0.0, 0.0, 0.0, 3);//bank
					Gps(playerid, "Active!");
				}
				case 1:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1481.2115, -1769.2195, 18.7929, 0.0, 0.0, 0.0, 3);//city hall
					Gps(playerid, "Active!");
				}
				case 2:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1552.6306, -1675.5353, 16.1953, 0.0, 0.0, 0.0, 3);//sapd
					Gps(playerid, "Active!");
				}
				case 3:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1176.6331, -1325.2738, 14.0309, 0.0, 0.0, 0.0, 3);//asgh
					Gps(playerid, "Active!");
				}
				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 645.6101, -1360.7520, 13.5887, 0.0, 0.0, 0.0, 3);//sanews
					Gps(playerid, "Active!");
				}
				case 5:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 341.5631,-1794.0978,4.8481, 0.0, 0.0, 0.0, 3);//sanews
					Gps(playerid, "Active!");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}		
	if(dialogid == DIALOG_GPS_PUBLIC)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetAnyBusiness() <= 0) return Error(playerid, "Tidak ada Business di kota.");
					new id, count = GetAnyBusiness(), location[4096], lstr[596];
					strcat(location,"No\tName Business\tType Business\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBusinessID(itt);

						new type[128];
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Equipment";
						}
						else if(bData[id][bType] == 5)
						{
							type= "Electronics";
						}
						else
						{
							type= "Unknown";
						}

						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKBUSINESS, DIALOG_STYLE_TABLIST_HEADERS,"Track Business",location,"Track","Cancel");
				}
				case 1:
				{
					if(GetAnyWorkshop() <= 0) return Error(playerid, "Tidak ada Workshop.");
					new id, count = GetAnyWorkshop(), location[4096], lstr[596], lock[64];
					strcat(location,"No\tName(Status)\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnWorkshopID(itt);
						if(wsData[id][wStatus] == 1)
						{
							lock = "{00FF00}Open{ffffff}";
						}
						else
						{
							lock = "{FF0000}Closed{ffffff}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKWS, DIALOG_STYLE_TABLIST_HEADERS,"Track Workshop",location,"Track","Cancel");
				}
				case 2:
				{
					if(GetAnyAtm() <= 0) return Error(playerid, "Tidak ada ATM di kota.");
					new id, count = GetAnyAtm(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAtmID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKATM, DIALOG_STYLE_TABLIST_HEADERS,"Track ATM",location,"Track","Cancel");
				}
				case 3:
				{
				    if(GetAnyPark() <= 0) return ErrorMsg(playerid, "Tidak ada Garasi Kota.");
					new id, count = GetAnyPark(), location[4096], lstr[596];
					strcat(location,"No\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnGarkotID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%0.2fm\n", itt, GetPlayerDistanceFromPoint(playerid, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%0.2fm\n", itt, GetPlayerDistanceFromPoint(playerid, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKPARK, DIALOG_STYLE_TABLIST_HEADERS,"Garasi Kota",location,"Pilih","Batal");
				}
				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 538.8544, -1292.9434, 17.2422, 0.0, 0.0, 0.0, 3);//Dealership
					Gps(playerid, "Active!");
				}
				case 5:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2062.9805, -1899.6351, 13.5538, 0.0, 0.0, 0.0, 3);//DMV
					Gps(playerid, "Active!");
				}
				case 6:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1335.0966, -1266.0402, 13.5469, 0.0, 0.0, 0.0, 3);//Insurance
					Gps(playerid, "Active!");
				}
				case 7:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2279.5249, -2356.6936, 13.5569, 0.0, 0.0, 0.0, 3);//Mechanic
					Gps(playerid, "Active!");
				}
				
				case 8:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 854.5555, -605.2056, 18.4219, 0.0, 0.0, 0.0, 3);//Component Shop
					Gps(playerid, "Active!");
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid,1, -381.44, -1426.13, 25.93, 0.0, 0.0, 0.0, 3.5); //Crate Fish Sell
					SendClientMessage(playerid, ARWIN, "MAP: "WHITE_E"Direction set to "YELLOW_E"Crate Import Fish "WHITE_E"location.");
				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, 797.60, -617.48, 16.00, 0.0, 0.0, 0.0, 3.5); //Crate Component Sell
					SendClientMessage(playerid, ARWIN, "MAP: "WHITE_E"Direction set to "YELLOW_E"Crate Import Component "WHITE_E"location.");
				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, -266.0215, -2213.7021, 29.0420, 0.0, 0.0, 0.0, 3.5); //Crate Material Sell
					SendClientMessage(playerid, ARWIN, "MAP: "WHITE_E"Direction set to "YELLOW_E"Crate Import Material "WHITE_E"location.");
				}
				case 12:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 846.2555, -1293.4869, 13.6528, 0.0, 0.0, 0.0, 3);//pedaganglv
					Gps(playerid, "Active!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
		}
	}
	if(dialogid == DIALOG_TRACKBUSINESS)
	{
		if(response)
		{
			new id = ReturnBusinessID((listitem + 1));

			pData[playerid][pTrackBisnis] = 1;
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Business checkpoint targeted! (%s)", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_TRACKATM)
	{
		if(response)
		{
			new id = ReturnAtmID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Atm checkpoint targeted! (%s)", GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
		}
	}
	if(dialogid == DIALOG_TRACKWS)
	{
		if(response)
		{
			new wid = ReturnWorkshopID((listitem + 1));

			pData[playerid][pLoc] = wid;
			SetPlayerRaceCheckpoint(playerid,1, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ], 0.0, 0.0, 0.0, 3.5);
			Info(playerid, "Workshop Checkpoint targeted! (%s)", GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		}
	}
	if(dialogid == DIALOG_TRACKPARK)
	{
		if(response)
		{
			new id = ReturnAnyPark((listitem + 1));

			pData[playerid][pLoc] = id;
			SetPlayerRaceCheckpoint(playerid,1, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ], 0.0, 0.0, 0.0, 3.5);
			Info(playerid, "Custom Park Checkpoint targeted! (%s)", GetLocation(ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));
		}
	}
	if(dialogid == DIALOG_PAY)
	{
		if(response)
		{
			new mstr[128];
			new otherid = GetPVarInt(playerid, "gcPlayer");
			new money = GetPVarInt(playerid, "gcAmount");

			if(otherid == INVALID_PLAYER_ID)
				return ErrorMsg(playerid, "Player not connected!");
			GivePlayerMoneyEx(otherid, money);
			GivePlayerMoneyEx(playerid, -money);

			format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", ReturnName(otherid), otherid, FormatMoney(money));
			SendClientMessage(playerid, COLOR_GREY, mstr);
			format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", ReturnName(playerid), playerid, FormatMoney(money));
			SendClientMessage(otherid, COLOR_GREY, mstr);
			InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
			InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}%s memberikan uang kepada %s sebesar %s", ReturnName(playerid), ReturnName(otherid), FormatMoney(money));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}%s menerima uang dari %s sebesar %s", ReturnName(otherid), ReturnName(playerid), FormatMoney(money));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[otherid][pName], pData[otherid][pID], money);
			mysql_tquery(g_SQL, query);
		}
		return 1;
	}
	//-------------[ Player Weapons Atth ]-----------
	if(dialogid == DIALOG_EDITBONE)
	{
		if(response)
		{
			new weaponid = EditingWeapon[playerid], weaponname[18], string[150];
	 
			GetWeaponName(weaponid, weaponname, sizeof(weaponname));
		   
			WeaponSettings[playerid][weaponid - 22][Bone] = listitem + 1;

			Servers(playerid, "You have successfully changed the bone of your %s.", weaponname);
		   
			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, Bone) VALUES ('%d', %d, %d) ON DUPLICATE KEY UPDATE Bone = VALUES(Bone)", pData[playerid][pID], weaponid, listitem + 1);
			mysql_tquery(g_SQL, string);
		}
		EditingWeapon[playerid] = 0;
	}
	//------------[ Family Dialog ]------------
	if(dialogid == FAMILY_SAFE)
	{
		if(!response) return 1;
		new fid = pData[playerid][pFamily];
		switch(listitem) 
		{
			case 0: Family_OpenStorage(playerid, fid);
			case 1:
			{
				//Marijuana
				ShowPlayerDialog(playerid, FAMILY_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 2:
			{
				//Component
				ShowPlayerDialog(playerid, FAMILY_COMPONENT, DIALOG_STYLE_LIST, "Component", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 3:
			{
				//Material
				ShowPlayerDialog(playerid, FAMILY_MATERIAL, DIALOG_STYLE_LIST, "Material", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 4:
			{
				//Money
				ShowPlayerDialog(playerid, FAMILY_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_STORAGE)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(listitem == 0) 
			{
				Family_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_WEAPONS)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(fData[fid][fGun][listitem] != 0)
			{
				if(pData[playerid][pFamilyRank] < 5)
					return ErrorMsg(playerid, "Only boss can taken the weapon!");
					
				GivePlayerWeaponEx(playerid, fData[fid][fGun][listitem], fData[fid][fAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(fData[fid][fGun][listitem]));

				fData[fid][fGun][listitem] = 0;
				fData[fid][fAmmo][listitem] = 0;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return ErrorMsg(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return ErrorMsg(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return ErrorMsg(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				fData[fid][fGun][listitem] = weaponid;
				fData[fid][fAmmo][listitem] = ammo;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
		}
		else
		{
			Family_OpenStorage(playerid, fid);
		}
		return 1;
	}
	if(dialogid == FAMILY_MARIJUANA)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw marijuana!");
							
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has withdrawn %d marijuana from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has deposited %d marijuana into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_COMPONENT)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw component!");
							
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fComponent])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has withdrawn %d component from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has deposited %d component into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MATERIAL)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw material!");
							
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMaterial])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has withdrawn %d material from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has deposited %d material into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw money!");
							
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMoney])
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has withdrawn %s money from their family safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "ErrorMsg: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s has deposited %s money into their family safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,marijuana,component,material,money FROM familys WHERE ID = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
						
					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFamily] == pData[playerid][pFamily])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Family Online", lstr, "Close", "");
					
				}
				case 2:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE family = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	//------------[ VIP Locker Dialog ]----------
	if(dialogid == DIALOG_LOCKERVIP)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					SetPlayerHealthEx(playerid, 100);
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 1, 1);
					GivePlayerWeaponEx(playerid, 7, 1);
					GivePlayerWeaponEx(playerid, 15, 1);
				}
				case 2:
				{
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, VIPMaleSkins, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, VIPFemaleSkins, "Choose your skin");
					}
				}
				case 3:
				{
					new string[248];
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

					/*if(pToys[playerid][4][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 5\n");
					}
					else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

					if(pToys[playerid][5][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 6\n");
					}
					else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

					ShowPlayerDialog(playerid, DIALOG_TOYVIP, DIALOG_STYLE_LIST, "{B897FF} Warga Kota {FFFFFF}- VIP Toys", string, "Select", "Cancel");
				}
			}
		}
	}
	//-------------[ Faction Commands Dialog ]-----------
	//-------------[ Faction Commands Dialog ]-----------
	if(dialogid == DIALOG_LOCKERSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDutyMendung] == 1)
					{
						pData[playerid][pOnDutyMendung] = 0;
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s places their badge and gun in their locker.", ReturnName(playerid));
						ResetWeapon(playerid, 25);
						ResetWeapon(playerid, 27);
						ResetWeapon(playerid, 29);
						ResetWeapon(playerid, 31);
						ResetWeapon(playerid, 33);
						ResetWeapon(playerid, 34);
						KillTimer(DutyTimer);
					}
					else
					{
						pData[playerid][pOnDutyMendung] = 1;
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 300);
							pData[playerid][pFacSkin] = 300;
						}
						else
						{
							SetPlayerSkin(playerid, 306);
							pData[playerid][pFacSkin] = 306;
						}
						DutyTimer = SetTimerEx("DutyHour", 1000, true, "i", playerid);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
				    ShowProgressbar(playerid, "Mengambil pelindung tubuh..", 2);
				    ShowItemBox(playerid, "Vest", "Received_1x", 1242, 2);
				    pData[playerid][pVest] += 1;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil pelindung tubuh dari locker", ReturnName(playerid));
				}
				case 2:
				{
				    ShowProgressbar(playerid, "Mengambil pelindung tubuh..", 2);
				    ShowItemBox(playerid, "Vest", "Received_1x", 1242, 2);
				    pData[playerid][pVest] += 1;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil pelindung tubuh dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDutyMendung] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAPD, DIALOG_STYLE_LIST, "SAPD Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nSHOTGUN\nSHOTGSPA\nMP5\nM4\nRIFLE\nSNIPER", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDutyMendung] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
				case 5:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDWar, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 2)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 7:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 25, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(25));
				}
				case 8:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 27, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(27));
				}
				case 9:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
				case 10:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 31, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(31));
				}
				case 11:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 33, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(33));
				}
				case 12:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 34, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(34));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 295);
							pData[playerid][pFacSkin] = 295;
						}
						else
						{
							SetPlayerSkin(playerid, 141);
							pData[playerid][pFacSkin] = 141;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAGS, DIALOG_STYLE_LIST, "SAGS Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nMP5", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAGSMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAGSFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 7:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDutyMendung] == 1)
					{
						pData[playerid][pOnDutyMendung] = 0;
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDutyMendung] = 1;
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 276);
							pData[playerid][pFacSkin] = 276;
						}
						else
						{
							SetPlayerSkin(playerid, 308);
							pData[playerid][pFacSkin] = 308;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_DRUGSSAMD, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Obat Medis", "Perban\nObat Stress", "Pilih", "Batal");
				}
				case 2:
				{
					if(pData[playerid][pOnDutyMendung] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAMDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAMDFemale, "Choose your skin");
					}
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Penyimpanan Medis", "Medicine\nMedkit\nPerban", "Pilih", "Batal");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DRUGSSAMD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pBandage] += 5;
					ShowItemBox(playerid, "Perban", "Received_5x", 11736, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s mengambil 5 perban dari locker.", ReturnName(playerid));
				}
				case 1:
				{
					pData[playerid][pObatStress] += 5;
					ShowItemBox(playerid, "Obat_Stress", "Received_5x", 1241, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s mengambil 5 obat stress dari locker.", ReturnName(playerid));
				}
			}
		}
	}
	if(dialogid == DIALOG_WEAPONSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 42, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(42));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 23, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 24, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1: 
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSANEW, DIALOG_STYLE_LIST, "SAPD Weapons", "CAMERA\nSPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SANEWMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SANEWFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 43, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(43));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
			}
		}
		return 1;
	}
	//--------[ DIALOG JOB ]--------
	if(dialogid == DIALOG_SERVICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return ErrorMsg(playerid, "Component anda kurang!");
						if(comp <= 0) return ErrorMsg(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan ~r~%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return ErrorMsg(playerid, "Component anda kurang!");
						if(comp <= 0) return ErrorMsg(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan ~r~%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Body...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 40) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 3:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 4:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 5:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 6:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 7:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 8:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 9:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 10:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 11:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 12:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 13:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
					ErrorMsg(playerid, "Side blm ada.");
				}
				case 14:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 15:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							InfoMsg(playerid, "Anda memodif kendaraan dengan ~r~150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 16:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							InfoMsg(playerid, "Anda memodif kendaraan dengan ~r~150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 17:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 250) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 250;
							InfoMsg(playerid, "Anda memodif kendaraan dengan ~r~250 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 18:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 375) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 375;
							InfoMsg(playerid, "Anda memodif kendaraan dengan ~r~375 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 19:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 500;
							InfoMsg(playerid, "Anda memodif kendaraan dengan ~r~500 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
				case 20:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "You must in Mechanic Center Area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_COLOR)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
			
			ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_COLOR2)
	{
		if(response)
		{
			pData[playerid][pMechColor2] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor2] < 0 || pData[playerid][pMechColor2] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 40) return ErrorMsg(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 40;
				InfoMsg(playerid, "Anda mengganti warna kendaraan dengan ~r~30 component.");
				pData[playerid][pMechanic] = SetTimerEx("SprayCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Spraying Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_PAINTJOB)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 3)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota {FFFFFF}- Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
			
			if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 100;
				InfoMsg(playerid, "Anda mengganti paintjob kendaraan dengan ~r~50 component.");
				pData[playerid][pMechanic] = SetTimerEx("PaintjobCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Painting Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_WHEELS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = 1025;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 85;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = 1074;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = 1076;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = 1078;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = 1081;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = 1082;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 1085;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					pData[playerid][pMechColor1] = 1096;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					pData[playerid][pMechColor1] = 1097;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 9:
				{
					pData[playerid][pMechColor1] = 1098;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 10:
				{
					pData[playerid][pMechColor1] = 1084;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 11:
				{
					pData[playerid][pMechColor1] = 1073;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 12:
				{
					pData[playerid][pMechColor1] = 1075;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 13:
				{
					pData[playerid][pMechColor1] = 1077;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 14:
				{
					pData[playerid][pMechColor1] = 1079;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 15:
				{
					pData[playerid][pMechColor1] = 1080;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 16:
				{
					pData[playerid][pMechColor1] = 1083;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SPOILER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1147;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1049;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1162;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1058;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1164;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1138;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1146;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1050;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1158;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1060;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1163;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1139;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1001;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1023;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 401 ||
						VehicleModel == 517 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 477 ||
						VehicleModel == 547 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1003;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 547 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1000;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1014;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542)
						{
				
							pData[playerid][pMechColor1] = 1015;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 546 ||
						VehicleModel == 517)
						{
				
							pData[playerid][pMechColor1] = 1002;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_HOODS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1005;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 402 ||
						VehicleModel == 546 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1004;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401)
						{
				
							pData[playerid][pMechColor1] = 1011;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1012;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_VENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 547 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1142;
							pData[playerid][pMechColor2] = 1143;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1144;
							pData[playerid][pMechColor2] = 1145;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_LIGHTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 436 ||
						VehicleModel == 439)
						{
				
							pData[playerid][pMechColor1] = 1013;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 603 ||
						VehicleModel == 400)
						{
				
							pData[playerid][pMechColor1] = 1024;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_EXHAUSTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1034;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1046;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1065;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1064;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1028;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1089;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1037;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1045;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1066;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1059;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1029;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1092;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1044;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1126;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1129;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1104;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1113;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1136;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1043;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1127;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1132;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1105;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1135;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1114;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1020;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 400 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1021;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 436)
						{
							
							pData[playerid][pMechColor1] = 1022;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1019;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 415 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1018;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_FRONT_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1171;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1153;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1160;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1155;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1166;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1169;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1172;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1152;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1173;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1157;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1165;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1170;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1174;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1179;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1189;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1182;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1191;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1115;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1175;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1185;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1188;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1181;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1190;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1116;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_REAR_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1149;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1150;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1159;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1154;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1168;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1141;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1148;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1151;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1161;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1156;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1167;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1140;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1176;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1180;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1187;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1184;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1192;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1109;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1177;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1178;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1186;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1183;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1193;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1110;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_ROOFS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1054;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1067;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1055;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1088;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1032;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1053;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1068;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1061;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1091;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1033;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1130;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1128;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1131;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1103;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1006;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SIDE_SKIRTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1036;
								pData[playerid][pMechColor2] = 1040;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1047;
								pData[playerid][pMechColor2] = 1051;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1069;
								pData[playerid][pMechColor2] = 1071;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1056;
								pData[playerid][pMechColor2] = 1062;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1090;
								pData[playerid][pMechColor2] = 1094;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1026;
								pData[playerid][pMechColor2] = 1027;
							}
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1039;
								pData[playerid][pMechColor2] = 1041;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1048;
								pData[playerid][pMechColor2] = 1052;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1070;
								pData[playerid][pMechColor2] = 1072;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1057;
								pData[playerid][pMechColor2] = 1063;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1093;
								pData[playerid][pMechColor2] = 1095;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1031;
								pData[playerid][pMechColor2] = 1030;
							}
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 567)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1042;
								pData[playerid][pMechColor2] = 1099;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1108;
								pData[playerid][pMechColor2] = 1107;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1134;
								pData[playerid][pMechColor2] = 1137;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1102;
								pData[playerid][pMechColor2] = 1133;
							}
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1102;
							pData[playerid][pMechColor2] = 1101;
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1106;
							pData[playerid][pMechColor2] = 1124;
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1118;
							pData[playerid][pMechColor2] = 1120;
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1119;
							pData[playerid][pMechColor2] = 1121;
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 436 ||
						VehicleModel == 439 ||
						VehicleModel == 580 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
				
							pData[playerid][pMechColor1] = 1007;
							pData[playerid][pMechColor2] = 1017;
							
							pData[playerid][pComponent] -= 90;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_BULLBARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1100;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1123;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1125;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1117;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_NEON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = RED_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = BLUE_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = GREEN_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = YELLOW_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = PINK_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = WHITE_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 0;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						SuccesMsg(playerid, "Anda memodif kendaraan dengan ~r~450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						ErrorMsg(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	//ARMS Dealer
	if(dialogid == DIALOG_ARMS_GUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slc pistol
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 1000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -1300);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $1.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SILENCED, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 1: //colt45 9mm
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 1800) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -1500);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $300!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_COLT45, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 2: //deagle
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 6000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -6000);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $6.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_DEAGLE, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 3: //shotgun
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 8000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -8000);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $4.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SHOTGUN, 50);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 4: //rifle
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 12000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -12000);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $8.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_RIFLE, 35);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 5: //ak-47
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 12000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -12000);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $12.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_AK47, 100);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 6: //Micro smg uzi
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component tidak cukup!(Butuh: 500).");
					if(GetPlayerMoney(playerid) < 10000) return ErrorMsg(playerid, "Not enough money!");
					
					pData[playerid][pMaterial] -= 500;
					pData[playerid][pComponent] -= 500;
					GivePlayerMoneyEx(playerid, -10000);
					
					TogglePlayerControllable(playerid, 0);
					SuccesMsg(playerid, "Anda membuat senjata ilegal dengan 500 material dan 500 component dengan harga $10.000!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_UZI, 200);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PLANT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pSeed] < 5) return ErrorMsg(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return ErrorMsg(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return ErrorMsg(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return ErrorMsg(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 5;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 1;
						PlantData[id][PlantTime] = 1800;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						SuccesMsg(playerid, "Planting Potato.");
					}
					else return ErrorMsg(playerid, "You must in farmer flint area!");
				}
				case 1:
				{
					if(pData[playerid][pSeed] < 18) return ErrorMsg(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return ErrorMsg(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return ErrorMsg(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return ErrorMsg(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 18;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 2;
						PlantData[id][PlantTime] = 3600;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						SuccesMsg(playerid, "Planting Wheat.");
					}
					else return ErrorMsg(playerid, "You must in farmer flint area!");
				}
				case 2:
				{
					if(pData[playerid][pSeed] < 11) return ErrorMsg(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return ErrorMsg(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return ErrorMsg(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return ErrorMsg(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 11;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 3;
						PlantData[id][PlantTime] = 2700;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						SuccesMsg(playerid, "Planting Orange.");
					}
					else return ErrorMsg(playerid, "You must in farmer flint area!");
				}
				case 3:
				{
					if(pData[playerid][pSeed] < 50) return ErrorMsg(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return ErrorMsg(playerid, "You too closes with other plant!");
					
					new id = Iter_Free(Plants);
					if(id == -1) return ErrorMsg(playerid, "Cant plant any more plant!");
					
					if(pData[playerid][pPlantTime] > 0) return ErrorMsg(playerid, "You must wait 10 minutes for plant again!");
					
					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{
					
						pData[playerid][pSeed] -= 50;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);
						
						PlantData[id][PlantType] = 4;
						PlantData[id][PlantTime] = 4500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						SuccesMsg(playerid, "Planting Marijuana.");
					}
					else return ErrorMsg(playerid, "You must in farmer flint area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_HAULING)
	{
		if(response)
		{
			new id = ReturnRestockGStationID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);

			if(IsValidVehicle(pData[playerid][pTrailer]))
			{
				DestroyVehicle(pData[playerid][pTrailer]);
				pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
			}
			
			if(pData[playerid][pHauling] > -1 || pData[playerid][pMission] > -1)
				return ErrorMsg(playerid, "Anda sudah sedang melakukan Mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMsg(playerid, "Anda harus mengendarai truck.");
			if(!IsAHaulTruck(vehicleid)) return ErrorMsg(playerid, "You're not in Hauling Truck ( Attachable Truck )");

			pData[playerid][pHauling] = id;
			
			new line9[900];

			format(line9, sizeof(line9), "Silahkan anda mengambil trailer gas oil di gudang miner!\n\nGas Station ID: %d\nLocation: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke Gas Station tujuan hauling anda!",
				id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			SetPlayerRaceCheckpoint(playerid, 1, 329.82, 859.27, 21.40, 0, 0, 0, 5.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hauling Info", line9, "Close","");
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockBisnisID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(bData[id][bMoney] < 1000)
				return ErrorMsg(playerid, "Maaf, Bisnis ini kehabisan uang product.");
			
			if(pData[playerid][pMission] > -1 || pData[playerid][pHauling] > -1)
				return ErrorMsg(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return ErrorMsg(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			bData[id][bRestock] = 0;
			
			new line9[900];
			new type[128];
			if(bData[id][bType] == 1)
			{
				type = "Fast Food";

			}
			else if(bData[id][bType] == 2)
			{
				type = "Market";
			}
			else if(bData[id][bType] == 3)
			{
				type = "Clothes";
			}
			else if(bData[id][bType] == 4)
			{
				type = "Equipment";
			}
			else
			{
				type = "Unknow";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock product di gudang!\n\nBisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke bisnis mission anda!",
			id, bData[id][bOwner], bData[id][bName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Mission Info", line9, "Close","");
		}
	}
	if(dialogid == DIALOG_PRODUCT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * ProductPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehProduct[vehicleid] + amount;
			if(amount < 0 || amount > 150) return ErrorMsg(playerid, "amount maximal 0 - 150.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Product < amount) return ErrorMsg(playerid, "Product stock tidak mencukupi.");
			if(total > 150) return ErrorMsg(playerid, "Product Maximal 150 in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehProduct[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += amount;
			}
			
			Product -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"product seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_GASOIL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehGasOil[vehicleid] + amount;
			
			if(amount < 0 || amount > 1000) return ErrorMsg(playerid, "amount maximal 0 - 1000.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(GasOil < amount) return ErrorMsg(playerid, "GasOil stock tidak mencukupi.");
			if(total > 1000) return ErrorMsg(playerid, "Gas Oil Maximal 1000 liter in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehGasOil[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cGasOil] += amount;
			}
			
			GasOil -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"liter gas oil seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_MATERIAL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMaterial] + amount;
			new value = amount * MaterialPrice;
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "amount maximal 0 - 500.");
			if(total > 500) return ErrorMsg(playerid, "Material terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Material < amount) return ErrorMsg(playerid, "Material stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMaterial] += amount;
			Material -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"material seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_OBAT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pObat] + amount;
			new value = amount * ObatPrice;
			if(amount < 0 || amount > 5) return ErrorMsg(playerid, "amount maximal 0 - 5.");
			if(total > 5) return ErrorMsg(playerid, "Obat terlalu penuh di Inventory! Maximal 5.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(ObatMyr < amount) return ErrorMsg(playerid, "Obat stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pObat] += amount;
			ObatMyr -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"obat seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_COMPONENT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pComponent] + amount;
			new value = amount * ComponentPrice;
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "amount maximal 0 - 500.");
			if(total > 500) return ErrorMsg(playerid, "Component terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Component < amount) return ErrorMsg(playerid, "Component stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pComponent] += amount;
			Component -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"component seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DRUGS)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMarijuana] + amount;
			new value = amount * MarijuanaPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Marijuana full in your inventory! max: 100 kg.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Marijuana < amount) return ErrorMsg(playerid, "Marijuana stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMarijuana] += amount;
			Marijuana -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Marijuana seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_FOOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//buy food
					if(pData[playerid][pFood] > 500) return ErrorMsg(playerid, "Anda sudah membawa 500 Food!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Food:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Food Price"GREEN_E"%s /item", Food, FormatMoney(FoodPrice));
					ShowPlayerDialog(playerid, DIALOG_FOOD_BUY, DIALOG_STYLE_INPUT, "Buy Food", mstr, "Buy", "Cancel");
				}
				case 1:
				{
					//buy seed
					if(pData[playerid][pSeed] > 100) return ErrorMsg(playerid, "Anda sudah membawa 100 Seed!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Seed:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Seed Price"GREEN_E"%s /item", Food, FormatMoney(SeedPrice));
					ShowPlayerDialog(playerid, DIALOG_SEED_BUY, DIALOG_STYLE_INPUT, "Buy Seed", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_FOOD_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pFood] + amount;
			new value = amount * FoodPrice;
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "amount maximal 0 - 500.");
			if(total > 500) return ErrorMsg(playerid, "Bahan Mentah terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Pedagang < amount) return ErrorMsg(playerid, "stock bahan mentah tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pFood] += amount;
			Pedagang -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Bahan Mentah seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_SEED_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pSeed] + amount;
			new value = amount * SeedPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Seed terlalu penuh di Inventory! Maximal 100.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Food < amount) return ErrorMsg(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSeed] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Seed seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Sprunk(1 - 500):\nPrice 1(Sprunk): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE1, DIALOG_STYLE_INPUT, "Price 1", mstr, "Edit", "Cancel");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Snack(1 - 500):\nPrice 2(Snack): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice2]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE2, DIALOG_STYLE_INPUT, "Price 2", mstr, "Edit", "Cancel");
				}
				case 2:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Ice Cream Orange(1 - 500):\nPrice 3(Ice Cream Orange): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice3]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE3, DIALOG_STYLE_INPUT, "Price 3", mstr, "Edit", "Cancel");
				}
				case 3:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Hotdog(1 - 500):\nPrice 4(Hotdog): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice4]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE4, DIALOG_STYLE_INPUT, "Price 4", mstr, "Edit", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE1)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice1] = amount;
			Info(playerid, "Anda berhasil mengedit price 1(Sprunk) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE2)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice2] = amount;
			Info(playerid, "Anda berhasil mengedit price 2(Snack) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE3)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice3] = amount;
			Info(playerid, "Anda berhasil mengedit price 3(Ice Cream Orange) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE4)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice4] = amount;
			Info(playerid, "Anda berhasil mengedit price 4(Hotdog) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_OFFER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice1])
						return ErrorMsg(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 5)
						return ErrorMsg(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice1]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice1]);
					pData[playerid][pSprunk] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli sprunk seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice1]));
				}
				case 1:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice2])
						return ErrorMsg(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 5)
						return ErrorMsg(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice2]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice2]);
					pData[playerid][pSnack] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice2]));	
				}
				case 2:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice3])
						return ErrorMsg(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 10)
						return ErrorMsg(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice3]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice3]);
					pData[playerid][pEnergy] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli ice cream orange seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice3]));
				}
				case 3:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice4])
						return ErrorMsg(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 10)
						return ErrorMsg(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice4]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice4]);
					pData[playerid][pHunger] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli hotdog seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice4]));
				}
			}
		}
		pData[playerid][pOffer] = -1;
	}
	if(dialogid == DIALOG_APOTEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerMoney(playerid) < MedicinePrice) return ErrorMsg(playerid, "Not enough money.");
					pData[playerid][pMedicine]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedicinePrice);
					Server_AddMoney(MedicinePrice);
					Info(playerid, "Anda membeli medicine seharga "RED_E"%s,"WHITE_E" /use untuk menggunakannya.", FormatMoney(MedicinePrice));
				}
				case 1:
				{
					if(pData[playerid][pFaction] != 3) return ErrorMsg(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < MedkitPrice) return ErrorMsg(playerid, "Not enough money.");
					pData[playerid][pMedkit]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedkitPrice);
					Server_AddMoney(MedkitPrice);
					Info(playerid, "Anda membeli medkit seharga "RED_E"%s", FormatMoney(MedkitPrice));
				}
				case 2:
				{
					pData[playerid][pBandage] += 5;
					ShowItemBox(playerid, "Perban", "Received_5x", 11736, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}* %s mengambil 5 perban dari locker.", ReturnName(playerid));
				}
			}
		}
	}
	if(dialogid == DIALOG_ATM)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 1: // Withdraw
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"My Balance: "LB_E"%s", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_LIST, mstr, "$50\n$200\n$500\n$1.000\n$5.000", "Withdraw", "Cancel");
			}
			case 2: // Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 3: //Paycheck
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_ATMWITHDRAW)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pBankMoney] < 50)
						return ErrorMsg(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 50);
					pData[playerid][pBankMoney] -= 50;
					SuccesMsg(playerid, "ATM withdraw "LG_E"$50");
				}
				case 1:
				{
					if(pData[playerid][pBankMoney] < 200)
						return ErrorMsg(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 200);
					pData[playerid][pBankMoney] -= 200;
					SuccesMsg(playerid, "ATM withdraw "LG_E"$200");
				}
				case 2:
				{
					if(pData[playerid][pBankMoney] < 500)
						return ErrorMsg(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 500);
					pData[playerid][pBankMoney] -= 500;
					SuccesMsg(playerid, "ATM withdraw "LG_E"$500");
				}
				case 3:
				{
					if(pData[playerid][pBankMoney] < 1000)
						return ErrorMsg(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 1000);
					pData[playerid][pBankMoney] -= 1000;
					SuccesMsg(playerid, "ATM withdraw "LG_E"$1.000");
				}
				case 4:
				{
					if(pData[playerid][pBankMoney] < 5000)
						return ErrorMsg(playerid, "Not enough balance!");
					
					GivePlayerMoneyEx(playerid, 5000);
					pData[playerid][pBankMoney] -= 5000;
					SuccesMsg(playerid, "ATM withdraw "LG_E"$5.000");
				}
			}
		}
	}
	if(dialogid == DIALOG_BANK)
	{
		if(!response) return true;
		switch(listitem)
		{
			case 0: // Deposit
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case 1: // Withdraw
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
			case 2: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 3: //Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 4:
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_BANKDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return ErrorMsg(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return ErrorMsg(playerid, "You have entered an invalid amount!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully deposited "LB_E"%s {F6F6F6}into your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF} Warga Kota {FFFFFF}- Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return ErrorMsg(playerid, "You have entered an invalid amount!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully withdrawed "LB_E"%s {F6F6F6}from your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF} Warga Kota {FFFFFF}- Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return ErrorMsg(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_BANKTRANSFER, DIALOG_STYLE_INPUT, "{B897FF} Warga Kota {FFFFFF}- Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}
	if(dialogid == DIALOG_BANKTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_BANKCONFIRM)
	{
		if(response)
		{
			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);
			
			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}
			
			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];
			
			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_BANKSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_BANKSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	if(dialogid == DIALOG_ASKS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, AskData[i][askText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Ask Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Asked: "GREEN_E"%s\n"WHITE_E"Question: "RED_E"%s.", pData[AskData[i][askPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	if(dialogid == DIALOG_REPORTS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, ReportData[i][rText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Report Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Reported: "GREEN_E"%s\n"WHITE_E"Reason: "RED_E"%s.", pData[ReportData[i][rPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	if(dialogid == DIALOG_BUYPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				ErrorMsg(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pMoney] < cost)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly+1.2, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return ErrorMsg(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 544.2508;
			y = -1269.8116;
			z = 17.1995;
			a = 219.4500;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 17.1995, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYVIPPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				ErrorMsg(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new gold = GetVipVehicleCost(GetVehicleModel(vehicleid));
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pGold] < gold)
			{
				ErrorMsg(playerid, "gold anda tidak mencukupi!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return ErrorMsg(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			pData[playerid][pGold] -= gold;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 544.2508;
			y = -1269.8116;
			z = 17.1995;
			a = 219.4500;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 17.1995, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYPVCP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//Bikes
					new str[1024];
					/*format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(468), FormatMoney(GetVehicleCost(468)));*/
					
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)), 
					GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)),
					GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)),
					GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)),
					GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)),
					GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)),
					GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)),
					GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)),
					GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)),
					GetVehicleModelName(468), FormatMoney(GetVehicleCost(468))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Motorcycle", str, "Buy", "Close");
				}
				case 1:
				{
					//Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(400), FormatMoney(GetVehicleCost(400)), 
					GetVehicleModelName(412), FormatMoney(GetVehicleCost(412)),
					GetVehicleModelName(419), FormatMoney(GetVehicleCost(419)),
					GetVehicleModelName(426), FormatMoney(GetVehicleCost(426)),
					GetVehicleModelName(436), FormatMoney(GetVehicleCost(436)),
					GetVehicleModelName(466), FormatMoney(GetVehicleCost(466)),
					GetVehicleModelName(467), FormatMoney(GetVehicleCost(467)),
					GetVehicleModelName(474), FormatMoney(GetVehicleCost(474)),
					GetVehicleModelName(475), FormatMoney(GetVehicleCost(475)),
					GetVehicleModelName(480), FormatMoney(GetVehicleCost(480)),
					GetVehicleModelName(603), FormatMoney(GetVehicleCost(603)),
					GetVehicleModelName(421), FormatMoney(GetVehicleCost(421)),
					GetVehicleModelName(602), FormatMoney(GetVehicleCost(602)),
					GetVehicleModelName(492), FormatMoney(GetVehicleCost(492)),
					GetVehicleModelName(545), FormatMoney(GetVehicleCost(545)),
					GetVehicleModelName(489), FormatMoney(GetVehicleCost(489)),
					GetVehicleModelName(405), FormatMoney(GetVehicleCost(405)),
					GetVehicleModelName(445), FormatMoney(GetVehicleCost(445)),
					GetVehicleModelName(579), FormatMoney(GetVehicleCost(579)),
					GetVehicleModelName(507), FormatMoney(GetVehicleCost(507))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Mobil", str, "Buy", "Close");
				}
				case 2:
				{
					//Unique Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(483), FormatMoney(GetVehicleCost(483)), 
					GetVehicleModelName(534), FormatMoney(GetVehicleCost(534)),
					GetVehicleModelName(535), FormatMoney(GetVehicleCost(535)),
					GetVehicleModelName(536), FormatMoney(GetVehicleCost(536)),
					GetVehicleModelName(558), FormatMoney(GetVehicleCost(558)),
					GetVehicleModelName(559), FormatMoney(GetVehicleCost(559)),
					GetVehicleModelName(560), FormatMoney(GetVehicleCost(560)),
					GetVehicleModelName(561), FormatMoney(GetVehicleCost(561)),
					GetVehicleModelName(562), FormatMoney(GetVehicleCost(562)),
					GetVehicleModelName(565), FormatMoney(GetVehicleCost(565)),
					GetVehicleModelName(567), FormatMoney(GetVehicleCost(567)),
					GetVehicleModelName(575), FormatMoney(GetVehicleCost(575)),
					GetVehicleModelName(576), FormatMoney(GetVehicleCost(576))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Unik", str, "Buy", "Close");
				}
				case 3:
				{
					//Job Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s", 
					GetVehicleModelName(420), FormatMoney(GetVehicleCost(420)), 
					GetVehicleModelName(438), FormatMoney(GetVehicleCost(438)), 
					GetVehicleModelName(403), FormatMoney(GetVehicleCost(403)), 
					GetVehicleModelName(413), FormatMoney(GetVehicleCost(413)),
					GetVehicleModelName(414), FormatMoney(GetVehicleCost(414)),
					GetVehicleModelName(422), FormatMoney(GetVehicleCost(422)),
					GetVehicleModelName(440), FormatMoney(GetVehicleCost(440)),
					GetVehicleModelName(455), FormatMoney(GetVehicleCost(455)),
					GetVehicleModelName(456), FormatMoney(GetVehicleCost(456)),
					GetVehicleModelName(478), FormatMoney(GetVehicleCost(478)),
					GetVehicleModelName(482), FormatMoney(GetVehicleCost(482)),
					GetVehicleModelName(498), FormatMoney(GetVehicleCost(498)),
					GetVehicleModelName(499), FormatMoney(GetVehicleCost(499)),
					GetVehicleModelName(423), FormatMoney(GetVehicleCost(423)),
					GetVehicleModelName(588), FormatMoney(GetVehicleCost(588)),
					GetVehicleModelName(524), FormatMoney(GetVehicleCost(524)),
					GetVehicleModelName(525), FormatMoney(GetVehicleCost(525)),
					GetVehicleModelName(543), FormatMoney(GetVehicleCost(543)),
					GetVehicleModelName(552), FormatMoney(GetVehicleCost(552)),
					GetVehicleModelName(554), FormatMoney(GetVehicleCost(554)),
					GetVehicleModelName(578), FormatMoney(GetVehicleCost(578)),
					GetVehicleModelName(609), FormatMoney(GetVehicleCost(609))
					//GetVehicleModelName(530), FormatMoney(GetVehicleCost(530)) //fortklift
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan Job", str, "Buy", "Close");
				}
				case 4:
				{
					// VIP Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n", 
					GetVehicleModelName(522), GetVipVehicleCost(522), 
					GetVehicleModelName(411), GetVipVehicleCost(411), 
					GetVehicleModelName(451), GetVipVehicleCost(451),
					GetVehicleModelName(415), GetVipVehicleCost(415), 
					GetVehicleModelName(402), GetVipVehicleCost(402), 
					GetVehicleModelName(541), GetVipVehicleCost(541), 
					GetVehicleModelName(429), GetVipVehicleCost(429), 
					GetVehicleModelName(506), GetVipVehicleCost(506), 
					GetVehicleModelName(494), GetVipVehicleCost(494), 
					GetVehicleModelName(502), GetVipVehicleCost(502), 
					GetVehicleModelName(503), GetVipVehicleCost(503), 
					GetVehicleModelName(409), GetVipVehicleCost(409), 
					GetVehicleModelName(477), GetVipVehicleCost(477)
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCARS, DIALOG_STYLE_TABLIST_HEADERS, "{7fff00}Kendaraan VIP", str, "Buy", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 559;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 560;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 562;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 565;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 567;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 575;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 576;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 420;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 438;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 403;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 413;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 414;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 422;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 440;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 455;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 456;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 478;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 482;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 498;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 499;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 423;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 588;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 524;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 525;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 543;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 552;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 554;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 20:
				{
					new modelid = 578;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 21:
				{
					new modelid = 609;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 522;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 411;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 451;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 415;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 541;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 429;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 506;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 494;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 503;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 409;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 477;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < 500)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -500);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 538.1642;
			y = -1275.1239;
			z = 17.2182;
			a = 219.8838;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 544.2508;
			y = -1269.8116;
			z = 17.1995;
			a = 219.4500;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 544.2508;
			y = -1269.8116;
			z = 17.1995;
			a = 219.4500;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	/*if(dialogid == DIALOG_SALARY)
	{
		if(!response) 
		{
			ListPage[playerid]--;
			if(ListPage[playerid] < 0)
			{
				ListPage[playerid] = 0;
				return 1;
			}
		}
		else
		{
			ListPage[playerid]++;
		}
		
		DisplaySalary(playerid);
		return 1;
	}*/
	if(dialogid == DIALOG_PAYCHECK)
	{
		if(response)
		{
			if(pData[playerid][pPaycheck] < 3600) return ErrorMsg(playerid, "Sekarang belum waktunya anda mengambil paycheck.");
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM salary WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();
			if(rows) 
			{
				new list[2000], date[30], info[16], money, totalduty, gajiduty, totalsal, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				for(new i; i < rows; ++i)
				{
					cache_get_value_name(i, "info", info);
					cache_get_value_name(i, "date", date);
					cache_get_value_name_int(i, "money", money);
					totalsal += money;
				}
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty + totalsal;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM salary WHERE owner='%d'", pData[playerid][pID]);
				mysql_query(g_SQL, query);
			}
			else
			{
				new list[2000], totalduty, gajiduty, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
			}
		}
	}
	if(dialogid == DIALOG_SWEEPER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 1;
			SetPlayerCheckpoint(playerid, sweperpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 2;
			SetPlayerCheckpoint(playerid, buspoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_FORKLIFT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			
			pData[playerid][pSideJob] = 3;
			SetPlayerCheckpoint(playerid, forpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_ISIKUOTA)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					new string[512], twitter[64];
					if(pData[playerid][pTwitter] < 1)
					{
						twitter = ""RED_E"Pasang";
					}
					else
					{
						twitter = ""LG_E"Terinstall";
					}
					download[playerid] = 1;
					format(string, sizeof(string),"Aplikasi\tStatus\n{7fffd4}Twitter ( 38mb )\t%s", twitter);
					ShowPlayerDialog(playerid, DIALOG_DOWNLOAD, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF} Warga Kota -{FFFFFF}  App Store",string,"Download","Batal");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), "Kuota\tHarga Pulsa\n{ffffff}Kuota 512MB\t{7fff00}3\n{ffffff}Kuota 1GB\t{7fff00}6\n{ffffff}Kuota 2GB\t{7fff00}12\n");
					ShowPlayerDialog(playerid, DIALOG_KUOTA, DIALOG_STYLE_TABLIST_HEADERS, "Isi Kuota", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_DOWNLOAD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new sisa = pData[playerid][pKuota]/1000;
					if(pData[playerid][pKuota] <= 38000)
						return Error(playerid, "Kuota yang anda miliki tidak mencukup ( Sisa %dmb )", sisa);

					SetTimerEx("DownloadTwitter", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
			}
		}
		else
		{
			Servers(playerid, "Berhasil membatalkan Download Twitter");
		}
	}
	if(dialogid == DIALOG_KUOTA)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pPhoneCredit] < 3)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 512000;
					pData[playerid][pPhoneCredit] -= 3;
					Servers(playerid, "Berhasil membeli Kuota 512mb");
				}
				case 1:
				{
					if(pData[playerid][pPhoneCredit] < 6)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 1000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 1gb");
				}
				case 2:
				{
					if(pData[playerid][pPhoneCredit] < 12)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 2000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 2gb");
				}
			}
		}
	}
	if(dialogid ==  DIALOG_STUCK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut di Gedung", pData[playerid][pName], playerid);
				}
				case 1:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut setelah keluar masuk Interior", pData[playerid][pName], playerid);
				}
				case 2:
				{

					if((Vehicle_Nearest(playerid)) != -1)
					{
						new Float:vX, Float:vY, Float:vZ;
						GetPlayerPos(playerid, vX, vY, vZ);
						SetPlayerPos(playerid, vX, vY, vZ+2);
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Non Visual Bug)", pData[playerid][pName], playerid);
					}
					else
					{
						ErrorMsg(playerid, "Anda tidak berada didekat Kendaraan apapun");
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Visual Bug)", pData[playerid][pName], playerid);
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TDM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerTeam(playerid) == 1)
						return ErrorMsg(playerid, "Anda sudah bergabung ke Tim ini");

					if(RedTeam >= MaxRedTeam)
						return ErrorMsg(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 1);
					SetPlayerPos(playerid, RedX, RedY, RedZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_RED);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					RedTeam += 1;
				}
				case 1:
				{
					if(GetPlayerTeam(playerid) == 2)
						return ErrorMsg(playerid, "Anda sudah bergabung ke Tim ini");

					if(BlueTeam >= MaxBlueTeam)
						return ErrorMsg(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 2);
					SetPlayerPos(playerid, BlueX, BlueY, BlueZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_BLUE);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					BlueTeam += 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_PICKUPVEH)
	{
		if(response)
		{
			new id = ReturnAnyVehiclePark((listitem + 1), pData[playerid][pPark]);

			if(pvData[id][cOwner] != pData[playerid][pID]) return ErrorMsg(playerid, "This is not your Vehicle!");
			pvData[id][cPark] = -1;
			GetPlayerPos(playerid, pvData[id][cPosX], pvData[id][cPosY], pvData[id][cPosZ]);
			GetPlayerFacingAngle(playerid, pvData[id][cPosA]);

			OnPlayerVehicleRespawn(id);
			SetPlayerPos(playerid, pvData[id][cPosX]-2, pvData[id][cPosY], pvData[id][cPosZ]+1);
			//Info(playerid, "You've successfully spawned %s(ID: %d)", GetVehicleModelName(pvData[id][cVeh]), pvData[id][cVeh]);
			PutPlayerInVehicle(playerid, pvData[id][cVeh], 0);
			SetTimerEx("PutPlayerInVehicle", 700, false, "id", playerid, pvData[id][cVeh]);
		}
	}
	if(dialogid == DIALOG_MY_WS)
	{
		if(!response) return true;
		new id = ReturnPlayerWorkshopID(playerid, (listitem + 1));
		SetPlayerRaceCheckpoint(playerid,1, wsData[id][wX], wsData[id][wY], wsData[id][wZ], 0.0, 0.0, 0.0, 3.5);
		SuccesMsg(playerid, "Ikuti checkpoint untuk menemukan Business anda!");
		return 1;
	}
	if(dialogid == WS_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return ErrorMsg(playerid, "Only Workshop Owner who can use this");

					new str[256];
					format(str, sizeof str,"Current Workshop Name:\n%s\n\nInput new name to Change Workshop Name", wsData[id][wName]);
					ShowPlayerDialog(playerid, WS_SETNAME, DIALOG_STYLE_INPUT, "Change Workshop Name", str,"Change","Cancel");
				}
				case 1:
				{
					new str[556];
					format(str, sizeof str,"Name\tRank\n(%s)\tOwner\n",wsData[id][wOwner]);
					for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
					{
						format(str, sizeof str,"%s(%s)\tEmploye\n", str, wsEmploy[id][z]);
					}
					ShowPlayerDialog(playerid, WS_SETEMPLOYE, DIALOG_STYLE_TABLIST_HEADERS, "Employe Menu", str, "Change","Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, WS_COMPONENT, DIALOG_STYLE_LIST, "Workshop Component", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, WS_MATERIAL, DIALOG_STYLE_LIST, "Workshop Material", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, WS_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw\nDeposit", "Select","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_SETNAME)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			if(strlen(inputtext) > 24) 
				return ErrorMsg(playerid, "Maximal 24 Character");

			if(strfind(inputtext, "'", true) != -1)
				return ErrorMsg(playerid, "You can't put ' in Workshop Name");
			
			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully set Workshop Name from {ffff00}%s{ffffff} to {7fffd4}%s", wsData[id][wName], inputtext);
			format(wsData[id][wName], 24, inputtext);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETEMPLOYE)
	{
		if(response)
		{
			new id = pData[playerid][pInWs], str[256];

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 0;
					format(str, sizeof str, "Current Owner:\n%s\n\nInput Player ID/Name to Change Ownership", wsData[id][wOwner]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][0]);
				}
				case 2:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][1]);
				}
				case 3:
				{
					pData[playerid][pMenuType] = 3;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][2]);
				}
			}
			ShowPlayerDialog(playerid, WS_SETEMPLOYEE, DIALOG_STYLE_INPUT, "Employe Menu", str, "Change", "Cancel");
		}
	}
	if(dialogid == WS_SETEMPLOYEE)
	{
		if(response)
		{
			new otherid, id = pData[playerid][pInWs], eid = pData[playerid][pMenuType];
			if(!strcmp(inputtext, "-", true))
			{
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully removed %s from Workshop", wsEmploy[id][(eid - 1)]);
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, "-");
				Workshop_Save(id);
				return 1;
			}

			if(sscanf(inputtext,"u", otherid))
				return ErrorMsg(playerid, "You must put Player ID/Name");

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return ErrorMsg(playerid, "Player itu Disconnect or not near you.");

			if(otherid == playerid)
				return ErrorMsg(playerid, "You can't set to yourself as owner.");

			if(eid == 0)
			{
				new str[128];
				pData[playerid][pTransferWS] = otherid;
				format(str, sizeof str,"Are you sure want to transfer ownership to %s?", ReturnName(otherid));
				ShowPlayerDialog(playerid, WS_SETOWNERCONFIRM, DIALOG_STYLE_MSGBOX, "Transfer Ownership", str,"Confirm","Cancel");
			}
			else if(eid > 0 && eid < 4)
			{
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, pData[otherid][pName]);
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully add %s to Workshop", pData[otherid][pName]);
				SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been hired in Workshop %s by %s", wsData[id][wName], pData[playerid][pName]);
				Workshop_Save(id);
			}
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETOWNERCONFIRM)
	{
		if(!response) 
			pData[playerid][pTransferWS] = INVALID_PLAYER_ID;

		new otherid = pData[playerid][pTransferWS], id = pData[playerid][pInWs];
		if(response)
		{
			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return ErrorMsg(playerid, "Player itu Disconnect or not near you.");

			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully transfered %s Workshop to %s",wsData[id][wName], pData[otherid][pName]);
			SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been transfered to owner in %s Workshop by %s", wsData[id][wName], pData[playerid][pName]);
			format(wsData[id][wOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_COMPONENT)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Withdraw", wsData[id][wComp]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Deposit", wsData[id][wComp]);
				}
			}
			ShowPlayerDialog(playerid, WS_COMPONENT2, DIALOG_STYLE_INPUT, "Component Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_COMPONENT2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(wsData[id][wComp] < amount) return ErrorMsg(playerid, "Not Enough Workshop Component");

				if((pData[playerid][pComponent] + amount) >= 500)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] += amount;
				wsData[id][wComp] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Component from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pComponent] < amount) return ErrorMsg(playerid, "Not Enough Component");

				if((wsData[id][wComp] + amount) >= MAX_WORKSHOP_INT)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] -= amount;
				wsData[id][wComp] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Component to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MATERIAL)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Withdraw", wsData[id][wMat]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Deposit", wsData[id][wMat]);
				}
			}
			ShowPlayerDialog(playerid, WS_MATERIAL2, DIALOG_STYLE_INPUT, "Material Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_MATERIAL2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(wsData[id][wMat] < amount) return ErrorMsg(playerid, "Not Enough Workshop Material");

				if((pData[playerid][pMaterial] + amount) >= 500)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] += amount;
				wsData[id][wMat] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Material from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pMaterial] < amount) return ErrorMsg(playerid, "Not Enough Material");

				if((wsData[id][wMat] + amount) >= MAX_WORKSHOP_INT)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] -= amount;
				wsData[id][wMat] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Material to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MONEY)
	{
		if(response)
		{
			new str[264], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return ErrorMsg(playerid, "Only Workshop Owner who can use this");

					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Withdraw", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Workshop Money",str,"Withdraw","Cancel");
				}
				case 1:
				{
					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Deposit", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Workshop Money",str,"Deposit","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_WITHDRAWMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];

			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(wsData[id][wMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Workshop Money");

			GivePlayerMoneyEx(playerid, amount);
			wsData[id][wMoney] -= amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == WS_DEPOSITMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			
			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(pData[playerid][pMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Money");

			GivePlayerMoneyEx(playerid, -amount);
			wsData[id][wMoney] += amount;
			Workshop_Save(id);
		}
	}
	//new inv
	if(dialogid == DIALOG_AMOUNT)
	{
		if (response)
		{
			new str[125];

			pData[playerid][pGiveAmount] = strval(inputtext);
			format(str, sizeof(str), "%d", strval(inputtext));
			PlayerTextDrawSetString(playerid, MAIN[playerid][15], str);
		}
	}
	/*if(dialogid == DIALOG_VOICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
						PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
						PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "BERBISIK");
						PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_YELLOW);
						PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
	                    if ((lstream[playerid] = SvCreateDLStreamAtPlayer(5.0, SV_INFINITY, playerid, 0xff0000ff, "Berbisik")))
		             	SuccesMsg(playerid, "Voice Anda Sekarang Berbisik.");
					}
				}
				case 1:
				{
	                if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
						PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
						PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "NORMAL");
						PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_GREEN);
						PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
		             	if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Normal")))
		                SuccesMsg(playerid, "Voice Anda Sekarang Normal.");
					}
				}
				case 2:
				{
	  	            if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
						PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
						PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "TERIAK");
						PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_RED);
						PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
		             	if ((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Teriak")))
	  	            	SuccesMsg(playerid, "Voice Anda Sekarang Teriak.");
					}
				}
			}
		}
		return 1;
	}*/
	if(dialogid == DIALOG_ANIM)
    {
        if(response)
        {
            switch (listitem)
            {
                case 0:
                {
                	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
				   	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				   	return 1;
                }
                case 1:
                {
                	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
   					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
   					return 1;
                }
                case 2:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 3:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 4:
                {
                   	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 5:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
				case 6:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SITTING);
  					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
  					return 1;
                }
                case 7:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
				 	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 8:
                {
                   	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DUCK );
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 9:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_ENTER_VEHICLE);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 10:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_EXIT_VEHICLE);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
				case 11:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
  					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
  					return 1;
                }
                case 12:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 13:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
  					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
  					return 1;
                }
                case 14:
                {
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
				case 15:
                {
                   	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
				  	SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
				  	return 1;
                }
                case 16:
                {
                    ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 17:
                {
                    ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 18:
                {
                    ApplyAnimation(playerid, "Attractors", "Stepsit_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 19:
                {
                   	ApplyAnimation(playerid, "Attractors", "Stepsit_out", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 20:
                {
                    ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 21:
                {
                   	ApplyAnimation(playerid, "BAR", "Barcustom_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 22:
                {
                   	ApplyAnimation(playerid, "BAR", "BBarcustom_order", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 23:
                {
                    ApplyAnimation(playerid, "BAR", "BARman_idle", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 24:
                {
                    ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 25:
                {
                    ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 26:
                {
                    ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 27:
                {
                   	ApplyAnimation(playerid, "BAR", " Barserve_in", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
                }
                case 28:
                {
					ApplyAnimation(playerid, "BAR", "Barserve_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 29:
                {
					ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 30:
                {
                   	ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 31:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 32:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 33:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 34:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_Block", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 35:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_Hit_1", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 36:
               	{
					ApplyAnimation(playerid, "BASEBALL", "Bat_Hit_2", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 37:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_Hit_3", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 38:
               	{
					ApplyAnimation(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 39:
                {
					ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 40:
                {
					ApplyAnimation(playerid, "BASEBALL", "BAT_PART", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 41:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 42:
               {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Fire2", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 43:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Fire3", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 44:
                {
                  	ApplyAnimation(playerid, "BD_FIRE", "BD_GF_Wave", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 45:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 46:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_02", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 47:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_03", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 48:
               	{
					ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_04", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 49:
                {
					ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_Loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 50:
               	{
					ApplyAnimation(playerid, "BD_FIRE", "Grlfrd_Kiss_03", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 51:
                {
					ApplyAnimation(playerid, "BD_FIRE", "Playa_Kiss_03", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 52:
                {
					ApplyAnimation(playerid, "BEACH", "bather", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 53:
               	{
					ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 54:
                {
					ApplyAnimation(playerid, "BEACHE", "ParkSit_M_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 55:
                {
					ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 56:
                {
					ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 57:
              	{
					ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 58:
                {
					ApplyAnimation(playerid, "benchpress", "gym_bp_down", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 59:
                {
					ApplyAnimation(playerid, "benchpress", "gym_bp_geton", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 60:
                {
					ApplyAnimation(playerid, "benchpress", "gym_bp_up_A", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 61:
                {
					ApplyAnimation(playerid, "benchpress", "gym_bp_up_B", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 62:
                {
					ApplyAnimation(playerid, "benchpress", "ym_bp_up_smooth", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 63:
                {
					ApplyAnimation(playerid, "BF_injection", "BF_getin_LHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 64:
                {
					ApplyAnimation(playerid, "BF_injection", "BF_getin_RHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 65:
                {
					ApplyAnimation(playerid, "BF_injection", "BF_getout_RHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 66:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_Back", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 67:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_drivebyFT", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 68:
              	{
					ApplyAnimation(playerid, "BIKED", "BIKEd_drivebyLHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 69:
               	{
					ApplyAnimation(playerid, "BIKED", "BIKEd_drivebyRHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 70:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_Fwd", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 71:
                {
					ApplyAnimation(playerid, "BIKED", "getoffBACK", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 72:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_getoffLHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 73:
               	{
					ApplyAnimation(playerid, "BIKED", "BIKEd_getoffRHS", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 74:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_hit", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 75:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_jumponL", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 76:
               	{
					ApplyAnimation(playerid, "BIKED", "BIKEd_jumponR", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 77:
                {
					ApplyAnimation(playerid, "BIKED", "BIKEd_kick", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 78:
               	{
					ApplyAnimation(playerid, "BIKED", "BIKEd_Left", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 79:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 80:
               	{
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 81:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 82:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 83:
               	{
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 84:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_END_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 85:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
				case 86:
               	{
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 87:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 88:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 89:
                {
					ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
                case 90:
                {
					ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.1, 1, 1, 1, 1, 1, 1);
					SendClientMessage(playerid, -1, "{FF0000}< ! >: {B897FF}/astop {FFFFFF}For Stop The Animation");
					return 1;
				}
            }
        }
        return 1;
    }
 	if(dialogid == DIALOG_GIVE)
	{
		if(response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = pData[playerid][pSelectItem];
			new value = pData[playerid][pGiveAmount];

			CallLocalFunction("OnPlayerGiveInvItem", "ddds[128]d", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	if(dialogid == DIALOG_TAKE)
	{
		if(response)
		{
			//#define MAX_DROPPED_ITEMS 100
  			new id = GetPlayerListitemValue(playerid, listitem);

			CallLocalFunction("TakePlayerItem", "dds[128]", playerid, id, DroppedItems[id][droppedItem]);
		}
	}
	//atm
	//atm
	if(dialogid == DIALOG_FTRANSFER)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return ErrorMsg(playerid, "You have entered an invalid amount!");
		else
		{
			pData[playerid][pTransfer] = amount;
			UpdateATM(playerid);
			ShowPlayerDialog(playerid, DIALOG_FTRANSFER, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Fleeca Bank", "Mohon masukkan nomor rekening yang ingin anda transfer:", "Submit", "Batal");
		}
	}	
	if(dialogid == DIALOG_FDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang segitu.");
		if(amount < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");
		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "Berhasil masukkan %s", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
			UpdateATM(playerid);
		}
	}
	if(dialogid == DIALOG_FWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak itu di bank.");
		if(amount < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "Berhasil mengambil uang $%s", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
			UpdateATM(playerid);
		}	
	}
	//hp
	if(dialogid == DIALOG_AIRDROP)
	{
		if (response)
		{
			static string[128];
			new targetp2 = GetPlayerListitemValue(playerid, listitem), gstr[1025];
			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[targetp2][i][contactExists])
				{
					ContactData[targetp2][i][contactExists] = true;
					ContactData[targetp2][i][contactNumber] = pData[playerid][pPhone];

					format(ContactData[targetp2][i][contactName], 32, pData[playerid][pName]);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[targetp2][pID], pData[playerid][pName], pData[playerid][pPhone]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", targetp2, i);

					new meme[500];
					format(meme,sizeof(meme),"Anda Menerima Kontak Baru");
					SuccesMsg(targetp2, meme);

					return 1;
				}
			}
			new strong[128];
			mysql_format(g_SQL, strong, sizeof(strong), "SELECT * FROM `contacts` WHERE `ID` = '%d'", pData[targetp2][pID]);
			mysql_tquery(g_SQL, strong, "LoadContact", "d", targetp2);

			format(gstr,sizeof(gstr),"Anda menerima permintaan penyimpanan kontak dari:\nNama: %s\nNomor HP: %d\nApakah Anda yakin ingin menyimpan kontak tersebut?", pData[playerid][pName], pData[playerid][pPhone]);
			ShowPlayerDialog(targetp2, DIALOG_AIRDROP1, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Airdrop", gstr, "Save","");
			return 1;
		}
	}
	if(dialogid == DIALOG_PHONE_DIALUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::callanyar(playerid, string);
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_IKLANHP)//iklanhp
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
			{

				if(pData[playerid][pMoney] < 1000)
					return ErrorMsg(playerid, "You need at least $1000!");

				if(Advert_Count() >= 20)
					return ErrorMsg(playerid, "The server has reached limit of ads list, comeback later.");

				if(strlen(inputtext) > 82)
					return ErrorMsg(playerid, "Text cannot more than 82 characters.");

				GivePlayerMoneyEx(playerid, -1000);

				SendClientMessage(playerid, COLOR_SERVER, "VIP: {FFFFFF}Because you're a VIP Player, you able to create ads everywhere.");
				foreach(new  i: Player)
				{
					if(!pData[i][pTogAds])
					{
						SendClientMessageEx(i, COLOR_GREEN, "ADS: %s", inputtext);
						SendClientMessageEx(i, COLOR_GREEN, "Phone: {FF0000}%d {33CC33}| Name: {FF0000}%s", pData[playerid][pPhone], GetName(playerid));
					}
				}
			}
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == DIALOG_IBANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"I-Bank", str, "Close", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"I-Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
				}
				case 2:
				{
					DisplayPaycheck(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_CALLGOCAR)//callgocar
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				SuccesMsg(playerid, "Please wait for Go Car respon!");
				//SendFactionMessage(5, COLOR_PINK2, "[GOCAR CALL] "WHITE_E"%s calling the san andreas go car! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
				SendFactionMessage(5, COLOR_BLUE, "[GOCAR CALL] "WHITE_E"%s calling the go car! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
				SendFactionMessage(5, COLOR_BLUE, "[Pesan Singkat] "WHITE_E"%s", inputtext);
				pData[playerid][pCallTime] = gettime() + 60;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MUSICHP)
    {
    	if(!response)
     	{
			StopStream(playerid);
			StopAudioStreamForPlayer(playerid);
            SendClientMessage(playerid, COLOR_WHITE, " Kamu Membatalkan Music");
        	return 1;
        }
		switch(listitem)
  		{
			case 1:
			{
			    ShowPlayerDialog(playerid,DIALOG_MUSICHP2,DIALOG_STYLE_INPUT, "Link Music", "Please put a Music URL to play the Music", "Play", "Cancel");
			}
			case 2:
			{
			    new string[128], pNames[MAX_PLAYER_NAME];
			    GetPlayerName(playerid, pNames, MAX_PLAYER_NAME);
				format(string, sizeof(string), "* %s Mematikan musiknyanya", pNames);
				SendNearbyMessage(playerid, 15, COLOR_PURPLE, string);
			    foreach(new i : Player)
				{
			        StopStream(i);
				}
				SendClientMessage(playerid, COLOR_WHITE, "Kamu Telah Mematikan musiknya");
			}
        }
		return 1;
	}
	if(dialogid == DIALOG_PANELPHONE)
	{
		if (response)
		{
            switch (listitem)
			{
				case 0:
				{
				    new gstr[256];
				    format(gstr,sizeof(gstr),"{C6E2FF}iPhone 14 PRO milik %s\nNomor telepon: %d\nNama model: iPhone 14 PRO\nNomor serial: AS6R8127V1JKW\nIMEI (slot 1): 2374236342\nIMEI (slot 2): 8734563737", pData[playerid][pName], pData[playerid][pPhone]);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - TentangPonsel", gstr, "Tutup","");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Settings", "Nyalakan Handphone\nMatikan Handphone", "Select", "Back");
				}
			}
		}
	}
	//ini asli
	if(dialogid == DIALOG_VOICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pVoiceStatus] = 0;
					PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
					PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "BERBISIK");
					PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_YELLOW);
					PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
					if ((lstream[playerid] = SvCreateDLStreamAtPlayer(5.0, SV_INFINITY, playerid, 0xff0000ff, "Berbisik")))
					SuccesMsg(playerid, "Voice Anda Sekarang Berbisik.");
				}
				case 1:
				{
					pData[playerid][pVoiceStatus] = 1;
					PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
					PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "NORMAL");
					PlayerTextDrawColor(playerid, VoiceTD[playerid][1], 16711935);
					PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
					if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Normal")))
					SuccesMsg(playerid, "Voice Anda Sekarang Normal.");
				}
				case 2:
				{
					pData[playerid][pVoiceStatus] = 2;
					PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
					PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "TERIAK");
					PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_RED);
					PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
					if ((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Teriak")))
					SuccesMsg(playerid, "Voice Anda Sekarang Teriak.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOGGLEPHONE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pPhoneStatus] = 1;
					Servers(playerid, "Berhasil menyalakan Handphone");
					return 0;
				}
				case 1:
				{
					pData[playerid][pPhoneStatus] = 0;
					Servers(playerid, "Berhasil mematikan Handphone");
					return 0;
				}
			}
		}
	}
	//New Phone System
	if(dialogid == DIALOG_PHONE_CONTACT)
	{
		if (response)
		{
		    if (!listitem) 
			{
		        ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - New Contact", "Silakan masukkan nama kontak di bawah ini:", "Submit", "Back");
		    }
		    else 
			{
		    	pData[playerid][pContact] = ListedContacts[playerid][listitem - 1];
		        ShowPlayerDialog(playerid, DIALOG_PHONE_INFOCONTACT, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Contact Info", "Call Contact\nDelete Contact", "Select", "Back");
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		for (new i = 0; i != MAX_CONTACTS; i ++) 
		{
		    ListedContacts[playerid][i] = -1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_ADDCONTACT)
	{
		if (response)
		{
		    static
		        name[32],
		        str[128],
				string[128];

			strunpack(name, pData[playerid][pEditingItem]);
			format(str, sizeof(str), "Contact Name: %s\n\nSilakan masukkan nomor telepon untuk kontak ini:", name);
		    if (isnull(inputtext) || !IsNumeric(inputtext))
		    	return ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Contact Number", str, "Submit", "Back");

			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[playerid][i][contactExists])
				{
	            	ContactData[playerid][i][contactExists] = true;
	            	ContactData[playerid][i][contactNumber] = strval(inputtext);

					format(ContactData[playerid][i][contactName], 32, name);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[playerid][pID], name, ContactData[playerid][i][contactNumber]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);
					Info(playerid, "You have added \"%s\" to your contacts.", name);
	                return 1;
				}
		    }
		    ErrorMsg(playerid, "There is no room left for anymore contacts.");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_NEWCONTACT)
	{
		if (response)
		{
			new str[128];

		    if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - New Contact", "ErrorMsg: Silakan masukkan nama kontak.\n\nSilakan masukkan nama kontak di bawah ini:", "Submit", "Back");

		    if (strlen(inputtext) > 32)
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - New Contact", "ErrorMsg: Nama kontak tidak boleh melebihi 32 karakter.\n\nSilakan masukkan nama kontak di bawah ini:", "Submit", "Back");

			strpack(pData[playerid][pEditingItem], inputtext, 32);
			format(str, sizeof(str), "Contact Name: %s\n\nSilakan masukkan nomor telepon untuk kontak ini:", inputtext);
		    ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "Contact Number", str, "Submit", "Back");
		}
		else 
		{
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_INFOCONTACT)
	{
		if (response)
		{
		    new
				id = pData[playerid][pContact],
				string[72];

			switch (listitem)
			{
			    case 0:
			    {
			    	format(string, 16, "%d", ContactData[playerid][id][contactNumber]);
			    	callcmd::callanyar(playerid, string);
			    }
			    case 1:
			    {
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", pData[playerid][pID], ContactData[playerid][id][contactID]);
			        mysql_tquery(g_SQL, string);

			        Info(playerid, "You have deleted \"%s\" from your contacts.", ContactData[playerid][id][contactName]);

			        ContactData[playerid][id][contactExists] = false;
			        ContactData[playerid][id][contactNumber] = 0;
			        ContactData[playerid][id][contactID] = 0;

			        ShowContacts(playerid);
			    }
			}
		}
		else {
		    ShowContacts(playerid);
		}
		return 1;
	}
	//tambahan
	if(dialogid == DIALOG_AIRDROP1)
	{
		if (response)
		{
			new meme[500];
			format(meme,sizeof(meme),"Kontak berhasil tersave");
			SuccesMsg(playerid, meme);
		}
	}
	if(dialogid == DIALOG_AIRDROP2)
	{
		if (response)
		{
		    static
		        name[32],
		        str[128],
				string[128];

			strunpack(name, pData[playerid][pEditingItem]);
			format(str, sizeof(str), "Nama Kontak: %s\n\nMohon masukan nomor telepon kontak tersebut:", name);
		    if (isnull(inputtext) || !IsNumeric(inputtext))
		    	return ShowPlayerDialog(playerid, DIALOG_AIRDROP3, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Airdrop", str, "Input", "Kembali");

			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[playerid][i][contactExists])
				{
	            	ContactData[playerid][i][contactExists] = true;
	            	ContactData[playerid][i][contactNumber] = strval(inputtext);

					format(ContactData[playerid][i][contactName], 32, name);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[playerid][pID], name, ContactData[playerid][i][contactNumber]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);
					
					new meme[500];
					format(meme,sizeof(meme),"Berhasil Menambahkan %s Kedalam Kontak", name);
					SuccesMsg(playerid, meme);
	                return 1;
				}
		    }
		    ErrorMsg(playerid, "Kontak Kamu Telah Penuh.");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_AIRDROP3)
	{
		if (response)
		{
			new str[128];

		    if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_AIRDROP3, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Airdrop", "ErrorMsg: Please enter a contact name.\n\nPlease enter the name of the contact below:", "Submit", "Kembali");

		    if (strlen(inputtext) > 32)
		        return ShowPlayerDialog(playerid, DIALOG_AIRDROP3, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Airdrop", "ErrorMsg: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:", "Submit", "Kembali");

			strpack(pData[playerid][pEditingItem], inputtext, 32);
			format(str, sizeof(str), "Nama Kontak: %s\n\nMohon masukan nomor kontak yang akan disimpan:", inputtext);
		    ShowPlayerDialog(playerid, DIALOG_AIRDROP2, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Airdrop", str, "Input", "Kembali");
		}
		else 
		{
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_MUSICHP2)//SET URL
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
		    {
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				foreach(new ii : Player)
				{
					if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
					{
						PlayAudioStreamForPlayer(ii, inputtext, x, y, z, 35.0, 1);
						SendNearbyMessage(playerid, 35.0, COLOR_PURPLE, "* %s sedang memutar musik di ponselnya", ReturnName(playerid));

					}
				}
			}
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == DIALOG_PHONE_SENDSMS)
	{
		if(pData[playerid][pPhoneCredit] <= 0) 
			return ErrorMsg(playerid, "Anda tidak memiliki Ponsel credits!");

		if(GetSignalNearest(playerid) == 0)
			return ErrorMsg(playerid, "Ponsel anda tidak mendapatkan sinyal di wilayah ini.");

		if (response)
		{
		    new ph = strval(inputtext);

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");

		    foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
		        	if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
		            	return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "ErrorMsg: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:", "Dial", "Back");

		            ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Text Message", "Please enter the message to send", "Send", "Back");
		        	pData[playerid][pContact] = ph;
		        }
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_TEXTSMS)
	{
		if (response)
		{
			if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Text Message", "ErrorMsg: Please enter a message to send.", "Send", "Back");

			new targetid = pData[playerid][pContact];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == targetid)
				{
					if(GetSignalNearest(ii) == 0)
						return ErrorMsg(playerid, "Ponsel tersebut sedang mengalami gangguan sinyal.");

					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", targetid, inputtext);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], inputtext);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
				}
			}
		}
		else {
	        ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Send Text Message", "Please enter the number that you wish to send a text message to:", "Submit", "Back");
		}
		return 1;
	}
	//hp
	if(dialogid == DIALOG_AIRDROP)
	{
		if (response)
		{
			static string[128];
			new targetp2 = GetPlayerListitemValue(playerid, listitem), gstr[1025];
			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[targetp2][i][contactExists])
				{
					ContactData[targetp2][i][contactExists] = true;
					ContactData[targetp2][i][contactNumber] = pData[playerid][pPhone];

					format(ContactData[targetp2][i][contactName], 32, pData[playerid][pName]);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[targetp2][pID], pData[playerid][pName], pData[playerid][pPhone]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", targetp2, i);

					new meme[500];
					format(meme,sizeof(meme),"Anda Menerima Kontak Baru");
					SuccesMsg(targetp2, meme);

					return 1;
				}
			}
			new strong[128];
			mysql_format(g_SQL, strong, sizeof(strong), "SELECT * FROM `contacts` WHERE `ID` = '%d'", pData[targetp2][pID]);
			mysql_tquery(g_SQL, strong, "LoadContact", "d", targetp2);

			format(gstr,sizeof(gstr),"Anda menerima permintaan penyimpanan kontak dari:\nNama: %s\nNomor HP: %d\nApakah Anda yakin ingin menyimpan kontak tersebut?", pData[playerid][pName], pData[playerid][pPhone]);
			ShowPlayerDialog(targetp2, DIALOG_AIRDROP1, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Airdrop", gstr, "Save","");
			return 1;
		}
	}
	if(dialogid == DIALOG_PHONE_DIALUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::callanyar(playerid, string);
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_IKLANHP)//iklanhp
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
			{

				if(pData[playerid][pMoney] < 1000)
					return ErrorMsg(playerid, "You need at least $1000!");

				if(Advert_Count() >= 20)
					return ErrorMsg(playerid, "The server has reached limit of ads list, comeback later.");

				if(strlen(inputtext) > 82)
					return ErrorMsg(playerid, "Text cannot more than 82 characters.");

				GivePlayerMoneyEx(playerid, -1000);

				SendClientMessage(playerid, COLOR_SERVER, "VIP: {FFFFFF}Because you're a VIP Player, you able to create ads everywhere.");
				foreach(new  i: Player)
				{
					if(!pData[i][pTogAds])
					{
						SendClientMessageEx(i, COLOR_GREEN, "ADS: %s", inputtext);
						SendClientMessageEx(i, COLOR_GREEN, "Phone: {FF0000}%d {33CC33}| Name: {FF0000}%s", pData[playerid][pPhone], GetName(playerid));
					}
				}
			}
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == DIALOG_IBANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{B897FF}Warga Kota{FFFFFF} - Bank", str, "Close", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
				}
				case 2:
				{
					DisplayPaycheck(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_CALLGOCAR)//callgocar
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				SuccesMsg(playerid, "Please wait for Go Car respon!");
				//SendFactionMessage(5, COLOR_PINK2, "[GOCAR CALL] "WHITE_E"%s calling the san andreas go car! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
				SendFactionMessage(5, COLOR_BLUE, "[GOCAR CALL] "WHITE_E"%s calling the go car! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
				SendFactionMessage(5, COLOR_BLUE, "[Pesan Singkat] "WHITE_E"%s", inputtext);
				pData[playerid][pCallTime] = gettime() + 60;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MUSICHP)
    {
    	if(!response)
     	{
			StopStream(playerid);
			StopAudioStreamForPlayer(playerid);
            SendClientMessage(playerid, COLOR_WHITE, " Kamu Membatalkan Music");
        	return 1;
        }
		switch(listitem)
  		{
			case 1:
			{
			    ShowPlayerDialog(playerid,DIALOG_MUSICHP2,DIALOG_STYLE_INPUT, "{B897FF}Warga Kota{FFFFFF} - Link Music", "Please put a Music URL to play the Music", "Play", "Cancel");
			}
			case 2:
			{
			    new string[128], pNames[MAX_PLAYER_NAME];
			    GetPlayerName(playerid, pNames, MAX_PLAYER_NAME);
				format(string, sizeof(string), "* %s Mematikan musiknyanya", pNames);
				SendNearbyMessage(playerid, 15, COLOR_PURPLE, string);
			    foreach(new i : Player)
				{
			        StopStream(i);
				}
				SendClientMessage(playerid, COLOR_WHITE, "Kamu Telah Mematikan musiknya");
			}
        }
		return 1;
	}
	if(dialogid == DIALOG_TWITTER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						Error(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{

						//for(new i = 0; i < 92; i++) {
						//	TextDrawHideForPlayer(playerid, Text_Global[i]);
						//}
						new str[200];
						format(str, sizeof (str), "Name Twitter: %s\nApa yang ingin kamu post?", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERPOST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Post", "Back");
					}
				}
				case 1:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						Error(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{
						new str[200];
						format(str, sizeof (str), "Current Name: %s\nIsi kotak di bawah ini untuk menganti nama Twittermu.", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERNAME, DIALOG_STYLE_INPUT, "Twitter Post", str, "Change", "Back");
					}
				}
				case 2:
				{
					if(pData[playerid][pTwitterStatus] == 1)
					{
						pData[playerid][pTwitterStatus] = 0;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
					else
					{
						pData[playerid][pTwitterStatus] = 1;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TWITTERPOST)
	{
		if(response)
		{
			if(GetSignalNearest(playerid) == 0)
				return Error(playerid, "Perangkat anda tidak mendapatkan sinyal di wilayah ini.");
			if(pData[playerid][pTwitterPostCooldown] > 0)
			{
				Error(playerid, "Twitter masih cooldown %d detik", pData[playerid][pTwitterPostCooldown]);

				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}
			else
			{
				// Decide about multi-line msgs
				strcpy(tweet, inputtext);
				new i = -1;
				new line[512];

				if(strlen(tweet) > 70)
				{
					i = strfind(tweet, " ", false, 60);
					if(i > 80 || i == -1) i = 70;

					// store the second line text
					line = " ";
					strcat(line, tweet[i]);

					// delete the rest from msg
					tweet[i] = EOS;
				}

				new str[560];
				format(str,1000,"%s", pData[playerid][pTwittername]);
				TextDrawSetString(PublicTD[15], str);
				new stro[560];
				format(stro,1000,"[POST] %s", tweet);
				TextDrawSetString(PublicTD[17], stro);
				TextDrawShowForAll(PublicTD[0]);
				TextDrawShowForAll(PublicTD[1]);
				TextDrawShowForAll(PublicTD[2]);
				TextDrawShowForAll(PublicTD[3]);
				TextDrawShowForAll(PublicTD[4]);
				TextDrawShowForAll(PublicTD[5]);
				TextDrawShowForAll(PublicTD[6]);
				TextDrawShowForAll(PublicTD[7]);
				TextDrawShowForAll(PublicTD[8]);
				TextDrawShowForAll(PublicTD[9]);
				TextDrawShowForAll(PublicTD[10]);
				TextDrawShowForAll(PublicTD[11]);
				TextDrawShowForAll(PublicTD[12]);
				TextDrawShowForAll(PublicTD[13]);
				TextDrawShowForAll(PublicTD[14]);
				TextDrawShowForAll(PublicTD[15]);
				TextDrawShowForAll(PublicTD[16]);
				TextDrawShowForAll(PublicTD[17]);
				//PlayerTextDrawHideForAll(playerid, VoiceTD[playerid][0]);
				//PlayerTextDrawHideForAll(playerid, VoiceTD[playerid][1]);
				pData[playerid][pTwitterPostCooldown] = 60;
				SetTimerEx("TextDrawHide", 10000, false, "d");
				/*foreach(new ii : Player)
				{
					if(pData[ii][pTwitterStatus] == 0)
					{
						for(new i = 0; i <18; i++)
						{
							static szString[2777];
							format(szString, sizeof(szString), "[POST] %s", tweet);
							TextDrawShowForAll(PublicTD[i]);
							TextDrawSetString(PublicTD[17], szString);
							TextDrawSetString(PublicTD[15], pData[playerid][pName]);
							SetTimerEx("TextDrawHide", 10000, false, "d");
						}
						pData[playerid][pTwitterPostCooldown] = 60;
						//SetTimerEx("Lenzganteng", 10000, false, "ii", playerid);
					}
				}
				new dc[128];
				format(dc, sizeof(dc),  "```\n[TWITTER] @%s: %s```", pData[playerid][pTwittername], tweet);*/
				return 1;
			}
		}
		else
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

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
		}
	}
	if(dialogid == DIALOG_TWITTERNAME)
	{
		if(response)
		{
			if(pData[playerid][pTwitterNameCooldown] > 0)
			{
				Error(playerid, "Twitter changename masih cooldown %d detik", pData[playerid][pTwitterNameCooldown]);
				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}
			else
			{
				new query[512];
				format(pData[playerid][pTwittername], 64, inputtext);
				Info(playerid, "Kamu Berhasil Mengganti Nama Tweet, Bisa di Ubah Setelah 7 Hari {0099ff}%s", inputtext);
				pData[playerid][pTwitterNameCooldown] = 6048000;

				mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET twittername = '%s' WHERE reg_id = %i", inputtext, pData[playerid][pID]);
				mysql_tquery(g_SQL, query);

				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
			}
		}
		else
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

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Select", "Close");
		}
	}
	if(dialogid == DIALOG_DOKTERLOKAL)
	{
		if(response)
		{
			SetPlayerHealthEx(playerid, 100.0);
			pData[playerid][pInjured] = 0;
			pData[playerid][pHospital] = 0;
            pData[playerid][pHospitalTime] = 0;
			pData[playerid][pHunger] = 100;
			pData[playerid][pEnergy] = 100;
			pData[playerid][pBladder] = 100;
			pData[playerid][pSick] = 0;
			pData[playerid][pHead] += 60;
			pData[playerid][pPerut] += 60;
			pData[playerid][pRHand] += 60;
			pData[playerid][pLHand] += 60;
			pData[playerid][pRFoot] += 60;
			pData[playerid][pLFoot] += 60;
			pData[playerid][pSickTime] = 0;
			GivePlayerMoneyEx(playerid, -500);
			ShowItemBox(playerid, "Uang", "Removed_$500", 1212, 4);
			//HideTdDeath(playerid);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);

			SendStaffMessage(COLOR_RED, "BotZiro : {B897FF}[Dokter Lokal]"WHITE_E" %s Telah Menggunakan /dokterlokal untuk terbangun dari pingsannya.", ReturnName(playerid));
			Info(playerid, "Kamu Berhasil Menggunakan Dokter Lokal.");
		}
	}
	//ayam
	if(dialogid == DIALOG_AYAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 399.3665,-1818.9941,7.9219, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 156.6945,-1499.9636,12.3485, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
	if(dialogid == DIALOG_AYAMFILL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][AyamFillet] + amount;
			new value = amount * AyamFillPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Ayam full in your inventory! max: 100kg.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(AyamFill < amount) return Error(playerid, "ayam stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][AyamFillet] += amount;
			AyamFill -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"ayam seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DISNAKER)
	{
		if(response)
		{
			switch(listitem)
			{
			    //================[ CASE 0 ]=============
				//================[ CASE 1 ]=============
				case 0:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Tukang Ayam");
					pData[playerid][pJob] = 11;
					tukangayam++;
					//pData[playerid][DutyPemotong] = false;
					//RefreshJobPemotong(playerid);
				}
				//================[ CASE 2 ]=============
				case 1:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Penebang Kayu");
					pData[playerid][pJob] = 3;
					tukangtebang++;
					CreateDynamicMapIcon(-1448.7006, -1530.6364, 101.7578, 25, -1, -1, -1, -1, 4000.0);//penebang
				}
				//================[ CASE 3 ]=============
				case 2:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Petani");
					pData[playerid][pJob] = 7;
					petani++;
				}
				//================[ CASE 4 ]=============
				case 3:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penambang");
					pData[playerid][pJob] = 5;
					//RefreshJobTambang(playerid);
					penambang++;
				}
				//================[ CASE 5 ]=============
				case 4:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Pemetik Markisa");
					pData[playerid][pJob] = 13;
					//markisaCP = CreateDynamicCP(1548.4779,-57.6949,20.9545, 2.0, -1, -1, -1, 5.0);//pemerahlocier
					markisaa++;
					//pData[playerid][pJobmilkduty] = false;
					//RefreshMapJobSapi(playerid);
				}
				//================[ CASE 6 ]=============
				case 5:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Baggage Airport");
					pData[playerid][pJob] = 10;
					//RefreshJobTambang(playerid);
					bagage++;
				}
				//================[ CASE 7 ]=============
				case 6:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Trucker");
					Info(playerid, "Gunakan /mission atau /container untuk memulai pekerjaan anda");
					pData[playerid][pJob] = 4;
					Trucker++;
				}
				case 7:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Penjahit");
					pData[playerid][pJob] = 6;
					product++;
				}
				case 8:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~p~Merchant Filler");
					pData[playerid][pJob] = 12;
					Merchantfiller++;
					//RefreshJobBus(playerid);
				}
				case 9:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penambang Minyak");
					pData[playerid][pJob] = 14;
					penambangminyak++;
					//RefreshJobTambangMinyak(playerid);
				}
				case 10:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Pemerah Susu");
					pData[playerid][pJob] = 15;
					pemerah++;
					Iter_Add(MilkerOnduty, 1);
					RefreshMapJobSapi(playerid);
				}
				case 11:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Mekanik");
					pData[playerid][pJob] = 2;
					mekanik++;
					//RefreshJobTambangMinyak(playerid);
				}
				//================[ KELUAR PEKERJAAN ]=============
				case 12:
				{
				    if(pData[playerid][pJob] == 0) return ErrorMsg(playerid, "Anda seorang pengangguran.");
				    if(pData[playerid][pJob] == 2)
					{
					    mekanik--;
					    pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~mekanik");
						//DeleteBusCP(playerid);
					}
					else if(pData[playerid][pJob] == 11)
					{
				    	tukangayam--;
						pData[playerid][pJob] = 0;
						//DeletePemotongCP(playerid);
						SuccesMsg(playerid, "Anda resign menjadi ~p~tukang ayam");
					}
					else if(pData[playerid][pJob] == 15)
					{
						DeleteJobPemerahMap(playerid);
				    	pemerah--;
						pData[playerid][pJob] = 0;
						Iter_Remove(MilkerOnduty, 1);
                		PlayerSusuVars[playerid][DuringTakeSusu] = false;
						//DeletePemotongCP(playerid);
						SuccesMsg(playerid, "Anda resign menjadi ~y~pemerah");
					}
					else if(pData[playerid][pJob] == 3)
					{
				    	tukangtebang--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~lumberjack");
					}
					else if(pData[playerid][pJob] == 5)
					{
				    	penambang--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~penambang.");
						//DeleteMinyakCP(playerid);
					}
					else if(pData[playerid][pJob] == 13)
					{
					    //DeleteJobPemerahMap(playerid);
				    	markisaa--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~pemetik markisa");
					}
					else if(pData[playerid][pJob] == 10)
					{
				    	bagage--;
				    	//DeletePenambangCP(playerid);
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~Baggage Airport");
					}
					else if(pData[playerid][pJob] == 7)
					{
				    	petani--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~petani");
					}
					else if(pData[playerid][pJob] == 4)
					{
				    	Trucker--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~trucker");
					}
					else if(pData[playerid][pJob] == 6)
					{
				    	product--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~product");
					}
				    else if(pData[playerid][pJob] == 12)
					{
					    Merchantfiller--;
					    pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~p~Merchant FIller");

					}
					else if(pData[playerid][pJob] == 14)
					{
				    	penambangminyak--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~penambang minyak.");
						//DeleteMinyakCP(playerid);
					}
					else if(pData[playerid][pJob] == 2)
					{
				    	mekanik--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~penambang minyak.");
						//DeleteMinyakCP(playerid);
					}
				}
			}
		}
		return 1;
	}
	//penambang
	if(dialogid == DIALOG_TAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    callcmd::adolminyak(playerid, "");
				}
				case 1:
				{
				    callcmd::adolemas(playerid, "");
				}
				case 2:
				{
				    callcmd::adolwesi(playerid, "");
				}
				case 3:
				{
				    callcmd::adoltembaga(playerid, "");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERMINYAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,50);
					else SetPlayerSkin(playerid,192);// wanita
					pData[playerid][pDutyJob] = 1;
					RefreshJobTambangMinyak(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					RefreshJobTambangMinyak(playerid);
					pData[playerid][pDutyJob] = 0;
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPENAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid, 27);
					else SetPlayerSkin(playerid, 31);// wanita
					pData[playerid][pDutyJob] = 2;
					pData[playerid][DutyPenambang] = true;
                    RefreshJobTambang(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					pData[playerid][pDutyJob] = 0;
					pData[playerid][DutyPenambang] = false;
					RefreshJobTambang(playerid);
				}
			}
		}
		return 1;
	}
	//new vending dan trucker
	//Vending System
	if(dialogid == DIALOG_VENDING_BUYPROD)
	{
		static
        vid = -1,
        price;

		if((vid = pData[playerid][pInVending]) != -1 && response)
		{
			price = VendingData[vid][vendingItemPrice][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(VendingData[vid][vendingStock] < 1)
				return Error(playerid, "This vending is out of stock product.");
				
			
			switch(listitem)
			{
				case 0:
				{
					GivePlayerMoneyEx(playerid, -price);
					/*SetPlayerHealthEx(playerid, health+30);*/
					pData[playerid][pHunger] += 5;
					Vend(playerid, "{FFFFFF}You have purchased PotaBee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;						
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 1:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 5;
					Vend(playerid, "{FFFFFF}You have purchased Cheetos for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;			
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 2:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 5;
				    Vend(playerid, "{FFFFFF}You have purchased Sprunk for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
                case 3:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pEnergy] += 5;
				    Vend(playerid, "{FFFFFF}You have purchased Cofee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
			}		
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_MANAGE)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new string[258];
					format(string, sizeof(string), "Vending ID: %d\nVending Name : %s\nVending Location: %s\nVending Vault: %s",
					vid, VendingData[vid][vendingName], GetLocation(VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]), FormatMoney(VendingData[vid][vendingMoney]));

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vending Information", string, "Cancel", "");
				}
				case 1:
				{
					new string[218];
					format(string, sizeof(string), "Tulis Nama Vending baru yang anda inginkan : ( Nama Vending Lama %s )", VendingData[vid][vendingName]);
					ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT, "Vending Change Name", string, "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Select","Cancel");
				}
				case 3:
				{
					VendingProductMenu(playerid, vid);
				}
				case 4:
				{
					if(VendingData[vid][vendingStock] > 100)
						return Error(playerid, "Vending ini masih memiliki cukup produck.");
					if(VendingData[vid][vendingMoney] < 1000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalamam vending anda senilai $1000 untuk merestock product.");
					VendingData[vid][vendingRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];

			if(!PlayerOwnVending(playerid, bid)) return Error(playerid, "You don't own this Vending Machine.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending harus 5 sampai 32 kata.\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			format(VendingData[bid][vendingName], 32, ColouredText(inputtext));

			Vending_RefreshText(bid);
			Vending_Save(bid);

			Vend(playerid, "Vending name set to: \"%s\".", VendingData[bid][vendingName]);
		}
		else return callcmd::vendingmanage(playerid, "\0");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_VAULT)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam Vending ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_VENDING_DEPOSIT, DIALOG_STYLE_INPUT, "Vending Deposit Input", mstr, "Deposit", "Cancel");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Vending Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam Vending ini", FormatMoney(VendingData[vid][vendingMoney]));
					ShowPlayerDialog(playerid, DIALOG_VENDING_WITHDRAW, DIALOG_STYLE_INPUT,"Vending Withdraw Input", mstr, "Withdraw","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_VENDING_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > VendingData[bid][vendingMoney])
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] -= amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] += amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			Info(playerid, "You have deposit %s into the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_EDITPROD)
	{
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingVendingItem], item, 40 char);

				pData[playerid][pVendingProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::vendingmanage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_PRICESET)
	{
		static
        item[40];
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingVendingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				VendingData[vid][vendingItemPrice][pData[playerid][pVendingProductModify]] = strval(inputtext);
				Vending_Save(vid);

				Vend(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				VendingProductMenu(playerid, vid);
			}
			else
			{
				VendingProductMenu(playerid, vid);
			}
		}
	}
	if(dialogid == DIALOG_MY_VENDING)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVending", ReturnPlayerVendingID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_VENDING_INFO, DIALOG_STYLE_LIST, "{0000FF}My Vending", "Show Information\nTrack Vending", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_INFO)
	{
		if(!response) return 1;
		new ved = GetPVarInt(playerid, "ClickedVending");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new type[128];
				type = "Food & Drink";
				format(line9, sizeof(line9), "Vending ID: %d\nVending Owner: %s\nVending Address: %s\nVending Price: %s\nVending Type: %s",
				ved, VendingData[ved][vendingOwner], GetLocation(VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ]), FormatMoney(VendingData[ved][vendingPrice]), type);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vending Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackVending] = 1;
				SetPlayerRaceCheckpoint(playerid,1, VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan mesin vending anda!");
			}
		}
		return 1;
	}
	/*if(dialogid == DIALOG_VENDING_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(VendingData[id][vendingMoney] < 1000)
				return Error(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pRestock] == 1)
				return Error(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pRestock] = id;
			VendingData[id][vendingRestock] = 0;
			
			new line9[900];
			new type[128];
			if(VendingData[id][vendingType] == 1)
			{
				type = "Froozen Snack";

			}
			else if(VendingData[id][vendingType] == 2)
			{
				type = "Soda";
			}
			else
			{
				type = "Unknown";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\nVending Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][vendingOwner], VendingData[id][vendingName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}
	}*/
	if(dialogid == DIALOG_MENU_TRUCKER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetRestockBisnis() <= 0) return Error(playerid, "Mission sedang kosong.");
					new id, count = GetRestockBisnis(), mission[400], type[32], lstr[512];
					
					strcat(mission,"No\tBusID\tBusType\tBusName\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockBisnisID(itt);
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Ammunation";
						}
						else
						{
							type= "Unknow";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
				}
				case 1:
				{
					if(GetRestockGStation() <= 0) return Error(playerid, "Hauling sedang kosong.");
					new id, count = GetRestockGStation(), hauling[400], lstr[512];
					
					strcat(hauling,"No\tGas Station ID\tLocation\n",sizeof(hauling));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockGStationID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
						strcat(hauling,lstr,sizeof(hauling));
					}
					ShowPlayerDialog(playerid, DIALOG_HAULING, DIALOG_STYLE_TABLIST_HEADERS,"Hauling",hauling,"Start","Cancel");
				}
				case 2:
				{
					if(GetRestockVending() <= 0) return Error(playerid, "Misi Restock sedang kosong.");
					new id, count = GetRestockVending(), vending[400], lstr[512];
					
					strcat(vending,"No\tName Vending (ID)\tLocation\n",sizeof(vending));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockVendingID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(vending,lstr,sizeof(vending));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_VENDING, DIALOG_STYLE_TABLIST_HEADERS, "Vending", vending, "Start", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{

				}
				case 1:
				{
					if(GetAnyVendings() <= 0) return Error(playerid, "Tidak ada Vendings di kota.");
					new id, count = GetAnyVendings(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnVendingsID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_SHIPMENTS_VENDING, DIALOG_STYLE_TABLIST_HEADERS,"Vendings List",location,"Select","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS_VENDING)
	{
		if(response)
		{
			new id = ReturnVendingsID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ], 0.0, 0.0, 0.0, 3.5);
			//Gps(playerid, "Vendings checkpoint targeted! (%s)", GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
			SendClientMessageEx(playerid, -1,  "Vendings checkpoint targeted! (%s)", GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_VENDING)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1));
			if(VendingData[id][vendingMoney] < 1000)
				return Error(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pVendingRestock] == 1)
				return Error(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) != 586) return Error(playerid, "Kamu harus mengendarai wayfarer.");
				
			pData[playerid][pVendingRestock] = id;
			VendingData[id][vendingRestock] = 0;
			
			new line9[900];
			
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][vendingOwner], VendingData[id][vendingName]);
			SetPlayerRaceCheckpoint(playerid, 1, -56.39, -223.73, 5.42, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}	
	}
	//merchantfiller
	if(dialogid == DIALOG_MERCHANTFILLER)
	{
		if(response)
		{			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) != 499) return Error(playerid, "Kamu harus mengendarai benson.");							
			new line9[900];			
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang Merchant!\nLalu antarkan ke check point pedagang mission anda!");
			SetPlayerRaceCheckpoint(playerid, 1, 403.9664, -1809.8123, 7.9219, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}	
	}
	//pedagang
	if(dialogid == DIALOG_MENUMASAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //ayam goreng
				{
					if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pChiken] += 5;
					ShowProgressbar(playerid, "Memasak Chiken..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Ayam Goreng", "Received_1x", 19847, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 1: //KEBAB
				{
					if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

					InfoMsg(playerid, "Anda Memulai Kebab!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pKebab] += 5;
					ShowProgressbar(playerid, "Membuat Kebab..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Kebab", "Received_1x", 2769, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 2: //ROTI
				{
					if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pRoti] += 5;
					ShowProgressbar(playerid, "Memasak Roti ..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Roti", "Received_1x", 19883, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 3: //steak ayam
				{
					if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pSteak] += 5;
					ShowProgressbar(playerid, "Memasak Steak..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Steak", "Received_1x", 2769, 4);
					pData[playerid][pEnergy] -= 2;
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MENUMINUM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //MINUM
				{
					if(pData[playerid][pFood] < 2)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
					pData[playerid][pSprunk] += 3;
					ShowItemBox(playerid, "Water", "Received_3x", 2958, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil water di kulkas.", ReturnName(playerid));
				}
				case 1: //CAPPUCINO
				{
					if(pData[playerid][pFood] < 5)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
					pData[playerid][pCappucino] += 3;
					ShowItemBox(playerid, "Cappucino", "Received_3x", 19835, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil cappucino di kulkas.", ReturnName(playerid));
				}
				case 2: //STARLING
				{
					if(pData[playerid][pFood] < 5)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
					pData[playerid][pStarling] += 3;
					ShowItemBox(playerid, "Starling", "Received_3x", 1455, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil starling di kulkas.", ReturnName(playerid));
				}
				case 3: //MILK
				{
					if(pData[playerid][pFood] < 5)
						return ErrorMsg(playerid, "Kamu tidak memiliki bahan mentah!");
					pData[playerid][pMilxMax] += 3;
					ShowItemBox(playerid, "Milx_Max", "Received_3x", 19570, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil milxmax di kulkas.", ReturnName(playerid));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPEDAGANG)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetPlayerColor(playerid, COLOR_GOLD);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 167);
							pData[playerid][pFacSkin] = 167;
						}
						else
						{
							SetPlayerSkin(playerid, 169);
							pData[playerid][pFacSkin] = 169;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, PDGSkinMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, PDGSkinFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	//staterpack
	if(dialogid == DIALOG_SP)
	{
		if(response)
		{
			pData[playerid][pStarterpack] = 1;
			pData[playerid][pVip] = 2;
			pData[playerid][pVipTime] = gettime() + (6 * 86400);
			pData[playerid][pRoti] += 10;
			pData[playerid][pMilxMax] += 10;
			GivePlayerMoneyEx(playerid, 5000);
			ShowItemBox(playerid, "Uang", "Received_$5.000", 1212, 4);
			ShowItemBox(playerid, "Roti Sobek", "Received_10x", 19883, 4);
			ShowItemBox(playerid, "Susu Mamah", "Received_10x", 19570, 4);
			Servers(playerid, "SELAMAT! Anda mendapatkan $5.000 di kantong, 10 Roti, dan 10 Susu. Bonus VIP Medium selama 7 Hari.. HAPPY ROLEPLAY!!!");

			SendClientMessageToAllEx(COLOR_PURPLE, "%s {ffffff}Telah mengclaim starterpack dan mendapat {b897ff}VIP Medium 7 Hari.!!", pData[playerid][pName]);
			SuccesMsg(playerid, "Kamu Berhasil Mengclaim Staterpack. Happy Roleplaying!");
		}
	}
	//mv baru
	if(dialogid == DIALOG_MYVEH)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_MYVEH_INFO, DIALOG_STYLE_LIST, "Vehicle Info", "Information Vehicle\nTrack Vehicle\nUnstuck Vehicle", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_MYVEH_INFO)
	{
		if(!response) return 1;
		new vid = GetPVarInt(playerid, "ClickedVeh");
		switch(listitem)
		{
			case 0:
			{
				
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle ID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cVeh], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
				else
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle UID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cID], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
			}
			case 1:
			{
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new palid = pvData[vid][cVeh];
					new
			        	Float:x,
			        	Float:y,
			        	Float:z;

					pData[playerid][pTrackCar] = 1;
					GetVehiclePos(palid, x, y, z);
					SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan anda!");
				}
				else if(pvData[vid][cPark] > 0)
				{
					SetPlayerRaceCheckpoint(playerid, 1, pvData[vid][cPosX], pvData[vid][cPosY], pvData[vid][cPosZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan yang ada di dalam garkot!");
				}
				else if(pvData[vid][cClaim] != 0)
				{
					Info(playerid, "Kendaraan kamu di kantor insuransi!");
				}
				else
					return Error(playerid, "Kendaraanmu belum di spawn!");
			}
			case 2:
			{
				static
				carid = -1;

				if((carid = Vehicle_Nearest(playerid)) != -1)
				{
					if(Vehicle_IsOwner(playerid, carid))
					{
						if(IsValidVehicle(pvData[vid][cVeh]))
						{
							//Vehicle_Save(vid);
							//SetTimerEx("DestroyVehicle", 2000, false, "d", vid);
							DestroyVehicle(pvData[vid][cVeh]);
							pvData[vid][cVeh] = INVALID_VEHICLE_ID;
						}	
						SetTimerEx("OnPlayerVehicleRespawn", 3000, false, "d", vid);
					}
				}	
				else Error(playerid, "Kamu tidak berada didekat Kendaraan tersebut.");
			}
		}
		return 1;
	}
	//job baggage
	if(dialogid == DIALOG_BAGGAGE)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0://Rute 1
				{
				    if(DialogBaggage[0] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[0] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][0] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2137.2085, -2380.0925, 13.2078, 2137.2085, -2380.0925, 13.2078, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2137.2085, -2380.0925, 13.2078, 180.7874, 1, 1, -1);
						pData[playerid][pBaggage] = 1;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
				case 1://Rute 2
				{
				    if(DialogBaggage[1] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[1] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][1] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2009.4430, -2273.0322, 13.2024, 2009.4430, -2273.0322, 13.2024, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2009.4430, -2273.0322, 13.2024, 91.8682, 1, 1, -1);
						pData[playerid][pBaggage] = 12;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
				case 2://Rute 3
				{
				    if(DialogBaggage[2] == false) // Kalau False atau tidak dipilih
				    {
					    DialogBaggage[2] = true; // Dialog 0 telah di pilih
					    MyBaggage[playerid][2] = true;
						SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1897.6689, -2225.1143, 13.2150, 1897.6689, -2225.1143, 13.2150, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1897.6689, -2225.1143, 13.2150, 180.8993, 1, 1, -1);
						pData[playerid][pBaggage] = 23;
						pData[playerid][pCheckPoint] = CHECKPOINT_BAGGAGE;
					}
					else
					    SendClientMessage(playerid,-1,"{FF0000}<!> {FFFFFF}Misi Baggage ini sudah diambil oleh seseorang");
				}
			}
		}
		else 
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	//garasi fraksi
	if(dialogid == DIALOG_SAPD_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(596, 1538.42, -1682.46, 5.59, 92.4917, 0, 1, VEHICLE_RESPAWN, 0);
					 
					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(597, 1538.42, -1682.46, 5.59, 92.4917, 0, 1, VEHICLE_RESPAWN, 0);
					 
					SetVehicleHealth(SAPDVeh[playerid], 5000);
					AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(598, 1538.42, -1682.46, 5.59, 92.4917, 0, 1,VEHICLE_RESPAWN, 0);
					 

					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(599, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					 
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 4:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(601, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					 
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 5:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(427, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					 
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 6:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(528, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 7:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(411, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 8:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(560, 1538.42, -1682.46, 5.59, 92.4917,0,1,VEHICLE_RESPAWN,0);
					 					
					AddVehicleComponent(SAPDVeh[playerid], 1029);
					AddVehicleComponent(SAPDVeh[playerid], 1030);
					AddVehicleComponent(SAPDVeh[playerid], 1031);
					AddVehicleComponent(SAPDVeh[playerid], 1033);
					AddVehicleComponent(SAPDVeh[playerid], 1139);
					AddVehicleComponent(SAPDVeh[playerid], 1140);
					AddVehicleComponent(SAPDVeh[playerid], 1170);
					AddVehicleComponent(SAPDVeh[playerid], 1010);//nos
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 9:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(468, 1538.42, -1682.46, 5.59, 92.4917,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 10:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(521, 1538.42, -1682.46, 5.59, 92.4917,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 11:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(523, 1538.42, -1682.46, 5.59, 92.4917,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 12:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(522, 1538.42, -1682.46, 5.59, 92.4917,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 13:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(525, 1538.42, -1682.46, 5.59, 92.4917,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);

				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 14:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1568.40, -1695.66, 5.89))
				{
					SAPDVeh[playerid] = CreateVehicle(497, 1569.1587,-1641.0361,28.5788,3,4,VEHICLE_RESPAWN,0);
					SetVehicleHealth(SAPDVeh[playerid], 5000);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
		}
		pData[playerid][pSpawnSapd] = 1;
		PutPlayerInVehicle(playerid, SAPDVeh[playerid], 0);
	}
	if(dialogid == DIALOG_SAMD_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(416, 1120.0265, -1317.1208, 13.8679, 271.4225, 1, 3, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(407, 1120.0265, -1317.1208, 13.8679, 271.4225, -1, 3, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(563, 1162.8176, -1313.8239, 32.2215, 270.7216, 0, 1,120000, 0);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(487, 1162.8176, -1313.8239, 32.2215, 270.7216, -1,3,120000,1);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 4:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(426, 1120.0265, -1317.1208, 13.8679, 271.4225, 1,1,120000,1);
					AddVehicleComponent(SAMDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
		}
		pData[playerid][pSpawnSamd] = 1;
		PutPlayerInVehicle(playerid, SAMDVeh[playerid], 0);
	}
	if(dialogid == DIALOG_UMPAN)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pWorm] + amount;
			new value = amount * 1;
			if(amount < 0 || amount > 1000) return ErrorMsg(playerid, "amount maximal 0 - 1000.");
			if(total > 1000) return ErrorMsg(playerid, "Umpan terlalu penuh di Inventory! Maximal 1000.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pWorm] += amount;
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Umpan seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	//spawn baru
	if(dialogid == DIALOG_PILIH_SPAWN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerPos(playerid, 1480.2825,-1743.0795,13.5469);
					SetPlayerFacingAngle(playerid, 6.7889);
					SuccesMsg(playerid, "Anda Spawn Di kantor Pemerintahan Metaverse");
					SpawnPlayer(playerid);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					SetCameraBehindPlayer(playerid);		
					loadWorld(playerid);
				}
				case 1:
				{
	   		    	SetPlayerPos(playerid, 1538.0959,-1674.1003,13.5469);
					SetPlayerFacingAngle(playerid, 96.0663);
					SuccesMsg(playerid, "Anda Spawn Di Kepolisian Warga Kota");
					SpawnPlayer(playerid);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					SetCameraBehindPlayer(playerid);		
					loadWorld(playerid);
				}
				case 2:
				{
                    SetPlayerPos(playerid, 1194.8440,-1328.5824,13.3984);
					SetPlayerFacingAngle(playerid, 274.6681);
					SuccesMsg(playerid, "Anda Spawn Di Rumah Sakit Warga Kota");
					SpawnPlayer(playerid);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					SetCameraBehindPlayer(playerid);		
					loadWorld(playerid);
				}
				case 3:
				{
					SetPlayerPos(playerid, 643.7294,-1361.2479,13.5914);
					SetPlayerFacingAngle(playerid, 97.0064);
					SuccesMsg(playerid, "Anda Spawn Di kantor berita Warga Kota");
					SpawnPlayer(playerid);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					SetCameraBehindPlayer(playerid);		
					loadWorld(playerid);
				}
				case 4:
				{
					SetPlayerPos(playerid, 334.6697,-1815.7426,4.3254);
					SetPlayerFacingAngle(playerid, 2.0655);
					SuccesMsg(playerid, "Anda Spawn Di Cafetaria Warga Kota");
					SpawnPlayer(playerid);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					SetCameraBehindPlayer(playerid);		
					loadWorld(playerid);
				}
			}
		}
		return 1;
	}
	//job sapi
	if(dialogid == DIALOG_LOCKERPEMERAH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,158);
					else SetPlayerSkin(playerid,157);// wanita
					new rand = random(sizeof(CowSpawn));
					if(DestroyPlayerObject(playerid, PlayerSusuVars[playerid][CowObject]))
					if(DestroyDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
						PlayerSusuVars[playerid][SusuTakeArea] = STREAMER_TAG_AREA:INVALID_STREAMER_ID;         

					PlayerSusuVars[playerid][DuringTakeSusu] = true;
					PlayerSusuVars[playerid][CowObject] = CreatePlayerObject(playerid, 19833, CowSpawn[rand][0], CowSpawn[rand][1], CowSpawn[rand][2], CowSpawn[rand][3], CowSpawn[rand][4], CowSpawn[rand][5], 300.00);           
					PlayerSusuVars[playerid][SusuTakeArea] = CreateDynamicSphere(CowSpawn[rand][0], CowSpawn[rand][1], CowSpawn[rand][2], 2.0);
					//InfoMsg(playerid, "Silahkan pergi untuk memeras susu,tekan ALT untuk memeras");
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					if(DestroyPlayerObject(playerid, PlayerSusuVars[playerid][CowObject]))
					if(DestroyDynamicArea(PlayerSusuVars[playerid][SusuTakeArea]))
					PlayerSusuVars[playerid][SusuTakeArea] = STREAMER_TAG_AREA:INVALID_STREAMER_ID;    
					PlayerSusuVars[playerid][DuringTakeSusu] = false;
					RefreshMapJobSapi(playerid);
				}
			}
		}
	}
	

// teleport confirm dialog
	if(dialogid == DIALOG_TELEPORT_CONFIRM)
	{
		if(response)
		{
			new Float:x = pData[playerid][pWaypointPos][0];
			new Float:y = pData[playerid][pWaypointPos][1];
			new Float:z = pData[playerid][pWaypointPos][2];

			new vehicleid = GetPlayerVehicleID(playerid);
			if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				SetVehiclePos(vehicleid, x, y, z + 10.0);
			}
			else
			{
				SetPlayerPosFindZ(playerid, x, y, 999.0); // Gunakan FindZ biar aman
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
			}
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "INFO: Teleport berhasil!");
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "INFO: Teleport dibatalkan.");
		}
		return 1;
	}
	return 1;

}