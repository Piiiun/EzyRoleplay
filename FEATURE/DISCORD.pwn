forward DCC_DM(str[]);
public DCC_DM(str[])
{
    new DCC_Channel:PM;
	PM = DCC_GetCreatedPrivateChannel();
	DCC_SendChannelMessage(PM, str);
	return 1;
}

forward DCC_DM_EMBED(str[], pin, id[]);
public DCC_DM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[200];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="Warga Kota", .image_url="https://i.postimg.cc/zfkjbpQb/20240508-161722.jpg");
	new str1[100], str2[100];

	format(str1, sizeof str1, "```Selamat Ucp Kamu Telah Terdaftar\nGunakan PIN Dibawah Ini Untuk\nMelanjutkan Ke Ingame```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	DCC_SetEmbedColor(embed, 0xD0AEEBFF);

	DCC_SendChannelEmbedMessage(PM, embed);

	mysql_format(g_SQL, query, sizeof query, "INSERT INTO `ucp` (`username`, `verifycode`, `DiscordID`) VALUES ('%e', '%d', '%e')", str, pin, id);
	mysql_tquery(g_SQL, query);
	return 1;
}

forward CheckDiscordUCP(DiscordID[], Nama_UCP[]);
public CheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role: WARGA, DCC_Guild: guild, DCC_User: user, dc[100];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(5, "**[UCP ERROR]** Nama UCP account tersebut sudah terdaftar");
	}
	else 
	{
		new ns[32];
		guild = DCC_FindGuildById("1208819613098582066");
		WARGA = DCC_FindRoleById("1209072973332357151");
		user = DCC_FindUserById(DiscordID);
		format(ns, sizeof(ns), "WK | %s ", Nama_UCP);
		DCC_SetGuildMemberNickname(guild, user, ns);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "**[UCP]** %s is now Verified.", Nama_UCP);
		SendDiscordMessage(5, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward CheckDiscordID(DiscordID[], Nama_UCP[]);
public CheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[20], dc[100];
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);

		format(dc, sizeof(dc),  "**[UCP ERROR]** Kamu sudah mendaftar UCP sebelumnya dengan nama __%s__", ucp);
		return SendDiscordMessage(5, dc);
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `ucp` WHERE `username` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}


IsHaveSpace(text[])
{
	for (new i = 0, len = strlen(text); i < len; i ++)
	{
		if(text[i] == ' ') return 1;
	}
	return 0;
}

DCMD:verify(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1230560519388266537"))
		return 1;
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**[ERROR]** Gunakan !verify [username]");

	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "**[UCP ERROR]** Gunakan nama UCP bukan nama IC!");

	if(IsHaveSpace(params))
		return DCC_SendChannelMessage(channel, "**[UCP ERROR]** Nama tidak boleh memiliki spasi!");
	
	DCC_GetUserId(user, id, sizeof id);
	new uname[33];
	DCC_GetUserName(user, uname);

	new zQuery[256];
	mysql_format(g_SQL, zQuery, sizeof(zQuery), "SELECT * FROM `ucp` WHERE `discordID` = '%e' LIMIT 1", id);
	new Cache:ex = mysql_query(g_SQL, zQuery, true);
	new count = cache_num_rows();
	if(count > 0)
	{
		new str[256];
		format(str, sizeof(str), "**[UCP ERROR]** Discord %s Sudah pernah mendaftar sebelumnya", uname);
		DCC_SendChannelMessage(channel, str);
	}
	else
	{
    	new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `ucp` WHERE `DiscordID` = '%s'", id);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
		DCC_SendChannelMessage(channel, "** Ucp anda berhasil diverifikasi, silahkan cek message dari Bot ZiroGanteng.**");
	}
    cache_delete(ex);
	return 1;
}

////////////////////////////////////////////////////////
///////////////////////////////////////////////////////

function CheckReverify(DiscordID[])
{
	new DCC_Role: WARGA, DCC_Guild: guild, DCC_User: user;
	new rows = cache_num_rows(), Nama_UCP[20], PIN;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", Nama_UCP);
		cache_get_value_name_int(0, "verifycode", PIN);

        new ns[32];
        guild = DCC_FindGuildById("1208819613098582066");
        WARGA = DCC_FindRoleById("1209072973332357151");
        user = DCC_FindUserById(DiscordID);
        format(ns, sizeof(ns), "WK | %s ", Nama_UCP);
        DCC_SetGuildMemberNickname(guild, user, ns);
        DCC_AddGuildMemberRole(guild, user, WARGA);

		new DCC_Channel:Info;
		Info = DCC_FindChannelById("1230560519388266537");
		new str[5260], string[5260];
		new DCC_Embed:dc;
		format(str, sizeof(str), "**[UCP]:** __%s__ Congratulations, your UCP has been verified again.", Nama_UCP);
		dc = DCC_CreateEmbed("BOT ZIRO PANEL","**UCP INFORMATION**","","",0xb897ff,"Warga Kota","","","");
		DCC_AddEmbedField(dc, str, string, true);
		DCC_SendChannelEmbedMessage(Info, dc);
		DCC_CreatePrivateChannel(user, "Embed_Reverify", "sds", Nama_UCP, PIN, DiscordID);
	}
	else 
	{
		new DCC_Channel:Info;
		Info = DCC_FindChannelById("1230560519388266537");
		new str[5260], string[5260];
		new DCC_Embed:dc;
		format(str, sizeof(str), "**[UCP]:** Akun anda belum terdaftar .");
		dc = DCC_CreateEmbed("BOT ZIRO PANEL","**UCP INFORMATION**","","",0xb897ff,"Warga Kota","","","");
		DCC_AddEmbedField(dc, str, string, true);
		DCC_SendChannelEmbedMessage(Info, dc);
	}
	return 1;
}

function Embed_Reverify(str[], pin, id[])
{
    new DCC_Channel:PM;
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="Warga Kota", .image_url="https://i.postimg.cc/zfkjbpQb/20240508-161722.jpg");
	new str1[100], str2[100];

	format(str1, sizeof str1, "```\nHalo!\nKamu berhasil reverif Akun,\nGunakan PIN dibawah ini jika kamu dimintai pin saat login```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);

	DCC_SendChannelEmbedMessage(PM, embed);
	return 1;
}

DCMD:reffucp(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1230560519388266537"))
		return 1;
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**[BOT ZIRO]**: !reffucp NamaUCP");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "**[BOT ZIRO]** gunakan nama UCP bukan nama IC!");
	

	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "CheckReverify", "ss", id, params);
	return 1;
}

DCMD:setcs(user, channel, params[])
{
    if(channel != activecs)
		return DCC_SendChannelMessage(channel, "Akses Anda Kami tolak!! Karna Kamu Bukan Admin.");

    if(isnull(params)) return DCC_SendChannelMessage(activecs, "**[BOT ZIRO]** !SETCS [name_character]");
	new query[528], bebas[400];
    mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%e'", params);
	mysql_query(g_SQL, query);

    if(cache_num_rows() == 0) return DCC_SendChannelMessage(activecs, "**[BOT ZIRO]** Nama Character Tersebut Tidak Ada Di Database.");
    
	new code = 1;
	new cQuery[3048];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `players` SET ");
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`cs` = '%s' ", cQuery, code);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `username` = '%e'", cQuery, params);
	mysql_tquery(g_SQL, cQuery);

	format(bebas ,sizeof(bebas),"**[BOT ZIRO]** Character Story __%s__ is active!", params);
	DCC_SendChannelMessage(activecs, bebas);
	return 1;
}

DCMD:ip(user, channel, params[])
{
    new DCC_Embed:msgEmbed, msgField[256];
	format(msgField, sizeof(msgField), "Ambil Disini <#1217653940926287927>");
	msgEmbed = DCC_CreateEmbed("", msgField, "", "", 0xb897ff, "Warga Kota | WKRP V2.0", "", "", "");
	DCC_SendChannelEmbedMessage(channel, msgEmbed);
	return 1;
}

DCMD:helpme(user, channel, params[])
{
	new string[128];
    format(string, sizeof string, "**IP :** <#1217653940926287927>");
	new DCC_Embed:dc = DCC_CreateEmbed(.title="Warga Kota | WKRP V2.0", .image_url="https://i.postimg.cc/zfkjbpQb/20240508-161722.jpg");

 	new str[526],stro[526],str1[526],str2[526];
	format(str1, sizeof str1, ":books: **Guide**");
	format(str2, sizeof str2, "<#1219487937012568125> <#1217664840659636254> <#1217665499735785544>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str, sizeof str, ":globe_with_meridians: Connect Server");
 	format(stro,sizeof(stro),"%d/%d", pemainic, GetMaxPlayers());
	DCC_AddEmbedField(dc, str, string, true);
	DCC_AddEmbedField(dc, ":globe_with_meridians: Players Online", stro, true);
	format(str1, sizeof str1, ":hammer_pick: **Changelogs Update**");
	format(str2, sizeof str2, "<#1217652657024667828>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":satellite: **Tutorial Connect**");
	format(str2, sizeof str2, "<#1208857046003486820>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":interrobang: **Saran Update & Kritik**");
	format(str2, sizeof str2, "<#1217667399747113051>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":scroll: **Character Story**");
	format(str2, sizeof str2, "<#1218381806009843772> <#1238178260299288627> <#1238178861498236992>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":no_entry: **Report Problem In Game**");
	format(str2, sizeof str2, "<#1226593610980659371> <#1217668669773971536>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":money_with_wings: **Donation**");
	format(str2, sizeof str2, "<#1218267565139165285> <#1218275211913330818> <#1218267733389738074> <#1218267825160847361> <#1230815026357604354> <#1218267944321155162> <#1218268254926012416>");
	DCC_AddEmbedField(dc, str1, str2, false);
	format(str1, sizeof str1, ":crown: **List Staff**");
	format(str2, sizeof str2, "<#1218020294363709560>");
	DCC_AddEmbedField(dc, str1, str2, false);
	DCC_SetEmbedColor(dc, 0xb897ff);
	new y, m, d, timestamp[200];
    getdate(y, m , d);
	format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	DCC_SetEmbedTimestamp(dc, timestamp);
	DCC_SetEmbedFooter(dc, "Warga Kota");
	DCC_SendChannelEmbedMessage(channel, dc);
	return 1;
}

DCMD:kickall(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1210055074223489064"))
		return DCC_SendChannelMessage(channel, "**[BOT ZIRO]** Ke Channel <#1210055074223489064> Dek!");

	SendRconCommand("hostname Warga Kota | WKRP V2.0 [MAINTENANCE]");
	GameTextForAll("Server will restart in 20 seconds", 20000, 3);
	SetTimer("PlayerKickALL", 20000, false);
	DCC_SendChannelMessage(channel, "**[BOT ZIRO]** Successfully kicked all the players in Server");
	return 1;
}

DCMD:sapdonline(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1238175557364219995"))
		return DCC_SendChannelMessage(channel, "**[ZiroGanteng]** Ke Channel <#1238175557364219995> Dek!");

	new duty[16], lstr[1024], count = 0;
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = "On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
			count++;
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);

	if(count > 0)
	{
		new DCC_Embed:msgEmbed, msgField[1520];
		format(msgField, sizeof(msgField), "```\n%s\n```", lstr);
		msgEmbed = DCC_CreateEmbed("", "", "", "", 0x00ff00, "SAPD online list", "", "", "");
		DCC_AddEmbedField(msgEmbed, "SAPD Online In Server", msgField);
		DCC_SendChannelEmbedMessage(channel, msgEmbed);	
	}
	else DCC_SendChannelMessage(channel, "**[BOT ZIRO]** __Tidak ada SAPD online__ ");
	return 1;
}

DCMD:samdonline(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1238175557364219995"))
		return DCC_SendChannelMessage(channel, "**[ZiroGanteng]** Wassap GenggðŸ—¿");

	new duty[16], lstr[1024], count = 0;
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 3)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = "On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
			count++;
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);

	if(count > 0)
	{
		new DCC_Embed:msgEmbed, msgField[1520];
		format(msgField, sizeof(msgField), "```\n%s\n```", lstr);
		msgEmbed = DCC_CreateEmbed("", "", "", "", 0x00ff00, "SAMD online list", "", "", "");
		DCC_AddEmbedField(msgEmbed, "SAMD Online In Server", msgField);
		DCC_SendChannelEmbedMessage(channel, msgEmbed);	
	}
	else DCC_SendChannelMessage(channel, "**[BOT ZIRO]** __Tidak ada SAMD online__ ");

	return 1;
}

DCMD:admins(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1238175557364219995"))
		return DCC_SendChannelMessage(channel, "**[YouSempel]** Ke Channel <#1238175557364219995> Dek!");

	new count = 0, line3[1200];
	foreach(new i:Player)
	{
		if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
		{
			format(line3, sizeof(line3), "%s\n%s(%s)\n", line3, pData[i][pName], pData[i][pAdminname], GetStaffRank(i));
			count++;
		}
	}
	if(count > 0)
	{
		new DCC_Embed:msgEmbed, msgField[256];
		format(msgField, sizeof(msgField), "```%s```", line3);
		msgEmbed = DCC_CreateEmbed("", "", "", "", 0xb897ff, "Admin online list", "", "", "");
		DCC_AddEmbedField(msgEmbed, "Admin Online In Server", msgField);
		DCC_SendChannelEmbedMessage(channel, msgEmbed);			
	}
	else return DCC_SendChannelMessage(channel, "**[BOT ZIRO]** __Tidak ada ADMIN Yang online!__ ");	
	return 1;
}

/*DCMD:checkp(user, channel, params[])
{
	if(channel != DCC_FindChannelById("1230561927898337342")) return DCC_SendChannelMessage(channel, "**[BOT ZIRO]** Error you are not part of the admin team");
	new otherid;
	new str[356];
	if(sscanf(params, "u", otherid))
	{
	    DCC_SendChannelMessage(channel, "**[BOT ZIRO]** !checkp [ID/Name]");
 		return 1;
 	}
	format(str, sizeof(str), "```%sName: %s SkinID: %d Tweet: %s Money: %d (ID: %d) | UCP Name: %s | Level: %d\n```", str, pData[otherid][pName], pData[otherid][pSkin], pData[otherid][pTwittername], pData[otherid][pMoney], otherid, UcpData[otherid][uUsername], pData[otherid][pLevel]);
	DCC_SendChannelMessage(channel, str);
	return 1;
}*/

DCMD:cekstats(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1230561927898337342"))
		return DCC_SendChannelMessage(channel, "**[BOT ZIRO]** Ke Channel <#1230561927898337342> dah disediain juga dek dek admin!");
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**[ERROR]**Gunakan __!cekstats__ **Ziro_Hamz**");

	new characterQuery[1780];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "CheckPlayer", "s", params);
	return 1;
}

forward CheckPlayer(Username[]);
public CheckPlayer(Username[])
{
	new rows = cache_num_rows(), ucp[2000], level, uid, duek, bmoney, redm, skin, comp, mat, band, marju, vip, viptime, reg[1000], lastlogin[1000], j1, j2, faction;
	if(rows > 0)
	{
		new DCC_Channel:CH, str1[10000], str2[10000];

		CH = DCC_FindChannelById("1230561927898337342");

		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "level", level);
		cache_get_value_name_int(0, "reg_id", uid);
		cache_get_value_name_int(0, "money", duek);
		cache_get_value_name_int(0, "redmoney", redm);
		cache_get_value_name_int(0, "skin", skin);
		cache_get_value_name_int(0, "bmoney", bmoney);
		cache_get_value_name_int(0, "vip", vip);
		cache_get_value_name_int(0, "vip_time", viptime);
		/*cache_get_value_name_int(0, "boost", boost);
		cache_get_value_name_int(0, "boost_time", boostt);*/
		cache_get_value_name(0, "reg_date", reg);
		cache_get_value_name(0, "last_login", lastlogin);
		cache_get_value_name_int(0, "job", j1);
    	cache_get_value_name_int(0, "job2", j2);
    	cache_get_value_name_int(0, "faction", faction);
    	cache_get_value_name_int(0, "component", comp);
    	cache_get_value_name_int(0, "material", mat);
    	cache_get_value_name_int(0, "marijuana", marju);
    	cache_get_value_name_int(0, "bandage", band);

		new DCC_Embed:embed = DCC_CreateEmbed(.title = "STATISTICS PLAYERS WARGA KOTA");

		format(str1, sizeof str1, "**Name UCP:**");
		format(str2, sizeof str2, "```\n%s```", ucp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Name Character:");
		format(str2, sizeof str2, "```\n%s```", Username);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**UserID:**");
		format(str2, sizeof str2, "```\n%d```", uid);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**Level:**");
		format(str2, sizeof str2, "```\n%d```", level);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**Vip:**");
		format(str2, sizeof str2, "```\n%s```", GetVipRank(vip));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**Vip Time:**");
		format(str2, sizeof str2, "```\n%d```", viptime);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(duek));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Bank Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(bmoney));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Red Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(redm));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Register Date:");
		format(str2, sizeof str2, "```\n%s```", reg);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Last Login:");
		format(str2, sizeof str2, "```\n%s```", lastlogin);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Faction:");
		format(str2, sizeof str2, "```\n%d```", faction);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Job:");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j1));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Job 2:");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j2));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Bandage:");
		format(str2, sizeof str2, "```\n%d```", band);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Component:");
		format(str2, sizeof str2, "```\n%d```", comp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Material:");
		format(str2, sizeof str2, "```\n%d```", mat);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Marijuana:");
		format(str2, sizeof str2, "```\n%d```", marju);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "https://assets.open.mp/assets/images/skins/%d.png", skin);
		DCC_SetEmbedImage(embed, str1);
		DCC_SetEmbedColor(embed, 0xb897ff);
		new y, m, d, timestamp[200];
    	getdate(y, m , d);
	    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	    DCC_SetEmbedTimestamp(embed, timestamp);
	    DCC_SetEmbedFooter(embed, "Warga Kota | #BersamaKitaBisa!!");

		DCC_SendChannelEmbedMessage(CH, embed);
	}
	else 
	{
		new DCC_Channel:CH;
		CH = DCC_FindChannelById("1230561927898337342");
		DCC_SendChannelMessage(CH, "**[ERROR]**  Nama Tersebut Tidak Ada Di Database Warga Kota");
	}
	return 1;
}


DCMD:online(user, channel, params[])
{
	//
	new DCC_Channel:hidupp, DCC_Embed:logss;
	new yy, m, d, timestamp[200];

	getdate(yy, m , d);
	hidupp = DCC_FindChannelById("1217654608546238566");

	format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
	logss = DCC_CreateEmbed("");
	DCC_SetEmbedTitle(logss, "SERVER KEMBALI MENGUDARA");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0xa5ff00); //0xffa500 
	DCC_SetEmbedUrl(logss, "");
	DCC_SetEmbedThumbnail(logss, "");
	DCC_SetEmbedFooter(logss, "", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "***Warga Kota Samp 2.0*** successfully starting and happy roleplaying!");
	DCC_AddEmbedField(logss, "Server Warga Kota Telah Kembali Mengudara!", stroi, true);
	DCC_SendChannelEmbedMessage(hidupp, logss);
	DCC_SendChannelMessage(hidupp, " @everyone ");
	return 1;
}

DCMD:restart(user, channel, params[])
{
    new DCC_Channel:hidupp, DCC_Embed:logss;
    hidupp = DCC_FindChannelById("1217654608546238566");
    new yy, m, d, timestamp[200];

    getdate(yy, m , d);

    format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
    logss = DCC_CreateEmbed("");
    DCC_SetEmbedTitle(logss, "RESTART HARIAN");
    DCC_SetEmbedTimestamp(logss, timestamp);
    DCC_SetEmbedColor(logss, 0x800080); //0xffa500 
    DCC_SetEmbedUrl(logss, "");
    DCC_SetEmbedThumbnail(logss, "");
    DCC_SetEmbedFooter(logss, "", "");
    new stroi[5000];
    format(stroi, sizeof(stroi), "***Warga Kota Samp 2.0*** The server will restart within: __**15 minutes**__.");
    DCC_AddEmbedField(logss, "Warga Kota Akan Segera Melakukan Restart Harian! Jangan Lupa Gunakan CMD /saveme.", stroi, true);
    DCC_SendChannelEmbedMessage(hidupp, logss);
    DCC_SendChannelMessage(hidupp, " @everyone ");
	return 1;
}

DCMD:mt(user, channel, params[])
{
    new DCC_Channel:hidupp, DCC_Embed:logss;
    hidupp = DCC_FindChannelById("1217654608546238566");
    new yy, m, d, timestamp[200];

    getdate(yy, m , d);

    format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
    logss = DCC_CreateEmbed("");
    DCC_SetEmbedTitle(logss, "SERVER MAINTANCE");
    DCC_SetEmbedTimestamp(logss, timestamp);
    DCC_SetEmbedColor(logss, 0x800080); //0xffa500 
    DCC_SetEmbedUrl(logss, "");
    DCC_SetEmbedThumbnail(logss, "");
    DCC_SetEmbedFooter(logss, "", "");
    new stroi[5000];
    format(stroi, sizeof(stroi), "***Warga Kota Samp 2.0*** The server will Maintance: __**15 minutes**__.");
    DCC_AddEmbedField(logss, "Warga Kota Akan Melakukan Maintance Untuk Memperbaiki Bug Dan Fitur New!! Jangan Lupa Untuk /Saveme.", stroi, true);
    DCC_SendChannelEmbedMessage(hidupp, logss);
    DCC_SendChannelMessage(hidupp, " @everyone ");
	return 1;
}
