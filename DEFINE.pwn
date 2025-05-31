// Server Define
#define TEXT_GAMEMODE	"EZYRP | BETA"
#define TEXT_WEBURL		"linktr.ee/wargakota-roleplay"
#define TEXT_LANGUAGE	"Bahasa Indonesia"
/*
#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"root"
#define		MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"wkrp"
*/
#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"root"
#define		MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"ezy"

// how many seconds until it kicks the player for taking too long to login
#define		SECONDS_TO_LOGIN 	300

// default spawn point: Las Venturas (The High Roller)
#define 	DEFAULT_POS_X 		1788.1824
#define 	DEFAULT_POS_Y 		-1877.3479
#define 	DEFAULT_POS_Z 		13.6007
#define 	DEFAULT_POS_A 		271.4230

#define MAX_CHARACTERS   (3)
#define NormalName(%0)                  CharacterList[%0][pData[%0][pChar]]
#define ReturnAdminName(%0)             UcpData[%0][uUsername]

//Android Client Check
//#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

// Message
#define function%0(%1) forward %0(%1); public %0(%1)
#define Servers(%1,%2) SendClientMessageEx(%1, COLOR_PURPLE, "Server: "WHITE_E""%2)
#define Info(%1,%2) SendClientMessageEx(%1, COLOR_PURPLE, "[ i ]: "WHITE_E""%2)
#define Vehicle(%1,%2) SendClientMessageEx(%1, COLOR_PURPLE, "VEHICLE: "WHITE_E""%2)
#define Usage(%1,%2) SendClientMessage(%1, COLOR_PURPLE , "CMD: "WHITEP_E""%2)
#define Error(%1,%2) SendClientMessageEx(%1, COLOR_PURPLE, ""RED_E"< ! >: "WHITE_E""%2)
#define AdminCMD(%1,%2) SendClientMessageEx(%1, COLOR_PURPLE , "[AdmCmd]: "WHITEP_E""%2)
#define Gps(%1,%2) SendClientMessageEx(%1, COLOR_GREY3, ""COLOR_GPS"[GPS]: "WHITE_E""%2)
#define SCM SendClientMessage
#define SM(%0,%1) \
    SendClientMessageEx(%0, COLOR_PURPLE, "»"WHITE_E" "%1)
//#define PermissionError(%0) SendClientMessage(%0, COLOR_RED, "ERROR: "WHITE_E"Kamu tidak memiliki akses untuk melakukan command ini!")

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//Converter
#define minplus(%1) \
        (((%1) < 0) ? (-(%1)) : ((%1)))

// AntiCaps
#define UpperToLower(%1) for( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

//Android Client Check
#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)

// Banneds
const BAN_MASK = (-1 << (32 - (/*this is the CIDR ip detection range [def: 26]*/26)));

new g_player_listitem[MAX_PLAYERS][96];
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2

#define MAX_RADIOS 999

//---------[ Define Untuk Crate ] ------------
#define CRATES 9

//---------[ Define Faction ]-----
#define SAPD	1		//locker 1573.26, -1652.93, -40.59
#define	SAGS	2		// 1464.10, -1790.31, 2349.68
#define SAMD	3		// -1100.25, 1980.02, -58.91
#define SANEW	4		// 256.14, 1776.99, 701.08
#define CAFE	5		// 256.14, 1776.99, 701.08
//---------[ JOB ]---------//
#define BOX_INDEX            9 // Index Box Barang

/*
//connectlogs
		new DCC_Embed:logss;
		new yy, mm, dd, timestamp[200];
		getdate(yy, mm , dd);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, mm, dd);
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "Warga Kota");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0xa5ff00);
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		DCC_SetEmbedDescription(logss, "Player Connect");
		new stroi[5000];
		format(stroi, sizeof(stroi), "%s", UcpData[playerid][uUsername]);
		DCC_AddEmbedField(logss, "Nama UCP", stroi, true);
		format(stroi, sizeof(stroi), "%s", GetRPName(playerid));
		DCC_AddEmbedField(logss, "Character", stroi, true);
		format(stroi, sizeof(stroi), "%d", pData[playerid][pID]);
		DCC_AddEmbedField(logss, "UID", stroi, true);
		DCC_SendChannelEmbedMessage(connectlogs, logss);
*/
