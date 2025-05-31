#define MAX_INVENTORY 				20

new PlayerText: MAIN[MAX_PLAYERS][20];

new PlayerText:NAMETD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:INDEXTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:MODELTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:AMOUNTTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:GARISBAWAH[MAX_PLAYERS][MAX_INVENTORY];
//new PlayerText:NOTIFBOX[MAX_PLAYERS][5];

new BukaInven[MAX_PLAYERS];

enum inventoryData
{
	invExists,
	invItem[32 char],
	invModel,
	invAmount,
	invTotalQuantity
};
new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
enum e_InventoryItems
{
	e_InventoryItem[32], //Nama item
	e_InventoryModel, //Object item
	e_InventoryTotal
};
//Tambahkan item
new const g_aInventoryItems[][e_InventoryItems] =
{
	{"Uang", 1212, 1},
	{"Hand_Phone", 18867, 3},
	{"Radio", 19942, 3},
	{"Painkiller", 1241, 3},
	{"Joran", 18632, 2},
	{"Jerigen", 1650, 2},
	{"botol", 1486, 2},

	{"Kamera", 367, 1},
	{"Tazer", 346, 1},
	{"Desert_Eagle", 348, 1},
	{"Parang", 339, 1},
	{"Molotov", 344, 1},
	{"Slc_9mm", 346, 1},

	{"Shotgun", 349, 3},
	{"Combat_Shotgun", 351, 3},
	{"MP5", 353, 3},
	{"M4", 356, 3},
	{"Clip", 19995, 3},

	//mancing
	{"Penyu", 1609, 3},
	{"Blue_Fish", 1604, 3},
	{"Nemo", 1599, 3},
	{"Ikan_Makarel", 19630, 3},

	//makan dan minum
	{"Water", 2958, 1},
	{"Starling", 1455, 3},
	{"Kentucky", 19847, 3},
	{"Roti", 19883, 3},
	{"Kebab", 2769, 3},
	{"Cappucino", 19835, 3},
	{"Snack", 2821, 3},
	{"Milx_Max", 19570, 2},
	{"Ktp", 1581, 1},

	{"Kanabis", 800, 3},
	{"Marijuana", 1578, 3},
	{"Steak", 19811, 2},
	{"Kopi", 19835, 3},

	//bahan jahit pakaian
	{"Ciki", 19565, 2},
	{"Wool", 2751, 2},
	{"Pakaian", 2399, 2},
	{"Kain", 11747, 2},

	//pertanian
    {"Padi", 2901, 3},
    {"Tebu", 2901, 3},
    {"Jagung", 2901, 3},
    {"Cabai", 2901, 3},
	{"Padi_Olahan", 19638, 3},
	{"Sambal", 19636, 3},
	{"Tepung", 19570, 3},
	{"Bibit_Padi", 862, 2},
	{"Bibit_Cabai", 862, 2},
	{"Bibit_Jagung", 862, 2},
	{"Bibit_Tebu", 862, 2},
	{"Biji_Kopi", 18225, 1},
	{"Gula", 19824, 2},
	{"Ikan", 19630, 2},
	{"Daging", 2804, 2},
	{"Umpan", 19566, 2},
	{"Phone", 18867, 3},
	{"Phone_Book", 18867, 3},
	{"FirstAid", 11738, 2},

	{"Jus", 1546, 1},
	{"Susu_Mentah", 19570, 2},
	{"Susu_Sapi", 19569, 2},
	{"Minyak", 2969, 3},
	{"Essence", 3015, 1},
	{"Nasgor", 2663, 1},
	{"Jus", 1546, 1},
	{"Sampah", 1265, 1},
	("Batu", 905, 3),
	("Jerigen", 1650, 3),
	("Batu_Cucian", 2936, 2),
	("Emas", 19941, 4),
	("Besi", 1519, 4),
	("Aluminium", 19809, 4),
	("Component", 3096, 4),
	{"Ayam", 16776, 2},
	{"Paket_Ayam", 19566, 2},
	{"Ayam_Potong", 2806, 2},
	{"Susu_Mentah", 19570, 1},
	("Perban", 11736, 4),
	("Rokok", 3027, 4),
	("Obat_Stress", 1241, 4),
	("GPS", 18867, 4),

	{"Worm", 902, 2},

	{"Baking_Soda", 2821, 3},
	{"Asam_Muriatic", 19573, 3},
	{"Uang_Kotor", 1575, 3},
	{"Seed", 859, 2},
	{"Pot", 860, 3},
	{"Ephedrine", 19473, 1},
	{"Meth", 1579, 2},
	{"Materials", 2041, 2},
	{"Vest", 1242, 2}

};
stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
			InventoryData[playerid][i][invAmount] = 0;
		}
	}
	return 1;
}

stock Inventory_GetItemID(playerid, item[])
{
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 20)
		return -1;

	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
    new count;

    for(new i = 0; i < MAX_INVENTORY; i++) if (InventoryData[playerid][i][invExists]) {
        count++;
	}
	return count;
}
stock Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invAmount];

	return 0;
}

stock PlayerHasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_Set(playerid, item[], model, amount, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Addset(playerid, item, model, amount, totalquantity);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount, totalquantity);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

stock Inventory_SetQuantity(playerid, item[], quantity, totalquantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    InventoryData[playerid][itemid][invAmount] = quantity;
	    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
	}
	return 1;
}

stock Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	{
	    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
		    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
		    if (InventoryData[playerid][itemid][invAmount] > 0 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
		    {
		        InventoryData[playerid][itemid][invAmount] -= quantity;
		        InventoryData[playerid][itemid][invTotalQuantity] -= totalquantity;
			}
			if (quantity == -1 || InventoryData[playerid][itemid][invTotalQuantity] < 1 || totalquantity == -1 || InventoryData[playerid][itemid][invAmount] < 1)
			{
			    InventoryData[playerid][itemid][invExists] = false;
			    InventoryData[playerid][itemid][invModel] = 0;
			    InventoryData[playerid][itemid][invAmount] = 0;
			    InventoryData[playerid][itemid][invTotalQuantity] = 0;
			}
			else if (quantity != -1 && InventoryData[playerid][itemid][invAmount] > 0 && totalquantity != -1 && InventoryData[playerid][itemid][invTotalQuantity] > 0)
			{
			    InventoryData[playerid][itemid][invAmount] = quantity;
			    InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
			}
		}
		return 1;
	}
	return 0;
}
stock Inventory_Addset(playerid, item[], model, amount = 1, totalquantity)
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);
	    if (itemid != -1)
	    {
	   		InventoryData[playerid][itemid][invExists] = true;
		    InventoryData[playerid][itemid][invModel] = model;
			InventoryData[playerid][itemid][invAmount] = amount;
			InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;

		    strpack(InventoryData[playerid][itemid][invItem], item, 32 char);
		    return itemid;
		}
		return -1;
	}
	else
	{
		InventoryData[playerid][itemid][invAmount] += amount;
		InventoryData[playerid][itemid][invTotalQuantity] += totalquantity;
	}
	return itemid;
}

stock Inventory_Add(playerid, item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);

	    if (itemid != -1)
	    {
         	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
			{
			    new totalquantity = g_aInventoryItems[i][e_InventoryTotal];
     	 	  	InventoryData[playerid][itemid][invExists] = true;
		        InventoryData[playerid][itemid][invModel] = model;
				InventoryData[playerid][itemid][invAmount] = model;
				InventoryData[playerid][itemid][invTotalQuantity] = totalquantity;
		        return itemid;
			}
		}
		return -1;
	}
	return itemid;
}
stock Inventory_Close(playerid)
{
	if(BukaInven[playerid] == 0)
		return Error(playerid, "Kamu Belum Membuka Inventory.");

	CancelSelectTextDraw(playerid);
	pData[playerid][pSelectItem] = -1;
	pData[playerid][pGiveAmount] = 0;
	BukaInven[playerid] = 0;
	for(new i = 0; i < 20; i++){
		PlayerTextDrawHide(playerid, MAIN[playerid][i]);
	}
	PlayerTextDrawSetString(playerid, MAIN[playerid][15], "Jumlah");
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		PlayerTextDrawHide(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawColor(playerid, INDEXTD[playerid][i], -1607729921); //
		PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
		PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
		PlayerTextDrawHide(playerid, GARISBAWAH[playerid][i]);
	}
	return 1;
}

stock Inventory_Show(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	new str[256], string[256], totalall;
	format(str,1000,"%s", GetName(playerid));
	PlayerTextDrawSetString(playerid, MAIN[playerid][11], str);
	BarangMasuk(playerid);
	BukaInven[playerid] = 1;
	PlayerPlaySound(playerid, 1039, 0,0,0);
	SelectTextDraw(playerid, COLOR_LBLUE);
	for(new i = 0; i < 20; i++){
		PlayerTextDrawShow(playerid, MAIN[playerid][i]);
	}
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    PlayerTextDrawShow(playerid, INDEXTD[playerid][i]);
		PlayerTextDrawShow(playerid, AMOUNTTD[playerid][i]);
		totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "Quantity_:_%.1f/850.0", float(totalall));
		PlayerTextDrawSetString(playerid, MAIN[playerid][12], str);
		if(InventoryData[playerid][i][invExists])
		{
			PlayerTextDrawShow(playerid, NAMETD[playerid][i]);
			PlayerTextDrawShow(playerid, GARISBAWAH[playerid][i]);
			PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][i], InventoryData[playerid][i][invModel]);
			//sesuakian dengan object item kalian
			if(InventoryData[playerid][i][invModel] == 18867)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], -254.000000, 0.000000, 0.000000, 2.779998);
			}
			else if(InventoryData[playerid][i][invModel] == 16776)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -85.000000, 1.000000);
			}
			else if(InventoryData[playerid][i][invModel] == 1581)
			{
				PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][i], 0.000000, 0.000000, -180.000000, 1.000000);
			}
			PlayerTextDrawShow(playerid, MODELTD[playerid][i]);
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%dx", InventoryData[playerid][i][invAmount]);
			PlayerTextDrawSetString(playerid, AMOUNTTD[playerid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
		}
	}
	return 1;
}
function OnPlayerGiveInvItem(playerid, userid, itemid, name[], value)
{
	new str[500], string[500];
	if(Inventory_Count(playerid, string) < pData[playerid][pGiveAmount])
		return Error(playerid, "KESALAHAN: Barang Kamu Tidak Mencukupi !");
		
	if(!strcmp(name, "Uang", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Uang", str, 1212, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Uang", str, 1212, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		
        GivePlayerMoneyEx(playerid, -value);
        GivePlayerMoneyEx(userid, value);
	}
	else if(!strcmp(name, "Kanabis", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kanabis", str, 800, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Kanabis", str, 800, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pKanabis] -= value;
		pData[userid][pKanabis] += value;
	}
	else if(!strcmp(name, "Botol", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Botol", str, 1486, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Botol", str, 1486, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBotol] -= value;
		pData[userid][pBotol] += value;
	}
	else if(!strcmp(name, "Marijuana", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Marijuana", str, 1578, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Marijuana", str, 1578, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMarijuana] -= value;
		pData[userid][pMarijuana] += value;
	}
	else if(!strcmp(name, "Sampah", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Sampah", str, 1265, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Sampah", str, 1265, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][sampahsaya] -= value;
		pData[userid][sampahsaya] += value;
	}
	else if(!strcmp(name, "Jerigen", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Jerigen", str, 1650, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Jerigen", str, 1650, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pGas] -= value;
		pData[userid][pGas] += value;
	}
	else if(!strcmp(name, "Paket_Ayam", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Paket_Ayam", str, 19566, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Paket_Ayam", str, 19566, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][AyamFillet] -= value;
		pData[userid][AyamFillet] += value;
	}
	else if(!strcmp(name, "Susu_Mentah", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Susu_Mentah", str, 19570, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Susu_Mentah", str, 19570, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSusu] -= value;
		pData[userid][pSusu] += value;
	}
	else if(!strcmp(name, "Worm", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Umpan", str, 902, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Umpan", str, 902, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pWorm] -= value;
		pData[userid][pWorm] += value;
	}
	else if(!strcmp(name, "Ayam", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ayam", str, 19638, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Ayam", str, 19638, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][AyamHidup] -= value;
		pData[userid][AyamHidup] += value;
	}
	else if(!strcmp(name, "Bahan_Mentah", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bahan", str, 16776, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Bahan", str, 16776, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pFood] -= value;
		pData[userid][pFood] += value;
	}
	else if(!strcmp(name, "Ayam_Potong", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ayam_Potong", str, 2806, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Ayam_Potong", str, 2806, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][AyamPotong] -= value;
		pData[userid][AyamPotong] += value;
	}
	else if(!strcmp(name, "Susu_Sapi", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Susu_Sapi", str, 19569, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Susu_Sapi", str, 19569, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSusuOlahan] -= value;
		pData[userid][pSusuOlahan] += value;
	}
	else if(!strcmp(name, "Pakaian", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Pakaian", str, 11741, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Pakaian", str, 11741, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pPakaian] -= value;
		pData[userid][pPakaian] += value;
	}
	else if(!strcmp(name, "Water", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Water", str, 2958, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Water", str, 2958, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSprunk] -= value;
		pData[userid][pSprunk] += value;
	}
	else if(!strcmp(name, "Starling", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Starling", str, 1455, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Starling", str, 1455, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pStarling] -= value;
		pData[userid][pStarling] += value;
	}
	else if(!strcmp(name, "Steak", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Steak", str, 19811, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Steak", str, 19811, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSteak] -= value;
		pData[userid][pSteak] += value;
	}
	else if(!strcmp(name, "Vest", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Vest", str, 1242, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Vest", str, 1242, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pVest] -= value;
		pData[userid][pVest] += value;
	}
	else if(!strcmp(name, "Batu", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Batu", str, 905, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Batu", str, 905, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBatu] -= value;
		pData[userid][pBatu] += value;
	}
	else if(!strcmp(name, "Milx_Max", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Milx_Max", str, 19570, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Milx_Max", str, 19570, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMilxMax] -= value;
		pData[userid][pMilxMax] += value;
	}
	else if(!strcmp(name, "Snack", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Snack", str, 2821, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Snack", str, 2821, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pSnack] -= value;
		pData[userid][pSnack] += value;
	}
	else if(!strcmp(name, "Roti", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Roti", str, 19883, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Roti", str, 19883, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pRoti] -= value;
		pData[userid][pRoti] += value;
	}
	else if(!strcmp(name, "Kebab", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kebab", str, 2769, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Kebab", str, 2769, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pKebab] -= value;
		pData[userid][pKebab] += value;
	}
	else if(!strcmp(name, "Cappucino", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Cappucino", str, 19835, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Cappucino", str, 19835, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pCappucino] -= value;
		pData[userid][pCappucino] += value;
	}
	else if(!strcmp(name, "Emas", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Emas", str, 19941, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Emas", str, 19941, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pEmas] -= value;
		pData[userid][pEmas] += value;
	}
	else if(!strcmp(name, "Aluminium", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Aluminium", str, 19809, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Aluminium", str, 19809, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pAluminium] -= value;
		pData[userid][pAluminium] += value;
	}
	else if(!strcmp(name, "Perban", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Perban", str, 11736, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Perban", str, 11736, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBandage] -= value;
		pData[userid][pBandage] += value;
	}
	else if(!strcmp(name, "Rokok", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Rokok", str, 1241, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Rokok", str, 1241, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pRokok] -= value;
		pData[userid][pRokok] += value;
	}
	else if(!strcmp(name, "Obat_Stress", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Obat_Stress", str, 1241, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Obat_Stress", str, 1241, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pObatStress] -= value;
		pData[userid][pObatStress] += value;
	}
	else if(!strcmp(name, "Besi", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Besi", str, 1510, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Besi", str, 1510, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pBesi] -= value;
		pData[userid][pBesi] += value;
	}
	else if(!strcmp(name, "Minyak", true))
	{
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Minyak", str, 2969, 2);

		format(str, sizeof(str), "Received_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(userid, "Minyak", str, 2969, 2);

		ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);
		ApplyAnimation(userid, "DEALER", "shop_pay", 4.1, 0, 1, 1, 0, 0, 1);

		pData[playerid][pMinyak] -= value;
		pData[userid][pMinyak] += value;
	}
	return Inventory_Close(playerid);
}
forward OnPlayerUseItem(playerid, itemid, name[]);
public OnPlayerUseItem(playerid, itemid, name[])
{
	if(!strcmp(name, "Snack"))
	{
	    callcmd::eatsnack(playerid, "");
	}
	else if(!strcmp(name, "Kebab"))
	{
	    callcmd::eatkebab(playerid, "");
	}
	else if(!strcmp(name, "Roti"))
	{
	    callcmd::eatroti(playerid, "");
	}
	else if(!strcmp(name, "Water"))
	{
	    callcmd::drinkwater(playerid, "");
	}
	else if(!strcmp(name, "Kentucky"))
	{
	    callcmd::chiken(playerid, "");
	}
	else if(!strcmp(name, "Cappucino"))
	{
	    callcmd::drinkcappucino(playerid, "");
	}
	else if(!strcmp(name, "Starling"))
	{
	    callcmd::drinkstarling(playerid, "");
	}
	else if(!strcmp(name, "Milx_Max"))
	{
	    callcmd::drinkmilk(playerid, "");
	}
	else if(!strcmp(name, "Steak"))
	{
	    callcmd::steak(playerid, "");
	}
	else if(!strcmp(name, "Ktp"))
	{
	    callcmd::ktp(playerid, "");
	}
	else if(!strcmp(name, "Marijuana"))
	{
	    ShowProgressbar(playerid, "Menggunakan Marijuana..", 5);
	    ApplyAnimation(playerid,"SMOKING","M_smk_in",4.0, 1, 0, 0, 0, 0, 1);
	    
		pData[playerid][pMarijuana] -= 1;
		pData[playerid][pArmour] += 5.0;

		SetPlayerArmour(playerid, pData[playerid][pArmour]);

		new string[128];
		format(string, sizeof(string), "%s Menggunakan Marijuana.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 		ShowItemBox(playerid, "Marijuana", "Menggunakan_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Jerigen"))
	{
	    new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
		if(vehicleid == INVALID_VEHICLE_ID) return Error(playerid, "Anda tidak berada di dekat kendaraan apapun.");
		if(GetVehicleFuel(vehicleid) >= 49)
			return Error(playerid, "Bahan bakar kendaraan tidak bisa lebih dari 100 liter.");
		new fuels = GetVehicleFuel(vehicleid);
		SetPlayerAttachedObject(playerid, 3, 1650, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		ShowProgressbar(playerid, "Mengisi Bensin Kendaraan..", 8);
		ApplyAnimation(playerid,"BD_FIRE","wash_up",4.0, 1, 0, 0, 0, 0, 1);
		ShowItemBox(playerid, "Jerigen", "Removed_1x", 1650, 4);
		SetVehicleFuel(vehicleid, fuels+50);
		pData[playerid][pGas] --;
	}
	else if(!strcmp(name, "Uang"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "botol"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Susu_Mentah"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Worm"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Susu_Sapi"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Ayam_Potong"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Ayam"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Sampah"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Batu_Cucian"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Padi_Olahan"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Penyu"))
	{
	    Error(playerid, "Anda tidak dapat memakan ini");
	}
	else if(!strcmp(name, "Blue_Fish"))
	{
	    Error(playerid, "Anda tidak bisa memakan ikan mentah");
	}
	else if(!strcmp(name, "Nemo"))
	{
	    Error(playerid, "Anda tidak bisa memakan ikan mentah");
	}
	else if(!strcmp(name, "Ikan_Makarel"))
	{
	    Error(playerid, "Anda tidak bisa memakan ikan mentah");
	}
	else if(!strcmp(name, "Cabai"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Padi"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Jagung"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Tebu"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Sambal"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Tepung"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Gula"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Bibit_Cabai"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Bibit_Jagung"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Bibit_Tebu"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Bibit_Padi"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Gula"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Emas"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Component"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Batu"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Minyak"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Essence"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Pakaian"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Kain"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Wool"))
	{
	    Error(playerid, "Item Ini Tidak Dapat Digunakan");
	}
	else if(!strcmp(name, "Vest"))
	{
	    ShowProgressbar(playerid, "Menggunakan vest..", 5);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0, 1);

		pData[playerid][pVest] -= 1;
		pData[playerid][pArmour] = 100.0;

		SetPlayerArmourEx(playerid, pData[playerid][pArmour]);

		new string[128];
		format(string, sizeof(string), "> %s Menggunakan vestnya.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
		
 		ShowItemBox(playerid, "Vest", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Perban"))
	{
	    if(pData[playerid][pHealth] > 90) return Error(playerid, "Anda tidak bisa memakai perban saat ini!");
		pData[playerid][pBandage] -= 1;
		ShowProgressbar(playerid, "Menggunakan perban..", 7);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0, 1);

		pData[playerid][pHealth] += 20.0;

		SetPlayerHealth(playerid, pData[playerid][pHealth]);

		new string[128];
		format(string, sizeof(string), "> %s Menggunakan perban.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 		ShowItemBox(playerid, "Perban", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	else if(!strcmp(name, "Rokok"))
	{
	    //if(pData[playerid][pBladder] < 50) return Error(playerid, "Anda sedang tidak stress");
		callcmd::smoke(playerid, "");
	}
	else if(!strcmp(name, "Obat_Stress"))
	{
	    //if(pData[playerid][pBladder] < 50) return Error(playerid, "Anda sedang tidak stress");
		pData[playerid][pObatStress] -= 1;
		ShowProgressbar(playerid, "Menggunakan obat stress..", 5);
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
		pData[playerid][pBladder] += 50.0;

		new string[128];
		format(string, sizeof(string), "> %s Menggunakan obat stress.", GetRPName(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 		ShowItemBox(playerid, "Obat_Stress", "Used_1x", InventoryData[playerid][itemid][invModel], 2);
		Inventory_Close(playerid);
	}
	return 1;
}

stock CreatePlayerInv(playerid)
{
    MAIN[playerid][0] = CreatePlayerTextDraw(playerid, 113.000, 155.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][0], 185.000, 191.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][0], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][0], -1375784961);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][0], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][0], 1);

	MAIN[playerid][1] = CreatePlayerTextDraw(playerid, 115.000, 157.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][1], 181.000, 186.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][1], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][1], 741092607);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][1], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][1], 1);

	MAIN[playerid][2] = CreatePlayerTextDraw(playerid, 309.000, 173.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][2], 56.000, 132.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][2], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][2], -1375784961);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][2], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][2], 1);

	MAIN[playerid][3] = CreatePlayerTextDraw(playerid, 311.000, 175.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][3], 52.000, 128.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][3], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][3], 741092607);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][3], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][3], 1);

	MAIN[playerid][4] = CreatePlayerTextDraw(playerid, 312.000, 190.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][4], 50.000, 18.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][4], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][4], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][4], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, MAIN[playerid][4], 1);

	MAIN[playerid][5] = CreatePlayerTextDraw(playerid, 312.000, 210.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][5], 50.000, 18.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][5], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][5], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][5], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, MAIN[playerid][5], 1);

	MAIN[playerid][6] = CreatePlayerTextDraw(playerid, 312.000, 230.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][6], 50.000, 18.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][6], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][6], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][6], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, MAIN[playerid][6], 1);

	MAIN[playerid][7] = CreatePlayerTextDraw(playerid, 312.000, 251.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][7], 50.000, 18.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][7], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][7], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][7], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, MAIN[playerid][7], 1);

	MAIN[playerid][8] = CreatePlayerTextDraw(playerid, 312.000, 279.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][8], 50.000, 18.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][8], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][8], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][8], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, MAIN[playerid][8], 1);

	MAIN[playerid][9] = CreatePlayerTextDraw(playerid, 312.000, 299.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][9], 50.000, 3.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][9], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][9], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][9], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][9], 1);

	MAIN[playerid][10] = CreatePlayerTextDraw(playerid, 115.000, 174.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, MAIN[playerid][10], 181.000, 3.000);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][10], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][10], -1607729921);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][10], 255);
	PlayerTextDrawFont(playerid, MAIN[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][10], 1);

	MAIN[playerid][11] = CreatePlayerTextDraw(playerid, 116.000, 159.000, "Emmanuel Joerend");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][11], 0.209, 0.999);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][11], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][11], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][11], 1);

	MAIN[playerid][12] = CreatePlayerTextDraw(playerid, 215.000, 159.000, "Quantity : 19.0/850.0");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][12], 0.209, 0.999);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][12], 1);
	PlayerTextDrawColor(playerid, MAIN[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][12], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][12], 1);

	MAIN[playerid][13] = CreatePlayerTextDraw(playerid, 207.000, 334.000, "Warga Kota");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][13], 0.179, 0.796);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][13], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][13], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][13], 1);

	MAIN[playerid][14] = CreatePlayerTextDraw(playerid, 338.000, 177.000, "WARGAKOTA");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][14], 0.209, 0.999);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][14], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][14], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][14], 1);

	MAIN[playerid][15] = CreatePlayerTextDraw(playerid, 337.000, 193.000, "Jumlah");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][15], 0.218, 1.098);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][15], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][15], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][15], 1);

	MAIN[playerid][16] = CreatePlayerTextDraw(playerid, 338.000, 213.000, "Gunakan");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][16], 0.218, 1.098);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][16], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][16], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][16], 1);

	MAIN[playerid][17] = CreatePlayerTextDraw(playerid, 338.000, 233.000, "Berikan");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][17], 0.218, 1.098);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][17], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][17], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][17], 1);

	MAIN[playerid][18] = CreatePlayerTextDraw(playerid, 338.000, 254.000, "Buang");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][18], 0.218, 1.098);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][18], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][18], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][18], 1);

	MAIN[playerid][19] = CreatePlayerTextDraw(playerid, 338.000, 281.000, "Tutup");
	PlayerTextDrawLetterSize(playerid, MAIN[playerid][19], 0.218, 1.098);
	PlayerTextDrawAlignment(playerid, MAIN[playerid][19], 2);
	PlayerTextDrawColor(playerid, MAIN[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, MAIN[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, MAIN[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, MAIN[playerid][19], 150);
	PlayerTextDrawFont(playerid, MAIN[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, MAIN[playerid][19], 1);

	INDEXTD[playerid][0] = CreatePlayerTextDraw(playerid, 116.000, 181.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][0], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][0], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][0], 1);

	INDEXTD[playerid][1] = CreatePlayerTextDraw(playerid, 152.000, 181.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][1], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][1], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][1], 1);

	INDEXTD[playerid][2] = CreatePlayerTextDraw(playerid, 188.000, 181.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][2], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][2], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][2], 1);

	INDEXTD[playerid][3] = CreatePlayerTextDraw(playerid, 224.000, 181.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][3], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][3], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][3], 1);

	INDEXTD[playerid][4] = CreatePlayerTextDraw(playerid, 260.000, 181.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][4], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][4], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][4], 1);

	INDEXTD[playerid][5] = CreatePlayerTextDraw(playerid, 260.000, 220.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][5], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][5], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][5], 1);

	INDEXTD[playerid][6] = CreatePlayerTextDraw(playerid, 224.000, 220.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][6], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][6], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][6], 1);

	INDEXTD[playerid][7] = CreatePlayerTextDraw(playerid, 188.000, 220.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][7], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][7], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][7], 1);

	INDEXTD[playerid][8] = CreatePlayerTextDraw(playerid, 152.000, 220.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][8], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][8], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][8], 1);

	INDEXTD[playerid][9] = CreatePlayerTextDraw(playerid, 116.000, 220.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][9], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][9], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][9], 1);

	INDEXTD[playerid][10] = CreatePlayerTextDraw(playerid, 116.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][10], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][10], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][10], 1);

	INDEXTD[playerid][11] = CreatePlayerTextDraw(playerid, 152.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][11], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][11], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][11], 1);

	INDEXTD[playerid][12] = CreatePlayerTextDraw(playerid, 188.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][12], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][12], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][12], 1);

	INDEXTD[playerid][13] = CreatePlayerTextDraw(playerid, 224.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][13], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][13], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][13], 1);

	INDEXTD[playerid][14] = CreatePlayerTextDraw(playerid, 260.000, 259.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][14], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][14], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][14], 1);

	INDEXTD[playerid][15] = CreatePlayerTextDraw(playerid, 260.000, 299.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][15], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][15], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][15], 1);

	INDEXTD[playerid][16] = CreatePlayerTextDraw(playerid, 224.000, 299.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][16], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][16], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][16], 1);

	INDEXTD[playerid][17] = CreatePlayerTextDraw(playerid, 188.000, 299.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][17], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][17], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][17], 1);

	INDEXTD[playerid][18] = CreatePlayerTextDraw(playerid, 152.000, 299.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][18], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][18], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][18], 1);

	INDEXTD[playerid][19] = CreatePlayerTextDraw(playerid, 116.000, 299.000, "LD_BUM:blkdot");
	PlayerTextDrawTextSize(playerid, INDEXTD[playerid][19], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, INDEXTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][19], -1607729921);
	PlayerTextDrawSetShadow(playerid, INDEXTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, INDEXTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, INDEXTD[playerid][19], 255);
	PlayerTextDrawFont(playerid, INDEXTD[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, INDEXTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, INDEXTD[playerid][19], 1);

	GARISBAWAH[playerid][0] = CreatePlayerTextDraw(playerid, 116.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][0], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][0], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][0], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][0], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][0], 1);

	GARISBAWAH[playerid][1] = CreatePlayerTextDraw(playerid, 152.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][1], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][1], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][1], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][1], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][1], 1);

	GARISBAWAH[playerid][2] = CreatePlayerTextDraw(playerid, 188.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][2], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][2], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][2], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][2], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][2], 1);

	GARISBAWAH[playerid][3] = CreatePlayerTextDraw(playerid, 224.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][3], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][3], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][3], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][3], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][3], 1);

	GARISBAWAH[playerid][4] = CreatePlayerTextDraw(playerid, 260.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][4], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][4], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][4], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][4], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][4], 1);

	GARISBAWAH[playerid][5] = CreatePlayerTextDraw(playerid, 260.000, 213.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][5], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][5], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][5], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][5], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][5], 1);

	GARISBAWAH[playerid][6] = CreatePlayerTextDraw(playerid, 260.000, 252.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][6], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][6], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][6], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][6], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][6], 1);

	GARISBAWAH[playerid][7] = CreatePlayerTextDraw(playerid, 224.000, 252.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][7], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][7], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][7], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][7], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][7], 1);

	GARISBAWAH[playerid][8] = CreatePlayerTextDraw(playerid, 188.000, 252.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][8], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][8], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][8], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][8], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][8], 1);

	GARISBAWAH[playerid][9] = CreatePlayerTextDraw(playerid, 152.000, 252.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][9], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][9], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][9], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][9], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][9], 1);

	GARISBAWAH[playerid][10] = CreatePlayerTextDraw(playerid, 116.000, 252.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][10], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][10], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][10], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][10], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][10], 1);

	GARISBAWAH[playerid][11] = CreatePlayerTextDraw(playerid, 116.000, 291.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][11], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][11], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][11], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][11], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][11], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][11], 1);

	GARISBAWAH[playerid][12] = CreatePlayerTextDraw(playerid, 152.000, 291.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][12], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][12], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][12], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][12], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][12], 1);

	GARISBAWAH[playerid][13] = CreatePlayerTextDraw(playerid, 188.000, 291.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][13], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][13], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][13], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][13], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][13], 1);

	GARISBAWAH[playerid][14] = CreatePlayerTextDraw(playerid, 224.000, 291.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][14], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][14], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][14], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][14], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][14], 1);

	GARISBAWAH[playerid][15] = CreatePlayerTextDraw(playerid, 260.000, 291.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][15], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][15], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][15], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][15], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][15], 1);

	GARISBAWAH[playerid][16] = CreatePlayerTextDraw(playerid, 260.000, 331.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][16], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][16], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][16], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][16], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][16], 1);

	GARISBAWAH[playerid][17] = CreatePlayerTextDraw(playerid, 224.000, 331.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][17], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][17], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][17], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][17], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][17], 1);

	GARISBAWAH[playerid][18] = CreatePlayerTextDraw(playerid, 188.000, 331.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][18], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][18], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][18], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][18], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][18], 1);

	GARISBAWAH[playerid][19] = CreatePlayerTextDraw(playerid, 152.000, 331.000, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GARISBAWAH[playerid][19], 34.000, 3.000);
	PlayerTextDrawAlignment(playerid, GARISBAWAH[playerid][19], 1);
	PlayerTextDrawColor(playerid, GARISBAWAH[playerid][19], -1375784961);
	PlayerTextDrawSetShadow(playerid, GARISBAWAH[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, GARISBAWAH[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, GARISBAWAH[playerid][19], 255);
	PlayerTextDrawFont(playerid, GARISBAWAH[playerid][19], 4);
	PlayerTextDrawSetProportional(playerid, GARISBAWAH[playerid][19], 1);

	AMOUNTTD[playerid][0] = CreatePlayerTextDraw(playerid, 117.000, 206.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][0], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][0], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][0], 1);

	AMOUNTTD[playerid][1] = CreatePlayerTextDraw(playerid, 153.000, 206.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][1], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][1], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][1], 1);

	AMOUNTTD[playerid][2] = CreatePlayerTextDraw(playerid, 189.000, 206.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][2], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][2], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][2], 1);

	AMOUNTTD[playerid][3] = CreatePlayerTextDraw(playerid, 225.000, 206.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][3], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][3], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][3], 1);

	AMOUNTTD[playerid][4] = CreatePlayerTextDraw(playerid, 261.000, 206.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][4], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][4], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][4], 1);

	AMOUNTTD[playerid][5] = CreatePlayerTextDraw(playerid, 261.000, 245.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][5], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][5], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][5], 1);

	AMOUNTTD[playerid][6] = CreatePlayerTextDraw(playerid, 224.000, 245.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][6], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][6], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][6], 1);

	AMOUNTTD[playerid][7] = CreatePlayerTextDraw(playerid, 188.000, 245.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][7], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][7], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][7], 1);

	AMOUNTTD[playerid][8] = CreatePlayerTextDraw(playerid, 153.000, 245.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][8], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][8], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][8], 1);

	AMOUNTTD[playerid][9] = CreatePlayerTextDraw(playerid, 117.000, 245.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][9], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][9], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][9], 1);

	AMOUNTTD[playerid][10] = CreatePlayerTextDraw(playerid, 117.000, 284.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][10], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][10], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][10], 1);

	AMOUNTTD[playerid][11] = CreatePlayerTextDraw(playerid, 153.000, 284.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][11], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][11], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][11], 1);

	AMOUNTTD[playerid][12] = CreatePlayerTextDraw(playerid, 189.000, 284.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][12], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][12], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][12], 1);

	AMOUNTTD[playerid][13] = CreatePlayerTextDraw(playerid, 225.000, 284.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][13], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][13], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][13], 1);

	AMOUNTTD[playerid][14] = CreatePlayerTextDraw(playerid, 261.000, 284.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][14], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][14], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][14], 1);

	AMOUNTTD[playerid][15] = CreatePlayerTextDraw(playerid, 261.000, 324.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][15], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][15], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][15], 1);

	AMOUNTTD[playerid][16] = CreatePlayerTextDraw(playerid, 225.000, 324.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][16], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][16], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][16], 1);

	AMOUNTTD[playerid][17] = CreatePlayerTextDraw(playerid, 189.000, 324.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][17], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][17], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][17], 1);

	AMOUNTTD[playerid][18] = CreatePlayerTextDraw(playerid, 153.000, 324.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][18], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][18], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][18], 1);

	AMOUNTTD[playerid][19] = CreatePlayerTextDraw(playerid, 116.000, 324.000, "100x");
	PlayerTextDrawLetterSize(playerid, AMOUNTTD[playerid][19], 0.149, 0.597);
	PlayerTextDrawAlignment(playerid, AMOUNTTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, AMOUNTTD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, AMOUNTTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, AMOUNTTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, AMOUNTTD[playerid][19], 150);
	PlayerTextDrawFont(playerid, AMOUNTTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, AMOUNTTD[playerid][19], 1);

	

	MODELTD[playerid][0] = CreatePlayerTextDraw(playerid, 116.000, 181.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][0], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][0], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][0], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][0], 0, 0);

	MODELTD[playerid][1] = CreatePlayerTextDraw(playerid, 152.000, 181.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][1], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][1], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][1], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][1], 0, 0);

	MODELTD[playerid][2] = CreatePlayerTextDraw(playerid, 188.000, 181.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][2], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][2], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][2], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][2], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][2], 0, 0);

	MODELTD[playerid][3] = CreatePlayerTextDraw(playerid, 224.000, 181.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][3], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][3], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][3], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][3], 0, 0);

	MODELTD[playerid][4] = CreatePlayerTextDraw(playerid, 260.000, 181.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][4], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][4], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][4], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][4], 0, 0);

	MODELTD[playerid][5] = CreatePlayerTextDraw(playerid, 260.000, 220.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][5], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][5], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][5], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][5], 0, 0);

	MODELTD[playerid][6] = CreatePlayerTextDraw(playerid, 224.000, 220.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][6], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][6], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][6], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][6], 0, 0);

	MODELTD[playerid][7] = CreatePlayerTextDraw(playerid, 188.000, 220.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][7], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][7], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][7], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][7], 0, 0);

	MODELTD[playerid][8] = CreatePlayerTextDraw(playerid, 152.000, 220.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][8], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][8], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][8], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][8], 0, 0);

	MODELTD[playerid][9] = CreatePlayerTextDraw(playerid, 116.000, 220.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][9], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][9], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][9], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][9], 0, 0);

	MODELTD[playerid][10] = CreatePlayerTextDraw(playerid, 116.000, 259.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][10], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][10], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][10], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][10], 0, 0);

	MODELTD[playerid][11] = CreatePlayerTextDraw(playerid, 152.000, 259.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][11], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][11], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][11], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][11], 0, 0);

	MODELTD[playerid][12] = CreatePlayerTextDraw(playerid, 188.000, 259.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][12], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][12], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][12], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][12], 0, 0);

	MODELTD[playerid][13] = CreatePlayerTextDraw(playerid, 224.000, 259.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][13], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][13], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][13], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][13], 0, 0);

	MODELTD[playerid][14] = CreatePlayerTextDraw(playerid, 260.000, 259.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][14], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][14], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][14], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][14], 0, 0);

	MODELTD[playerid][15] = CreatePlayerTextDraw(playerid, 260.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][15], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][15], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][15], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][15], 0, 0);

	MODELTD[playerid][16] = CreatePlayerTextDraw(playerid, 224.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][16], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][16], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][16], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][16], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][16], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][16], 0, 0);

	MODELTD[playerid][17] = CreatePlayerTextDraw(playerid, 188.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][17], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][17], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][17], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][17], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][17], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][17], 0, 0);

	MODELTD[playerid][18] = CreatePlayerTextDraw(playerid, 152.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][18], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][18], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][18], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][18], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][18], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][18], 0, 0);

	MODELTD[playerid][19] = CreatePlayerTextDraw(playerid, 116.000, 299.000, "_");
	PlayerTextDrawTextSize(playerid, MODELTD[playerid][19], 34.000, 35.000);
	PlayerTextDrawAlignment(playerid, MODELTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, MODELTD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawFont(playerid, MODELTD[playerid][19], 5);
	PlayerTextDrawSetProportional(playerid, MODELTD[playerid][19], 0);
	PlayerTextDrawSetPreviewModel(playerid, MODELTD[playerid][19], 1212);
	PlayerTextDrawSetPreviewRot(playerid, MODELTD[playerid][19], 0.000, 0.000, 0.000, 1.000);
	PlayerTextDrawSetPreviewVehCol(playerid, MODELTD[playerid][19], 0, 0);

	NAMETD[playerid][0] = CreatePlayerTextDraw(playerid, 117.000, 181.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][0], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][0], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][0], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][0], 1);

	NAMETD[playerid][1] = CreatePlayerTextDraw(playerid, 153.000, 181.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][1], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][1], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][1], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][1], 1);

	NAMETD[playerid][2] = CreatePlayerTextDraw(playerid, 189.000, 181.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][2], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][2], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][2], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][2], 1);

	NAMETD[playerid][3] = CreatePlayerTextDraw(playerid, 225.000, 181.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][3], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][3], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][3], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][3], 1);

	NAMETD[playerid][4] = CreatePlayerTextDraw(playerid, 261.000, 181.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][4], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][4], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][4], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][4], 1);

	NAMETD[playerid][5] = CreatePlayerTextDraw(playerid, 261.000, 220.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][5], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][5], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][5], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][5], 1);

	NAMETD[playerid][6] = CreatePlayerTextDraw(playerid, 225.000, 220.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][6], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][6], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][6], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][6], 1);

	NAMETD[playerid][7] = CreatePlayerTextDraw(playerid, 189.000, 220.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][7], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][7], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][7], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][7], 1);

	NAMETD[playerid][8] = CreatePlayerTextDraw(playerid, 153.000, 220.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][8], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][8], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][8], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][8], 1);

	NAMETD[playerid][9] = CreatePlayerTextDraw(playerid, 117.000, 220.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][9], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][9], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][9], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][9], 1);

	NAMETD[playerid][10] = CreatePlayerTextDraw(playerid, 117.000, 259.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][10], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][10], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][10], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][10], 1);

	NAMETD[playerid][11] = CreatePlayerTextDraw(playerid, 153.000, 259.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][11], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][11], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][11], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][11], 1);

	NAMETD[playerid][12] = CreatePlayerTextDraw(playerid, 189.000, 259.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][12], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][12], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][12], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][12], 1);

	NAMETD[playerid][13] = CreatePlayerTextDraw(playerid, 225.000, 259.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][13], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][13], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][13], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][13], 1);

	NAMETD[playerid][14] = CreatePlayerTextDraw(playerid, 261.000, 259.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][14], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][14], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][14], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][14], 1);

	NAMETD[playerid][15] = CreatePlayerTextDraw(playerid, 261.000, 299.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][15], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][15], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][15], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][15], 1);

	NAMETD[playerid][16] = CreatePlayerTextDraw(playerid, 225.000, 299.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][16], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][16], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][16], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][16], 1);

	NAMETD[playerid][17] = CreatePlayerTextDraw(playerid, 189.000, 299.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][17], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][17], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][17], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][17], 1);

	NAMETD[playerid][18] = CreatePlayerTextDraw(playerid, 153.000, 299.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][18], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][18], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][18], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][18], 1);

	NAMETD[playerid][19] = CreatePlayerTextDraw(playerid, 117.000, 299.000, "Uang");
	PlayerTextDrawLetterSize(playerid, NAMETD[playerid][19], 0.167, 0.796);
	PlayerTextDrawAlignment(playerid, NAMETD[playerid][19], 1);
	PlayerTextDrawColor(playerid, NAMETD[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, NAMETD[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, NAMETD[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, NAMETD[playerid][19], 150);
	PlayerTextDrawFont(playerid, NAMETD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, NAMETD[playerid][19], 1);
	return 1;
}

stock BarangMasuk(playerid)
{
		Inventory_Set(playerid, "Uang", 1212, pData[playerid][pMoney], 2);
		Inventory_Set(playerid, "Batu", 905, pData[playerid][pBatu], pData[playerid][pBatu]);
		Inventory_Set(playerid, "Component", 3096, pData[playerid][pComponent], pData[playerid][pComponent]);
		Inventory_Set(playerid, "Batu_Cucian", 2936, pData[playerid][pBatuCucian], pData[playerid][pBatuCucian]);
		Inventory_Set(playerid, "Emas", 19941, pData[playerid][pEmas], pData[playerid][pEmas]);
		Inventory_Set(playerid, "Aluminium", 19809, pData[playerid][pAluminium], pData[playerid][pAluminium]);
		Inventory_Set(playerid, "Perban", 11736, pData[playerid][pBandage], pData[playerid][pBandage]);
		Inventory_Set(playerid, "Rokok", 3027, pData[playerid][pRokok], pData[playerid][pRokok]);
		Inventory_Set(playerid, "Obat_Stress", 1241, pData[playerid][pObatStress], pData[playerid][pObatStress]);
		Inventory_Set(playerid, "Besi", 1510, pData[playerid][pBesi], pData[playerid][pBesi]);
		Inventory_Set(playerid, "Minyak", 2969, pData[playerid][pMinyak], pData[playerid][pMinyak]);
		Inventory_Set(playerid, "Vest", 1242, pData[playerid][pVest], pData[playerid][pVest]);
		Inventory_Set(playerid, "Essence", 2663, pData[playerid][pEssence], pData[playerid][pEssence]);
		Inventory_Set(playerid, "Jerigen", 1650, pData[playerid][pGas], pData[playerid][pGas]);
		Inventory_Set(playerid, "botol", 1486, pData[playerid][pBotol], pData[playerid][pBotol]);

		//Ikan
		Inventory_Set(playerid, "Penyu", 1609, pData[playerid][pPenyu], pData[playerid][pPenyu]);
		Inventory_Set(playerid, "Blue_Fish", 1604, pData[playerid][pBlueFish], pData[playerid][pBlueFish]);
		Inventory_Set(playerid, "Nemo", 1599, pData[playerid][pNemo], pData[playerid][pNemo]);
		Inventory_Set(playerid, "Ikan_Makarel", 19630, pData[playerid][pMakarel], pData[playerid][pMakarel]);

		//makanan
		Inventory_Set(playerid, "Water", 2958, pData[playerid][pSprunk], pData[playerid][pSprunk]);
		Inventory_Set(playerid, "Kentucky", 19847, pData[playerid][pChiken], pData[playerid][pChiken]);
		Inventory_Set(playerid, "Snack", 2821, pData[playerid][pSnack], pData[playerid][pSnack]);
		Inventory_Set(playerid, "Roti", 19883, pData[playerid][pRoti], pData[playerid][pRoti]);
		Inventory_Set(playerid, "Kebab", 2769, pData[playerid][pKebab], pData[playerid][pKebab]);
		Inventory_Set(playerid, "Starling", 1455, pData[playerid][pStarling], pData[playerid][pStarling]);
		Inventory_Set(playerid, "Cappucino", 19835, pData[playerid][pCappucino], pData[playerid][pCappucino]);
		Inventory_Set(playerid, "Milx_Max", 19570, pData[playerid][pMilxMax], pData[playerid][pMilxMax]);

		//pertanian
		Inventory_Set(playerid, "Bibit_Padi", 862, pData[playerid][pPadi], pData[playerid][pPadi]);
		Inventory_Set(playerid, "Bibit_Cabai", 862, pData[playerid][pCabai], pData[playerid][pCabai]);
		Inventory_Set(playerid, "Bibit_Jagung", 862, pData[playerid][pJagung], pData[playerid][pJagung]);
		Inventory_Set(playerid, "Bibit_Tebu", 862, pData[playerid][pTebu], pData[playerid][pTebu]);
		Inventory_Set(playerid, "Padi", 2901, pData[playerid][pPadiOlahan], pData[playerid][pPadiOlahan]);
		Inventory_Set(playerid, "Jagung", 2901, pData[playerid][pJagungOlahan], pData[playerid][pJagungOlahan]);
		Inventory_Set(playerid, "Tebu", 2901, pData[playerid][pTebuOlahan], pData[playerid][pTebuOlahan]);
		Inventory_Set(playerid, "Cabai", 2901, pData[playerid][pCabaiOlahan], pData[playerid][pCabaiOlahan]);
		Inventory_Set(playerid, "Padi_Olahan", 19638, pData[playerid][pBeras], pData[playerid][pBeras]);
		Inventory_Set(playerid, "Sambal", 19636, pData[playerid][pSambal], pData[playerid][pSambal]);
		Inventory_Set(playerid, "Tepung", 19570, pData[playerid][pTepung], pData[playerid][pTepung]);
		Inventory_Set(playerid, "Gula", 19824, pData[playerid][pGula], pData[playerid][pGula]);
		Inventory_Set(playerid, "Umpan", 902, pData[playerid][pWorm], pData[playerid][pWorm]);

		//barang sehari-hari
		Inventory_Set(playerid, "Ktp", 1581, pData[playerid][pIDCard], pData[playerid][pIDCard]);
		Inventory_Set(playerid, "Steak", 19811, pData[playerid][pSteak], pData[playerid][pSteak]);
		Inventory_Set(playerid, "Marijuana", 1578, pData[playerid][pMarijuana], pData[playerid][pMarijuana]);
		Inventory_Set(playerid, "Kanabis", 800, pData[playerid][pKanabis], pData[playerid][pKanabis]);
		Inventory_Set(playerid, "Kain", 2399, pData[playerid][pKain], pData[playerid][pKain]);
		Inventory_Set(playerid, "Wool", 2751, pData[playerid][pWool], pData[playerid][pWool]);
		Inventory_Set(playerid, "Pakaian", 11741, pData[playerid][pPakaian], pData[playerid][pPakaian]);
		Inventory_Set(playerid, "Sampah", 1265, pData[playerid][sampahsaya], pData[playerid][sampahsaya]);
		Inventory_Set(playerid, "Ayam", 16776, pData[playerid][AyamHidup], pData[playerid][AyamHidup]);
		Inventory_Set(playerid, "Ayam_Potong", 2806, pData[playerid][AyamPotong], pData[playerid][AyamPotong]);
		Inventory_Set(playerid, "Susu_Mentah", 19570, pData[playerid][pSusu], pData[playerid][pSusu]);
		Inventory_Set(playerid, "Susu_Sapi", 19569, pData[playerid][pSusuOlahan], pData[playerid][pSusuOlahan]);
		Inventory_Set(playerid, "Paket_Ayam", 19566, pData[playerid][AyamFillet], pData[playerid][AyamFillet]);
		Inventory_Set(playerid, "Bahan_Mentah", 19638, pData[playerid][pFood], pData[playerid][pFood]);
		Inventory_Update(playerid);
}

stock Inventory_Update(playerid)
{
	new str[256], string[256], totalall;
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
	    totalall += InventoryData[playerid][i][invTotalQuantity];
		format(str, sizeof(str), "Quantity_:_%.1f/850.0", float(totalall));
		PlayerTextDrawSetString(playerid, MAIN[playerid][12], str);
		if(InventoryData[playerid][i][invExists])
		{
			//sesuakian dengan object item kalian
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NAMETD[playerid][i], str);
			format(str, sizeof(str), "%d", InventoryData[playerid][i][invAmount]);
			PlayerTextDrawSetString(playerid, AMOUNTTD[playerid][i], str);
		}
		else
		{
			PlayerTextDrawHide(playerid, AMOUNTTD[playerid][i]);
			PlayerTextDrawHide(playerid, MODELTD[playerid][i]);
			PlayerTextDrawHide(playerid, NAMETD[playerid][i]);
		}
	}
}

stock MenuStore_SelectRow(playerid, row)
{
	pData[playerid][pSelectItem] = row;
    PlayerTextDrawHide(playerid,INDEXTD[playerid][row]);
	PlayerTextDrawColor(playerid, INDEXTD[playerid][row], -7232257);
	PlayerTextDrawShow(playerid,INDEXTD[playerid][row]);
}

stock MenuStore_UnselectRow(playerid)
{
	if(pData[playerid][pSelectItem] != -1)
	{
		new row = pData[playerid][pSelectItem];
		PlayerTextDrawHide(playerid,INDEXTD[playerid][row]);
		PlayerTextDrawColor(playerid, INDEXTD[playerid][row], -1607729921); //859394047
		PlayerTextDrawShow(playerid,INDEXTD[playerid][row]);
	}

	pData[playerid][pSelectItem] = -1;
}