CMD:eprop(playerid, params[])
{
	static
        type[20],
        string[225];

    if(sscanf(params, "s[20]S()[128]", type, string))
    {
        SendClientMessage(playerid,COLOR_PURPLE,"|__________________ Emote Property Command__________________|");
        SendClientMessage(playerid,COLOR_WHITE,"EMOTEPROP: /eprop, box(1-4), pizz, laptop, tv, sign, bunga, colmek, x [ to remove animation ] ");
        return 1;
    }

	if(!strcmp(type, "box1", true))
    {
		return callcmd::boxeprop(playerid, params);
	}
	else if(!strcmp(type,"box2",true))
	{
		return callcmd::boxeprop2(playerid, params);
	}
	else if(!strcmp(type,"box3",true))
	{
		return callcmd::boxeprop3(playerid, params);
	}
	else if(!strcmp(type,"box4",true))
	{
		return callcmd::boxeprop4(playerid, params);
	}	
	else if(!strcmp(type,"pizz",true))
	{
		return callcmd::pizzass(playerid, params);
	}
	else if(!strcmp(type,"laptop",true))
	{
		return callcmd::laptopzs(playerid, params);
	}
	else if(!strcmp(type,"tv",true))
	{
		return callcmd::tvzs(playerid, params);
	}
	else if(!strcmp(type,"sign",true))
	{
		return callcmd::forsaless(playerid, params);
	}
	else if(!strcmp(type,"bunga",true))
	{
		return callcmd::bungaprop(playerid, params);
	}
	else if(!strcmp(type,"colmek",true))
	{
		return callcmd::colmekzz(playerid, params);
	}
	else if(!strcmp(type,"x",true))
	{
		return callcmd::cleareprop(playerid, params);
	}
	return 1;
}

CMD:boxeprop(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,2694,6,0.000000,0.035999,-0.204999,-113.400009,-7.799998,0.000000,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:boxeprop2(playerid, params[])
{
	SetPlayerAttachedObject(playerid, 9,2814,6,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:boxeprop3(playerid, params[])
{
	SetPlayerAttachedObject(playerid, 9,19638,6,0.000000,0.309000,0.000000,-7.499999,2.299999,-5.800000,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:boxeprop4(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,2654,6,0.000000,0.130000,-0.235000,-108.999984,0.299999,161.899993,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:pizzass(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,2814,6,0.091999,-0.044999,-0.170000,-110.900001,0.000000,-12.499999,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:laptopzs(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,19894,5,-0.035000,0.069999,0.000000,93.099952,-14.199987,82.000015,1.000000,1.000000,1.000000);
	ClearAnimations(playerid);
	return 1;
}
CMD:tvzs(playerid, params[])
{
	SetPlayerAttachedObject(playerid, 9, 19787, 1,  0.114000, 0.545000, 0.000000,  177.800186, 0.000000, 0.000000,  0.266000, 1.000000, 0.828999); // 0
	//SetPlayerAttachedObject(playerid, 9, 19787, 1,  0.095999, 0.294000, 0.000000,  173.600021, 91.700012, 8.099990,  0.443000, 0.841999, 0.490000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:forsaless(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,19470,6,0.070000,0.025000,-0.090000,0.000000,3.799999,-14.999981,1.000000,1.000000,1.000000);
	ClearAnimations(playerid);
	return 1;
}

CMD:bungaprop(playerid, params[])
{
	SetPlayerAttachedObject(playerid, 9,325,6,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"KISSING","Gift_Give", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:colmekzz(playerid, params[])
{
	SetPlayerAttachedObject(playerid,9,321,5,-0.057000,-0.025999,-0.149999,0.000000,28.700014,-12.899999,1.192999,1.297999,1.000000);
	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:garukbijiprop(playerid, params[])
{
	RemovePlayerAttachedObject(playerid, 9);
	ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:cleareprop(playerid, params[])
{
	RemovePlayerAttachedObject(playerid, 9);
	ClearAnimations(playerid);
	SetPlayerSkin(playerid, GetPlayerSkin(playerid));
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}

/*

    new animationsss[512];
    format(animationsss, 512, "Elist\nEprop Anim\nInteraksi Anim");
    ShowPlayerDialog(playerid, DIALOG_LISTAIMATION, DIALOG_STYLE_LIST, animationsss, "{FF9999}Aeterno Roleplay{FFFFFF}- List Animation", "Pilih", "Batal");

    new eprop[512];
    format(eprop, 512, "TV\nBan\nBesbol\nBasket\nBunga\nBox\nBox1\nBox2\nBox3\n 4\nBendera\nBendera2\nBumper\nGuitar\nKamera\nKamera2\nKamera3\nKursi\nKursi 2\nNitro\nMic");
    ShowPlayerDialog(playerid, DIALOG_EMOTEPROPERTY, DIALOG_STYLE_LIST, eprop, "{FF9999}Aeterno Roleplay{FFFFFF}- Emote Property", "Close", "");
*/