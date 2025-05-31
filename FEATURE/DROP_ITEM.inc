#define MAX_DROPPED_ITEMS 1000

enum droppedItems
{
	droppedID,
	droppedItem[32],
	droppedPlayer[24],
	droppedModel,
	droppedQuantity,
	Float:droppedPos[3],
	droppedWeapon,
	droppedAmmo,
	droppedInt,
	droppedWorld,
	droppedObject,
	Text3D:droppedText3D
};

new DroppedItems[MAX_DROPPED_ITEMS][droppedItems],
	Iterator:DROPPED<MAX_DROPPED_ITEMS>;

function Dropped_Load()
{
	new rows;
	cache_get_row_count(rows);
 	if(rows)
  	{
  		new id, i = 0;
    	while(i < rows)
		{
		    cache_get_value_name_int(i, "ID", id);
			cache_get_value_name(i, "itemName", DroppedItems[id][droppedItem]);
			cache_get_value_name_int(i, "itemModel", DroppedItems[id][droppedModel]);
			cache_get_value_name_int(i, "itemQuantity", DroppedItems[id][droppedQuantity]);
			cache_get_value_name_float(i, "itemX", DroppedItems[id][droppedPos][0]);
			cache_get_value_name_float(i, "itemY", DroppedItems[id][droppedPos][1]);
			cache_get_value_name_float(i, "itemZ", DroppedItems[id][droppedPos][2]);
			cache_get_value_name_int(i, "itemInt", DroppedItems[id][droppedInt]);
			cache_get_value_name_int(i, "itemWorld", DroppedItems[id][droppedWorld]);
			DroppedItems[id][droppedObject] = CreateDynamicObject(DroppedItems[id][droppedModel], DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2], 0.0, 0.0, 0.0, DroppedItems[id][droppedWorld], DroppedItems[id][droppedInt]);
			DroppedItems[id][droppedText3D] = CreateDynamic3DTextLabel(DroppedItems[id][droppedItem], COLOR_LBLUE, DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DroppedItems[id][droppedWorld], DroppedItems[id][droppedInt]);
			Iter_Add(DROPPED, id);
			i++;
		}
		printf("[DROPITEM] Loaded: %d Dropped Items", i);
	}
}

Dropped_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE dropped SET itemName='%s', itemModel='%d', itemQuantity='%d', itemX='%f', itemY='%f', itemZ='%f', itemInt='%d', itemWorld='%d' WHERE ID='%d'",
	DroppedItems[id][droppedItem],
	DroppedItems[id][droppedModel],
	DroppedItems[id][droppedQuantity],
	DroppedItems[id][droppedPos][0],
	DroppedItems[id][droppedPos][1],
	DroppedItems[id][droppedPos][2],
	DroppedItems[id][droppedInt],
	DroppedItems[id][droppedWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

function DropItem(name[], itemid, value, Float:x, Float:y, Float:z, interior, world)
{
	new
	    query[512];

	new id = Iter_Free(DROPPED);
	
    format(DroppedItems[id][droppedItem], 32, name);

	DroppedItems[id][droppedModel] = itemid;
	DroppedItems[id][droppedPos][0] = x;
	DroppedItems[id][droppedPos][1] = y;
	DroppedItems[id][droppedPos][2] = z;
	DroppedItems[id][droppedQuantity] = value;
	DroppedItems[id][droppedInt] = interior;
	DroppedItems[id][droppedWorld] = world;
	printf("DropItem: %d", value);

	DroppedItems[id][droppedObject] = CreateDynamicObject(itemid, x, y, z, 0.0, 0.0, 0.0, world, interior);

	DroppedItems[id][droppedText3D] = CreateDynamic3DTextLabel(name, COLOR_LBLUE, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, world, interior);

	Iter_Add(DROPPED, id);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO dropped SET ID='%d', itemName='%s', itemModel='%d', itemQuantity='%d', itemX='%.4f', itemY='%.4f', itemZ='%.4f', itemInt='%d', itemWorld='%d'", id, name, itemid, value, x, y, z, interior, world);
	mysql_tquery(g_SQL, query, "OnDroppedItem", "d", id);
	return 1;
}

function OnDroppedItem(id)
{
	Dropped_Save(id);
	return 1;
}

function DropPlayerItem(playerid, itemid, name[], value)
{
    new
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		string[32],
		str[20];

	if(Inventory_Count(playerid, string) < pData[playerid][pGiveAmount])
		return ErrorMsg(playerid, "Barang Kamu Tidak Mencukupi!");

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);


	if(!strcmp(name, "Uang", true))
	{
		itemid = 1212;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Uang", str, 1212, 2);
		GivePlayerMoneyEx(playerid, -value);
		//OnPlayerUpdateAccountsPer(playerid, "pCash", pData[playerid][pCash]);
	}
	else if(!strcmp(name, "Water", true))
	{
		itemid = 2958;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Water", str, 2958, 2);
		pData[playerid][pSprunk] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pAir", pData[playerid][pAir]);
	}
	else if(!strcmp(name, "Susu", true))
	{
		itemid = 1546;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Susu", str, 1546, 2);
		pData[playerid][pSusu] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "Susu", pData[playerid][pSusu]);
	}
	else if(!strcmp(name, "Esteh", true))
	{
		itemid = 2647;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "esteh", str, 2647, 2);
		pData[playerid][pEsteh] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pTeh", pData[playerid][pTeh]);
	}
	else if(!strcmp(name, "Nasi kucing", true))
	{
		itemid = 2465;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Nasikucing", str, 2465, 2);
		pData[playerid][pNasikucing] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pNasgor", pData[playerid][pNasikucing]);
	}
	else if(!strcmp(name, "AyamGeprek", true))
	{
		itemid = 2768;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ayamgeprek", str, 2768, 2);
		pData[playerid][pAyamgeprek] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pIkanbakar", pData[playerid][pIkanbakar]);
	}
	else if(!strcmp(name, "Kue", true))
	{
		itemid = 19525;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "kue", str, 19525, 2);
		pData[playerid][pKuerayy] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pPizza", pData[playerid][pPizza]);
	}
	else if(!strcmp(name, "Kopi", true))
	{
		itemid = 19835;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "kopiruq", str, 19835, 2);
		pData[playerid][pKopiruq] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pDagingSapiBakar", pData[playerid][pDagingSapiBakar]);
	}
	else if(!strcmp(name, "Sambal", true))
	{
		itemid = 19636;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Sambal", str, 19636, 2);
		pData[playerid][pSambal] -= value;
		//OnPlayerUpdateAccountsPer(playerid, "pDagingRusaBakar", pData[playerid][pDagingRusaBakar]);
	}
	else if(!strcmp(name, "Beras", true))
	{
		itemid = 19638;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Beras", str, 19638, 2);
		pData[playerid][pBeras] -= value;
	}
	else if(!strcmp(name, "Tepung", true))
	{
		itemid = 19570;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Tepung", str, 19570, 2);
		pData[playerid][pTepung] -= value;
	}
	else if(!strcmp(name, "Snack", true))
	{
		itemid = 2821;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Snack", str, 2821, 2);
		pData[playerid][pSnack] -= value;
	}
	else if(!strcmp(name, "Roti", true))
	{
		itemid = 19883;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Roti", str, 19883, 2);
		pData[playerid][pRoti] -= value;
	}
	else if(!strcmp(name, "Kebab", true))
	{
		itemid = 2769;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kebab", str, 2769, 2);
		pData[playerid][pKebab] -= value;
	}
	else if(!strcmp(name, "Jerigen", true))
	{
		itemid = 1650;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Jerigen", str, 1650, 2);
		pData[playerid][pGas] -= value;
    }
	else if(!strcmp(name, "Sampah", true))
	{
		itemid = 1265;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Sampah", str, 1265, 2);
		pData[playerid][sampahsaya] -= value;
    }
	else if(!strcmp(name, "Marijuana", true))
	{
		itemid = 1578;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Marijuana", str, 1578, 2);
		pData[playerid][pMarijuana] -= value;
	}
	else if(!strcmp(name, "Paket_Ayam", true))
	{
		itemid = 19566;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Paket_Ayam", str, 19566, 2);
		pData[playerid][AyamFillet] -= value;
	}
	else if(!strcmp(name, "Milx_Max", true))
	{
		itemid = 19570;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Milx_Max", str, 19570, 2);
		pData[playerid][pMilxMax] -= value;
    }
    else if(!strcmp(name, "Phone", true))
	{
		itemid = 18867;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Phone", str, 18867, 2);
		pData[playerid][pPhone] -= value;
    }
    else if(!strcmp(name, "Obat_Stress", true))
	{
		itemid = 1241;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Obat_Stress", str, 1241, 2);
		pData[playerid][pObatStress] -= value;
    }
    else if(!strcmp(name, "Seed", true))
	{
		itemid = 1575;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Seed", str, 1575, 2);
		pData[playerid][pSeed] -= value;
    }
    else if(!strcmp(name, "Penyu", true))
	{
		itemid = 1609;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Penyu", str, 1609, 2);
		pData[playerid][pPenyu] -= value;
    }
    else if(!strcmp(name, "Blue_Fish", true))
	{
		itemid = 1604;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Blue_Fish", str, 1604, 2);
		pData[playerid][pBlueFish] -= value;
    }
    else if(!strcmp(name, "Nemo", true))
	{
		itemid = 1599;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Nemo", str, 1599, 2);
		pData[playerid][pNemo] -= value;
    }
    else if(!strcmp(name, "Ikan_Makarel", true))
	{
		itemid = 19630;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ikan_Makarel", str, 19630, 2);
		pData[playerid][pMakarel] -= value;
    }
    else if(!strcmp(name, "Pancingan", true))
	{
		itemid = 18632;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Pancingan", str, 18632, 2);
		pData[playerid][pFishTool] -= value;
    }
    else if(!strcmp(name, "Umpan", true))
	{
		itemid = 1485;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Umpan", str, 1485, 2);
		pData[playerid][pWorm] -= value;
    }
    else if(!strcmp(name, "botol", true))
	{
		itemid = 1486;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "botol", str, 1486, 2);
		pData[playerid][pBotol] -= value;
    }
    else if(!strcmp(name, "Perban", true))
	{
		itemid = 11736;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Perban", str, 11736, 2);
		pData[playerid][pBandage] -= value;
    }
    else if(!strcmp(name, "Ayam", true))
	{
		itemid = 16776;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ayam", str, 16776, 2);
		pData[playerid][AyamHidup] -= value;
    }
    else if(!strcmp(name, "Ayam_Potong", true))
	{
		itemid = 2806;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ayam_Potong", str, 2806, 2);
		pData[playerid][AyamPotong] -= value;
    }
    else if(!strcmp(name, "Cappucino", true))
	{
		itemid = 19835;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Cappucino", str, 19835, 2);
		pData[playerid][pCappucino] -= value;
    }
    else if(!strcmp(name, "FirstAid", true))
	{
		itemid = 11738;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "FirstAid", str, 11738, 2);
		pData[playerid][pMedkit] -= value;
    }
    else if(!strcmp(name, "Batu", true))
	{
		itemid = 905;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Batu", str, 905, 2);
		pData[playerid][pBatu] -= value;
    }
    else if(!strcmp(name, "Batu_Cucian", true))
	{
		itemid = 2936;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Batu_Cucian", str, 2936, 2);
		pData[playerid][pBatuCucian] -= value;
    }
    else if(!strcmp(name, "Emas", true))
	{
		itemid = 19941;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Emas", str, 19941, 2);
		pData[playerid][pEmas] -= value;
    }
    else if(!strcmp(name, "Aluminium", true))
	{
		itemid = 19809;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Aluminium", str, 19809, 2);
		pData[playerid][pAluminium] -= value;
    }
    else if(!strcmp(name, "Besi", true))
	{
		itemid = 1510;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Besi", str, 1510, 2);
		pData[playerid][pBesi] -= value;
    }
    else if(!strcmp(name, "Minyak", true))
	{
		itemid = 2969;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Minyak", str, 2969, 2);
		pData[playerid][pMinyak] -= value;
    }
    else if(!strcmp(name, "Vest", true))
	{
		itemid = 1242;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Vest", str, 1242, 2);
		pData[playerid][pVest] -= value;
    }
    else if(!strcmp(name, "Chiken", true))
	{
		itemid = 19847;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Chiken", str, 19847, 2);
		pData[playerid][pChiken] -= value;
    }
    else if(!strcmp(name, "Starling", true))
	{
		itemid = 1455;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Starling", str, 1455, 2);
		pData[playerid][pStarling] -= value;
    }
    else if(!strcmp(name, "Bibit_Padi", true))
	{
		itemid = 862;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bibit_Padi", str, 862, 2);
		pData[playerid][pPadi] -= value;
    }
    else if(!strcmp(name, "Bibit_Cabai", true))
	{
		itemid = 862;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bibit_Cabai", str, 862, 2);
		pData[playerid][pCabai] -= value;
    }
    else if(!strcmp(name, "Bibit_Jagung", true))
	{
		itemid = 862;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bibit_Jagung", str, 862, 2);
		pData[playerid][pJagung] -= value;
    }
    else if(!strcmp(name, "Bibit_Tebu", true))
	{
		itemid = 862;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Bibit_Tebu", str, 862, 2);
		pData[playerid][pTebu] -= value;
    }
    else if(!strcmp(name, "Padi", true))
	{
		itemid = 2901;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Padi", str, 2901, 2);
		pData[playerid][pPadiOlahan] -= value;
    }
    else if(!strcmp(name, "Jagung", true))
	{
		itemid = 2901;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Jagung", str, 2901, 2);
		pData[playerid][pJagungOlahan] -= value;
    }
    else if(!strcmp(name, "Tebu", true))
	{
		itemid = 2901;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Tebu", str, 2901, 2);
		pData[playerid][pTebuOlahan] -= value;
    }
    else if(!strcmp(name, "Cabai", true))
	{
		itemid = 2901;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Cabai", str, 2901, 2);
		pData[playerid][pCabaiOlahan] -= value;
    }
    else if(!strcmp(name, "Gula", true))
	{
		itemid = 19824;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Gula", str, 19824, 2);
		pData[playerid][pGula] -= value;
    }
    else if(!strcmp(name, "bijikopi", true))
	{
		itemid = 2880;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "bijikopi", str, 2880, 2);
		pData[playerid][pBijikopi] -= value;
    }
    else if(!strcmp(name, "sariteh", true))
	{
		itemid = 2353;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "sariteh", str, 2353, 2);
		pData[playerid][pSariteh] -= value;
    }
    else if(!strcmp(name, "sarijeruk", true))
	{
		itemid = 19574;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "serijeruk", str, 19574, 2);
		pData[playerid][pSarijeruk] -= value;
    }
    else if(!strcmp(name, "esjeruk", true))
	{
		itemid = 19563;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "esjeruk", str, 19563, 2);
		pData[playerid][pEsjeruk] -= value;
    }
    else if(!strcmp(name, "kunci", true))
	{
		itemid = 2237;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kunci", str, 2237, 2);
		pData[playerid][pLockPick] -= value;
    }
    else if(!strcmp(name, "Ktp", true))
	{
		itemid = 1581;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Ktp", str, 1581, 2);
		pData[playerid][pIDCard] -= value;
    }
    else if(!strcmp(name, "Steak", true))
	{
		itemid = 19811;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Steak", str, 19811, 2);
		pData[playerid][pSteak] -= value;
    }
    else if(!strcmp(name, "Kain", true))
	{
		itemid = 2399;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kain", str, 2399, 2);
		pData[playerid][pKain] -= value;
    }
    else if(!strcmp(name, "Kanabis", true))
	{
		itemid = 800;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Kanabis", str, 800, 2);
		pData[playerid][pKanabis] -= value;
    }
    else if(!strcmp(name, "Wool", true))
	{
		itemid = 800;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Wool", str, 800, 2);
		pData[playerid][pWool] -= value;
    }
    else if(!strcmp(name, "Pakaian", true))
	{
		itemid = 11741;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Pakaian", str, 11741, 2);
		pData[playerid][pPakaian] -= value;
    }
    else if(!strcmp(name, "Susu_Olahan", true))
	{
		itemid = 19569;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "Susu_Olahan", str, 19569, 2);
		pData[playerid][pSusuOlahan] -= value;
    }
    else if(!strcmp(name, "material", true))
	{
		itemid = 1158;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "material", str, 1158, 2);
		pData[playerid][pMaterial] -= value;
    }
    else if(!strcmp(name, "component", true))
	{
		itemid = 1104;
		format(str, sizeof(str), "Removed_%dx", pData[playerid][pGiveAmount]);
		ShowItemBox(playerid, "component", str, 1104, 2);
		pData[playerid][pComponent] -= value;
    }



    printf("Itemid: %d, Name: %s, value: %d", itemid, name, value);

	DropItem(name, itemid, value, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
 	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menjatuhkan %s.", ReturnName(playerid), name);
	return Inventory_Close(playerid);
}

NearItemDropped(playerid, targetid, Float:radius)
{
    return (IsPlayerInRangeOfPoint(playerid, radius, DroppedItems[targetid][droppedPos][0], DroppedItems[targetid][droppedPos][1], DroppedItems[targetid][droppedPos][2]));
}

CMD:takedrop(playerid)
{
	new count = 0, str[500], strr[500];
	foreach(new i : DROPPED) if(NearItemDropped(playerid, i, 2))
	{
		format(str, sizeof(str), "%d.\t (%s[%d])\n", i, DroppedItems[i][droppedItem], DroppedItems[i][droppedQuantity]);
		strcat(strr, str);
		SetPlayerListitemValue(playerid, count++, i);
	}
	if(!count) ErrorMsg(playerid, "Tidak ada item yang terdrop didekat mu!");
	else ShowPlayerDialog(playerid, DIALOG_TAKE, DIALOG_STYLE_LIST, "Metaverse - Item Drop", strr, "Ambil", "Tutup");
}

function TakePlayerItem(playerid, id, name[])
{
	new query[512];
	ShowProgressbar(playerid, "Mengambil Item", 2);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mengambil %s di tanah.", ReturnName(playerid), name);
	DestroyDynamicObject(DroppedItems[id][droppedObject]);
	DestroyDynamic3DTextLabel(DroppedItems[id][droppedText3D]);
	DroppedItems[id][droppedObject] = -1;
	DroppedItems[id][droppedText3D] = Text3D: -1;
	Iter_Remove(DROPPED, id);

	if(!strcmp(name, "Uang", true))
	{
		GivePlayerMoneyEx(playerid, DroppedItems[id][droppedQuantity]);
		//OnPlayerUpdateAccountsPer(playerid, "pCash", pData[playerid][pCash]);
	}
	else if(!strcmp(name, "Water", true))
	{
		pData[playerid][pSprunk] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pAir", pData[playerid][pAir]);
	}
	else if(!strcmp(name, "Susu", true))
	{
		pData[playerid][pSusu] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pJusapel", pData[playerid][pJusapel]);
	}
	else if(!strcmp(name, "Esteh", true))
	{
		pData[playerid][pEsteh] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pTeh", pData[playerid][pTeh]);
	}
	else if(!strcmp(name, "Nasi kucig", true))
	{
		pData[playerid][pNasikucing] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pNasgor", pData[playerid][pNasgor]);
	}
	else if(!strcmp(name, "Ayamgeprek", true))
	{
		pData[playerid][pAyamgeprek] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pIkanbakar", pData[playerid][pIkanbakar]);
	}
	else if(!strcmp(name, "kue", true))
	{
		pData[playerid][pKuerayy] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pPizza", pData[playerid][pPizza]);
	}
	else if(!strcmp(name, "kopiruq", true))
	{
		pData[playerid][pKopiruq] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pDagingSapiBakar", pData[playerid][pDagingSapiBakar]);
	}
	else if(!strcmp(name, "Sambal", true))
	{
		pData[playerid][pSambal] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pDagingRusaBakar", pData[playerid][pDagingRusaBakar]);
	}
	else if(!strcmp(name, "Beras", true))
	{
		pData[playerid][pBeras] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pDagingSapi", pData[playerid][pDagingSapi]);
	}
	else if(!strcmp(name, "Tepung", true))
	{
		pData[playerid][pTepung] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pDagingRusa", pData[playerid][pDagingRusa]);
	}
	else if(!strcmp(name, "Snack", true))
	{
		pData[playerid][pSnack] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pBait", pData[playerid][pBait]);
	}
	else if(!strcmp(name, "Roti", true))
	{
		pData[playerid][pRoti] += DroppedItems[id][droppedQuantity];
		//OnPlayerUpdateAccountsPer(playerid, "pApel", pData[playerid][pApel]);
	}
	else if(!strcmp(name, "Kebab", true))
	{
        pData[playerid][pKebab] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pGandum", pData[playerid][pGandum]);
	}
	else if(!strcmp(name, "Jerigen", true))
	{
        pData[playerid][pGas] += DroppedItems[id][droppedQuantity];
        //OnPlayerUpdateAccountsPer(playerid, "pGaram", pData[playerid][pGaram]);
    }
	else if(!strcmp(name, "Sampah", true))
	{
        pData[playerid][sampahsaya] += DroppedItems[id][droppedQuantity];
      //  OnPlayerUpdateAccountsPer(playerid, "pFish", pData[playerid][pFish]);
    }
	else if(!strcmp(name, "Marijuana", true))
	{
		pData[playerid][pMarijuana] += DroppedItems[id][droppedQuantity];
      //  OnPlayerUpdateAccountsPer(playerid, "pKecubung", pData[playerid][pKecubung]);
	}
	else if(!strcmp(name, "Paket_Ayam", true))
	{
        pData[playerid][AyamFillet] += DroppedItems[id][droppedQuantity];
      //  OnPlayerUpdateAccountsPer(playerid, "pHeals", pData[playerid][pHeals]);
	}
	else if(!strcmp(name, "Milx_Max", true))
	{
		pData[playerid][pMilxMax] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Phone", true))
	{
		pData[playerid][pPhone] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Obat_Stress", true))
	{
		pData[playerid][pObatStress] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Seed", true))
	{
		pData[playerid][pSeed] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Penyu", true))
	{
		pData[playerid][pPenyu] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Blue_Fish", true))
	{
		pData[playerid][pBlueFish] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Nemo", true))
	{
		pData[playerid][pNemo] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Ikan_Makarel", true))
	{
		pData[playerid][pMakarel] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Pancingan", true))
	{
		pData[playerid][pFishTool] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Umpan", true))
	{
		pData[playerid][pWorm] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "botol", true))
	{
		pData[playerid][pBotol] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Perban", true))
	{
		pData[playerid][pBandage] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Ayam", true))
	{
		pData[playerid][AyamHidup] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Ayam_Potong", true))
	{
		pData[playerid][AyamPotong] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Cappucino", true))
	{
		pData[playerid][pCappucino] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "FirstAid", true))
	{
		pData[playerid][pMedkit] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Batu", true))
	{
		pData[playerid][pBatu] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Batu_Cucian", true))
	{
		pData[playerid][pBatuCucian] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Emas", true))
	{
		pData[playerid][pEmas] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Aluminium", true))
	{
		pData[playerid][pAluminium] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Besi", true))
	{
		pData[playerid][pBesi] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Minyak", true))
	{
		pData[playerid][pMinyak] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Vest", true))
	{
		pData[playerid][pVest] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Chiken", true))
	{
		pData[playerid][pChiken] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Starling", true))
	{
		pData[playerid][pStarling] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Bibit_Padi", true))
	{
		pData[playerid][pPadi] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Bibit_Cabai", true))
	{
		pData[playerid][pCabai] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Bibit_Jagung", true))
	{
		pData[playerid][pJagung] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Bibit_Tebu", true))
	{
		pData[playerid][pTebu] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Padi", true))
	{
		pData[playerid][pPadiOlahan] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Jagung", true))
	{
		pData[playerid][pJagungOlahan] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Tebu", true))
	{
		pData[playerid][pTebuOlahan] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Cabai", true))
	{
		pData[playerid][pCabaiOlahan] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Gula", true))
	{
		pData[playerid][pGula] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "bijikopi", true))
	{
		pData[playerid][pBijikopi] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "sariteh", true))
	{
		pData[playerid][pSariteh] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "sarijeruk", true))
	{
		pData[playerid][pSarijeruk] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "esjeruk", true))
	{
		pData[playerid][pEsjeruk] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Kunci", true))
	{
		pData[playerid][pLockPick] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Ktp", true))
	{
		pData[playerid][pIDCard] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Steak", true))
	{
		pData[playerid][pSteak] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Kain", true))
	{
		pData[playerid][pKain] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Kanabis", true))
	{
		pData[playerid][pKanabis] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Wool", true))
	{
		pData[playerid][pWool] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Pakaian", true))
	{
		pData[playerid][pPakaian] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "Susu_Olahan", true))
	{
		pData[playerid][pSusuOlahan] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "material", true))
	{
		pData[playerid][pMaterial] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }
    else if(!strcmp(name, "component", true))
	{
		pData[playerid][pComponent] += DroppedItems[id][droppedQuantity];
       // OnPlayerUpdateAccountsPer(playerid, "pRepairKit", pData[playerid][pRepairKit]);
    }

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM dropped WHERE id= %d", id);
	mysql_tquery(g_SQL, query);
	return 1;
}

/*CMD:gotoitem(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "CMD ini untuk admin!");
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoitem [id]");
	if(!Iter_Contains(DROPPED, id)) return ErrorMsg(playerid, "The item drop you specified ID of doesn't exist!");
	SetPlayerPosition(playerid, DroppedItems[id][droppedPos][0], DroppedItems[id][droppedPos][1], DroppedItems[id][droppedPos][2] + 0.9, 0);
    SetPlayerInterior(playerid, DroppedItems[id][droppedInt]);
    SetPlayerVirtualWorld(playerid, DroppedItems[id][droppedWorld]);
	InfoMsg(playerid, "You has teleport to item drop");
	return 1;
}*/