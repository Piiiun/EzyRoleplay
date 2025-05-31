//Business
#define MAX_BISNIS 1000

enum bisinfo
{
	bOwner[MAX_PLAYER_NAME],
	bName[128],
	bPrice,
	bType,
	bLocked,
	bMoney,
	bProd,
	bP[12],
	bInt,
	Float:bExtposX,
	Float:bExtposY,
	Float:bExtposZ,
	Float:bExtposA,
	Float:bIntposX,
	Float:bIntposY,
	Float:bIntposZ,
	Float:bIntposA,
	bVisit,
	bRestock,
	Float:bPointX,
	Float:bPointY,
	Float:bPointZ,
	bSegel,
	bPName0[128],
	bPName1[128],
	bPName2[128],
	bPName3[128],
	bPName4[128],
	bPName5[128],
	bPName6[128],
	bPName7[128],
	bPName8[128],
	bPName9[128],
	bPName10[128],
	bStream[128],
	//Not Saved
	bPickPoint,
	Text3D:bLabelPoint,
	bPickup,
	bCP,
	//bisnis baru
	bExtInt,
	bExtVw,
	Text3D:bLabel,
	BiznisID
};

new bData[MAX_BISNIS][bisinfo],
	Iterator: Bisnis<MAX_BISNIS>;

Bisnis_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE bisnis SET owner='%s', name='%s', price='%d', type='%d', locked='%d', money='%d', prod='%d', bprice0='%d', bprice1='%d', bprice2='%d', bprice3='%d', bprice4='%d', bprice5='%d', bprice6='%d', bprice7='%d', bprice8='%d', bprice9='%d', bprice10='%d', bint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', pointx='%f', pointy='%f', pointz='%f', visit='%d', restock='%d', segel='%d', bpname0='%s', bpname1='%s', bpname2='%s', bpname3='%s', bpname4='%s', bpname5='%s', bpname6='%s', bpname7='%s', bpname8='%s', bpname9='%s', bpname10='%s', stream='%s', extvw='%d', extint='%d' WHERE ID='%d'",
	bData[id][bOwner],
	bData[id][bName],
	bData[id][bPrice],
	bData[id][bType],
	bData[id][bLocked],
	bData[id][bMoney],
	bData[id][bProd],
	bData[id][bP][0],
	bData[id][bP][1],
	bData[id][bP][2],
	bData[id][bP][3],
	bData[id][bP][4],
	bData[id][bP][5],
	bData[id][bP][6],
	bData[id][bP][7],
	bData[id][bP][8],
	bData[id][bP][9],
	bData[id][bP][10],
	bData[id][bInt],
	bData[id][bExtposX],
	bData[id][bExtposY],
	bData[id][bExtposZ],
	bData[id][bExtposA],
	bData[id][bIntposX],
	bData[id][bIntposY],
	bData[id][bIntposZ],
	bData[id][bIntposA],
	bData[id][bPointX],
	bData[id][bPointY],
	bData[id][bPointZ],
	bData[id][bVisit],
	bData[id][bRestock],
	bData[id][bSegel],
	bData[id][bPName0],
	bData[id][bPName1],
	bData[id][bPName2],
	bData[id][bPName3],
	bData[id][bPName4],
	bData[id][bPName5],
	bData[id][bPName6],
	bData[id][bPName7],
	bData[id][bPName8],
	bData[id][bPName9],
	bData[id][bPName10],
	bData[id][bStream],
	bData[id][bExtVw],
	bData[id][bExtInt],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}
	
Player_OwnsBisnis(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(bData[id][bOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_BisnisCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Bisnis)
	{
		if(Player_OwnsBisnis(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

GetAnyBusiness()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnBusinessID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

Bisnis_Reset(id)
{
	format(bData[id][bOwner], MAX_PLAYER_NAME, "-");
	bData[id][bLocked] = 1;
    bData[id][bMoney] = 0;
	bData[id][bProd] = 0;
	bData[id][bVisit] = 0;
	bData[id][bRestock] = 0;
	Bisnis_Refresh(id);
}

GetOwnedBisnis(playerid)
{
	new tmpcount;
	foreach(new bid : Bisnis)
	{
	    if(!strcmp(bData[bid][bOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerBisnisID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new bid : Bisnis)
	{
	    if(!strcmp(pData[playerid][pName], bData[bid][bOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return bid;
  			}
	    }
	}
	return -1;
}

Bisnis_BuyMenu(playerid, bizid)
{
    if(bizid <= -1 )
        return 0;

    static
        string[512];

    switch(bData[bizid][bType])
    {
		case 1:
        {
            format(string, sizeof(string), "%s (Menu +12)  - %s\n%s (Menu +45)  - %s\n%s (Menu +60)  - %s\n%s (Energy Drink) - %s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "%s (Snack) - %s\n%s (Water) - %s\n%s (Cigarretes) - %s\n%s (Pack of Cigaretes) - %s\n%s (Bandage) - %s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
				FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 3:
        {
            format(string, sizeof(string), "Clothes - %s\nToys - %s\nMask - %s\nHelmet - %s",
                FormatMoney(bData[bizid][bP][0]),
                FormatMoney(bData[bizid][bP][1]),
                FormatMoney(bData[bizid][bP][2]),
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "%s (Baseball bat) - %s\n%s (Shovel) - %s\n%s (Cane) - %s\n%s (Fish Tool)- %s\n%s (Mask)- %s\n%s (Chainsaw)- %s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4]),
				bData[bizid][bPName5],
                FormatMoney(bData[bizid][bP][5])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "%s (Handphone) - %s\n%s (GPS) - %s\n%s (Phone Credit (1000)) - %s\n%s (Walkie Talkie)- %s\n%s (Phone Book)- %s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
    }
    return 1;
}

Bisnis_ProductMenu(playerid, bizid)
{
    if(bizid <= -1)
        return 0;

    static
        string[512];

    switch (bData[bizid][bType])
    {
        case 1:
        {
            format(string, sizeof(string), "%s (Menu +12)  - $%s\n%s (Menu +45)  - $%s\n%s (Menu +60)  - $%s\n%s (Energy Drink) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "%s (Snack) - $%s\n%s (Water) - $%s\n%s (Cigarretes) - $%s\n%s (Pack of Cigaretes) - $%s\n%s (Bandage) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
				FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 3:
        {
            format(string, sizeof(string), "%s (Clothes) - $%s\n%s (Caps) - $%s\n%s (Bandana) - $%s\n%s (Mask) - $%s\n%s (Helmet) - $%s\n%s (Watch) - $%s\n%s (Glasses) - $%s\n%s (Hair) - $%s\n%s (Misc) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4]),
				bData[bizid][bPName5],
                FormatMoney(bData[bizid][bP][5]),
				bData[bizid][bPName6],
                FormatMoney(bData[bizid][bP][6])
            );
            ShowPlayerDialog(playerid, BISNIS_BUYPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "%s (Baseball bat) - $%s\n%s (Shovel) - $%s\n%s (Cane) - $%s\n%s (Fish Tool)- $%s\n%s (Mask)- $%s\n%s (Chainsaw)- %s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4]),
				bData[bizid][bPName5],
                FormatMoney(bData[bizid][bP][5])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "%s (Handphone) - $%s\n%s (GPS) - $%s\n%s (Phone Credit (1000)) - $%s\n%s (Walkie Talkie)- $%s\n%s (Phone Book)- $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITPROD, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
    }
    return 1;
}

Bisnis_ProductMenuName(playerid, bizid)
{
    if(bizid <= -1)
        return 0;

    static
        string[512];

    switch (bData[bizid][bType])
    {
        case 1:
        {
            format(string, sizeof(string), "%s (Menu +12)  - $%s\n%s (Menu +45)  - $%s\n%s (Menu +60)  - $%s\n%s (Energy Drink) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITNAME, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 2:
        {
            format(string, sizeof(string), "%s (Snack) - $%s\n%s (Water) - $%s\n%s (Cigarretes) - $%s\n%s (Pack of Cigaretes) - $%s\n%s (Bandage) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
				FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITNAME, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 3:
        {
            format(string, sizeof(string), "%s (Clothes) - $%s\n%s (Caps) - $%s\n%s (Bandana) - $%s\n%s (Mask) - $%s\n%s (Helmet) - $%s\n%s (Watch) - $%s\n%s (Glasses) - $%s\n%s (Hair) - $%s\n%s (Misc) - $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4]),
				bData[bizid][bPName5],
                FormatMoney(bData[bizid][bP][5]),
				bData[bizid][bPName6],
                FormatMoney(bData[bizid][bP][6])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITNAME, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
        case 4:
        {
            format(string, sizeof(string), "%s (Baseball bat) - $%s\n%s (Shovel) - $%s\n%s (Cane) - $%s\n%s (Fish Tool)- $%s\n%s (Mask)- $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITNAME, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
		case 5:
        {
            format(string, sizeof(string), "%s (Handphone) - $%s\n%s (GPS) - $%s\n%s (Phone Credit (1000)) - $%s\n%s (Walkie Talkie)- $%s\n%s (Phone Book)- $%s",
                bData[bizid][bPName0],
				FormatMoney(bData[bizid][bP][0]),
				bData[bizid][bPName1],
                FormatMoney(bData[bizid][bP][1]),
				bData[bizid][bPName2],
                FormatMoney(bData[bizid][bP][2]),
				bData[bizid][bPName3],
                FormatMoney(bData[bizid][bP][3]),
				bData[bizid][bPName4],
                FormatMoney(bData[bizid][bP][4])
            );
            ShowPlayerDialog(playerid, BISNIS_EDITNAME, DIALOG_STYLE_LIST, bData[bizid][bName], string, "Buy", "Cancel");
        }
    }
    return 1;
}

Bisnis_ProductNameRefresh(id)
{
    if(id != -1)
    {
		switch(bData[id][bType])
		{
			case 1:
			{
				if(strcmp(bData[id][bPName0], "-"))
				{
				}
				else
				{
					format(bData[id][bPName0], 128, "Fried Chicken(+25)");
				}
				if(strcmp(bData[id][bPName1], "-"))
				{
				}
				else
				{
					format(bData[id][bPName1], 128, "Pizza Stack(+45)");
				}
				if(strcmp(bData[id][bPName2], "-"))
				{
				}
				else
				{
					format(bData[id][bPName2], 128, "Patty Burger(+60)");
				}
				if(strcmp(bData[id][bPName3], "-"))
				{
				}
				else
				{
					format(bData[id][bPName3], 128, "Sprunk(+45)");
				}
			}
			case 2:
			{
				if(strcmp(bData[id][bPName0], "-"))
				{
				}
				else
				{
					format(bData[id][bPName0], 128, "Snack");
				}
				if(strcmp(bData[id][bPName1], "-"))
				{
				}
				else
				{
					format(bData[id][bPName1], 128, "Sprunk");
				}
				if(strcmp(bData[id][bPName2], "-"))
				{
				}
				else
				{
					format(bData[id][bPName2], 128, "Cigarretes");
				}
				if(strcmp(bData[id][bPName3], "-"))
				{
				}
				else
				{
					format(bData[id][bPName3], 128, "Pack of Cigarretes");
				}
				if(strcmp(bData[id][bPName4], "-"))
				{
				}
				else
				{
					format(bData[id][bPName4], 128, "Bandage");
				}
			}	
			case 3:
			{
				if(strcmp(bData[id][bPName0], "-"))
				{
				}
				else
				{
					format(bData[id][bPName0], 128, "Clothes");
				}
				if(strcmp(bData[id][bPName1], "-"))
				{
				}
				else
				{
					format(bData[id][bPName1], 128, "Hats");
				}
				if(strcmp(bData[id][bPName2], "-"))
				{
				}
				else
				{
					format(bData[id][bPName2], 128, "Glasses");
				}
				if(strcmp(bData[id][bPName3], "-"))
				{
				}
				else
				{
					format(bData[id][bPName3], 128, "Helm");
				}
				if(strcmp(bData[id][bPName4], "-"))
				{
				}
				else
				{
					format(bData[id][bPName4], 128, "Accessory");
				}
				if(strcmp(bData[id][bPName5], "-"))
				{
				}
				else
				{
					format(bData[id][bPName5], 128, "Mask (Accessory)");
				}
				if(strcmp(bData[id][bPName6], "-"))
				{
				}
				else
				{
					format(bData[id][bPName6], 128, "Hairs");
				}
			}
			case 4:
			{	
				if(strcmp(bData[id][bPName0], "-"))
				{
				}
				else
				{
					format(bData[id][bPName0], 128, "Baseball Bat");
				}
				if(strcmp(bData[id][bPName1], "-"))
				{
				}
				else
				{
					format(bData[id][bPName1], 128, "Shovel");
				}
				if(strcmp(bData[id][bPName2], "-"))
				{
				}
				else
				{
					format(bData[id][bPName2], 128, "Cane");
				}
				if(strcmp(bData[id][bPName3], "-"))
				{
				}
				else
				{
					format(bData[id][bPName3], 128, "Fishing Tools");
				}
				if(strcmp(bData[id][bPName4], "-"))
				{
				}
				else
				{
					format(bData[id][bPName4], 128, "Mask");
				}
				if(strcmp(bData[id][bPName5], "-"))
				{
				}
				else
				{
					format(bData[id][bPName5], 128, "Chainsaw");
				}
			}
			case 5:
			{	
				if(strcmp(bData[id][bPName0], "-"))
				{
				}
				else
				{
					format(bData[id][bPName0], 128, "Handphone");
				}
				if(strcmp(bData[id][bPName1], "-"))
				{
				}
				else
				{
					format(bData[id][bPName1], 128, "GPS");
				}
				if(strcmp(bData[id][bPName2], "-"))
				{
				}
				else
				{
					format(bData[id][bPName2], 128, "Phone credit");
				}
				if(strcmp(bData[id][bPName3], "-"))
				{
				}
				else
				{
					format(bData[id][bPName3], 128, "Walkie talkie");
				}
				if(strcmp(bData[id][bPName4], "-"))
				{
				}
				else
				{
					format(bData[id][bPName4], 128, "Phone Book");
				}
			}
		}	
        
    }
    return 1;
}

Bisnis_Type(bisid)
{
	if(bData[bisid][bType] == 1) // Fast Food
	{
	    switch(random(2))
		{
			case 0:
			{
				bData[bisid][bIntposX] = 363.22;
				bData[bisid][bIntposY] = -74.86;
				bData[bisid][bIntposZ] = 1001.50;
				bData[bisid][bIntposA] = 319.72;
				bData[bisid][bInt] = 10;
				bData[bisid][bPointX] = 376.8142;
				bData[bisid][bPointY] = -68.0401;
				bData[bisid][bPointZ] = 1001.5151;
			}
			case 1: // ,,
			{
				bData[bisid][bIntposX] = 372.34;
				bData[bisid][bIntposY] = -133.25;
				bData[bisid][bIntposZ] = 1001.49;
				bData[bisid][bIntposA] = 4.80;
				bData[bisid][bInt] = 5;
				bData[bisid][bPointX] = 375.4402;
				bData[bisid][bPointY] = -119.9117;
				bData[bisid][bPointZ] = 1001.4995;
			} 
		}
	}
	if(bData[bisid][bType] == 2) //Market
	{
	    switch(random(2))
		{
			case 0: // 1.9983,-29.0117,1003.5494
			{
				bData[bisid][bIntposX] = 5.73;
				bData[bisid][bIntposY] = -31.04;
				bData[bisid][bIntposZ] = 1003.54;
				bData[bisid][bIntposA] = 355.73;
				bData[bisid][bInt] = 10;
				bData[bisid][bPointX] = 1.9983;
				bData[bisid][bPointY] = -29.0117;
				bData[bisid][bPointZ] = 1003.5494;
			}
			case 1: //-23.4406,-55.6324,1003.5469
			{
				bData[bisid][bIntposX] = -26.68;
				bData[bisid][bIntposY] = -57.92;
				bData[bisid][bIntposZ] = 1003.54;
				bData[bisid][bIntposA] = 357.58;
				bData[bisid][bInt] = 6;
				bData[bisid][bPointX] = -23.4406;
				bData[bisid][bPointY] = -55.6324;
				bData[bisid][bPointZ] = 1003.5469;
			}
		}
	}
	if(bData[bisid][bType] == 3) //Clothes
	{
	    switch(random(2))
		{
			case 0: // 207.5234,-100.7358,1005.2578
			{
				bData[bisid][bIntposX] = 207.55;
				bData[bisid][bIntposY] = -110.67;
				bData[bisid][bIntposZ] = 1005.13;
				bData[bisid][bIntposA] = 0.16;
				bData[bisid][bInt] = 15;
				bData[bisid][bPointX] = 207.5234;
				bData[bisid][bPointY] = -100.7358;
				bData[bisid][bPointZ] = 1005.2578;
			}
			case 1: // 204.3724,-159.6976,1000.5234
			{
				bData[bisid][bIntposX] = 204.49;
				bData[bisid][bIntposY] = -168.26;
				bData[bisid][bIntposZ] = 1000.52;
				bData[bisid][bIntposA] = 358.74;
				bData[bisid][bInt] = 14;
				bData[bisid][bPointX] = 204.3724;
				bData[bisid][bPointY] = -159.6976;
				bData[bisid][bPointZ] = 1000.5234;
			}
		}
	}
	if(bData[bisid][bType] == 4) // Sportshop
	{ //203.7197,-50.0292,1001.8047,5.1475
		bData[bisid][bIntposX] = 203.7197;
		bData[bisid][bIntposY] = -50.0292;
		bData[bisid][bIntposZ] = 1001.8047;
		bData[bisid][bIntposA] = 5.1475;
		bData[bisid][bInt] = 1;
		bData[bisid][bPointX] = 203.8431;
		bData[bisid][bPointY] = -43.2778;
		bData[bisid][bPointZ] = 1001.8047;
	}
	if(bData[bisid][bType] == 5) // Electronic
	{ //-2240.468505,137.060440,1035.414062	 // 1422.1898 -1185.0836 26.0029
		bData[bisid][bIntposX] = 1421.95;
		bData[bisid][bIntposY] = -1180.97;
		bData[bisid][bIntposZ] = 26.00;
		bData[bisid][bIntposA] =  176.57;
		bData[bisid][bInt] = 1;
		bData[bisid][bPointX] = 1422.1898;
		bData[bisid][bPointY] = -1185.0836;
		bData[bisid][bPointZ] = 26.0029; 
	}
}

Bisnis_Refresh(id)
{
    if(id != -1)
    {
        if(IsValidDynamic3DTextLabel(bData[id][bLabel]))
            DestroyDynamic3DTextLabel(bData[id][bLabel]);

        if(IsValidDynamicPickup(bData[id][bPickup]))
            DestroyDynamicPickup(bData[id][bPickup]);
			
		if(IsValidDynamic3DTextLabel(bData[id][bLabelPoint]))
            DestroyDynamic3DTextLabel(bData[id][bLabelPoint]);

        if(IsValidDynamicPickup(bData[id][bPickPoint]))
            DestroyDynamicPickup(bData[id][bPickPoint]);
		
		if(IsValidDynamicCP(bData[id][bCP]))
			DestroyDynamicCP(bData[id][bCP]);

        static
        string[255], tstr[128];
		
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
			type= "Sportshop";
		}
		else if(bData[id][bType] == 5)
		{
			type= "Electronic";
		}
		else
		{
			type= "Unknow";
		}
        if(strcmp(bData[id][bOwner], "-"))
		{
			format(string, sizeof(string), "{00FFFF}[id:%d]\n{00FF00}%s{FFFFFF}\nOwner: {FFFF00}%s", id, bData[id][bName], bData[id][bOwner]);
			bData[id][bPickup] = CreateDynamicPickup(19133, 23, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.2, 0, 0, _, 150.0);
        }
        else
        {
            format(string, sizeof(string), "{00FFFF}[id:%d]\n{00D900}this businesses for sale!\n{FFFF00}Type: {FFFFFF}%s\n{FFFFFF}Price: {00FF00}$%s\n{00D900}use '/buy' for buy this businesess", id, type, FormatMoney(bData[id][bPrice]), type);
            bData[id][bPickup] = CreateDynamicPickup(19133, 23, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.2, 0, 0, _, 150.0);
        }
		if(bData[id][bSegel] == 1)
		{
			format(string, sizeof(string), "{00FFFF}[id:%d]\n{FF0000}This businesses sealed by authority\nOwner: {FFFF00}%s", id, bData[id][bOwner]);
			bData[id][bPickup] = CreateDynamicPickup(19133, 23, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.2, 0, 0, _, 150.0);
		}
		bData[id][bPickPoint] = CreateDynamicPickup(1274, 23, bData[id][bPointX], bData[id][bPointY], bData[id][bPointZ]+0.2, id, bData[id][bInt], _, 4);
		
		format(tstr, 128, "{00FFFF}[id:%d]\n"RED_E"Bisnis Point\n"LG_E"use '/buy' here", id);
		bData[id][bLabelPoint] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, bData[id][bPointX], bData[id][bPointY], bData[id][bPointZ]+0.5, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, id, bData[id][bInt]);
		bData[id][bPickup] = CreateDynamicCP(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 2.0, -1, -1, -1, 4.0);
		bData[id][bPickup] = CreateDynamicCP(bData[id][bIntposX], bData[id][bIntposY], bData[id][bIntposZ], 2.0, -1, -1, -1, 4.0);
        bData[id][bLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]+0.5, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
	}
    return 1;
}

function LoadBisnis()
{
    static bid;
	
	new rows = cache_num_rows(), owner[128], name[128], bpname0[128], bpname1[128], bpname2[128], bpname3[128], bpname4[128], bpname5[128], bpname6[128], bpname7[128], bpname8[128], bpname9[128], bpname10[128], stream[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(bData[bid][bOwner], 128, owner);
			cache_get_value_name(i, "name", name);
			format(bData[bid][bName], 128, name);
			cache_get_value_name_int(i, "type", bData[bid][bType]);
			cache_get_value_name_int(i, "price", bData[bid][bPrice]);
			cache_get_value_name_float(i, "extposx", bData[bid][bExtposX]);
			cache_get_value_name_float(i, "extposy", bData[bid][bExtposY]);
			cache_get_value_name_float(i, "extposz", bData[bid][bExtposZ]);
			cache_get_value_name_float(i, "extposa", bData[bid][bExtposA]);
			cache_get_value_name_float(i, "intposx", bData[bid][bIntposX]);
			cache_get_value_name_float(i, "intposy", bData[bid][bIntposY]);
			cache_get_value_name_float(i, "intposz", bData[bid][bIntposZ]);
			cache_get_value_name_float(i, "intposa", bData[bid][bIntposA]);
			cache_get_value_name_int(i, "bint", bData[bid][bInt]);
			cache_get_value_name_int(i, "money", bData[bid][bMoney]);
			cache_get_value_name_int(i, "locked", bData[bid][bLocked]);
			cache_get_value_name_int(i, "prod", bData[bid][bProd]);
			cache_get_value_name_int(i, "bprice0", bData[bid][bP][0]);
			cache_get_value_name_int(i, "bprice1", bData[bid][bP][1]);
			cache_get_value_name_int(i, "bprice2", bData[bid][bP][2]);
			cache_get_value_name_int(i, "bprice3", bData[bid][bP][3]);
			cache_get_value_name_int(i, "bprice4", bData[bid][bP][4]);
			cache_get_value_name_int(i, "bprice5", bData[bid][bP][5]);
			cache_get_value_name_int(i, "bprice6", bData[bid][bP][6]);
			cache_get_value_name_int(i, "bprice7", bData[bid][bP][7]);
			cache_get_value_name_int(i, "bprice8", bData[bid][bP][8]);
			cache_get_value_name_int(i, "bprice9", bData[bid][bP][9]);
			cache_get_value_name_int(i, "bprice10", bData[bid][bP][10]);
			cache_get_value_name_float(i, "pointx", bData[bid][bPointX]);
			cache_get_value_name_float(i, "pointy", bData[bid][bPointY]);
			cache_get_value_name_float(i, "pointz", bData[bid][bPointZ]);
			cache_get_value_name_int(i, "visit", bData[bid][bVisit]);
			cache_get_value_name_int(i, "restock", bData[bid][bRestock]);
			cache_get_value_name_int(i, "segel", bData[bid][bSegel]);
			cache_get_value_name_int(i, "extvw", bData[bid][bExtVw]);
			cache_get_value_name_int(i, "extint", bData[bid][bExtInt]);
			cache_get_value_name(i, "bpname0", bpname0);
			format(bData[bid][bPName0], 128, bpname0);
			cache_get_value_name(i, "bpname1", bpname1);
			format(bData[bid][bPName1], 128, bpname1);
			cache_get_value_name(i, "bpname2", bpname2);
			format(bData[bid][bPName2], 128, bpname2);
			cache_get_value_name(i, "bpname3", bpname3);
			format(bData[bid][bPName3], 128, bpname3);
			cache_get_value_name(i, "bpname4", bpname4);
			format(bData[bid][bPName4], 128, bpname4);
			cache_get_value_name(i, "bpname5", bpname5);
			format(bData[bid][bPName5], 128, bpname5);
			cache_get_value_name(i, "bpname6", bpname6);
			format(bData[bid][bPName6], 128, bpname6);
			cache_get_value_name(i, "bpname7", bpname7);
			format(bData[bid][bPName7], 128, bpname7);
			cache_get_value_name(i, "bpname8", bpname8);
			format(bData[bid][bPName8], 128, bpname8);
			cache_get_value_name(i, "bpname9", bpname9);
			format(bData[bid][bPName9], 128, bpname9);
			cache_get_value_name(i, "bpname10", bpname10);
			format(bData[bid][bPName10], 128, bpname10);
			cache_get_value_name(i, "stream", stream);
			format(bData[bid][bStream], 128, stream);
			

			bData[bid][BiznisID] = bid;
			Bisnis_Refresh(bid);
			Iter_Add(Bisnis, bid);
		}
		printf("*** [Database: Loaded] bisnis data (%d count).", rows);
	}
}

//------------[ Bisnis Command ]------------
//Bisnis System
CMD:createbisnis(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new bid = Iter_Free(Bisnis), address[128];
	if(bid == -1) return Error(playerid, "You cant create more door!");
	new type;
	if(sscanf(params, "d", type)) return SyntaxMsg(playerid, "/createbisnis [type, 1.Fastfood 2.Market 3.Clothes 4.Sportshop 5.Electronic]");
	format(bData[bid][bOwner], 128, "-");
	GetPlayerPos(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
	GetPlayerFacingAngle(playerid, bData[bid][bExtposA]);
	bData[bid][bExtVw] = GetPlayerVirtualWorld(playerid);
	bData[bid][bExtInt] = GetPlayerInterior(playerid);
	bData[bid][bPrice] = 50000;
	bData[bid][bType] = type;
	address = GetLocation(bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
	format(bData[bid][bName], 128, address);
	bData[bid][bLocked] = 0;
	bData[bid][bInt] = 0;
	bData[bid][bIntposX] = 0;
	bData[bid][bIntposY] = 0;
	bData[bid][bIntposZ] = 0;
	bData[bid][bIntposA] = 0;
	bData[bid][bVisit] = 0;
	bData[bid][bRestock] = 1;
	bData[bid][bMoney] = 0;
	bData[bid][bProd] = 2000;

	if(type == 1)
	{
		bData[bid][bP][0] = 75;
		bData[bid][bP][1] = 300;
		bData[bid][bP][2] = 350;
		bData[bid][bP][3] = 375;
	}
	else if(type == 2)
	{
		bData[bid][bP][0] = 2;
		bData[bid][bP][1] = 2;
		bData[bid][bP][2] = 5;
		bData[bid][bP][3] = 1;
		bData[bid][bP][4] = 1;
	}
	else if(type == 3)
	{
		bData[bid][bP][0] = 35;
		bData[bid][bP][1] = 10;
		bData[bid][bP][2] = 50;
		bData[bid][bP][3] = 5;
		bData[bid][bP][4] = 1;
		bData[bid][bP][5] = 1;
	}
	else if(type == 4)
	{
		bData[bid][bP][0] = 35;
		bData[bid][bP][1] = 15;
		bData[bid][bP][2] = 15;
		bData[bid][bP][3] = 20;
		bData[bid][bP][4] = 50;
		bData[bid][bP][4] = 35;
	}
	else if(type == 5)
	{
		bData[bid][bP][0] = 25;
		bData[bid][bP][1] = 15;
		bData[bid][bP][2] = 10;
		bData[bid][bP][3] = 35;
		bData[bid][bP][4] = 10;
	}
	Bisnis_ProductNameRefresh(bid);
	Bisnis_Type(bid);
    Bisnis_Refresh(bid);
	Iter_Add(Bisnis, bid);
	new String[212];
	format(String, sizeof(String), "AdmWarn: "YELLOW_E"%s "WHITE_E"telah membuat Bisnis ID "YELLOW_E"%d.", pData[playerid][pAdminname], bid);
	SendAdminMessage(COLOR_ARWIN, String, 4); 
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO bisnis SET ID='%d', owner='%s', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', name='%s'", bid, bData[bid][bOwner], bData[bid][bPrice], bData[bid][bType], bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], bData[bid][bExtposA], bData[bid][bName]);
	mysql_tquery(g_SQL, query, "OnBisnisCreated", "i", bid);
	return 1;
}

function OnBisnisCreated(bid)
{
	Bisnis_Save(bid);
	return 1;
}

CMD:gotobisnis(playerid, params[])
{
	new bid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", bid))
		return SyntaxMsg(playerid, "/gotobisnis [id]");
	if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The Bisnis you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], bData[bid][bExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to bisnis id %d", bid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

CMD:editbisnis(playerid, params[])
{
    static
        bid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", bid, type, string))
    {
        SyntaxMsg(playerid, "/editbisnis [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, point, price, type, product, restock, reset, delete");
        return 1;
    }
    if((bid < 0 || bid >= MAX_BISNIS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The bisnis you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]);
		GetPlayerFacingAngle(playerid, bData[bid][bExtposA]);
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ]);
		GetPlayerFacingAngle(playerid, bData[bid][bIntposA]);
		bData[bid][bInt] = GetPlayerInterior(playerid);

        Bisnis_Save(bid);
		Bisnis_Refresh(bid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the interior spawn of bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return SyntaxMsg(playerid, "/editbisnis [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        bData[bid][bLocked] = locked;
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has locked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has unlocked bisnis ID: %d.", pData[playerid][pAdminname], bid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/editbisnis [id] [Price] [Amount]");

        bData[bid][bPrice] = price;

        Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new btype;

        if(sscanf(string, "d", btype))
            return SyntaxMsg(playerid, "/editbisnis [id] [Type] [1.Fastfood 2.Market 3.Clothes 4.Equipment]");

        bData[bid][bType] = btype;
		Bisnis_Type(bid);
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the type of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, btype);
    }
	else if(!strcmp(type, "product", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return SyntaxMsg(playerid, "/editbisnis [id] [product] [Ammount]");

        bData[bid][bProd] = prod;
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the product of bisnis ID: %d to %d.", pData[playerid][pAdminname], bid, prod);
    }
	else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return SyntaxMsg(playerid, "/editbisnis [id] [money] [Ammount]");

        bData[bid][bMoney] = money;
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of bisnis ID: %d to %s.", pData[playerid][pAdminname], bid, FormatMoney(money));
    }
	else if(!strcmp(type, "restock", true))
    {
        new prod;

        if(sscanf(string, "d", prod))
            return SyntaxMsg(playerid, "/editbisnis [id] [restock] [0-1]");
		
		if(prod == 0)
		{
			bData[bid][bRestock] = 0;
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to disable.", pData[playerid][pAdminname], bid);
		}
		else if(prod == 1)
		{
			bData[bid][bRestock] = 1;
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
			SendAdminMessage(COLOR_RED, "%s has adjusted the restock of bisnis ID: %d to enable.", pData[playerid][pAdminname], bid);
		}
		else return Error(playerid, "Hanya id 0-1");
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return SyntaxMsg(playerid, "/editbisnis [id] [owner] [player name] (use '-' to no owner)");

        format(bData[bid][bOwner], MAX_PLAYER_NAME, owners);
  
        Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of bisnis ID: %d to %s", pData[playerid][pAdminname], bid, owners);
    }
    else if(!strcmp(type, "reset", true))
    {
        Bisnis_Reset(bid);
		Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has reset bisnis ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "point", true))
    {
		new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
		bData[bid][bPointX] = x;
		bData[bid][bPointY] = y;
		bData[bid][bPointZ] = z;
		Bisnis_Save(bid);
		Bisnis_Refresh(bid);
        SendAdminMessage(COLOR_RED, "%s has edit bisnis point ID: %d.", pData[playerid][pAdminname], bid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Bisnis_Reset(bid);
		
		DestroyDynamic3DTextLabel(bData[bid][bLabel]);
        DestroyDynamicPickup(bData[bid][bPickup]);
        DestroyDynamicCP(bData[bid][bCP]);
		
		bData[bid][bExtposX] = 0;
		bData[bid][bExtposY] = 0;
		bData[bid][bExtposZ] = 0;
		bData[bid][bExtposA] = 0;
		bData[bid][bPrice] = 0;
		bData[bid][bInt] = 0;
		bData[bid][bIntposX] = 0;
		bData[bid][bIntposY] = 0;
		bData[bid][bIntposZ] = 0;
		bData[bid][bIntposA] = 0;
		bData[bid][bLabel] = Text3D: INVALID_3DTEXT_ID;
		bData[bid][bPickup] = -1;
		
		Iter_Remove(Bisnis, bid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM bisnis WHERE ID=%d", bid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete bisnis ID: %d.", pData[playerid][pAdminname], bid);
	}
    return 1;
}

CMD:lockbisnis(playerid, params[])
{
	foreach(new bid : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(!Player_OwnsBisnis(playerid, bid)) return Error(playerid, "You don't own this bisnis.");
			if(!bData[bid][bLocked])
			{
				bData[bid][bLocked] = 1;
				Bisnis_Save(bid);

				InfoTD_MSG(playerid, 4000, "You have ~r~locked~w~ your bisnis!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				bData[bid][bLocked] = 0;
				Bisnis_Save(bid);

				InfoTD_MSG(playerid, 4000,"You have ~g~unlocked~w~ your bisnis!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:sellbisnis(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1393.3154,-12.7873,1000.9166)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedBisnis(playerid) == -1) return Error(playerid, "You don't have a bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, bData[hid][bName], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, bData[hid][bName], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_BISNISS, DIALOG_STYLE_LIST, "Sell Bisnis", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:mybis(playerid)
{
	if(GetOwnedBisnis(playerid) == -1) return Error(playerid, "You don't have a bisnis.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedBisnis(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerBisnisID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, bData[hid][bName], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, bData[hid][bName], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_BISNIS, DIALOG_STYLE_LIST, "{FF0000}LJRP:RP {0000FF}Bisnis", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:bm(playerid, params[])
{
	if(pData[playerid][pInBiz] == -1) return 0;
	if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");
    ShowPlayerDialog(playerid, BISNIS_MENU, DIALOG_STYLE_LIST, "Bisnis Menu","Bisnis Info\nChange Name\nChange Price Product Menu\nChange Name Product Menu\nRequest Restock\nRadio URL(Music)","Next","Close");
    return 1;
}

CMD:givebisnis(playerid, params[])
{
	new bid, otherid;
	
	if(pData[playerid][pLevel] < 3)
		return Error(playerid, "Anda harus level 3 untuk menggunakan fitur ini");
		
	if(sscanf(params, "ud", otherid, bid)) return SyntaxMsg(playerid, "/givebisnis [playerid/name] [id] | /mybisnis - for show info");
	if(bid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
	
	if(!Player_OwnsBisnis(playerid, bid)) return Error(playerid, "You don't own this bisnis.");
	if(bData[bid][bSegel] == 1) return Error(playerid, "Biz anda masih tersegel.");
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 2) return Error(playerid, "Target player cant own any more bisnis.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 3) return Error(playerid, "Target player cant own any more bisnis.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 4) return Error(playerid, "Target player cant own any more bisnis.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_BisnisCount(otherid) + 1 > 1) return Error(playerid, "Target player cant own any more bisnis.");
		#endif
	}
	GetPlayerName(otherid, bData[bid][bOwner], MAX_PLAYER_NAME);
	bData[bid][bVisit] = gettime();
	
	Bisnis_Refresh(bid);
	Bisnis_Save(bid);
	SendClientMessageEx(playerid, COLOR_ARWIN, "BISNIS: Anda memberikan bisnis id: %d kepada %s", bid, ReturnName(otherid));
	SendClientMessageEx(otherid, COLOR_ARWIN, "BISNIS: %s memberikan bisnis id: %d kepada anda", bid, ReturnName(playerid));
	return 1;
}

CMD:bwithdraw(playerid, params[])
{
	if(pData[playerid][pInBiz] == -1) return 0;
	if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");

	new bid = pData[playerid][pInBiz];
	if(bData[bid][bSegel] == 1) return Error(playerid, "Biz anda masih tersegel.");
	new String[512], amount[32], dollars, cents, duit[32];

	if(sscanf(params, "s[32]", amount))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "KEGUNAAN: /bwithdraw [Jumlah]");
		format(String, sizeof(String), "Anda memiliki uang sebesar %s di dalam Akun bisnis Anda.", FormatMoney(bData[bid][bMoney]));
		SendClientMessageEx(playerid, COLOR_GRAD3, String);
		return 1;
	}
	if(strfind(amount, ".", true) != 1)
	{
	   	sscanf(amount, "p<.>dd", dollars, cents);
	    format(duit, sizeof(duit), "%d%02d", dollars, cents);
		if(strval(duit) > bData[bid][bMoney])
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Anda tidak memiliki uang sebesar itu di dalam Akun bisnis anda!");
			return 1;
		}
		if(strval(duit) < 0) return SendClientMessageEx(playerid, COLOR_GREY, "Tidak bisa dibawah $0.00");
		GivePlayerMoneyEx(playerid,strval(duit));
		bData[bid][bMoney]=bData[bid][bMoney]-strval(duit);
		format(String, sizeof(String), "BISNIS: {ffffff}You've withdrawn {ffff00}$%s{ffffff} from your bisnis account", FormatMoney(strval(duit)));
		SendClientMessageEx(playerid, COLOR_ARWIN, String);
		format(String, sizeof(String), "BISNIS: {ffff00}$%s",FormatMoney(bData[bid][bMoney]));
		SendClientMessageEx(playerid, COLOR_ARWIN, String);
	}
	else
	{
	   	sscanf(amount, "d", dollars);
	    format(duit, sizeof(duit), "%d00", dollars);
		if(strval(duit) > bData[bid][bMoney])
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "Anda tidak memiliki uang sebesar itu di dalam Akun bisnis anda!");
			return 1;
		}
		if(strval(duit) < 0) return SendClientMessageEx(playerid, COLOR_GREY, "Tidak bisa dibawah $0.00");
		GivePlayerMoneyEx(playerid,strval(duit));
		bData[bid][bMoney]=bData[bid][bMoney]-strval(duit);
		format(String, sizeof(String), "BISNIS: {ffffff}You've withdrawn {ffff00}$%s{ffffff} from your bisnis account", FormatMoney(strval(duit)));
		SendClientMessageEx(playerid, COLOR_ARWIN, String);
		format(String, sizeof(String), "BISNIS: {ffff00}$%s",FormatMoney(bData[bid][bMoney]));
		SendClientMessageEx(playerid, COLOR_ARWIN, String);
	}
	return 1;
}
