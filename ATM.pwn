
#define MAX_ATM 50

enum    E_ATM
{
	// loaded from db
	Float: atmX,
	Float: atmY,
	Float: atmZ,
	Float: atmRX,
	Float: atmRY,
	Float: atmRZ,
	atmInt,
	atmWorld,
	// temp
	atmObjID,
	atmArea,
	atmExists,
	Text3D: atmLabel
}

new AtmData[MAX_ATM][E_ATM],
	Iterator:ATMS<MAX_ATM>;
/*	
GetClosestATM(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : ATMS)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, AtmData[i][atmX], AtmData[i][atmY], AtmData[i][atmZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist && GetPlayerInterior(playerid) == AtmData[i][atmInt] && GetPlayerVirtualWorld(playerid) == AtmData[i][atmWorld])
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}*/

function LoadATM()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0, str[55];
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", AtmData[id][atmX]);
			cache_get_value_name_float(i, "posy", AtmData[id][atmY]);
			cache_get_value_name_float(i, "posz", AtmData[id][atmZ]);
			cache_get_value_name_float(i, "posrx", AtmData[id][atmRX]);
			cache_get_value_name_float(i, "posry", AtmData[id][atmRY]);
			cache_get_value_name_float(i, "posrz", AtmData[id][atmRZ]);
			cache_get_value_name_int(i, "interior", AtmData[id][atmInt]);
			cache_get_value_name_int(i, "world", AtmData[id][atmWorld]);
			AtmData[id][atmObjID] = CreateDynamicObject(11688, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], AtmData[id][atmWorld], AtmData[id][atmInt], -1, 150.0, 150.0);
			//SetDynamicObjectMaterial(AtmData[id][atmObjID], 0, 1975, "texttest", "kb_red", 0x00000000);
			//SetDynamicObjectMaterial(AtmData[id][atmObjID], 1, 1975, "texttest", "kb_red", 0x00000000);
			SetDynamicObjectMaterial(AtmData[id][atmObjID], 0, 8839, "vgsecarshow", "lightpurple2_32", 0x00000000);
			SetDynamicObjectMaterial(AtmData[id][atmObjID], 1, 8839, "vgsecarshow", "lightpurple2_32", 0x00000000);
			SetDynamicObjectMaterial(AtmData[id][atmObjID], 3, 6060, "shops2_law", "atmflat", 0x00000000);
			format(str, sizeof(str), "[ID: %d]", id);
			AtmData[id][atmLabel] = CreateDynamic3DTextLabel(str, COLOR_PURPLE2, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]+0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, AtmData[id][atmWorld], AtmData[id][atmInt], -1, 10.0);
			AtmData[id][atmArea] = CreateDynamicSphere(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ] - 0.4, 1.3);
			AtmData[id][atmExists] = true;	
			//AtmData[id][atmMap] = CreateDynamicMapIcon(ATMIslem[id][atmPos][0], ATMIslem[id][atmPos][1], ATMIslem[id][atmPos][2], 52, -1, -1, -1, -1, 100.0, 1);
			//AtmData[id][atmCP] = CreateDynamicCP(ATMIslem[id][atmPos][0], ATMIslem[id][atmPos][1], ATMIslem[id][atmPos][2], 1.5, -1, -1, -1, 3.0);
			Iter_Add(ATMS, id);
	    	i++;
		}
		printf("[Dynamic ATM] Number of Loaded: %d.", i);
	}
}

GetAnyAtm()
{
	new tmpcount;
	foreach(new id : ATMS)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnAtmID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_ATM) return -1;
	foreach(new id : ATMS)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

Atm_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE atms SET posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d' WHERE id='%d'",
	AtmData[id][atmX],
	AtmData[id][atmY],
	AtmData[id][atmZ],
	AtmData[id][atmRX],
	AtmData[id][atmRY],
	AtmData[id][atmRZ],
	AtmData[id][atmInt],
	AtmData[id][atmWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

Atm_BeingEdited(id)
{
	if(!Iter_Contains(ATMS, id)) return 0;
	foreach(new i : Player) if(pData[i][EditingATMID] == id) return 1;
	return 0;
}

CMD:createatm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id = Iter_Free(ATMS), query[512];
	if(id == -1) return Error(playerid, "Can't add any more ATM.");
 	new Float: x, Float: y, Float: z;
 	GetPlayerPos(playerid, x, y, z);
 	/*GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;*/
	
	AtmData[id][atmX] = x;
	AtmData[id][atmY] = y;
	AtmData[id][atmZ] = z;
	AtmData[id][atmRX] = AtmData[id][atmRY] = AtmData[id][atmRZ] = 0.0;
	AtmData[id][atmInt] = GetPlayerInterior(playerid);
	AtmData[id][atmWorld] = GetPlayerVirtualWorld(playerid);
	AtmData[id][atmArea] = CreateDynamicSphere(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ] - 0.4, 1.3);
	AtmData[id][atmExists] = true;
	
	new str[128];
	/*AtmData[id][atmObjID] = CreateDynamicObject(19324, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], AtmData[id][atmWorld], AtmData[id][atmInt], -1, 10.0, 10.0);
	format(str, sizeof(str), "[ID: %d]", id);*/
	AtmData[id][atmObjID] = CreateDynamicObject(11688, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], AtmData[id][atmWorld], AtmData[id][atmInt], -1, 150.0, 150.0);
	SetDynamicObjectMaterial(AtmData[id][atmObjID], 0, 1975, "texttest", "kb_red", 0x00000000);
	SetDynamicObjectMaterial(AtmData[id][atmObjID], 1, 1975, "texttest", "kb_red", 0x00000000);
	SetDynamicObjectMaterial(AtmData[id][atmObjID], 3, 6060, "shops2_law", "atmflat", 0x00000000);
	format(str, sizeof(str), "[ID: %d]", id);
	AtmData[id][atmLabel] = CreateDynamic3DTextLabel(str, COLOR_PURPLE2, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ] + 0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, AtmData[id][atmWorld], AtmData[id][atmInt], -1, 10.0);
	Iter_Add(ATMS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO atms SET id='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d'", id, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], AtmData[id][atmRX], AtmData[id][atmRY], AtmData[id][atmRZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	mysql_tquery(g_SQL, query, "OnAtmCreated", "ii", playerid, id);
	return 1;
}

function OnAtmCreated(playerid, id)
{
	Atm_Save(id);
	Servers(playerid, "You has created ATM id: %d.", id);
	return 1;
}

CMD:editatm(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	if(pData[playerid][EditingATMID] != -1) return Error(playerid, "You're already editing.");

	new id;
	if(sscanf(params, "i", id)) return SyntaxMsg(playerid, "/editatm [id]");
	if(!Iter_Contains(ATMS, id)) return Error(playerid, "Invalid ID.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ])) return Error(playerid, "You're not near the atm you want to edit.");
	pData[playerid][EditingATMID] = id;
	EditDynamicObject(playerid, AtmData[id][atmObjID]);
	return 1;
}

CMD:removeatm(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return SyntaxMsg(playerid, "/removeatm [id]");
	if(!Iter_Contains(ATMS, id)) return Error(playerid, "Invalid ID.");
	
	if(Atm_BeingEdited(id)) return Error(playerid, "Can't remove specified atm because its being edited.");
	DestroyDynamicObject(AtmData[id][atmObjID]);
	DestroyDynamic3DTextLabel(AtmData[id][atmLabel]);
	
	AtmData[id][atmX] = AtmData[id][atmY] = AtmData[id][atmZ] = AtmData[id][atmRX] = AtmData[id][atmRY] = AtmData[id][atmRZ] = 0.0;
	AtmData[id][atmInt] = AtmData[id][atmWorld] = 0;
	AtmData[id][atmObjID] = -1;
	AtmData[id][atmLabel] = Text3D: -1;
	AtmData[id][atmExists] = false;
	Iter_Remove(ATMS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM atms WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Atm %d.", id);
	return 1;
}

CMD:gotoatm(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return SyntaxMsg(playerid, "/gotoatm [id]");
	if(!Iter_Contains(ATMS, id)) return Error(playerid, "ATM ID tidak ada.");
	
	SetPlayerPosition(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 2.0);
    SetPlayerInterior(playerid, AtmData[id][atmInt]);
    SetPlayerVirtualWorld(playerid, AtmData[id][atmWorld]);
	Servers(playerid, "Teleport ke ID ATM %d", id);
	return 1;
}