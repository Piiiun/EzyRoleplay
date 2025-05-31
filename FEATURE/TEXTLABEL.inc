#include <YSI\y_hooks>
#define MAX_LABEL 50

enum e_label
{
	Float: LPointX,
	Float: LPointY,
	Float: LPointZ,
	Float: LPointRX,
	Float: LPointRY,
	Float: LPointRZ,
	LPointInt,
	LPointWorld,
    LPointExists,
	// temp
	LPointObjID,
    LPointArea,
	Text3D: LPoint3Text
}

new LabelData[MAX_LABEL][e_label],
	Iterator:LABELS<MAX_LABEL>;

function LoadLabels()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0, str[300];
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", LabelData[id][LPointX]);
			cache_get_value_name_float(i, "posy", LabelData[id][LPointY]);
			cache_get_value_name_float(i, "posz", LabelData[id][LPointZ]);
			cache_get_value_name_float(i, "posrx", LabelData[id][LPointRX]);
			cache_get_value_name_float(i, "posry", LabelData[id][LPointRY]);
			cache_get_value_name_float(i, "posrz", LabelData[id][LPointRZ]);
			cache_get_value_name_int(i, "interior", LabelData[id][LPointInt]);
			cache_get_value_name_int(i, "world", LabelData[id][LPointWorld]);
			LabelData[id][LPointObjID] = CreateDynamicPickup(1276, 0, LabelData[id][LPointX], LabelData[id][LPointY], LabelData[id][LPointZ], LabelData[id][LPointWorld], LabelData[id][LPointInt]);			
			format(str, 300, "Selamat datang di {B897FF}Warga Kota\n{FFFF00}'/help'{FFFFFF} -> Petunjuk & bantuan.\n{FFFF00}'/ask'{FFFFFF} -> Hanya untuk bertanya seputar server & fitur.\n{FFFF00}'/report{FFFFFF} -> Melaporkan bug atau player yang melanggar aturan");
			LabelData[id][LPoint3Text] = CreateDynamic3DTextLabel(str, COLOR_WHITE, LabelData[id][LPointX], LabelData[id][LPointY], LabelData[id][LPointZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, LabelData[id][LPointWorld], LabelData[id][LPointInt], -1, 30.0);
            LabelData[id][LPointExists] = true;
			Iter_Add(LABELS, id);
	    	i++;
		}
		printf("[LABEL POINT]: %d Loaded.", i);
	}
}

Label_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE labelpoint SET posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d' WHERE id='%d'",
	LabelData[id][LPointX],
	LabelData[id][LPointY],
	LabelData[id][LPointZ],
	LabelData[id][LPointRX],
	LabelData[id][LPointRY],
	LabelData[id][LPointRZ],
	LabelData[id][LPointInt],
	LabelData[id][LPointWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

CMD:createlabel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return Error(playerid, "You don't have permission to use this command!");
		
	new id = Iter_Free(LABELS), query[512];
	if(id == -1) return Error(playerid, "Can't add any more Label.");
 	new Float: x, Float: y, Float: z;
 	GetPlayerPos(playerid, x, y, z);
	
	LabelData[id][LPointX] = x;
	LabelData[id][LPointY] = y;
	LabelData[id][LPointZ] = z;
	LabelData[id][LPointRX] = LabelData[id][LPointRY] = LabelData[id][LPointRZ] = 0.0;
	LabelData[id][LPointInt] = GetPlayerInterior(playerid);
	LabelData[id][LPointWorld] = GetPlayerVirtualWorld(playerid);
    LabelData[id][LPointExists] = true;
	
    new str[300];
	LabelData[id][LPointObjID] = CreateDynamicPickup(18631, 0, LabelData[id][LPointX], LabelData[id][LPointY], LabelData[id][LPointZ], LabelData[id][LPointWorld], LabelData[id][LPointInt]);			
	format(str, 300, "Selamat datang di {B897FF}Warga Kota\n{FFFF00}'/help'{FFFFFF} -> Petunjuk & bantuan.\n{FFFF00}'/ask'{FFFFFF} -> Hanya untuk bertanya seputar server & fitur.\n{FFFF00}'/report{FFFFFF} -> Melaporkan bug atau player yang melanggar aturan");
	LabelData[id][LPoint3Text] = CreateDynamic3DTextLabel(str, COLOR_WHITE, LabelData[id][LPointX], LabelData[id][LPointY], LabelData[id][LPointZ]+0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, LabelData[id][LPointWorld], LabelData[id][LPointInt], -1, 30.0);
    LabelData[id][LPointExists] = true;
	Iter_Add(LABELS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO labelpoint SET id='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d'", id, LabelData[id][LPointX], LabelData[id][LPointY], LabelData[id][LPointZ], LabelData[id][LPointRX], LabelData[id][LPointRY], LabelData[id][LPointRZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	mysql_tquery(g_SQL, query, "OnLabelCreated", "ii", playerid, id);
	return 1;
}

function OnLabelCreated(playerid, id)
{
	Label_Save(id);
	return 1;
}

CMD:deletelabel(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
		return Error(playerid, "You don't have permission to use this command!");
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deletelabel [id]");
	if(!Iter_Contains(LABELS, id)) return Error(playerid, "Invalid ID.");
	
	DestroyDynamicPickup(LabelData[id][LPointObjID]);
	DestroyDynamic3DTextLabel(LabelData[id][LPoint3Text]);
	
	LabelData[id][LPointX] = LabelData[id][LPointY] = LabelData[id][LPointZ] = LabelData[id][LPointRX] = LabelData[id][LPointRY] = LabelData[id][LPointRZ] = 0.0;
	LabelData[id][LPointInt] = LabelData[id][LPointWorld] = 0;
	LabelData[id][LPointObjID] = -1;
	LabelData[id][LPoint3Text] = Text3D: -1;
    LabelData[id][LPointExists] = false;
	Iter_Remove(LABELS, id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM labelpoint WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	return 1;
}