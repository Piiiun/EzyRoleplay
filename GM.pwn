///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
      * BASED OF GAMEMODE: LRP v7

               [================== THANKS TO ==================]
               [ + SERVER PC/ANDROID WARGA KOTA ROLEPLAY       ]
               [ + ZiroHanz ( Developer )                      ]
               [ + Satrio  ( Kredit )                          ]
               [ + Warga Kota Roleplay  Staff's                ]
			   [ + ZiroHamz  ( Server Owner )                  ]
               [===============================================]

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 500
#include <crashdetect>
 
#include <sscanf2>
#include <a_mysql>
#include <a_zones>	

#include <gvar>	
#include <a_actor>
#include <strlib>

#include <progress2>
#include <Pawn.CMD>
#include <mSelection.inc>
#include <FiTimestamp>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg>
#include <streamer>
#include <EVF2>
#include <YSI\y_timers>
#include <YSI\y_hooks>
#include <YSI\y_ini>
#include <yom_buttons>
#include <geoiplite>
#include <garageblock>
#include <tp>
#include <compat>
#define DCMD_PREFIX '!'
#include <discord-connector>
#include <discord-cmd>
#include <fixobject>
#include <textdraw-streamer>
#include <callbacks>
#include <dini.inc>
#include <easyDialog> 
#include <foreach>
//#include <winteredition>

//#include <nex-ac>                  

//#include <samp-loadingbar>
#include <loadingbar.inc>
#include <td-actions>

//-----[ Modular ]-----
#include "DEFINE.pwn"

#include <sampvoice>
#define GLOBAL_CHANNEL 0
#define  LOCAL_CHANNEL 1

new bool:Warung;
//pedagang
new menumasak;
new menuminum;
//new menupedagang;

//-----[ Twitter ]-----
new tweet[60];

//nikahan
new WatchingTV[MAX_PLAYERS];
new Spectating[MAX_PLAYERS];

//garasi fraksi
//STATIC SANA
new SANAVeh[MAX_PLAYERS];
//STATIC SAGS
new SAGSVeh[MAX_PLAYERS];
//STATIC SAPD
new SAPDVeh[MAX_PLAYERS];
//callsign
new vehiclecallsign[MAX_VEHICLES];
new STREAMER_TAG_3D_TEXT_LABEL:vehicle3Dtext[MAX_VEHICLES];
//STATIC SAMD
new SAMDVeh[MAX_PLAYERS];

//voicehp
new SV_UINT:gstream = SV_NULL;
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:OnPhone[MAX_PLAYERS];
new TogglePhone[MAX_PLAYERS];
new ToggleSid[MAX_PLAYERS];
new ToggleCall[MAX_PLAYERS];
new JamCall[MAX_PLAYERS];
new DetikCall[MAX_PLAYERS];
new MenitCall[MAX_PLAYERS];
new CallTimer[MAX_PLAYERS];
new cbugwarn[MAX_PLAYERS];

//dc
new STATUS_BOT2;
new pemainic;
new DCC_Channel:activecs;

//serverlogs
new DCC_Channel:serverlogs; 
new DCC_Channel:acceptdeathlogs;
new DCC_Channel:connectlogs;
new DCC_Channel:cheatlogs;
new DCC_Channel:AdminLogs; 
//drone
new Drones[MAX_PLAYERS];


//-----[ Selfie System ]-----
new takingselfie[MAX_PLAYERS];
new Float:Degree[MAX_PLAYERS];
const Float: Radius = 1.4; //do not edit this
const Float: Speed  = 1.25; //do not edit this
const Float: Height = 1.0; // do not edit this
new Float:lX[MAX_PLAYERS];
new Float:lY[MAX_PLAYERS];
new Float:lZ[MAX_PLAYERS];

//disnaker
new Disnaker;
new Staterpack;
//======[ LENZ JOB ]========
new Sopirbus;
new Merchantfiller;
new mekanik;
new tukangayam;
new petani;
new tukangtebang;
new penambang;
new product;
new markisaa;
new penambangminyak;
new pemerah;
new PemerahCP;
//new markisaCP;
new Trucker;
new bagage;

//====== QUIZ
new quiz,
	answers[256],
	answermade,
	qprs;

new RobMember = 0;
// EVENT SYSTEM
new EventCreated = 0, EventStarted = 0, EventPrize = 500;
new Float: RedX, Float: RedY, Float: RedZ, EventInt, EventWorld;
new Float: BlueX, Float: BlueY, Float: BlueZ;
new EventHP = 100, EventArmour = 0, EventLocked = 0;
new EventWeapon1, EventWeapon2, EventWeapon3, EventWeapon4, EventWeapon5;
new BlueTeam = 0, RedTeam = 0;
new MaxRedTeam = 5, MaxBlueTeam = 5;
new IsAtEvent[MAX_PLAYERS];

new AntiBHOP[MAX_PLAYERS];

//-----[ Baggage ]-----	
new bool:DialogBaggage[10];
new bool:MyBaggage[MAX_PLAYERS][10];
//-----[ Type Checkpoint ]-----	
enum
{
	CHECKPOINT_NONE = 0,
	CHECKPOINT_BAGGAGE,
	CHECKPOINT_DRIVELIC
}

//----------[ New Variable ]-----
enum
{
	//---[ DIALOG PUBLIC ]---
	DIALOG_RADIO,
	DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_AGE,
	DIALOG_GENDER,
	DIALOG_EMAIL,
	DIALOG_PASSWORD,
	DIALOG_STATS,
	DIALOG_SETTINGS,
	DIALOG_HBEMODE,
	DIALOG_CHANGEAGE,
	DIALOG_VERIFYCODE,
	//-----------------------
	DIALOG_GOLDSHOP,
	DIALOG_GOLDNAME,
	//-----------------------
	//SATERPACK
	DIALOG_SP,
	//---[ DIALOG BISNIS ]---
	DIALOG_SELL_BISNISS,
	DIALOG_SELL_BISNIS,
	DIALOG_MY_BISNIS,
	BISNIS_MENU,
	BISNIS_INFO,
	BISNIS_NAME,
	BISNIS_VAULT,
	BISNIS_WITHDRAW,
	BISNIS_DEPOSIT,
	BISNIS_BUYPROD,
	BISNIS_EDITPROD,
	BISNIS_EDITNAME,
	BISNIS_NAMESET,
	BISNIS_PRICESET,
	DIALOG_URL_BISNIS,
	BISNIS_BUYRESTOCK,
	//---[ DIALOG HOUSE ]---
	DIALOG_SELL_HOUSES,
	DIALOG_SELL_HOUSE,
	DIALOG_MY_HOUSES,
	HOUSE_INFO,
	HOUSE_STORAGE,
	HOUSE_WEAPONS,
	HOUSE_MONEY,
	HOUSE_WITHDRAWMONEY,
	HOUSE_DEPOSITMONEY,
	//---[ DIALOG PRIVATE VEHICLE ]---
	DIALOG_MYVEH,
	DIALOG_MYVEH_INFO,
	DIALOG_FINDVEH,
	DIALOG_TRACKVEH,
	DIALOG_GOTOVEH,
	DIALOG_GETVEH,
	DIALOG_DELETEVEH,
	DIALOG_BUYPV,
	DIALOG_BUYVIPPV,
	DIALOG_BUYPLATE,
	DIALOG_BUYPVCP,
	DIALOG_BUYPVCP_BIKES,
	DIALOG_BUYPVCP_CARS,
	DIALOG_BUYPVCP_UCARS,
	DIALOG_BUYPVCP_JOBCARS,
	DIALOG_BUYPVCP_VIPCARS,
	DIALOG_BUYPVCP_CONFIRM,
	DIALOG_BUYPVCP_VIPCONFIRM,
	DIALOG_RENT_JOBCARS,
	DIALOG_RENT_JOBCARSCONFIRM,
	//---[ DIALOG DEALER ]---
	D_DEALER,
	D_SELLCARTOSERVER,
	D_SELLCARDEALER,
	//---[ DIALOG TOYS ]---
	DIALOG_TOY,
	DIALOG_TOYEDIT,
	DIALOG_TOYPOSISI,
	DIALOG_TOYPOSISIBUY,
	DIALOG_TOYBUY,
	DIALOG_TOYVIP,
	DIALOG_TOYPOSX,
	DIALOG_TOYPOSY,
	DIALOG_TOYPOSZ,
	DIALOG_TOYPOSRX,
	DIALOG_TOYPOSRY,
	DIALOG_TOYPOSRZ,
	//---[ DIALOG PLAYER ]---
	DIALOG_HELP,
	DIALOG_GPS,
	DIALOG_JOB,
	DIALOG_GPS_JOB,
	DIALOG_GPS_MORE,
	DIALOG_PAY,
	DIALOG_GPS_PUBLIC,
	DIALOG_GPS_PROPERTIES,
	DIALOG_GPS_GENERAL,
	DIALOG_GPS_MISSION,
	DIALOG_TRACKBUSINESS,
	DIALOG_ELECTRONIC_TRACK,
	DIALOG_TRACKATM,
	//---[ DIALOG WEAPONS ]---
	DIALOG_EDITBONE,
	//---[ DIALOG FAMILY ]---
	FAMILY_SAFE,
	FAMILY_STORAGE,
	FAMILY_WEAPONS,
	FAMILY_MARIJUANA,
	FAMILY_WITHDRAWMARIJUANA,
	FAMILY_DEPOSITMARIJUANA,
	FAMILY_COMPONENT,
	FAMILY_WITHDRAWCOMPONENT,
	FAMILY_DEPOSITCOMPONENT,
	FAMILY_MATERIAL,
	FAMILY_WITHDRAWMATERIAL,
	FAMILY_DEPOSITMATERIAL,
	FAMILY_MONEY,
	FAMILY_WITHDRAWMONEY,
	FAMILY_DEPOSITMONEY,
	FAMILY_INFO,
	//---[ DIALOG FACTION ]---
	DIALOG_LOCKERSAPD,
	DIALOG_WEAPONSAPD,
	DIALOG_LOCKERSAGS,
	DIALOG_WEAPONSAGS,
	DIALOG_LOCKERSAMD,
	DIALOG_WEAPONSAMD,
	DIALOG_LOCKERSANEW,
	DIALOG_WEAPONSANEW,
	
	DIALOG_LOCKERVIP,
	//---[ DIALOG JOB ]---
	//MECH
	DIALOG_SERVICE,
	DIALOG_SERVICE_COLOR,
	DIALOG_SERVICE_COLOR2,
	DIALOG_SERVICE_PAINTJOB,
	DIALOG_SERVICE_WHEELS,
	DIALOG_SERVICE_SPOILER,
	DIALOG_SERVICE_HOODS,
	DIALOG_SERVICE_VENTS,
	DIALOG_SERVICE_LIGHTS,
	DIALOG_SERVICE_EXHAUSTS,
	DIALOG_SERVICE_FRONT_BUMPERS,
	DIALOG_SERVICE_REAR_BUMPERS,
	DIALOG_SERVICE_ROOFS,
	DIALOG_SERVICE_SIDE_SKIRTS,
	DIALOG_SERVICE_BULLBARS,
	DIALOG_SERVICE_NEON,
	//Trucker
	DIALOG_HAULING,
	//DOKTERLOKAL
	DIALOG_DOKTERLOKAL,
	//ARMS Dealer
	DIALOG_ARMS_GUN,
	
	//Farmer job
	DIALOG_PLANT,
	DIALOG_EDIT_PRICE,
	DIALOG_EDIT_PRICE1,
	DIALOG_EDIT_PRICE2,
	DIALOG_EDIT_PRICE3,
	DIALOG_EDIT_PRICE4,
	DIALOG_OFFER,
	//----[ Items ]-----
	DIALOG_MATERIAL,
	DIALOG_COMPONENT,
	DIALOG_DRUGS,
	DIALOG_FOOD,
	DIALOG_FOOD_BUY,
	DIALOG_SEED_BUY,
	DIALOG_PRODUCT,
	DIALOG_GASOIL,
	DIALOG_APOTEK,
	//Bank
	DIALOG_ATM,
	DIALOG_ATMWITHDRAW,
	DIALOG_BANK,
	DIALOG_BANKDEPOSIT,
	DIALOG_BANKWITHDRAW,
	DIALOG_BANKREKENING,
	DIALOG_BANKTRANSFER,
	DIALOG_BANKCONFIRM,
	DIALOG_BANKSUKSES,
	
	//reports
	DIALOG_REPORTS,
	//ask
	DIALOG_ASKS,
	DIALOG_SALARY,
	DIALOG_PAYCHECK,
	
	//Sidejob
	DIALOG_SWEEPER,
	DIALOG_BUS,
	DIALOG_FORKLIFT,
	// HEALTH
	DIALOG_HEALTH,
	//job pemerah
	DIALOG_LOCKERPEMERAH,
	// OBAT
	DIALOG_OBAT,
	// KUOTA
	DIALOG_ISIKUOTA,
	DIALOG_DOWNLOAD,
	DIALOG_KUOTA,
	// STUCK
	DIALOG_STUCK,
	// TDM
	DIALOG_TDM,
	// Admin
	DIALOG_PICKUPVEH,
	DIALOG_TRACKPARK,
	DIALOG_MY_WS,
	DIALOG_TRACKWS,
	WS_MENU,
	WS_SETNAME,
	WS_SETOWNER,
	WS_SETEMPLOYE,
	WS_SETEMPLOYEE,
	WS_SETOWNERCONFIRM,
	WS_SETMEMBER,
	WS_SETMEMBERE,
	WS_MONEY,
	WS_WITHDRAWMONEY,
	WS_DEPOSITMONEY,
	WS_COMPONENT,
	WS_COMPONENT2,
	WS_MATERIAL,
	WS_MATERIAL2,
	DIALOG_TELEPORT_CONFIRM,
	//VOICE
	DIALOG_VOICE,
	//ANIM
	DIALOG_ANIM,
	//streamer
	DIALOG_STREAMER_CONFIG,
	//atm
	//atm
	DIALOG_FTRANSFER,
	DIALOG_FWITHDRAW,
	DIALOG_FDEPOSIT,
	//disnaker
	DIALOG_DISNAKER,
	//loker
	DIALOG_DRUGSSAMD,
	//NEW SPAWN FRAKSI
	DIALOG_PILIH_SPAWN,
	//sinyal
	DIALOG_ADMIN_SIGNAL,
	//job ayam
	//ayam
	DIALOG_AYAMFILL,
	DIALOG_AYAM,
	//jobnambang
	DIALOG_LOCKERPENAMBANG,
	DIALOG_LOCKERMINYAK,
	DIALOG_GPS_MINYAK,
	DIALOG_GPS_PENAMBANG,
	DIALOG_TAMBANG,
	//crate
	DIALOG_CRATES,
	DIALOG_CRATE_EXPORT,
	//vending
	DIALOG_MY_VENDING,
	DIALOG_VENDING_INFO,
	DIALOG_VENDING_BUYPROD,
	DIALOG_VENDING_MANAGE,
	DIALOG_VENDING_NAME,
	DIALOG_VENDING_VAULT,
	DIALOG_VENDING_WITHDRAW,
	DIALOG_VENDING_DEPOSIT,
	DIALOG_VENDING_EDITPROD,
	DIALOG_VENDING_PRICESET,
	DIALOG_VENDING_RESTOCK,
	//trucker new
	DIALOG_MENU_TRUCKER,
	DIALOG_SHIPMENTS,
	DIALOG_SHIPMENTS_VENDING,
	DIALOG_RESTOCK,
	DIALOG_RESTOCK_VENDING,
	//mechant filler
	DIALOG_MERCHANTFILLER,
	//pedagang
	DIALOG_MENU,
	DIALOG_MENUMASAK,
	DIALOG_LOCKERPEDAGANG,
	DIALOG_MENUMINUM,
	DIALOG_GUDANGPEDAGANG,
	//job baggage
	DIALOG_BAGGAGE,
	//garasi fraksi
	DIALOG_SANA_GARAGE,
	DIALOG_SAGS_GARAGE,
	DIALOG_SAMD_GARAGE,
	DIALOG_SAPD_GARAGE,
	//umpan beli umpan
	DIALOG_UMPAN,
	//new inv
	DIALOG_PISSUE,
	DIALOG_GIVE,
	DIALOG_AMOUNT,
	DIALOG_ACTORANIM,
	//DROP
	DIALOG_TAKE,
	//hp
	DIALOG_AIRDROP,
	DIALOG_PHONE_DIALUMBER,
	DIALOG_IKLANHP,
	DIALOG_IBANK,
	DIALOG_TWITTERPOST,
	DIALOG_TWITTER,
	DIALOG_TWITTERNAME,
	TWEET_APP,
	TWEET_SIGNUP,
	TWEET_CHANGENAME,
	TWEET_ACCEPT_CHANGENAME,
	DIALOG_TWEETMODE,
	PHONE_NOTIF,
	DIALOG_CALLGOCAR,
	DIALOG_MUSICHP,
	DIALOG_PHONE_CONTACT,
	DIALOG_PHONE_TEXTSMS,
	DIALOG_PHONE_SENDSMS,
	DIALOG_PHONE_INFOCONTACT,
	DIALOG_PHONE_NEWCONTACT,
	DIALOG_PHONE_ADDCONTACT,
	DIALOG_AIRDROP1,
	DIALOG_AIRDROP2,
	DIALOG_AIRDROP3,
	DIALOG_MUSICHP2,
	DIALOG_PANELPHONE,
	DIALOG_TOGGLEPHONE,
	//dialog
	DIALOG_SELECTCHAR,
	DIALOG_CREATECHAR
}

// DOWNLOAD
new download[MAX_PLAYERS];
// Countdown
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

// WBR
//new File[128]; /ini 

// ROB
new robmoney;


//-----[ Trucker ]-----	
new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];

// Server Uptime
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//Model Selection 
new SpawnMale = mS_INVALID_LISTID,
	SpawnFemale = mS_INVALID_LISTID,
	MaleSkins = mS_INVALID_LISTID,
	FemaleSkins = mS_INVALID_LISTID,
	VIPMaleSkins = mS_INVALID_LISTID,
	VIPFemaleSkins = mS_INVALID_LISTID,
	SAPDMale = mS_INVALID_LISTID,
	SAPDFemale = mS_INVALID_LISTID,
	SAPDWar = mS_INVALID_LISTID,
	SAGSMale = mS_INVALID_LISTID,
	SAGSFemale = mS_INVALID_LISTID,
	SAMDMale = mS_INVALID_LISTID,
	SAMDFemale = mS_INVALID_LISTID,
	SANEWMale = mS_INVALID_LISTID,
	SANEWFemale = mS_INVALID_LISTID,
	toyslist = mS_INVALID_LISTID,
	viptoyslist = mS_INVALID_LISTID,
	PDGSkinMale = mS_INVALID_LISTID,
	PDGSkinFemale = mS_INVALID_LISTID;
	
// Faction Vehicle
#define VEHICLE_RESPAWN 7200

new SAPDVehicles[30],
	SAGSVehicles[30],
	SAMDVehicles[30],
	SANAVehicles[30];

// Faction Vehicle
IsSAPDCar(carid)
{
	for(new v = 0; v < sizeof(SAPDVehicles); v++)
	{
	    if(carid == SAPDVehicles[v]) return 1;
	}
	return 0;
}

IsGovCar(carid)
{
	for(new v = 0; v < sizeof(SAGSVehicles); v++)
	{
	    if(carid == SAGSVehicles[v]) return 1;
	}
	return 0;
}

IsSAMDCar(carid)
{
	for(new v = 0; v < sizeof(SAMDVehicles); v++)
	{
	    if(carid == SAMDVehicles[v]) return 1;
	}
	return 0;
}

IsSANACar(carid)
{
	for(new v = 0; v < sizeof(SANAVehicles); v++)
	{
	    if(carid == SANAVehicles[v]) return 1;
	}
	return 0;
}

//Showroom Checkpoint
new ShowRoomCP,
	ShowRoomCPRent;

// Showroom Vehicles
//new SRV[35],
//	VSRV[20];
	
/*// Button and Doors
new SAGSLobbyBtn[2],
	SAGSLobbyDoor;
new gMyButtons[2],
	gMyDoor;*/
	
/*//Keypad Txd
new SAGSLobbyKey[2],
	SAGSLobbyDoor;
*/

// Duty Timer

new DutyTimer;

// Yom Button
new SAGSLobbyBtn[2],
	SAGSLobbyDoor,
	SAPDLobbyBtn[4],
	SAPDLobbyDoor[4],
	LLFLobbyBtn[2],
	LLFLobbyDoor;

// MySQL connection handle
new MySQL: g_SQL;

new TogOOC = 1;

enum ucpData {
    uID,
    uUsername[64],
    uPassword[128],
    uVerifyCode[32],
    uSalt[128],
    uIP[16],
    uLogged,
    uLoginAttempts,
    uRegisterDate,
	uExtraChar,

    uAdmin,
};
new UcpData[MAX_PLAYERS][ucpData];

// Player data
enum E_PLAYERS
{
	pOnline,
	pID,
	pUCP[22],
	pExtraChar,
	pChar,
	pCharacterStory,
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	pTwittername[MAX_PLAYER_NAME],
	pIP[16],
	pPassword[65],
	pSalt[17],
	pEmail[40],
	pAdmin,
	pClikmap,
	pHelper,
	pLevel,
	pLevelUp,
	pVip,
	pVipTime,
	pGold,
	pRegDate[50],
	pLastLogin[50],
	pMoney,
	Text3D:pMaskLabel,
	pBankMoney,
	pBankRek,
	pPhone,
	pPhoneCredit,
	pPhoneBook,
	pPhoneOff,
	pContact,
	pSMS,
	pCall,
	pCallTime,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pGender,
	pAge[50],
	pInDoor,
	pInHouse,
	pInBiz,
	pInVending,
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
	pHunger,
	pBladder,
	pEnergy,
	pHungerTime,
	pEnergyTime,
	pBladderTime,
	pSick,
	pSickTime,
	pHospital,
	pHospitalTime,
	pInjured,
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pFactionLead,
	pTazer,
	pBroadcast,
	pNewsGuest,
	pFamily,
	pFamilyRank,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pWarn,
	pJob,
	pJob2,
	pJobTime,
	pExitJob,
	pMedicine,
	pMedkit,
	pMask,
	pHelmet,
	pSnack,
	pSprunk,
	pGas,
	pBandage,
	pGPS,
	pGpsActive,
	pMaterial,
	pComponent,
	pFood,
	pSeed,
	pPotato,
	pWheat,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pPlant,
	pPlantTime,
	pFishTool,
	pWorm,
	pFish,
	pInFish,
	pIDCard,
	pIDCardTime,
	pDriveLic,
	pDriveLicTime,
	pDriveLicApp,
	pBoatLic,
	pBoatLicTime,
	pFlyLic,
	pFlyLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pSpaTime,
	pAdminDuty,
	pOnDutyMendung,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	pSPY,
	pTogPM,
	pTogLog,
	pTogAds,
	pTogWT,
	Text3D:pAdoTag,
	Text3D:pBTag,
	bool:pBActive,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackBisnis,
	pTrackVending,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pFindEms,
	pCuffed,
	toySelected,
	bool:PurchasedToy,
	pEditingItem,
	pProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	playerSpectated,
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pHelmetOn,
	pSeatBelt,
	pReportTime,
	pAskTime,
	//vending
	pEditingVendingItem,
	pVendingProductModify,
	//Vending
	EditingVending,
	//Player Progress Bar
	PlayerBar:fuelbar,
	PlayerBar:damagebar,
	PlayerBar:hungrybar,
	PlayerBar:energybar,
	PlayerBar:bladdybar,
	PlayerBar:spfuelbar,
	PlayerBar:spdamagebar,
	PlayerBar:sphungrybar,
	PlayerBar:spenergybar,
	PlayerBar:spbladdybar,
	PlayerBar:activitybar,
	pProducting,
	pCooking,
	pArmsDealer,
	pMechanic,
	pActivity,
	pActivityTime,
	//Jobs
	pSideJob,
	pSideJobTime,
	pGetJob,
	pGetJob2,
	pTaxiDuty,
	pTaxiTime,
	pFare,
	pFareTimer,
	pTotalFare,
	Float:pFareOldX,
	Float:pFareOldY,
	Float:pFareOldZ,
	Float:pFareNewX,
	Float:pFareNewY,
	Float:pFareNewZ,
	pMechDuty,
	pMechVeh,
	pMechColor1,
	pMechColor2,
	//trash
	EditingTrash,
	//ATM
	EditingATMID,
	//lumber job
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//Miner job
	EditingOreID,
	MiningOreID,
	CarryingLog,
	LoadingPoint,
	//production
	CarryProduct,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Bank
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//Gas Station
	pFill,
	pFillTime,
	pFillPrice,
	//Gate
	gEditID,
	gEdit,
	// WBR
	pHead,
 	pPerut,
 	pLHand,
 	pRHand,
 	pLFoot,
 	pRFoot,
 	// Inspect Offer
 	pInsOffer,
 	// Obat System
 	pObat,
 	// Suspect
 	pSuspectTimer,
 	pSuspect,
 	// Phone On Off
 	pUsePhone,
 	pTogPhone,
 	// Kurir
 	pKurirEnd,
 	// Shareloc Offer
 	pLocOffer,
 	// Twitter
 	pTwitter,
 	pRegTwitter,
	// Twitter
	pTwitterStatus, 
	pTwitterPostCooldown,
	pTwitterNameCooldown,
 	// Kuota
 	pKuota,
 	// DUTY SYSTEM
 	pDutyHour,
 	// CHECKPOINT
 	pCP,
	//jobstatus
	pFillStatus,
	pMechanicStatus,
	pProductingStatus,
	pCookingStatus,
	pPackingChicken1Status,
	pFryChicken1Status,
	pGetChicken1Status,
	pMilkJobStatus,
 	// ROBBERY
 	pRobTime,
 	pRobOffer,
 	pRobLeader,
 	pRobMember,
 	pMemberRob,
 	// Roleplay Booster
 	pBooster,
 	pBoostTime,
	pTrailer,
	// Smuggler
	bool:pTakePacket,
	pTrackPacket,
	//new data
	//spawn faction
	pFactionVeh,
	//garasi fraksi
	pSpawnSana,
	pSpawnSags,
	pSpawnSamd,
	pSpawnSapd,
	//job baggage
	pBaggage,
	pDelayBaggage,
	pTrailerBaggage,
	//Starterpack
	pStarterpack,
	//Pedagang
	pdgMenuType,
	pInPdg,
	//accent
	pAccent1,
	pAccent[80],
	pTogAccent,
	//nikahan
	pMarried,
	pMarriedTo[128],
	pTogMoney,
	pMarriedAccept,
	pMarriedCancel,
	// Crates Job
	pGetcrateFish[MAX_PLAYERS],
	//jobbaru
	bool:DutyPenambang,
	bool:DutyMinyak,
	//Penambang
	pTimeTambang1,
	pTimeTambang2,
	pTimeTambang3,
	pTimeTambang4,
	pTimeTambang5,
	pTimeTambang6,
	//PENAMBANG
	pDutyJob,
	pBatu,
	pBatuCucian,
	pEmas,
	pBesi,
	pAluminium,
	//trucker
	pTruckerTime,
	pMission,
	pHauling,
	pVendingRestock,
	bool: CarryingBox,
	//PENAMBANGMINYAK
	pMinyak,
	pEssence,
	//Senter
	pFlashlight,
	pUsedFlashlight,
	//job ayam
	//pemotong ayam
	pGetChicken,
	pChicken,
	pFryChicken,
	pGetChicken1,
	pChicken1,
	pFryChicken1,
	pPackingChicken1,
	timerambilayamhidup,
    timerpotongayam,
    timerpackagingayam,
    timerjualayam,
    AyamHidup,
	AyamPotong,
	AyamFillet,
	sedangambilayam,
    sedangpotongayam,
    sedangfilletayam,
    sedangjualayam,
	pPemotongStatus,
	//GPS TAG HAN
	pWaypoint,
	pLocation[32],
	Float:pWaypointPos[3],
	PlayerText:pTextdraws[83],
		//UPDATE HUD
	pProgress,
	//NEW
	//afk
	Float:pAFKPos[6],
	pAFK,
	pAFKTime,	
	//
	//Checkpoint
	pCheckPoint,
	//
	EditingSIGNAL,
	//vip
	pTogVip,
	// Phone On Off
 	pPhoneStatus,
	//Voice status
	pVoiceStatus,
	//Anim
	pLoopAnim,
	//UNTUK //LIVEMODE
	pLiveText[256],
	pLiveChannel[256],
	//tambahan biar bisa inventory
	pSelectItem,
	pTarget,
	pGiveAmount,
	//=======[ PEMERAS SUSU ]======
	pSusu,
	bool:pJobmilkduty,
	pMilkJob,
	bool:pLoading,
	pSusuOlahan,
	//new
	pKecubung,
	pBotol,
	pPaketkecubung,
	sampahsaya,
	pKanabis,
	pPakaian,
	pStarling,
	pSteak,
	pVest,
	pMilxMax,
	pRoti,
	pKebab,
	pCappucino,
	pPerban,
	pRokok,
	pObatStress,
	pBijikopi,
	pSariteh,
	pSarijeruk,
	pBeras,
	pSambal,
	pTepung,
	pModal,
	pGula,
	pKopiruq,
	pEsteh,
	pEsjeruk,
	pNasikucing,
	pAyamgeprek,
	pKuerayy,
	pLockPick,
	pCig,
	pMineral,
	pPizza,
	pBurger,
	pChiken,
	pPenyu,
	pBlueFish,
	pNemo,
	pMakarel,
	pPadi,
	pCabai,
	pJagung,
	pTebu,
	pPadiOlahan,
	pJagungOlahan,
	pTebuOlahan,
	pCabaiOlahan,
	pKain,
	pWool,
	pSavedNum,
	//akhir inventory
	// Garkot
	pPark,
	pLoc,
	// WS
	pMenuType,
	pInWs,
	pTransferWS,
};
new pData[MAX_PLAYERS][E_PLAYERS];
new CharacterList[MAX_PLAYERS][MAX_CHARACTERS][MAX_PLAYER_NAME + 1];
new g_MysqlRaceCheck[MAX_PLAYERS];
#define PlayerData pData
#define PlayerInfo PlayerData
#define AccountData PlayerData

//---------- SMUGGLER

new Text3D:packetLabel,
	packetObj,
	Float:paX, 
	Float:paY, 
	Float:paZ;

//-----[ Lumber Object Vehicle ]-----	
#define MAX_BOX 50
#define BOX_LIFETIME 100
#define BOX_LIMIT 8

enum    E_BOX
{
	boxDroppedBy[MAX_PLAYER_NAME],
	boxSeconds,
	boxObjID,
	boxTimer,
	boxType,
	Text3D: boxLabel
}
new BoxData[MAX_BOX][E_BOX],
	Iterator:Boxs<MAX_BOX>;

new
	BoxStorage[MAX_VEHICLES][BOX_LIMIT];

//----------[ Lumber Object Vehicle Job ]------------
#define MAX_LUMBERS 50
#define LUMBER_LIFETIME 100
#define LUMBER_LIMIT 10

enum    E_LUMBER
{
	// temp
	lumberDroppedBy[MAX_PLAYER_NAME],
	lumberSeconds,
	lumberObjID,
	lumberTimer,
	Text3D: lumberLabel
}
new LumberData[MAX_LUMBERS][E_LUMBER],
	Iterator:Lumbers<MAX_LUMBERS>;

new
	LumberObjects[MAX_VEHICLES][LUMBER_LIMIT];
	
new
	Float: LumberAttachOffsets[LUMBER_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};

//---------[ Ores miner Job Log ]-------	
#define LOG_LIFETIME 100
#define LOG_LIMIT 10
#define MAX_LOG 100

/*enum    E_LOG
{
	// temp
	bool:logExist,
	logType,
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	Text3D:logLabel
}
new LogData[MAX_LOG][E_LOG];*/

new
	LogStorage[MAX_VEHICLES][2];

//----------[ Dealer ]-------
enum e_dealership
{
	pClickTruk,
	pClickMotor,
	pClickSuv,
	pClickClassic,
	pClick2Door,
	pClick4Door
};
new PlayerDealer[MAX_PLAYERS][e_dealership];

//-----[ Modular ]-----
main() 
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 8000, true);
}
#include "COLOR.pwn"
#include "UCP.pwn"
#include "TEXTDRAW.pwn"
#include "ANIMS.pwn"
#include "GARKOT.pwn"
#include "FEATURE\DINI_SYSTEM_SAVE.inc"
#include "PRIVATE_VEHICLE.inc"
#include "REPORT.pwn"
#include "ASK.pwn"
#include "WEAPON_ATTH.pwn"
#include "TOYS.pwn"
#include "HELMET.pwn"
#include "SERVER.pwn"
#include "DOOR.pwn"
#include "FAMILY.pwn"
#include "HOUSE.pwn"
#include "BISNIS.pwn"
#include "GAS_STATION.pwn"
#include "DYNAMIC_LOCKER.pwn"
#include "NATIVE.pwn"
#include "SIDEJOB\SIDEJOB_SWEEPER.pwn"
#include "SIDEJOB\SIDEJOB_BUS.pwn"
#include "SIDEJOB\SIDEJOB_FORKLIFT.pwn"
#include "VOUCHER.pwn"
#include "SALARY.pwn"
#include "ATM.pwn"
#include "ARMS_DEALER.pwn"
#include "GATE.pwn"
//#include "AUDIO.pwn"
//#include "ROBBERY.pwn"
#include "WORKSHOP.pwn"
#include "FEATURE/VENDING.inc"
#include "Dealer.pwn"

#include "JOB\JOB_SMUGGLER.pwn"
#include "JOB\JOB_TAXI.pwn"
#include "JOB\JOB_MECH.pwn"
#include "JOB\JOB_LUMBER.pwn"
//#include "JOB\JOB_MINER.pwn" // lama
#include "JOB\JOB_PRODUCTION.pwn"
#include "JOB\JOB_TRUCKER.pwn"
#include "JOB\JOB_FISH.pwn"
#include "JOB\JOB_FARMER.pwn"
//#include "JOB\JOB_KURIR.pwn"
#include "JOB\JOB_PEMOTONGAYAM.inc"
#include "JOB\JOB_PENAMBANG_MINYAK.inc"
#include "JOB\JOB_PENAMBANG_BATU.inc"
#include "JOB\JOB_CRATE.inc"
#include "JOB\JOB_MERCHANT_FILLER.inc"
#include "JOB\JOB_BAGGAGE.inc"
#include "JOB\JOB_PEMERASSAPI.inc"

#include "FEATURE/TRASH.inc"

#include "CMD\ADMIN.pwn"
#include "CMD\FACTION.pwn"
#include "CMD\PLAYER.pwn"

#include "SAPD_TASER.pwn"
#include "SAPD_SPIKE.pwn"

#include "FEATURE/CONTACT.inc"
#include "FEATURE/INV.inc"
#include "FEATURE/ADVERT.inc"
#include "FEATURE/AFKANIM.inc"
#include "FEATURE/EPROP.inc"
#include "FEATURE/TEXTLABEL.inc"
#include "FEATURE/STREAMER.inc"
#include "FEATURE/DISCORD.pwn"
#include "FEATURE/DROP_ITEM.inc"
#include "FEATURE/LOTRE.inc"


#include "DIALOG.pwn"

#include "CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "CMD\ALIAS\ALIAS_HOUSE.pwn"
#include "CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"

#include "FEATURE/SIGNAL.inc"

#include "GARASIFRAKSI/SAMD.inc"
#include "GARASIFRAKSI/SAPD.inc"
#include "GARASIFRAKSI/SAGS.inc"
#include "GARASIFRAKSI/SANA.inc"

#include "EVENT.pwn"

#include "FUNCTION.pwn"

#include "TASK.pwn"

//ziro PROJECT
#include "ziro/MAPPING/MAPPING.inc"
#include "ziro\ACTOR.pwn"
#include "ziro\ROBWARUNG.pwn"
#include "ziro\KANABIS.pwn"

forward SaveLunarSystem(playerid);
public SaveLunarSystem(playerid)
{
	format(File, sizeof(File), "[AkunPlayer]/Stats/%s.ini", pData[playerid][pName]);
	if( dini_Exists( File ) )
	{
		// WBR
        dini_IntSet(File, "Kepala", pData[playerid][pHead]);
        dini_IntSet(File, "Perut", pData[playerid][pPerut]);
        dini_IntSet(File, "TanganKanan", pData[playerid][pRHand]);
        dini_IntSet(File, "TanganKiri", pData[playerid][pLHand]);
        dini_IntSet(File, "KakiKanan", pData[playerid][pRFoot]);
        dini_IntSet(File, "KakiKiri", pData[playerid][pLFoot]);
        // ASK
        dini_IntSet(File, "AskTime", pData[playerid][pAskTime]);
        // OBAT
        dini_IntSet(File, "Obat Myricous", pData[playerid][pObat]);
        // SUSPECT
        dini_IntSet(File, "Suspected", pData[playerid][pSuspect]);
        dini_IntSet(File, "GetLoc Timer", pData[playerid][pSuspectTimer]);
        // PHONE
        dini_IntSet(File, "Phone Status", pData[playerid][pUsePhone]);
        // KURIR
        dini_IntSet(File, "Kurir Done", pData[playerid][pKurirEnd]);
        // TWITTER
        dini_IntSet(File, "Twitter", pData[playerid][pTwitter]);
        // Kuota
        dini_IntSet(File, "Kuota", pData[playerid][pKuota]);
        // DELAY ROB
        dini_IntSet(File, "Rob Delay", pData[playerid][pRobTime]);
        // Booster System
        dini_IntSet(File, "Boost", pData[playerid][pBooster]);
        dini_IntSet(File, "Boost Time", pData[playerid][pBoostTime]);
	}
}

forward LoadLunarSystem(playerid);
public LoadLunarSystem(playerid)
{
	format( File, sizeof( File ), "[AkunPlayer]/Stats/%s.ini", pData[playerid][pName]);
    if(dini_Exists(File))//Buat load data user(dikarenakan sudah ada datanya)
    {  
    	// WBR
        pData[playerid][pHead] = dini_Int( File,"Kepala");
        pData[playerid][pPerut] = dini_Int( File,"Perut");
        pData[playerid][pRHand] = dini_Int( File,"TanganKanan");
        pData[playerid][pLHand] = dini_Int( File,"TanganKiri");
        pData[playerid][pRFoot] = dini_Int( File,"KakiKanan");
        pData[playerid][pLFoot] = dini_Int( File,"KakiKiri");
        // ASK
        pData[playerid][pAskTime] = dini_Int( File, "AskTime");
        // OBAT
        pData[playerid][pObat] = dini_Int( File, "Obat Myricous");
        // SUSPECT
        pData[playerid][pSuspect] = dini_Int( File, "Suspected");
        pData[playerid][pSuspectTimer] = dini_Int( File, "GetLoc Timer");
        // KURIR
        pData[playerid][pKurirEnd] = dini_Int( File, "Kurir Done");
        // TWITTER
        pData[playerid][pKuota] = dini_Int(File , "Kuota");
        pData[playerid][pTwitter] = dini_Int(File, "Twitter");
        // DUTY
        pData[playerid][pDutyHour] = dini_Int(File, "Waktu Duty");
        // DELAY ROB
        pData[playerid][pRobTime] = dini_Int(File, "Rob Delay");
        // RP BOOST
        pData[playerid][pBooster] = dini_Int(File, "Boost");
        pData[playerid][pBoostTime] = dini_Int(File, "Boost Time");
        if(pData[playerid][pKurirEnd] == 3)
        {
        	AddPlayerSalary(playerid, "Job (Kurir)", 400);
        	pData[playerid][pKurirEnd] = 0;
        }
    }
    else //Buat user baru(Bikin file buat pemain baru dafar)
    {
    	dini_Create( File );
    	// WBR
        dini_IntSet(File, "Kepala", 100);
        dini_IntSet(File, "Perut", 100);
        dini_IntSet(File, "TanganKanan", 100);
        dini_IntSet(File, "TanganKiri", 100);
        dini_IntSet(File, "KakiKanan", 100);
        dini_IntSet(File, "KakiKiri", 100);
        // ASK
        dini_IntSet(File, "AskTime", 0);
        // Obat
        dini_IntSet(File, "Obat Myricous", 0);
        // Suspect
        dini_IntSet(File, "Suspected", 0);
        dini_IntSet(File, "GetLoc Timer", 0);
        dini_IntSet(File, "Phone Status", 0);
        // KURIR
        dini_IntSet(File, "Kurir Done", 0);
        // TWITTER
        dini_IntSet(File, "Kuota", 0);
        dini_IntSet(File, "Twitter", 0);
        // DUTY
        dini_IntSet(File, "Waktu Duty", 0);
        // ROB
        dini_IntSet(File, "Rob Delay", 0);
        // Roleplay Boost
        dini_IntSet(File, "Booost", 0);
        dini_IntSet(File, "Boost Time", 0);
        pData[playerid][pHead] = dini_Int( File,"Kepala");
        pData[playerid][pPerut] = dini_Int( File,"Perut");
        pData[playerid][pRHand] = dini_Int( File,"TanganKanan");
        pData[playerid][pLHand] = dini_Int( File,"TanganKiri");
        pData[playerid][pRFoot] = dini_Int( File,"KakiKanan");
        pData[playerid][pLFoot] = dini_Int( File,"KakiKiri");
        pData[playerid][pAskTime] = dini_Int( File, "AskTime");
        pData[playerid][pObat] = dini_Int( File, "Obat Myricous");
        pData[playerid][pSuspect] = dini_Int( File, "Suspected");
        pData[playerid][pSuspectTimer] = dini_Int( File, "GetLoc Timer");
        pData[playerid][pUsePhone] = dini_Int( File, "Phone Status");
        pData[playerid][pKurirEnd] = dini_Int( File, "Kurir Done");
        pData[playerid][pKuota] = dini_Int(File, "Kuota");
        pData[playerid][pTwitter] = dini_Int(File, "Twitter");
        pData[playerid][pDutyHour] = dini_Int(File, "Waktu Duty");
        pData[playerid][pRobTime] = dini_Int(File, "Rob Delay");
        pData[playerid][pBooster] = dini_Int(File, "Boost");
        pData[playerid][pBoostTime] = dini_Int(File, "Boost Time");
    }
    pData[playerid][pMemberRob] = 0;
    pData[playerid][pRobMember] = 0;
    pData[playerid][pRobLeader] = 0;
    return 1;
}

#include "FEATURE/DMV.inc"

#include "UI/infonotif.inc"
#include "UI/notif.inc"
#include "UI/progressbar.inc"
#include "UI/showitembox.inc"
#include "UI/player_text.inc"

//#include "FEATURE/ANTICHEAT.inc"

public OnGameModeInit()
{
//=========Nama Diatas kepala Jika ( False/0 Diganti Dengan True/1 )==============
    ShowNameTags(false);
    SetNameTagDrawDistance(1.0);
//================================================================================
	//mysql_log(ALL);
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	/*g_SQL = mysql_connect_file();
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}
	print("MySQL connection is successful.");*/
	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}
	print("MySQL connection is successful.");
	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers");
	mysql_tquery(g_SQL, "SELECT * FROM `trees`", "LoadTrees");
	//mysql_tquery(g_SQL, "SELECT * FROM `ores`", "LoadOres");
	mysql_tquery(g_SQL, "SELECT * FROM `plants`", "LoadPlants");
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");
	mysql_tquery(g_SQL, "SELECT * FROM `parks`", "LoadPark");
	mysql_tquery(g_SQL, "SELECT * FROM `sigenal`", "LoadSignal");
	mysql_tquery(g_SQL, "SELECT * FROM `labelpoint`", "LoadLabels");
	mysql_tquery(g_SQL, "SELECT * FROM `contacts`", "LoadContact");
	mysql_tquery(g_SQL, "SELECT * FROM `dropped`", "Dropped_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `trash`", "LoadTrash");
	mysql_tquery(g_SQL, "SELECT * FROM `vending`", "LoadVending");
	mysql_tquery(g_SQL, "SELECT * FROM `actor`", "LoadActor", "");

	CreateTextDraw();
	CreateServerPoint();
	//CreateJoinLumberPoint();
	CreateJoinTaxiPoint();
	//CreateJoinMechPoint();
	//CreateJoinMinerPoint();
	CreateJoinProductionPoint();
	//CreateJoinTruckPoint();
	CreateArmsPoint();
	//CreateJoinKurirPoint();
	//CreateJoinFarmerPoint();
	LoadTazerSAPD();
	CreateJoinSmugglerPoint();
	//CreateJoinPemotongPoint();
	CreateJoinMFPoint();
	//dc
	// Whitelist = DCC_FindChannelById("1230560519388266537");
	activecs = DCC_FindChannelById("1208946871612215297");
	serverlogs = DCC_FindChannelById("1218266951672139916");
	AdminLogs = DCC_FindChannelById("1218267035595964476");
	connectlogs = DCC_FindChannelById("1237029739433037934");
	acceptdeathlogs = DCC_FindChannelById("1238184998071435374");
	cheatlogs = DCC_FindChannelById("1218266490998882385");
	//RefundRoles = DCC_FindChannelById("1192673206352498740");
	
	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	//SendRconCommand("hostname Xero Gaming Roleplay");
	SendRconCommand("mapname San Andreas");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(15.0);
	SetNameTagDrawDistance(20.0);
	//DisableNameTagLOS();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text="NO ENTER");
	//Audio_SetPack("default_pack");

	//new
	
	SpawnMale = LoadModelSelectionMenu("spawnmale.txt");
	SpawnFemale = LoadModelSelectionMenu("spawnfemale.txt");
	MaleSkins = LoadModelSelectionMenu("maleskin.txt");
	FemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	VIPMaleSkins = LoadModelSelectionMenu("maleskin.txt");
	VIPFemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	SAPDMale = LoadModelSelectionMenu("sapdmale.txt");
	SAPDFemale = LoadModelSelectionMenu("sapdfemale.txt");
	SAPDWar = LoadModelSelectionMenu("sapdwar.txt");
	SAGSMale = LoadModelSelectionMenu("sagsmale.txt");
	SAGSFemale = LoadModelSelectionMenu("sagsfemale.txt");
	SAMDMale = LoadModelSelectionMenu("samdmale.txt");
	SAMDFemale = LoadModelSelectionMenu("samdfemale.txt");
	SANEWMale = LoadModelSelectionMenu("sanewmale.txt");
	SANEWFemale = LoadModelSelectionMenu("sanewfemale.txt");
	toyslist = LoadModelSelectionMenu("toys.txt");
	viptoyslist = LoadModelSelectionMenu("viptoys.txt");
	PDGSkinMale = LoadModelSelectionMenu("pmale.txt");
	PDGSkinFemale = LoadModelSelectionMenu("pfemale.txt");

	//pedagang
	menumasak = CreateDynamicCP(341.6693,-1838.8120,9.7921, 1.0, -1, -1, -1, 5.0);
	menuminum = CreateDynamicCP(337.0453,-1836.7041,9.7921, 1.0, -1, -1, -1, 5.0);
	//menupedagang = CreateDynamicCP(1316.866088,-872.307128,39.626033, 1.0, -1, -1, -1, 5.0);
	
	new strings[128];
	//disnaker
	Disnaker = CreateDynamicCP(1393.4916, -10.7371, 1000.9166, 1.0, -1, -1, -1, 20.0);
	CreateDynamicPickup(1210, 23, 1393.4916, -10.7371, 1000.9166, -1, -1, -1, 50);
	CreateDynamic3DTextLabel("{B897FF}Ambil Pekerjaanmu Disini\n{ffffff}Stand Here Gunakan {B897FF}ALT{FFFFFF}!", COLOR_LBLUE, 1393.4916,-10.7371,1000.9166, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);

	//Beli Umpan
	CreateDynamicPickup(1604, 23, 360.5281,-2031.9830,7.8359, -1, -1, -1, 250);
	CreateDynamic3DTextLabel("{B897FF}ALT\n{ffffff}Untuk membeli Umpan!", COLOR_LBLUE, 360.5281,-2031.9830,7.8359, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);


	//staterpack
    Staterpack = CreateDynamicCP(1806.9672,-1876.5265,13.5859, 1.0, -1, -1, -1, 1.0);
    CreateDynamicPickup(19057, 23, 1806.9672,-1876.5265,13.5859, -1, -1, -1, 50);
    CreateDynamic3DTextLabel("{B897FF}Stand Here!\n{ffffff} Gunakan {B897FF}ALT{FFFFFF} Untuk Mendapatkan Staterpackmu!", COLOR_LBLUE, 1806.9672,-1876.5265,13.5859, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	
	//job

	//SIDEJOB BUS
	CreateDynamicPickup(19131, 23, 1760.4087,-1866.5735,13.5996, -1, -1, -1, 150);
    CreateDynamic3DTextLabel("{B897FF}[SIDEJOB DRIVER BUS]\n{ffffff} Naik ke dalam bus untuk mulai bekerja.\nGa ada bus? Mohon antri!", COLOR_LBLUE, 1760.4087,-1866.5735,13.5996, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);

	//restock vending
	//Vending Restock
	new box = ProductPrice*15;
	CargoPickup = CreateDynamicPickup(1271, 23, -50.61, -233.28, 6.76, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Cargo Warehouse]\n"WHITE_E"Box Stock: "LG_E"%d\n\n"WHITE_E"Product Price: "LG_E"%s /item\n"LB_E"/cargo buy", Product, FormatMoney(box));
	CargoText = CreateDynamic3DTextLabel(strings, COLOR_PURPLE, -50.61, -233.28, 6.76, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Vending Product

	//lockeer nambang batu
	format(strings, sizeof(strings), "[Locker Penambang Batu]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk mengakses");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, -397.3630,1263.2987,7.1776, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	//lockeer pemerah sapi
	format(strings, sizeof(strings), "[Locker Pemerah Susu Sapi]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk mengakses");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 300.121429,1141.311645,9.137485, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	//jual hasil tambang batu
	CreateDynamicPickup(905, 23, 846.2555,-1293.4869,13.6528, -1, -1, -1, 150);
	format(strings, sizeof(strings), "[Tempat Penjualan Pertambangan]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk mengakses");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 846.2555,-1293.4869,13.6528, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	//jual botol
	CreateDynamicPickup(1486, 23, 919.4504,-1252.1967,16.2109, -1, -1, -1, 150);
    format(strings, sizeof(strings), "[Tempat Penjualan Botol]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk menjual");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 919.4504,-1252.1967,16.2109, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);		

	//jual susu
	CreateDynamicPickup(19833, 23, 919.4351,-1266.0238,15.1719, -1, -1, -1, 150);
    format(strings, sizeof(strings), "[Tempat Penjualan Susu]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk menjual");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 919.4351,-1266.0238,15.1719, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);		
	
	//olah susu
	format(strings, sizeof(strings), "{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk mengolah susu");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 315.5888, 1154.6294, 8.5859, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	//PENAMBANG MINYAK 
	format(strings, sizeof(strings), "[Locker Penambang Minyak]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}untuk mengakses");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 576.9179,1223.8799,11.7113, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//pemotong ayam
	format(strings, sizeof(strings), "[AYAM HIDUP]\n{FFFFFF}Gunakan {B897FF}ALT{FFFFFF} Untuk Ambil Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 156.6945,-1499.9636,12.3485, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 156.6945,-1499.9636,12.3485, -1, -1, -1, 5.0);

	//MOBIL INSURANCE
	format(strings, sizeof(strings), "[AREA PENDARATAN KENDARAAN]");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1327.7679,-1238.2716,13.4189, 45.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 1327.7679,-1238.2716,13.4189, -1, -1, -1, 5.0);

	//MOBIL
	format(strings, sizeof(strings), "[AREA PENDARATAN KENDARAAN]");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 544.2508,-1269.8116,17.1995, 45.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 544.2508,-1269.8116,17.1995, -1, -1, -1, 5.0);

	//RENTAL
	format(strings, sizeof(strings), "[AREA PENDARATAN KENDARAAN]");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 538.1642,-1275.1239,17.2182, 45.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 538.1642,-1275.1239,17.2182, -1, -1, -1, 5.0);

	/*format(strings, sizeof(strings), "[AYAM HIDUP]\n{FFFFFF}Gunakan {B897FF}ALT{FFFFFF}m Untuk Ambil Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 159.8527,-1498.8038,12.3820, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 159.8527,-1498.8038,12.3820, -1, -1, -1, 5.0);*/
	
	format(strings, sizeof(strings), "[Pemotongan]\n{FFFFFF}Gunakan {B897FF}ALT{FFFFFF} Untuk Memotong Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 155.8964,-1512.2314,12.1621, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 155.8964,-1512.2314,12.1621, -1, -1, -1, 5.0);

    format(strings, sizeof(strings), "[Packing Ayam]\n{FFFFFF}Gunakan {B897FF}ALT{FFFFFF} Untuk Membungkus Ayam Potong");
    CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 173.7471,-1481.2899,12.6098, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(19197, 23, 173.7471,-1481.2899,12.6098, -1, -1, -1, 5.0);
	//akhir job ayam
	
	//dokterlokal
	CreateDynamicPickup(11738, 23, 1152.7679,-1340.4303,-26.5895, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Treatment Lokal]\n{FFFFFF}Tekan {B897FF}ALT {FFFFFF}\nuntuk berobat dengan peawat Lokal");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1152.7679,-1340.4303,-26.5895, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	//garasi fraksi
	//SAMD
	CreateDynamicPickup(19131, 23, 1131.5339, -1332.3248, 13.5797, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAMD Garage]\n{FFFFFF}/spawnmd - Ambil kendaraan Fraksi\n/despawnmd - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1131.5339, -1332.3248, 13.5797, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	CreateDynamicPickup(19131, 23, 1162.8176, -1313.8239, 32.2215, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAMD Helipad]\n/despawnmd - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1162.8176, -1313.8239, 32.2215, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	//SAPD
	CreateDynamicPickup(19131, 23, 1554.1858, -1611.3740, 13.3828, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAPD Garage]\n{FFFFFF}/spawnpd - Ambil kendaraan Fraksi\n/despawnpd - Mengembalikan Kendaraan Fraksi\n/callsign - add callsign");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1554.1858, -1611.3740, 13.3828, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	CreateDynamicPickup(19131, 23, 1565.4584,-1706.9548,28.1604, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAPD Helipad]\n{FFFFFF}/despawnpd - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1565.4584,-1706.9548,28.1604, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	//SANA
	CreateDynamicPickup(19131, 23, 741.9764,-1371.2441,25.8835, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SANA Helipad]\n/despawnsags - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 741.9764,-1371.2441,25.8835, 5.0);

	CreateDynamicPickup(19131, 23, 743.5262, -1332.2343, 13.8414, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SANA Garage]\n{FFFFFF}/spawnsana - Ambil kendaraan Fraksi\n/despawnsana - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 743.5262, -1332.2343, 13.8414, 5.0); // Vehicles Stats Sana

	//SAGS
	CreateDynamicPickup(19131, 23, 1480.0067, -1828.6716, 13.5469, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAGS Garage]\n{FFFFFF}/spawnsags - Ambil kendaraan Fraksi\n/despawnsags - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1480.0067, -1828.6716, 13.5469, 20.0); // Vehicles Statis Sags

	CreateDynamicPickup(19131, 23, 1424.6909, -1789.1492, 33.4297, -1, -1, -1, 250);
	format(strings, sizeof(strings), "[SAGS Helipad]\n/despawnsags - Mengembalikan Kendaraan Fraksi");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1424.6909, -1789.1492, 33.4297, 5.0);

	//bawaan
	CreateDynamicPickup(1581, 23, 1393.3154,-12.7873,1000.9166, -1);
	format(strings, sizeof(strings), "[City Hall]\n{FFFFFF}/newidcard - create new ID Card\n/newage - Change Birthday\n/sellhouse - sell your house\n/sellbisnis - sell your bisnis");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1393.3154,-12.7873,1000.9166, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	//ROBBANKK
    CreateDynamicPickup(1239, 23, 339.771,-397.98,-95.38, -1);
	format(strings, sizeof(strings), "[Robbank]\n{FFFFFF}/robbank\nuntuk melakukan rob bank");
	CreateDynamic3DTextLabel(strings, COLOR_WHITE, 1360.3846,-17.1967,1000.9219, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
	
	CreateDynamicPickup(1239, 23, 1299.5710,-1267.5194,13.5939, -1);
	format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/buyinsu - buy insurance\n/claimpv - claim insurance\n/sellpv - sell vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1299.5710,-1267.5194,13.5939, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance
	
	CreateDynamicPickup(1239, 23, 1491.6233,1305.2896,1093.2964, -1);
	format(strings, sizeof(strings), "[License]\n{FFFFFF}/newdrivelic - create new license");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1491.6233,1305.2896,1093.2964, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
	
	CreateDynamicPickup(1239, 23, 1401.0576,1115.8191,23233.0859, -1);
	format(strings, sizeof(strings), "[Plate]\n{FFFFFF}/buyplate - create new plate");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1401.0576,1115.8191,23233.0859, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate
	
	CreateDynamicPickup(1239, 23, 1400.9375,1109.9957,23233.0859, -1);
	format(strings, sizeof(strings), "[Ticket]\n{FFFFFF}/payticket - to pay ticket");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1400.9375,1109.9957,23233.0859, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket
	
	CreateDynamicPickup(1239, 23, 224.11, 118.50, 999.10, -1);
	format(strings, sizeof(strings), "[ARREST POINT]\n{FFFFFF}/arrest - arrest wanted player");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 224.11, 118.50, 999.10, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	CreateDynamicPickup(1239, 23, 1142.38, -1330.74, 13.62, -1);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1142.38, -1330.74, 13.62, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital
	
	CreateDynamicPickup(1239, 23, 2246.46, -1757.03, 1014.77, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 2246.46, -1757.03, 1014.77, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 193.0425,-91.0659,1031.4844, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 193.0425,-91.0659,1031.4844, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 1473.3381,-140.0212,1243.9742, -1);
	format(strings, sizeof(strings), "[IKLAN]\n{B897FF}/ad -{FFFFFF} public ads\n{B897FF}/ads{FFFFFF} - List Advertisment Aktif");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1473.3381,-140.0212,1243.9742, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan

	CreateDynamicPickup(1241, 23, 1165.3550,-1339.8245,-26.5895, -1);
	format(strings, sizeof(strings), "[MYRICOUS PRODUCTION]\n{FFFFFF}/mix");
	CreateDynamic3DTextLabel(strings, COLOR_PURPLE, 1165.3550,-1339.8245,-26.5895, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // racik obat
	
	//Dynamic CP
	ShowRoomCP = CreateDynamicCP(545.4697,-1292.2668,17.3082, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("{7fffd4}Vehicle Showroom\n{ffffff}Stand Here!", COLOR_GREEN, 545.4697,-1292.2668,17.3082, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	CreateDynamicPickup(1274, 23, 545.4697,-1292.2668,17.3082, -1, -1, -1, 50);

	ShowRoomCPRent = CreateDynamicCP(539.0476,-1291.7998,17.3082, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("{7fff00}Rental Vehicle\n{ffffff}Stand Here!"YELLOW_E"/unrentpv", COLOR_LBLUE, 539.0476,-1291.7998,17.3082, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	CreateDynamicPickup(1274, 23, 539.0476,-1291.7998,17.3082, -1, -1, -1, 50);

	//Dealer
	AreaData[dealer] = CreateDynamicObject(1042.7394,234.8009,15.5392, 3.0);

	SAGSLobbyBtn[0] = CreateButton(1388.987670, -25.291969, 1001.358520, 180.000000);
	SAGSLobbyBtn[1] = CreateButton(1391.275756, -25.481920, 1001.358520, 0.000000);
	SAGSLobbyDoor = CreateDynamicObject(1569, 1389.375000, -25.387500, 999.978210, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	
	SAPDLobbyBtn[0] = CreateButton(252.95264, 107.67332, 1004.00909, 264.79898);
	SAPDLobbyBtn[1] = CreateButton(253.43437, 110.62970, 1003.92737, 91.00000);
	SAPDLobbyDoor[0] = CreateDynamicObject(1569, 253.10965, 107.61060, 1002.21368,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[1] = CreateDynamicObject(1569, 253.12556, 110.49657, 1002.21460,   0.00000, 0.00000, -91.00000);

	SAPDLobbyBtn[2] = CreateButton(239.82739, 116.12640, 1004.00238, 91.00000);
	SAPDLobbyBtn[3] = CreateButton(238.75888, 116.12949, 1003.94086, 185.00000);
	SAPDLobbyDoor[2] = CreateDynamicObject(1569, 239.69435, 116.15908, 1002.21411,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[3] = CreateDynamicObject(1569, 239.64050, 119.08750, 1002.21332,   0.00000, 0.00000, 270.00000);
	
	//Family Button
	LLFLobbyBtn[0] = CreateButton(-2119.90039, 655.96808, 1062.39954, 184.67528);
	LLFLobbyBtn[1] = CreateButton(-2119.18481, 657.88519, 1062.39954, 90.00000);
	LLFLobbyDoor = CreateDynamicObject(1569, -2119.21509, 657.54187, 1060.73560,   0.00000, 0.00000, -90.00000);
	
	//Sidejob Vehicle
	AddSweeperVehicle();
	AddBusVehicle();
	//AddKurirVehicle();
	AddForVehicle();
	AddBaggageVehicle();

	//-----[ DMV ]-----	
	AddDmvVehicle();

	gstream = SvCreateGStream();
	LoadMapMetro();
	SetTimer("BotLenz", 1000, true);
	SetTimer("sinyal", 1800000, true);
	new hours;
	SetWorldTime(hours);
	WorldTime = hours;
	printf("[Object] Number of Dynamic objects loaded: %d", CountDynamicObjects());
	return 1;
}

public OnGameModeExit()
{
	if (gstream != SV_NULL)
    {
        SvDeleteStream(gstream);
        gstream = SV_NULL;
    }
	new count = 0, count1 = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station] Number of Saved: %d", count);
	
	foreach(new pid : Plants)
	{
		if(Iter_Contains(Plants, pid))
		{
			count1++;
			Plant_Save(pid);
		}
	}
	printf("[Farmer Plant] Number of Saved: %d", count1);
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) 
	{
		if (IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	UnloadTazerSAPD();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
	return 1;
}

function SAGSLobbyDoorClose()
{
	MoveDynamicObject(SAGSLobbyDoor, 1389.375000, -25.387500, 999.978210, 3);
	return 1;
}

function SAPDLobbyDoorClose()
{
	MoveDynamicObject(SAPDLobbyDoor[0], 253.10965, 107.61060, 1002.21368, 3);
	MoveDynamicObject(SAPDLobbyDoor[1], 253.12556, 110.49657, 1002.21460, 3);
	MoveDynamicObject(SAPDLobbyDoor[2], 239.69435, 116.15908, 1002.21411, 3);
	MoveDynamicObject(SAPDLobbyDoor[3], 239.64050, 119.08750, 1002.21332, 3);
	return 1;
}

function LLFLobbyDoorClose()
{
	MoveDynamicObject(LLFLobbyDoor, -2119.21509, 657.54187, 1060.73560, 3);
	return 1;
}

public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0] || buttonid == SAGSLobbyBtn[1])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[0] || buttonid == SAPDLobbyBtn[1])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[0], 253.14204, 106.60210, 1002.21368, 3);
			MoveDynamicObject(SAPDLobbyDoor[1], 253.24377, 111.94370, 1002.21460, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[2] || buttonid == SAPDLobbyBtn[3])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[2], 239.52385, 114.75534, 1002.21411, 3);
			MoveDynamicObject(SAPDLobbyDoor[3], 239.71977, 120.21591, 1002.21332, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == LLFLobbyBtn[0] || buttonid == LLFLobbyBtn[1])
	{
		if(pData[playerid][pFamily] == 0)
		{
			MoveDynamicObject(LLFLobbyDoor, -2119.27148, 656.04028, 1060.73560, 3);
			SetTimer("LLFLobbyDoorClose", 5000, 0);
		}
		else
		{
			Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	RemovePlayerAttachedObject(playerid, BOX_INDEX);
	//angkatBox[playerid] = false;
	if(!ispassenger)
	{
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAPD!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAGS!");
			}
		}
		if(IsABaggageVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 10 && pData[playerid][pJob2] != 10)
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
                ErrorMsg(playerid, "Kamu tidak bekerja sebagai Baggage Airport");
			}
		}
		if(IsADmvVeh(vehicleid))
        {
            if(!pData[playerid][pDriveLicApp])
            {
                RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
                ErrorMsg(playerid, "Kamu tidak sedang mengikuti Tes Mengemudi");
			}
			else 
			{
				InfoMsg(playerid, "Silahkan ikuti Checkpoint yang ada di GPS mobil ini.");
				SetPlayerRaceCheckpoint(playerid, 1, dmvpoint1, dmvpoint1, 5.0);
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SANEW!");
			}
		}
		if(GetVehicleModel(vehicleid) == 548 || GetVehicleModel(vehicleid) == 417 || GetVehicleModel(vehicleid) == 487 || GetVehicleModel(vehicleid) == 488 ||
		GetVehicleModel(vehicleid) == 497 || GetVehicleModel(vehicleid) == 563 || GetVehicleModel(vehicleid) == 469)
		{
			if(pData[playerid][pLevel] < 5)
			{
				RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Anda tidak memiliki izin!");
			}
		}
		/*foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) && pvData[pv][cLocked] == 1)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					Error(playerid, "This bike is locked by owner.");
				}
			}
		}*/
	}
	return 1;
}

stock SGetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}
/*public OnVehicleStreamIn(vehicleid, forplayerid)
{
	foreach(new pv : PVehicles)
	{
		if(vehicleid == pvData[pv][cVeh])
		{
			if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
			{
				if(pvData[pv][cLocked] == 1)
				{
					SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
				}
			}
		}
	}
	return 1;
}*/

/*
public OnPlayerEnterKeypadArea(playerid, keypadid)
{
    ShowPlayerKeypad(playerid, keypadid);
    return 1;
}

public OnKeypadResponse(playerid, keypadid, bool:response, bool:success, code[])
{
    if(keypadid == SAGSLobbyKey[0])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
		if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
			if(success)
			{
				InfoMsg(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
			}
		}
	}
    if(keypadid == SAGSLobbyKey[1])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
        if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
            if(success)
            {
                InfoMsg(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
            }
        }
    }
    return 1;
} */

/*public OnPlayerActivateDoor(playerid, doorid)
{
	if(doorid == SAGSLobbyDoor)
	{
		if(pData[playerid][pFaction] != 2)
		{
			Error(playerid, "You dont have access!");
			return 1; // Cancels the door from being opened
		}
	}
	if(doorid == gMyDoor)
	{
		new bool:gIsDoorLocked = false;
		if(gIsDoorLocked == true)
		{
			SendClientMessage(playerid, -1, "Door is locked, can't open!");
			return 1; // Cancels the door from being opened
		}
	}
	return 1;
}

public OnButtonPress(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0])
	{
		InfoMsg(playerid, "Well done!");
	}
	if(buttonid == SAGSLobbyBtn[1])
	{
		InfoMsg(playerid, "Well done!");
	}
}*/

public OnPlayerText(playerid, text[])
{
	if(isnull(text)) return 0;
	printf("[CHAT] %s(%d) : %s", pData[playerid][pName], playerid, text);
	
	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	// AUTO RP
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s lepaskan senjatanya dari sabuk dan siap untuk menembak kapan saja.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s kaget setelah kecelakaan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfish", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memancing dengan kedua tangannya.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfall", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s jatuh dan merasakan sakit.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpmad", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s merasa kesal dan ingin mengeluarkan amarah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprob", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s menggeledah sesuatu dan siap untuk merampok.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcj", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s mencuri kendaraan seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpwar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s berperang dengan sesorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdie", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s pingsan dan tidak sadarkan diri.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfixmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memperbaiki mesin kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcheckmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memeriksa kondisi kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfight", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s ribut dan memukul seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcry", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s sedang bersedih dan menangis.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s berlari dan kabur.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfear", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s merasa ketakutan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdropgun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s meletakkan senjata kebawah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rptakegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s mengamnbil senjata.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpgivegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memberikan kendaraan kepada seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpshy", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s merasa malu.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnusuk", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s menusuk dan membunuh seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpharvest", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memanen tanaman.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockhouse", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s sedang mengunci rumah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockcar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s sedang mengunci kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnodong", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s memulai menodong seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpeat", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s makan makanan yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdrink", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s meminum minuman yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(text[0] == '!')
	{
		new tmp[512];
		if(text[1] == ' ')
		{
			format(tmp, sizeof(tmp), "%s", text[2]);
		}
		else
		{
			format(tmp, sizeof(tmp), "%s", text[1]);
		}
		if(pData[playerid][pAdminDuty] == 1)
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
		else
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "Anda tidak memiliki Credit!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "Tidak dapat melakukan saat ini.");
				return 0;
			}
			new tmp[512];
			foreach(new ii : Player)
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[ii][pPhone] == pData[playerid][pSMS])
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
					{
						Error(playerid, "Nomor ini tidak aktif!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
		return 0;
	}
	else
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		if(!IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdminDuty] == 1)
			{
				if(strlen(text) > 80)
				{
					SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), text);
					SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", text[64]);
					return 0;
				}
				else
				{
					SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), text);
					//adminlogs
					new DCC_Embed:logss;
					new yy, m, d, timestamp[200];

					getdate(yy, m , d);

					format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
					logss = DCC_CreateEmbed("");
					DCC_SetEmbedTitle(logss, "LOGS CHAT ADMIN");
					DCC_SetEmbedTimestamp(logss, timestamp);
					DCC_SetEmbedColor(logss, 0xd96ad5); //0xffa500 
					DCC_SetEmbedUrl(logss, "");
					DCC_SetEmbedThumbnail(logss, "");
					DCC_SetEmbedFooter(logss, "", "");
					new stroi[5000];
					format(stroi, sizeof(stroi), "**[CHAT ADMIN]** %s[%s] : __%s__", UcpData[playerid][uAdmin], pData[playerid][pAdminname], text);
					DCC_AddEmbedField(logss, "", stroi, true);
					DCC_SendChannelEmbedMessage(AdminLogs, logss);
					return 0;
				}
			}
			new playerscore[40];
			if(pData[playerid][pLevel] > 0)
			{
				playerscore = "New Citizen";
			}
			if(pData[playerid][pLevel] > 1)
			{
				playerscore = "Starty I";
			}
			if(pData[playerid][pLevel] > 2)
			{
				playerscore = "Starty II";
			}
			if(pData[playerid][pLevel] > 3)
			{
				playerscore = "Midly I";
			}
			if(pData[playerid][pLevel] > 4)
			{
				playerscore = "Midly II";
			}
			if(pData[playerid][pLevel] > 5)
			{
				playerscore = "Nowee I";
			}
			if(pData[playerid][pLevel] > 6)
			{
				playerscore = "Nowee II";
			}
			if(pData[playerid][pLevel] > 7)
			{
				playerscore = "Naudie I";
			}
			if(pData[playerid][pLevel] > 8)
			{
				playerscore = "Naudie II";
			}
			if(pData[playerid][pLevel] > 9)
			{
				playerscore = "Goodie I";
			}
			if(pData[playerid][pLevel] > 10)
			{
				playerscore = "Goodie II";
			}
			if(pData[playerid][pLevel] > 11)
			{
				playerscore = "Calmy I";
			}
			if(pData[playerid][pLevel] > 12)
			{
				playerscore = "Calmy II";
			}
			if(pData[playerid][pLevel] > 13)
			{
				playerscore = "Rainy I";
			}
			if(pData[playerid][pLevel] > 14)
			{
				playerscore = "Rainy II";
			}
			if(pData[playerid][pLevel] > 15)
			{
				playerscore = "Weedy I";
			}
			if(pData[playerid][pLevel] > 16)
			{
				playerscore = "Weedy II";
			}
			if(pData[playerid][pLevel] > 17)
			{
				playerscore = "Masty I";
			}
			if(pData[playerid][pLevel] > 18)
			{
				playerscore = "Masty II";
			}
			if(pData[playerid][pLevel] > 19)
			{
				playerscore = "Xeny I";
			}
			if(pData[playerid][pLevel] > 20)
			{
				playerscore = "Xeny II";
			}
			if(pData[playerid][pLevel] > 21)
			{
				playerscore = "Loyee I";
			}
			if(pData[playerid][pLevel] > 22)
			{
				playerscore = "Loyee II";
			}
			if(pData[playerid][pLevel] > 23)
			{
				playerscore = "Wasy I";
			}
			if(pData[playerid][pLevel] > 24)
			{
				playerscore = "Wasy II";
			}
			if(pData[playerid][pLevel] > 25)
			{
				playerscore = "Maestry I";
			}
			if(pData[playerid][pLevel] > 26)
			{
				playerscore = "Maestry II";
			}
			if(pData[playerid][pLevel] > 27)
			{
				playerscore = "Cloudie I";
			}
			if(pData[playerid][pLevel] > 28)
			{
				playerscore = "Cloudie II";
			}
			if(pData[playerid][pLevel] > 29)
			{
				playerscore = "Middie I";
			}
			if(pData[playerid][pLevel] > 30)
			{
				playerscore = "Middie II";
			}
			if(pData[playerid][pLevel] > 31)
			{
				playerscore = "Lancy I";
			}
			if(pData[playerid][pLevel] > 32)
			{
				playerscore = "Lancy II";
			}
			if(pData[playerid][pLevel] > 33)
			{
				playerscore = "Soddy I";
			}
			if(pData[playerid][pLevel] > 34)
			{
				playerscore = "Soddy II";
			}
			if(pData[playerid][pLevel] > 35)
			{
				playerscore = "Epsy I";
			}
			if(pData[playerid][pLevel] > 36)
			{
				playerscore = "Epsy II";
			}
			if(pData[playerid][pLevel] > 37)
			{
				playerscore = "Flirdie I";
			}
			if(pData[playerid][pLevel] > 38)
			{
				playerscore = "Flirdie II";
			}
			if(pData[playerid][pLevel] > 39)
			{
				playerscore = "Geny I";
			}
			if(pData[playerid][pLevel] > 40)
			{
				playerscore = "Geny II";
			}
			if(pData[playerid][pLevel] > 41)
			{
				playerscore = "Byutee I";
			}
			if(pData[playerid][pLevel] > 42)
			{
				playerscore = "Byutee II";
			}
			if(pData[playerid][pLevel] > 43)
			{
				playerscore = "Hexy I";
			}
			if(pData[playerid][pLevel] > 44)
			{
				playerscore = "Hexy II";
			}
			if(pData[playerid][pLevel] > 45)
			{
				playerscore = "Fillie I";
			}
			if(pData[playerid][pLevel] > 46)
			{
				playerscore = "Fillie II";
			}
			if(pData[playerid][pLevel] > 47)
			{
				playerscore = "Catty I";
			}
			if(pData[playerid][pLevel] > 48)
			{
				playerscore = "Catty II";
			}
			if(pData[playerid][pLevel] > 49)
			{
				playerscore = "Legendary I";
			}
			if(pData[playerid][pLevel] > 50)
			{
				playerscore = "Legendary II";
			}
			if(pData[playerid][pLevel] > 51)
			{
				playerscore = "Aclimary I";
			}
			if(pData[playerid][pLevel] > 52)
			{
				playerscore = "Aclimary II";
			}
			if(pData[playerid][pLevel] > 53)
			{
				playerscore = "Neucly I";
			}
			if(pData[playerid][pLevel] > 54)
			{
				playerscore = "Neucly II";
			}
			if(pData[playerid][pLevel] > 55)
			{
				playerscore = "Jivy I";
			}
			if(pData[playerid][pLevel] > 56)
			{
				playerscore = "Jivy II";
			}
			if(pData[playerid][pLevel] > 57)
			{
				playerscore = "Stary I";
			}
			if(pData[playerid][pLevel] > 58)
			{
				playerscore = "Stary II";
			}
			if(pData[playerid][pLevel] > 59)
			{
				playerscore = "Jebie I";
			}
			if(pData[playerid][pLevel] > 60)
			{
				playerscore = "Jebie II";
			}
			if(pData[playerid][pLevel] > 61)
			{
				playerscore = "Noxie I";
			}
			if(pData[playerid][pLevel] > 62)
			{
				playerscore = "Noxie II";
			}
			if(pData[playerid][pLevel] > 63)
			{
				playerscore = "Vexy I";
			}
			if(pData[playerid][pLevel] > 64)
			{
				playerscore = "Vexy II";
			}
			if(pData[playerid][pLevel] > 65)
			{
				playerscore = "Kuxie I";
			}
			if(pData[playerid][pLevel] > 66)
			{
				playerscore = "Kuxie II";
			}
			if(pData[playerid][pLevel] > 67)
			{
				playerscore = "Perie I";
			}
			if(pData[playerid][pLevel] > 68)
			{
				playerscore = "Perie II";
			}
			if(pData[playerid][pLevel] > 69)
			{
				playerscore = "Azimuth I";
			}
			if(pData[playerid][pLevel] > 70)
			{
				playerscore = "Azimuth II";
			}
			if(pData[playerid][pLevel] > 71)
			{
				playerscore = "Axedus I";
			}
			if(pData[playerid][pLevel] > 72)
			{
				playerscore = "Axedus II";
			}
			if(pData[playerid][pLevel] > 73)
			{
				playerscore = "Morius I";
			}
			if(pData[playerid][pLevel] > 74)
			{
				playerscore = "Morius II";
			}
			if(pData[playerid][pLevel] > 75)
			{
				playerscore = "Versus I";
			}
			if(pData[playerid][pLevel] > 76)
			{
				playerscore = "Versus II";
			}
			if(pData[playerid][pLevel] > 77)
			{
				playerscore = "Nominus I";
			}
			if(pData[playerid][pLevel] > 78)
			{
				playerscore = "Nominus II";
			}
			if(pData[playerid][pLevel] > 79)
			{
				playerscore = "Albus I";
			}
			if(pData[playerid][pLevel] > 80)
			{
				playerscore = "Albus II";
			}
			if(pData[playerid][pLevel] > 81)
			{
				playerscore = "Oculus I";
			}
			if(pData[playerid][pLevel] > 82)
			{
				playerscore = "Oculus II";
			}
			if(pData[playerid][pLevel] > 83)
			{
				playerscore = "Zuxius I";
			}
			if(pData[playerid][pLevel] > 84)
			{
				playerscore = "Zuxius II";
			}
			if(pData[playerid][pLevel] > 85)
			{
				playerscore = "Luxious I";
			}
			if(pData[playerid][pLevel] > 86)
			{
				playerscore = "Luxious II";
			}
			if(pData[playerid][pLevel] > 87)
			{
				playerscore = "Aleous I";
			}
			if(pData[playerid][pLevel] > 88)
			{
				playerscore = "Aleous II";
			}
			if(pData[playerid][pLevel] > 90)
			{
				playerscore = "Maxima I";
			}
			if(pData[playerid][pLevel] > 91)
			{
				playerscore = "Maxima II";
			}
			if(pData[playerid][pLevel] > 92)
			{
				playerscore = "Livus I";
			}
			if(pData[playerid][pLevel] > 93)
			{
				playerscore = "Livus II";
			}
			if(pData[playerid][pLevel] > 94)
			{
				playerscore = "Galaxus I";
			}
			if(pData[playerid][pLevel] > 95)
			{
				playerscore = "Galaxus II";
			}
			if(pData[playerid][pLevel] > 96)
			{
				playerscore = "Olus I";
			}
			if(pData[playerid][pLevel] > 97)
			{
				playerscore = "Olus II";
			}
			if(pData[playerid][pLevel] > 98)
			{
				playerscore = "Omnipous I";
			}
			if(pData[playerid][pLevel] > 99)
			{
				playerscore = "Omnipous II";
			}
			if(pData[playerid][pLevel] > 100)
			{
				playerscore = "OLYMPUS";
			} //says
			format(lstr, sizeof(lstr), "%s || %s : %s", playerscore, ReturnName(playerid), text);
			ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
			//serverlogs
			new DCC_Embed:logss;
			new yy, m, d, timestamp[200];

			getdate(yy, m , d);

			format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
			logss = DCC_CreateEmbed("");
			DCC_SetEmbedTitle(logss, "LOGS CHAT");
			DCC_SetEmbedTimestamp(logss, timestamp);
			DCC_SetEmbedColor(logss, 0x856629); //0xffa500 
			DCC_SetEmbedUrl(logss, "");
			DCC_SetEmbedThumbnail(logss, "");
			DCC_SetEmbedFooter(logss, "", "");
			new stroi[5000];
			format(stroi, sizeof(stroi), "**[CHAT]** %s || %s : __%s__", playerscore, GetRPName(playerid), text);
			DCC_AddEmbedField(logss, "", stroi, true);
			DCC_SendChannelEmbedMessage(serverlogs, logss);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdmin] < 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: (( %s ))", ReturnName(playerid), text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
			else if(pData[playerid][pAdmin] > 1 || pData[playerid][pHelper] > 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: %s", pData[playerid][pAdminname], text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
		}
		return 0;
	}
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        Error(playerid, "Unknown Command! Gunakan /help untuk info lanjut.");
        return 0;
    }
	printf("[CMD]: %s(%d) menggunakan CMD '%s' (%s)", pData[playerid][pName], playerid, cmd, params);
	/*new dc[128];
	format(dc, sizeof(dc),  "```\n[CMD] %s: [%s] [%s]", GetRPName(playerid), cmd);
	SendDiscordMessage(1, dc);*/
	if(pData[playerid][pAdminDuty] == 1)
	{
		//serverlogs
		new DCC_Embed:logss;
		new yy, m, d, timestamp[200];

		getdate(yy, m , d);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "LOGS CMD");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0x7f887a); //0xffa500 
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		new stroi[5000];
		format(stroi, sizeof(stroi), "[CMD] **%s**[%s]: __/%s__", GetRPName(playerid), UcpData[playerid][uUsername], cmd);
		DCC_AddEmbedField(logss, "", stroi, true);
		DCC_SendChannelEmbedMessage(serverlogs, logss);
	}
	else
	{
		//adminlogs
		new DCC_Embed:logss;
		new yy, m, d, timestamp[200];

		getdate(yy, m , d);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "LOGS CMD ADMIN");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0xd96ad5); //0xffa500 
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		new stroi[5000];
		format(stroi, sizeof(stroi), "**[CMD ADMIN]** **%s**[%s]: __/%s__", GetRPName(playerid), pData[playerid][pAdminname], cmd);
		DCC_AddEmbedField(logss, "", stroi, true);
		DCC_SendChannelEmbedMessage(AdminLogs, logss);
	}
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	pemainic++;
	//
	if (SvGetVersion(playerid) == 0) // Checking for plugin availability
    {
        SendClientMessage(playerid, -1, "{B897FF}[ i ] {FFFFFF}Plugin Voice tidak terdeteksi!");
    }
    if (SvHasMicro(playerid) == SV_FALSE) // Checking for microphone availability
    {
        SendClientMessage(playerid, -1, "{B897FF}[ i ] {FFFFFF}Microphone tidak terdeteksi!");
    }
	SendClientMessageEx(playerid, -1, "{B897FF}[ i ] Warga Kota Voice & Chat -> #BersamaKitaBisa.");
	SendClientMessageEx(playerid, -1, "{b897ff}[ZiroGanteng] -> {FFFFFF}Sync your account in database server.");
	PlayAudioStreamForPlayer(playerid, "http://j.top4top.io/m_3048ielxi1.mp3");
	new PlayerIP[16], country[MAX_COUNTRY_LENGTH], city[MAX_CITY_LENGTH];
	g_MysqlRaceCheck[playerid]++;
	AntiBHOP[playerid] = 0;
	IsAtEvent[playerid] = 0;
	pData[playerid][pDriveLicApp] = 0;
	ResetVariables(playerid);
	CreatePlayerTextDraws(playerid);
	CreatePlayerInv(playerid);
	RemoveMappingMetro(playerid);
	for (new i = 0; i != MAX_INVENTORY; i ++)
	{
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	}

	//hp
	//hapeanyar
	TogglePhone[playerid] = 0;
	ToggleCall[playerid] = 0;
	ToggleSid[playerid] = 0;
	DetikCall[playerid] = 0;
	MenitCall[playerid] = 0;
	JamCall[playerid] = 0;

	// Crates
	CarryCrate[playerid] = 0;
	CarryCrateFish[playerid] = 0;
	CarryCrateCompo[playerid] = 0;

	//dron
	SetPVarInt( playerid, "DroneSpawned", 0 );
	SetPVarFloat( playerid, "OldPosX", 0 );
	SetPVarFloat( playerid, "OldPosY", 0 );
	SetPVarFloat( playerid, "OldPosZ", 0 );

	//LagiKerja[playerid] = false;
	//Kurir[playerid] = false;
	//angkatBox[playerid] = false;

	SetPlayerMapIcon(playerid, 12, 1001.29,-1356.507,12.992, 51 , 0, MAPICON_LOCAL); // ICON TRUCKER
	CreateDynamicMapIcon(285.2960,1147.2983,8.9483, 24, 0, -1, -1, -1, 700.0, -1);//JOB PEMERAH SUSU
	CreateDynamicMapIcon(896.9470,-1216.8611,16.9766, 52, 0, -1, -1, -1, 700.0, -1);//TEMPAT MARKET PENJUALAN
	CreateDynamicMapIcon(1555.30,-1675.68,16.19, 20, 0, -1, -1, -1, 700.0, -1);//Police
	CreateDynamicMapIcon(1480.96,-1772.31,18.79, 19, 0, -1, -1, -1, 700.0, -1);//Pemerintah 
	CreateDynamicMapIcon(338.94,-1834.54,4.77, 10, 0, -1, -1, -1, 700.0, -1);//Pedagang/Cafetaria
	CreateDynamicMapIcon(649.28,-1357.09,13.66, 48, 0, -1, -1, -1, 700.0, -1);//Sanews
	CreateDynamicMapIcon(1172.07,-1323.55,15.40, 22, 0, -1, -1, -1, 700.0, -1);//Medis		
		
	GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	pData[playerid][pIP] = PlayerIP;
	InterpolateCameraPos(playerid, 1429.946655, -1597.120483, 41, 2098.130615, -1775.991210, 41.111639, 50000);
	InterpolateCameraLookAt(playerid, 247.605590, -1841.989990, 39.802570, 817.645996, -1645.395751, 29.292520, 15000);
	
	GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	GetPlayerCity(playerid, city, MAX_CITY_LENGTH);
	
	SetTimerEx("SafeLogin", 1000, 0, "i", playerid);
	
	// new query[103];
	// mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
	// mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	// SetPlayerColor(playerid, COLOR_WHITE);
	CheckAccount(playerid);
	/*foreach(new ii : Player)
	{
		if(pData[ii][pTogLog] == 0)
		{
			SendClientMessageEx(ii, COLOR_RED, "{ff0000}[JOIN]"YELLOW_E" %s[%d] telah join kedalam Server.{7fffd4}(%s, %s)", UcpData[playerid][uUsername], playerid, city, country);
		}
	}*/

	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 273.500000, 157.333541, 88.000000, 8.000000, 5930683, 100, 0);
	
	//HBE textdraw Modern
	pData[playerid][damagebar] = CreatePlayerProgressBar(playerid, 459.000000, 415.749938, 61.000000, 9.000000, 16711935, 1000.0, 0);
	pData[playerid][fuelbar] = CreatePlayerProgressBar(playerid, 459.500000, 432.083221, 61.000000, 9.000000, 16711935, 1000.0, 0);
                
	pData[playerid][hungrybar] = CreatePlayerProgressBar(playerid, 565.500000, 405.833404, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][energybar] = CreatePlayerProgressBar(playerid, 565.500000, 420.416717, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][bladdybar] = CreatePlayerProgressBar(playerid, 565.500000, 435.000091, 68.000000, 8.000000, 16711935, 100.0, 0);
	
	//HBE textdraw Simple
	pData[playerid][spdamagebar] = CreatePlayerProgressBar(playerid, 565.500000, 383.666717, 51.000000, 7.000000, 16711935, 1000.0, 0);
	pData[playerid][spfuelbar] = CreatePlayerProgressBar(playerid, 566.000000, 398.250061, 51.000000, 7.000000, 16711935, 1000.0, 0);
                
	pData[playerid][sphungrybar] = CreatePlayerProgressBar(playerid, 467.500000, 433.833282, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spenergybar] = CreatePlayerProgressBar(playerid, 531.500000, 433.249938, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spbladdybar] = CreatePlayerProgressBar(playerid, 595.500000, 433.250061, 41.000000, 8.000000, 16711935, 100.0, 0);

    if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;
	//PlayAudioStreamForPlayer(playerid, "http://www.soi-rp.com/music/songs/LP-A_Light.mp3");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if (lstream[playerid] != SV_NULL)
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
	pemainic--;
	//job
	if(pData[playerid][pJob] == 2)
	{
	    mekanik--;
	}
	else if(pData[playerid][pJob] == 11)
	{
    	tukangayam--;
	}
	else if(pData[playerid][pJob] == 3)
	{
    	tukangtebang--;
	}
	else if(pData[playerid][pJob] == 14)
	{
	    DeleteMinyakCP(playerid);
    	penambangminyak--;
	}
	else if(pData[playerid][pJob] == 5)
	{
    	penambang--;
    	DeletePenambangCP(playerid);
	}
	else if(pData[playerid][pJob] == 13)
	{
    	markisaa--;
	}
	else if(pData[playerid][pJob] == 10)
	{
    	bagage--;
	}
	else if(pData[playerid][pJob] == 7)
	{
    	petani--;
	}
	else if(pData[playerid][pJob] == 8)
	{
    	Trucker--;
	}
	else if(pData[playerid][pJob] == 6)
	{
    	product--;
	}
	else if(pData[playerid][pJob] == 1)
	{
    	Sopirbus--;
	}
	else if(pData[playerid][pJob] == 12)
	{
    	Merchantfiller--;
	}
	pData[playerid][pSpaTime] = gettime() + 3600;
	if (lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
	//LagiKerja[playerid] = false;
	//Kurir[playerid] = false;
	//KillTimer(Unload_Timer[playerid]);
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
	//baggage
	for(new i; i <= 9; i++)
	{
		if(MyBaggage[playerid][i] == true)
		{
		    MyBaggage[playerid][i] = false;
		    DialogBaggage[i] = false;
			if(IsValidVehicle(pData[playerid][pTrailerBaggage]))
		    	DestroyVehicle(pData[playerid][pTrailerBaggage]);  //jika player disconnect maka trailer akan kembali seperti awal
		}
    }
	//dron
	DestroyVehicle( Drones[playerid] );
	//UpdateWeapons(playerid);
	g_MysqlRaceCheck[playerid]++;
	
	if(pData[playerid][IsLoggedIn] == true)
	{
		if(IsAtEvent[playerid] == 0)
		{
			UpdatePlayerData(playerid);
		}
		RemovePlayerVehicle(playerid);
		Report_Clear(playerid);
		Ask_Clear(playerid);
		//Player_ResetMining(playerid);
		Player_ResetCutting(playerid);
		Player_RemoveLumber(playerid);
		Player_ResetHarvest(playerid);
		KillTazerTimer(playerid);
		SaveLunarSystem(playerid);
		if(IsValidVehicle(pData[playerid][pTrailer]))
			DestroyVehicle(pData[playerid][pTrailer]);

		pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
		if(IsAtEvent[playerid] == 1)
		{
			if(GetPlayerTeam(playerid) == 1)
			{
				if(EventStarted == 1)
				{
					RedTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 2)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 1)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							RedTeam = 0;
						}
					}
				}
			}
			if(GetPlayerTeam(playerid) == 2)
			{
				if(EventStarted == 1)
				{
					BlueTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 1)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 2)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
					}
				}
			}
			SetPlayerTeam(playerid, 0);
			IsAtEvent[playerid] = 0;
			pData[playerid][pInjured] = 0;
			pData[playerid][pSpawned] = 1;
		}
		if(pData[playerid][pRobLeader] == 1)
		{
			foreach(new ii : Player) 
			{
				if(pData[ii][pMemberRob] > 1)
				{
					Servers(ii, "* Pemimpin Perampokan anda telah keluar! [ MISI GAGAL ]");
					pData[ii][pMemberRob] = 0;
					RobMember = 0;
					pData[ii][pRobLeader] = 0;
					ServerMoney += robmoney;
				}
			}
		}
		if(pData[playerid][pMemberRob] == 1)
		{
			pData[playerid][pMemberRob] = 0;
			foreach(new ii : Player) 
			{
				if(pData[ii][pRobLeader] > 1)
				{
					Servers(ii, "* Member berkurang 1");
					pData[ii][pMemberRob] -= 1;
					RobMember -= 1;
				}
			}
		}
	}
	
	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

    if(IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);
			
	if(IsValidDynamicObject(pData[playerid][pFlare]))
            DestroyDynamicObject(pData[playerid][pFlare]);
    
    if(pData[playerid][pMaskOn] == 1)
            Delete3DTextLabel(pData[playerid][pMaskLabel]);

    pData[playerid][pAdoActive] = false;
	
	/*if(cache_is_valid(pData[playerid][Cache_ID]) && pData[playerid][IsLoggedIn] == false)
	{
		cache_delete(pData[playerid][Cache_ID]);
		pData[playerid][Cache_ID] = MYSQL_INVALID_CACHE;
	}*/

	if (pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	//hp
	//hapeanyar
	TogglePhone[playerid] = 0;
	ToggleSid[playerid] = 0;
	ToggleCall[playerid] = 0;
	DetikCall[playerid] = 0;
	MenitCall[playerid] = 0;
	JamCall[playerid] = 0;

	//ntah
	pData[playerid][pOnline] = 0;
	
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 40.0, x, y, z))
		{
			switch(reason)
			{
				case 0:
				{
					//connectlogs
					new DCC_Embed:logss;
					new yy, mm, dd, timestamp[200];
					getdate(yy, mm , dd);

					format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, mm, dd);
					logss = DCC_CreateEmbed("");
					DCC_SetEmbedTitle(logss, "Warga Kota");
					DCC_SetEmbedTimestamp(logss, timestamp);
					DCC_SetEmbedColor(logss, 0xff1100);
					DCC_SetEmbedUrl(logss, "");
					DCC_SetEmbedThumbnail(logss, "");
					DCC_SetEmbedFooter(logss, "", "");
					DCC_SetEmbedDescription(logss, "Player Disconnect");
					new stroi[5000];
					format(stroi, sizeof(stroi), "%s", UcpData[playerid][uUsername]);
					DCC_AddEmbedField(logss, "Nama UCP", stroi, true);
					format(stroi, sizeof(stroi), "%s", GetRPName(playerid));
					DCC_AddEmbedField(logss, "Character", stroi, true);
					format(stroi, sizeof(stroi), "(FC/Crash/Timeout)");
					DCC_AddEmbedField(logss, "Reason", stroi, true);
					DCC_SendChannelEmbedMessage(connectlogs, logss);
				}
				case 1:
				{
					//connectlogs
					new DCC_Embed:logss;
					new yy, mm, dd, timestamp[200];
					getdate(yy, mm , dd);

					format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, mm, dd);
					logss = DCC_CreateEmbed("");
					DCC_SetEmbedTitle(logss, "Warga Kota");
					DCC_SetEmbedTimestamp(logss, timestamp);
					DCC_SetEmbedColor(logss, 0xff1100);
					DCC_SetEmbedUrl(logss, "");
					DCC_SetEmbedThumbnail(logss, "");
					DCC_SetEmbedFooter(logss, "", "");
					DCC_SetEmbedDescription(logss, "Player Disconnect");
					new stroi[5000];
					format(stroi, sizeof(stroi), "%s", UcpData[playerid][uUsername]);
					DCC_AddEmbedField(logss, "Nama UCP", stroi, true);
					format(stroi, sizeof(stroi), "%s", GetRPName(playerid));
					DCC_AddEmbedField(logss, "Character", stroi, true);
					format(stroi, sizeof(stroi), "(Disconnected)");
					DCC_AddEmbedField(logss, "Reason", stroi, true);
					DCC_SendChannelEmbedMessage(connectlogs, logss);
				}
				case 2:
				{
					//connectlogs
					new DCC_Embed:logss;
					new yy, mm, dd, timestamp[200];
					getdate(yy, mm , dd);

					format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, mm, dd);
					logss = DCC_CreateEmbed("");
					DCC_SetEmbedTitle(logss, "Warga Kota");
					DCC_SetEmbedTimestamp(logss, timestamp);
					DCC_SetEmbedColor(logss, 0xff1100);
					DCC_SetEmbedUrl(logss, "");
					DCC_SetEmbedThumbnail(logss, "");
					DCC_SetEmbedFooter(logss, "", "");
					DCC_SetEmbedDescription(logss, "Player Disconnect");
					new stroi[5000];
					format(stroi, sizeof(stroi), "%s", UcpData[playerid][uUsername]);
					DCC_AddEmbedField(logss, "Nama UCP", stroi, true);
					format(stroi, sizeof(stroi), "%s", GetRPName(playerid));
					DCC_AddEmbedField(logss, "Character", stroi, true);
					format(stroi, sizeof(stroi), "(Kick/Banned)");
					DCC_AddEmbedField(logss, "Reason", stroi, true);
					DCC_SendChannelEmbedMessage(connectlogs, logss);				
				}
			}
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	//SpawnPlayer(playerid);
	//LagiKerja[playerid] = false;
	//Kurir[playerid] = false;
	StopAudioStreamForPlayer(playerid);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	
	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);
	return 1;
}


SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		//TogglePlayerSpectating(playerid, false);
		ClearChat(playerid);
		new j, m, d;
		new dayz, monthz, yearz;
		new MonthName[12][] =
		{
			"January", "February", "March", "April", "May", "June",
			"July",    "August", "September", "October", "November", "December"
		};
		gettime(j, m, d);
		getdate(yearz,monthz,dayz);	
		SendClientMessageEx(playerid, -1, "{b897ff}SERVER: {FFFFFF}Selamat datang {b897ff} %s.", AccountData[playerid][pName]);
		SendClientMessageEx(playerid, -1, "{b897ff}SERVER: {FFFFFF}Hari Ini {b897ff}%02d %s %d, %02d:%02d:%02d", dayz,  MonthName[monthz-1], yearz, j, m, d);
		SendClientMessageEx(playerid, -1, "{b897ff}MOTD:{FFFFFF} Discord kita yaitu: {B897FF}linktr.ee/Wargakota-roleplay");
		SendClientMessageEx(playerid, -1, "{b897ff}NOTE: {FFFFFF}Jika anda punya pertanyaan gunakan {b897ff}/ask{FFFFFF}, untuk keperluan lainnya anda dapat menggunakan {b897ff}/help");
		if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 0.0);
			SetPlayerPos(playerid, 1716.1129, -1880.0715, -10.0);
			SetPlayerCameraPos(playerid,1429.946655, -1597.120483, 41);
			SetPlayerCameraLookAt(playerid,247.605590, -1841.989990, 39.802570);
			SetPlayerVirtualWorld(playerid, 0);
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir\n(Tgl/Bulan/Tahun)\nContoh : 15/04/1998", "Enter", "Batal");
		}
		else
		{
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			SetPlayerColor(playerid, COLOR_WHITE);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
				ShowHbeaufaDua(playerid);
				UpdateHBEDua(playerid);
			}
			if(pData[playerid][pHBEMode] == 2) //modern
			{
				UpdateHBE(playerid);
				ShowHbeaufa(playerid);
			}
			else
			{
				
			}
			//TextDrawShowForPlayer(playerid, SOIRP_TXD);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pOnDutyMendung] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionMendungColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_RED);
			}
			if(pData[playerid][pVoiceStatus] == 0)
			{
				PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
				PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
				PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "BERBISIK");
				PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_YELLOW);
				PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
				if ((lstream[playerid] = SvCreateDLStreamAtPlayer(5.0, SV_INFINITY, playerid, 0xff0000ff, "Berbisik")))
				SuccesMsg(playerid, "Voice Anda Sekarang Berbisik.");
			}
			if(pData[playerid][pVoiceStatus] == 1)
			{
				PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
				PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
				PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "NORMAL");
				PlayerTextDrawColor(playerid, VoiceTD[playerid][1], 16711935);
				PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
				if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Normal")))
				SuccesMsg(playerid, "Voice Anda Sekarang Normal.");
			}
			if(pData[playerid][pVoiceStatus] == 2)
			{
				PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
				PlayerTextDrawHide(playerid, VoiceTD[playerid][1]);
				PlayerTextDrawSetString(playerid, VoiceTD[playerid][1], "TERIAK");
				PlayerTextDrawColor(playerid, VoiceTD[playerid][1], COLOR_RED);
				PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
				if ((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Teriak")))
				SuccesMsg(playerid, "Voice Anda Sekarang Teriak.");
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
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
		}
	}
}

function SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealth(playerid, pData[playerid][pHealth]);
	SetPlayerArmour(playerid, pData[playerid][pArmour]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	if(pData[playerid][pJail] > 0)
	{
		JailPlayer(playerid); 
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	LoadLunarSystem(playerid);
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == SpawnMale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1685.94, -2334.16, 13.54, 270.0000, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	if(listid == SpawnFemale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1685.94, -2334.16, 13.54, 270.0000, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	//Locker Faction Skin
	if(listid == SAPDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDWar)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	///Bisnis buy skin clothes
	if(listid == MaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, 
            	(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == FemaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPMaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPFemaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == toyslist)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][1];
			
			GivePlayerMoneyEx(playerid, -price);
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	if(listid == viptoyslist)
	{
		if(response)
		{
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "{FFFFFF}ACTION: {DDA0DD}** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled toys");
	}
	//PEDAGANG
	if(listid == PDGSkinMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == PDGSkinFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerCameraPos(playerid,1429.946655, -1597.120483, 41);
	SetPlayerCameraLookAt(playerid,247.605590, -1841.989990, 39.802570);
	InterpolateCameraPos(playerid, 1429.946655, -1597.120483, 41, 2098.130615, -1775.991210, 41.111639, 50000);
	InterpolateCameraLookAt(playerid, 247.605590, -1841.989990, 39.802570, 817.645996, -1645.395751, 29.292520, 15000);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	//dron
    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) {
    	SetPVarInt( playerid, "DroneSpawned", 0 );
    	DestroyVehicle( Drones[playerid] );
    	SendClientMessage( playerid, COLOR_GREEN, "Your drone was automatically shut down as you have died." );
	}
	pData[playerid][pSpawned] = 0;
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	//Player_ResetMining(playerid);
	Player_ResetHarvest(playerid);

	pData[playerid][CarryProduct] = 0;
	
	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pCooking]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;
	
	pData[playerid][pMechDuty] = 0;
	pData[playerid][pTaxiDuty] = 0;
	pData[playerid][pMission] = -1;
	
	pData[playerid][pSideJob] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	//anti dual
	//pData[playerid][pOnline] = 1;
	if(killerid != INVALID_PLAYER_ID)
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Bunuh Diri/Bug";
		}
		new h, m, s;
		new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);

        new dc[128];
        //format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] killed %s [ID: %d] (%s)\n```",day, month, year, h, m, s, pData[killerid][pName], killerid, pData[playerid][pName], playerid, reasontext);
        format(dc, sizeof dc, "**[KILL LOGS]**  __%s__ *(%s)* | killed by:  __%s[ID:%d]__ | Weap: __%s__ | Loc: __%s__\nTime: *%02d.%02d.%d - %02d:%02d:%02d*", pData[killerid][pName], UcpData[playerid][uUsername], killerid, pData[playerid][pName], playerid, reasontext, GetLocation(x, y, z), day, month, year, h, m, s);
		SendDiscordMessage(3, dc);
	}
    else
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Bunuh Diri/Bug";
		}
	    new h, m, s;
	    new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);
	    new name[MAX_PLAYER_NAME + 1];
	    GetPlayerName(playerid, name, sizeof name);
		//new Float:x, Float:y, Float:z;
		//GetPlayerPos(playerid, x, y, z);

	    new dc[128];
		format(dc, sizeof dc, "**[KILL LOGS]**  __%s__*(%s)* | Weap: __%s__ | Loc: __%s__\nTime: *%02d.%02d.%d - %02d:%02d:%02d*", name, UcpData[playerid][uUsername], reasontext, GetLocation(x, y, z), day, month, year, h, m, s);
	    //format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] death(%s)\n```",day, month, year, h, m, s, name, playerid, reasontext);
	    SendDiscordMessage(3, dc);
	}
	foreach(new ii : Player)
    {
        if(pData[ii][pAdmin] > 0)
        {
            SendDeathMessageToPlayer(ii, killerid, playerid, reason);
        }
    }
    if(IsAtEvent[playerid] == 1)
    {
    	SetPlayerPos(playerid, 1474.65, -1736.36, 13.38);
    	SetPlayerVirtualWorld(playerid, 0);
    	SetPlayerInterior(playerid, 0);
    	ClearAnimations(playerid);
    	ResetPlayerWeaponsEx(playerid);
       	SetPlayerColor(playerid, COLOR_WHITE);
    	if(GetPlayerTeam(playerid) == 1)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		RedTeam -= 1;
    	}
    	else if(GetPlayerTeam(playerid) == 2)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		BlueTeam -= 1;
    	}
    	if(BlueTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 1)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 2)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    		}
    	}
    	if(RedTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 2)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 1)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				RedTeam = 0;
    			}
    		}
    	}
    	SetPlayerTeam(playerid, 0);
    	IsAtEvent[playerid] = 0;
    	pData[playerid][pInjured] = 0;
    	pData[playerid][pSpawned] = 1;
    }
    if(IsAtEvent[playerid] == 0)
    {
    	new asakit = RandomEx(0, 5);
    	new bsakit = RandomEx(0, 9);
    	new csakit = RandomEx(0, 7);
    	new dsakit = RandomEx(0, 6);
    	pData[playerid][pLFoot] -= dsakit;
    	pData[playerid][pLHand] -= bsakit;
    	pData[playerid][pRFoot] -= csakit;
    	pData[playerid][pRHand] -= dsakit;
    	pData[playerid][pHead] -= asakit;
    }
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];
 
            GetWeaponName(weaponid, weaponname, sizeof(weaponname));
           
            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;
 
            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
 
            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);
           
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;
			
			MySQL_SavePlayerToys(playerid);
		}
		else if(response == 0)
		{
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);

			SetPlayerAttachedObject(playerid,
				index,
				modelid,
				boneid,
				pToys[playerid][index][toy_x],
				pToys[playerid][index][toy_y],
				pToys[playerid][index][toy_z],
				pToys[playerid][index][toy_rx],
				pToys[playerid][index][toy_ry],
				pToys[playerid][index][toy_rz],
				pToys[playerid][index][toy_sx],
				pToys[playerid][index][toy_sy],
				pToys[playerid][index][toy_sz]);
		}
		SetPVarInt(playerid, "UpdatedToy", 1);
		TogglePlayerControllable(playerid, true);
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(pData[playerid][EditingTreeID] != -1 && Iter_Contains(Trees, pData[playerid][EditingTreeID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        TreeData[etid][treeX] = x;
	        TreeData[etid][treeY] = y;
	        TreeData[etid][treeZ] = z;
	        TreeData[etid][treeRX] = rx;
	        TreeData[etid][treeRY] = ry;
	        TreeData[etid][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_X, TreeData[etid][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Y, TreeData[etid][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Z, TreeData[etid][treeZ] + 1.5);

		    Tree_Save(etid);
	        pData[playerid][EditingTreeID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
	        pData[playerid][EditingTreeID] = -1;
	    }
	}
	//vending
	if(pData[playerid][EditingVending] != -1 && Iter_Contains(Vendings, pData[playerid][EditingVending]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new venid = pData[playerid][EditingVending];
	        VendingData[venid][vendingX] = x;
	        VendingData[venid][vendingY] = y;
	        VendingData[venid][vendingZ] = z;
	        VendingData[venid][vendingRX] = rx;
	        VendingData[venid][vendingRY] = ry;
	        VendingData[venid][vendingRZ] = rz;

	        SetDynamicObjectPos(objectid, VendingData[venid][vendingX], VendingData[venid][vendingY], VendingData[venid][vendingZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][vendingRX], VendingData[venid][vendingRY], VendingData[venid][vendingRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_X, VendingData[venid][vendingX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_Y, VendingData[venid][vendingY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_Z, VendingData[venid][vendingZ] + 0.3);

		    Vending_Save(venid);
			//UpdatePlayerStreamer(playerid);
	        pData[playerid][EditingVending] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new venid = pData[playerid][EditingVending];
	        SetDynamicObjectPos(objectid, VendingData[venid][vendingX], VendingData[venid][vendingY], VendingData[venid][vendingZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][vendingRX], VendingData[venid][vendingRY], VendingData[venid][vendingRZ]);
	    	pData[playerid][EditingVending] = -1;
			//UpdatePlayerStreamer(playerid);
	    }
	}
	if(pData[playerid][EditingTrash] != -1 && Iter_Contains(Trashs, pData[playerid][EditingTrash]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTrash];
	        TrashData[etid][TrashX] = x;
	        TrashData[etid][TrashY] = y;
	        TrashData[etid][TrashZ] = z;
	        //TrashData[etid][atmRX] = rx;
	       	//TrashData[etid][atmRY] = ry;
	        //TrashData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, TrashData[etid][TrashX], TrashData[etid][TrashY], TrashData[etid][TrashZ]);
	       // SetDynamicObjectRot(objectid, TrashData[etid][atmRX], TrashData[etid][atmRY], TrashData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[etid][TrashLabel], E_STREAMER_X, TrashData[etid][TrashX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[etid][TrashLabel], E_STREAMER_Y, TrashData[etid][TrashY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[etid][TrashLabel], E_STREAMER_Z, TrashData[etid][TrashZ] + 0.3);

		    Trash_Save(etid);
	        pData[playerid][EditingTrash] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTrash];
	        SetDynamicObjectPos(objectid, TrashData[etid][TrashX], TrashData[etid][TrashY], TrashData[etid][TrashZ]);
	       // SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingTrash] = -1;
	    }
	}
	//sinyal signal
	if(pData[playerid][EditingSIGNAL] != -1 && Iter_Contains(Signal, pData[playerid][EditingSIGNAL]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        sgData[sgid][sgX] = x;
	        sgData[sgid][sgY] = y;
	        sgData[sgid][sgZ] = z;
	        sgData[sgid][sgRX] = rx;
	        sgData[sgid][sgRY] = ry;
	        sgData[sgid][sgRZ] = rz;

	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_X, sgData[sgid][sgX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Y, sgData[sgid][sgY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Z, sgData[sgid][sgZ] + 3.5);

		    Signal_Save(sgid);
	        pData[playerid][EditingSIGNAL] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);
	        pData[playerid][EditingSIGNAL] = -1;
	    }
	}
	/*if(pData[playerid][EditingOreID] != -1 && Iter_Contains(Ores, pData[playerid][EditingOreID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        OreData[etid][oreX] = x;
	        OreData[etid][oreY] = y;
	        OreData[etid][oreZ] = z;
	        OreData[etid][oreRX] = rx;
	        OreData[etid][oreRY] = ry;
	        OreData[etid][oreRZ] = rz;

	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_X, OreData[etid][oreX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Y, OreData[etid][oreY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Z, OreData[etid][oreZ] + 1.5);

		    Ore_Save(etid);
	        pData[playerid][EditingOreID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);
	        pData[playerid][EditingOreID] = -1;
	    }
	}*/
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	//job sapi
	if(areaid == PlayerSusuVars[playerid][SusuTakeArea])
	{
		KeyBindInfo(playerid, "[ALT] Perah Susu");
	}
	//atm
	forex(i, MAX_ATM) if(AtmData[i][atmExists])
	{
		if(areaid == AtmData[i][atmArea])
		{
			KeyBindInfo(playerid, "[ALT] Menggunakan ATM");								
		}
	}
	if(checkpointid == AreaData[dealer])
    {
        KeyBindInfo(playerid, "[Y] Akses Showroom");
    }			
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	HideInfo(playerid);
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	HideInfo(playerid);
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	//job sapi
	if(checkpointid == PemerahCP)
	{
		KeyBindInfo(playerid, "[ALT] Akses Locker");
	}
	//pedagang
	if(checkpointid == menumasak)
	{
		KeyBindInfo(playerid, "[ALT] Untuk Memasak");
	}
	if(checkpointid == menuminum)
	{
		KeyBindInfo(playerid, "[ALT] Membuka Kulkas");
	}
	/*if(checkpointid == menupedagang)
	{
		KeyBindInfo(playerid, "menu pedagang");
	}*/
	//disnaker
	if(checkpointid == Disnaker)
	{
		KeyBindInfo(playerid, "[ALT] Untuk Ambil Job");
	}
	//Staterpack
    if(checkpointid == Staterpack)
    {
        KeyBindInfo(playerid, "[ALT] Claim Staterpack");
    }
	//PENAMBANG BATU
	if(checkpointid == PenambangArea[playerid][Nambang])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][Nambang2])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][Nambang3])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][Nambang4])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][Nambang5])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][Nambang6])
	{
		KeyBindInfo(playerid, "[ALT] Untuk menambang");
	}
	if(checkpointid == PenambangArea[playerid][CuciBatu])
	{
		KeyBindInfo(playerid, "[ALT] mencuci batu");
	}
	if(checkpointid == PenambangArea[playerid][Peleburan])
	{
		KeyBindInfo(playerid, "[ALT] meleburkan batu");
	}
	//PENAMBANG MINYAK
	if(checkpointid == MinyakArea[playerid][OlahMinyak])
	{
		InfoMsg(playerid, "[ALT] mengolah minyak");
	}
	if(checkpointid == MinyakArea[playerid][Nambangg])
	{
		InfoMsg(playerid, "[ALT] mengambil minyak");
	}
	if(checkpointid == MinyakArea[playerid][Nambang])
	{
		InfoMsg(playerid, "[ALT] mengambil minyak");
	}
	/*if(checkpointid == pData[playerid][LoadingPoint])
	{
	    if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		return 1;
	}*/
	if(checkpointid == ShowRoomCP)
	{
		ShowPlayerDialog(playerid, DIALOG_BUYPVCP, DIALOG_STYLE_LIST, "{B897FF}Warga Kota{FFFFFF} - Showroom", "Motorcycle\nMobil\nKendaraan Unik\nKendaraan Job", "Select", "Cancel");
	}
	if(checkpointid == ShowRoomCPRent)
	{
		new str[1024];
		format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days",
		GetVehicleModelName(414), 
		GetVehicleModelName(455), 
		GetVehicleModelName(456),
		GetVehicleModelName(498),
		GetVehicleModelName(499),
		GetVehicleModelName(609),
		GetVehicleModelName(478),
		GetVehicleModelName(422),
		GetVehicleModelName(543),
		GetVehicleModelName(554),
		GetVehicleModelName(525),
		GetVehicleModelName(438),
		GetVehicleModelName(420)
		);
		
		ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "Rent Job Cars", str, "Rent", "Close");
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(pData[playerid][pGpsActive] == 1)
	{
		pData[playerid][pGpsActive] = 0;
		DisablePlayerRaceCheckpoint(playerid);
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pClikmap] == 1)
	{
		pData[playerid][pClikmap] = 0;
		DisablePlayerCheckpoint(playerid);
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackCar] == 1)
	{
		SuccesMsg(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		SuccesMsg(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackVending] == 1)
	{
		InfoMsg(playerid, "Anda telah berhasil menemukan mesin vending anda!");
		pData[playerid][pTrackVending] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		SuccesMsg(playerid, "Anda telah berhasil menemukan bisnis anda!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		SuccesMsg(playerid, "/buy , /gps(My Mission) , /storeproduct.");
	}
	if(pData[playerid][pHauling] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, 336.70, 895.54, 20.40, 5.5);
		printf("[HAULING] %s's attached vehicle trailer", pData[playerid][pName]);
		new Float:z;
		GetVehicleZAngle(GetPlayerVehicleID(playerid), z);
		pData[playerid][pTrailer] = CreateVehicle(584, 324.33, 858.41, 20.40, z, -1, -1, -1, 0);
		AttachTrailerToVehicle(pData[playerid][pTrailer], GetPlayerVehicleID(playerid));
	}
	switch(pData[playerid][pCheckPoint])
	{
		case CHECKPOINT_BAGGAGE:
		{
			if(pData[playerid][pBaggage] > 0)
			{
				if(pData[playerid][pBaggage] == 1)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 2;
					SetPlayerRaceCheckpoint(playerid, 1, 1524.4792, -2435.2844, 13.2118, 1524.4792, -2435.2844, 13.2118, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 2)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 3;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2087.7998, -2392.8328, 13.2083, 2087.7998, -2392.8328, 13.2083, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2087.7998, -2392.8328, 13.2083, 179.9115, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 3)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 4;
					SetPlayerRaceCheckpoint(playerid, 1, 1605.2043, -2435.4360, 13.2153, 1605.2043, -2435.4360, 13.2153, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 4)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 5;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2006.6425, -2340.5103, 13.2045, 2006.6425, -2340.5103, 13.2045, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2006.6425, -2340.5103, 13.2045, 90.0068, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 5)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 6;
					SetPlayerRaceCheckpoint(playerid, 1, 1684.9463, -2435.2239, 13.2137, 1684.9463, -2435.2239, 13.2137, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 6)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 7;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2006.4136, -2273.7458, 13.2012, 2006.4136, -2273.7458, 13.2012, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2006.4136, -2273.7458, 13.2012, 92.4049, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 7)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 8;
					SetPlayerRaceCheckpoint(playerid, 1, 1765.8700, -2435.1189, 13.2090, 1765.8700, -2435.1189, 13.2090, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 8)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 9;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2056.9043, -2392.0959, 13.2038, 2056.9043, -2392.0959, 13.2038, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2056.9043, -2392.0959, 13.2038, 179.4666, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 9)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 10;
					SetPlayerRaceCheckpoint(playerid, 1, 1524.1018, -2435.0664, 13.2139, 1524.1018, -2435.0664, 13.2139, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 10)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 11;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint terakhir di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2099.8982, -2200.7234, 13.2042, 2099.8982, -2200.7234, 13.2042, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 11)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 1380;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[0] = false;
					MyBaggage[playerid][0] = false;
					ShowItemBox(playerid, "Uang", "Received_320x", 1212, 2);
					GivePlayerMoneyEx(playerid, 320);
					InfoMsg(playerid, "Job(Baggage) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				//RUTE BAGGGAGE 2
				else if(pData[playerid][pBaggage] == 12)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 13;
					SetPlayerRaceCheckpoint(playerid, 1, 1891.7626, -2638.8113, 13.2074, 1891.7626, -2638.8113, 13.2074, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 13)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 14;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2007.5886, -2406.7236, 13.2065, 2007.5886, -2406.7236, 13.2065, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2007.5886, -2406.7236, 13.2065, 85.9836, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 14)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 15;
					SetPlayerRaceCheckpoint(playerid, 1, 1822.6267, -2637.9224, 13.2049, 1822.6267, -2637.9224, 13.2049, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 15)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 16;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2007.2054, -2358.0920, 13.2030, 2007.2054, -2358.0920, 13.2030, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2007.2054, -2358.0920, 13.2030, 89.7154, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 16)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 17;
					SetPlayerRaceCheckpoint(playerid, 1, 1617.9980, -2638.5725, 13.2034, 1617.9980, -2638.5725, 13.2034, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 17)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 18;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1874.9221, -2348.8616, 13.2039, 1874.9221, -2348.8616, 13.2039, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1874.9221, -2348.8616, 13.2039, 274.8172, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 18)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 19;
					SetPlayerRaceCheckpoint(playerid, 1, 1681.0703, -2638.5410, 13.2045, 1681.0703, -2638.5410, 13.2045, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 19)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 20;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1424.8074, -2415.5378, 13.2094, 1424.8074, -2415.5378, 13.2094, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 1424.8074, -2415.5378, 13.2094, 268.7459, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 20)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 21;
					SetPlayerRaceCheckpoint(playerid, 1, 1755.4872, -2639.1306, 13.2014, 1755.4872, -2639.1306, 13.2014, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 21)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 22;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint terakhir di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2110.0212, -2211.1377, 13.2008, 2110.0212, -2211.1377, 13.2008, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 22)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 1380;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[1] = false;
					MyBaggage[playerid][1] = false;
					ShowItemBox(playerid, "Uang", "Received_320x", 1212, 2);
					GivePlayerMoneyEx(playerid, 320);
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				//RUTE BAGGAGE 3
				else if(pData[playerid][pBaggage] == 23)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 24;
					SetPlayerRaceCheckpoint(playerid, 1, 1509.5022, -2431.4277, 13.2163, 1509.5022, -2431.4277, 13.2163, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 24)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 25;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1913.4680, -2678.1877, 13.2135, 1913.4680, -2678.1877, 13.2135, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 1913.4680, -2678.1877, 13.2135, 358.3546, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 25)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 26;
					SetPlayerRaceCheckpoint(playerid, 1, 1591.0934, -2432.3208, 13.2094, 1591.0934, -2432.3208, 13.2094, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 26)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 27;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1593.1262, -2685.6423, 13.2016, 1593.1262, -2685.6423, 13.2016, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1593.1262, -2685.6423, 13.2016, 359.1027, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 27)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 28;
					SetPlayerRaceCheckpoint(playerid, 1, 1751.1523, -2432.6274, 13.2132, 1751.1523, -2432.6274, 13.2132, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 28)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 29;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1706.6799, -2686.6472, 13.2031, 1706.6799, -2686.6472, 13.2031, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1706.6799, -2686.6472, 13.2031, 358.5210, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 29)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 30;
					SetPlayerRaceCheckpoint(playerid, 1, 1892.2029, -2344.9568, 13.2069, 1892.2029, -2344.9568, 13.2069, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 30)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 31;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2160.3184, -2390.0625, 13.2055, 2160.3184, -2390.0625, 13.2055, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2160.3184, -2390.0625, 13.2055, 157.5291, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 31)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 32;
					SetPlayerRaceCheckpoint(playerid, 1, 1891.8900, -2261.1121, 13.2071, 1891.8900, -2261.1121, 13.2071, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 32)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 33;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2087.1458, -2192.2161, 13.2047, 2087.1458, -2192.2161, 13.2047, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 33)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 1380;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[2] = false;
					MyBaggage[playerid][2] = false;
					ShowItemBox(playerid, "Uang", "Received_300x", 1212, 2);
					GivePlayerMoneyEx(playerid, 300);
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}	
			}
		}
		case CHECKPOINT_DRIVELIC:
		{
			if(pData[playerid][pDriveLicApp] > 0)
			{
				if(pData[playerid][pDriveLicApp] == 1)
				{
					pData[playerid][pDriveLicApp] = 2;
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint2, dmvpoint2, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 2)
				{
					pData[playerid][pDriveLicApp] = 3;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint3, dmvpoint3, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 3)
				{
					pData[playerid][pDriveLicApp] = 4;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint4, dmvpoint4, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 4)
				{
					pData[playerid][pDriveLicApp] = 5;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint5, dmvpoint5, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 5)
				{
					pData[playerid][pDriveLicApp] = 6;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint6, dmvpoint6, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 6)
				{
					pData[playerid][pDriveLicApp] = 7;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint7, dmvpoint7, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 7)
				{
					pData[playerid][pDriveLicApp] = 8;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint8, dmvpoint8, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 8)
				{
					pData[playerid][pDriveLicApp] = 9;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint9, dmvpoint9, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 9)
				{
					pData[playerid][pDriveLicApp] = 10;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint10, dmvpoint10, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 10)
				{
					pData[playerid][pDriveLicApp] = 11;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint11, dmvpoint11, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 11)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					pData[playerid][pDriveLicApp] = 0;
					pData[playerid][pDriveLic] = 1;
					pData[playerid][pDriveLicTime] = gettime() + (30 * 86400);
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DisablePlayerRaceCheckpoint(playerid);
					GivePlayerMoneyEx(playerid, -70);
					Server_AddMoney(70);
					//ShowItemBox(playerid, "Uang", "Received_$300", 1212, 4);
					ShowItemBox(playerid, "Uang", "Removed_$70", 1212, 4);
					InfoMsg(playerid, "Selamat kamu telah berhasil membuat SIM");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	new playerState = GetPlayerState(playerid);
    if(playerState == PLAYER_STATE_ONFOOT )
    {
	    /*if(Kurir[playerid] == true)
	    {
            if(angkatBox[playerid] == false)
	        {
				 Error(playerid,"Silahkan bawa Box pengiriman barang, /angkatbox");
			}
			else if(angkatBox[playerid] == true)
	        {
	        RemovePlayerAttachedObject(playerid, BOX_INDEX);
			GameTextForPlayer(playerid, "~g~MELETAKKAN BARANG...", 4000, 3);
            ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
	        Unload_Timer[playerid] = SetTimerEx("PekerjaanSelesai", 5000, false, "i", playerid);
	        TogglePlayerControllable(playerid,0);
		    }
        }*/
	}
	if(pData[playerid][pClikmap] == 1)
	{
		pData[playerid][pClikmap] = 0;
		DisablePlayerCheckpoint(playerid);
		DisablePlayerRaceCheckpoint(playerid);
	}
	if (PlayerInfo[playerid][pWaypoint])
	{
		PlayerInfo[playerid][pWaypoint] = 0;

		DisablePlayerCheckpoint(playerid);
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pHauling] > -1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.5, 336.70, 895.54, 20.40))
		{
			DisablePlayerCheckpoint(playerid);
			InfoMsg(playerid, "/buy , /gps(My Hauling) , /storegas.");
		}
	}
	if(pData[playerid][pCP] == 1)
	{
		pData[playerid][pJobTime] = 120;
		DisablePlayerCheckpoint(playerid);
		AddPlayerSalary(playerid, "Job (Kurir)", 400);
        pData[playerid][pKurirEnd] = 0;
        pData[playerid][pCP] = 0;
		InfoMsg(playerid, "Job (Kurir) telah masuk ke pending salary anda!");
		RemovePlayerFromVehicle(playerid);
		SetTimerEx("RespawnPV", 3000, false, "d", GetPlayerVehicleID(playerid));
	}
	/*if(pData[playerid][CarryingLog] != -1)
	{
		if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		DisablePlayerCheckpoint(playerid);
		return 1;
	}*/
	if(pData[playerid][pFindEms] != INVALID_PLAYER_ID)
	{
		pData[playerid][pFindEms] = INVALID_PLAYER_ID;
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pSideJob] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 574)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint1))
			{
				SetPlayerCheckpoint(playerid, sweperpoint2, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint2))
			{
				SetPlayerCheckpoint(playerid, sweperpoint3, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint3))
			{
				SetPlayerCheckpoint(playerid, sweperpoint4, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint4))
			{
				SetPlayerCheckpoint(playerid, sweperpoint5, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint5))
			{
				SetPlayerCheckpoint(playerid, sweperpoint6, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint6))
			{
				SetPlayerCheckpoint(playerid, sweperpoint7, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint7))
			{
				SetPlayerCheckpoint(playerid, sweperpoint8, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint8))
			{
				SetPlayerCheckpoint(playerid, sweperpoint9, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint9))
			{
				SetPlayerCheckpoint(playerid, sweperpoint10, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint10))
			{
				SetPlayerCheckpoint(playerid, sweperpoint11, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint11))
			{
				SetPlayerCheckpoint(playerid, sweperpoint12, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint12))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 120;
				DisablePlayerCheckpoint(playerid);
				ShowItemBox(playerid, "Uang", "Received_150x", 1212, 2);
				GivePlayerMoneyEx(playerid, 150);
				//AddPlayerSalary(playerid, "Sidejob(Sweeper)", 150);
				InfoMsg(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint1))
			{
				SetPlayerCheckpoint(playerid, buspoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint2))
			{
				SetPlayerCheckpoint(playerid, buspoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint3))
			{
				SetPlayerCheckpoint(playerid, buspoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint4))
			{
				SetPlayerCheckpoint(playerid, buspoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint5))
			{
				SetPlayerCheckpoint(playerid, buspoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint6))
			{
				SetPlayerCheckpoint(playerid, buspoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint7))
			{
				SetPlayerCheckpoint(playerid, buspoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint8))
			{
				SetPlayerCheckpoint(playerid, buspoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint9))
			{
				SetPlayerCheckpoint(playerid, buspoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint10))
			{
				SetPlayerCheckpoint(playerid, buspoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint11))
			{
				SetPlayerCheckpoint(playerid, buspoint12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint12))
			{
				SetPlayerCheckpoint(playerid, buspoint13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint13))
			{
				SetPlayerCheckpoint(playerid, buspoint14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint14))
			{
				SetPlayerCheckpoint(playerid, buspoint15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint15))
			{
				SetPlayerCheckpoint(playerid, buspoint16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint16))
			{
				SetPlayerCheckpoint(playerid, buspoint17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint17))
			{
				SetPlayerCheckpoint(playerid, buspoint18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint18))
			{
				SetPlayerCheckpoint(playerid, buspoint19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint19))
			{
				SetPlayerCheckpoint(playerid, buspoint20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint20))
			{
				SetPlayerCheckpoint(playerid, buspoint21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint21))
			{
				SetPlayerCheckpoint(playerid, buspoint22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint22))
			{
				SetPlayerCheckpoint(playerid, buspoint23, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint23))
			{
				SetPlayerCheckpoint(playerid, buspoint24, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint24))
			{
				SetPlayerCheckpoint(playerid, buspoint25, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint25))
			{
				SetPlayerCheckpoint(playerid, buspoint26, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint26))
			{
				SetPlayerCheckpoint(playerid, buspoint27, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspoint27))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 360;
				DisablePlayerCheckpoint(playerid);
				ShowItemBox(playerid, "Uang", "Received_200x", 1212, 2);
				GivePlayerMoneyEx(playerid, 200);
				//AddPlayerSalary(playerid, "Sidejob(Bus)", 200);
				InfoMsg(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 3)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 530)
		{
			if (IsPlayerInRangeOfPoint(playerid, 4.0,forpoint1))
			{
				SetPlayerCheckpoint(playerid, 2400.02,-2565.49,13.21, 4.0);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~MEMUAT ~g~BARANG...", 5000, 3);
				SetTimerEx("JobForklift", 3000, false, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0,forpoint2))
			{
				SetPlayerCheckpoint(playerid, 2752.89,-2392.60,13.64, 4.0);
				TogglePlayerControllable(playerid, 0);
				GameTextForPlayer(playerid, "~w~MELETAKKAN ~g~BARANG...", 5000, 3);
				SetTimerEx("JobForklift", 3000, false, "i", playerid);
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 4.0,forpoint3))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 80;
				DisablePlayerCheckpoint(playerid);
				ShowItemBox(playerid, "Uang", "Received_70x", 1212, 2);
				GivePlayerMoneyEx(playerid, 70);
				//AddPlayerSalary(playerid, "Sidejob(Forklift)", 70);
				InfoMsg(playerid, "Sidejob(Forklift) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
		}
	}
	//DisablePlayerCheckpoint(playerid);
	return 1;
}

forward JobForklift(playerid);
public JobForklift(playerid)
{
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~w~SELESAI!", 5000, 3);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, 874.77, -14.01, 63.19))//Olah kanabis
		{
  			callcmd::olahkanabis(playerid, "");
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 2, 1772.586547, -176.416519, 78.483963))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1770.586547, -182.416519, 79.383956))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
       	else if(IsPlayerInRangeOfPoint(playerid, 2, 1767.586547, -173.416519, 78.083953))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1761.586547, -178.416519, 78.683952))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1761.586547, -167.416519, 76.483940))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1770.586547, -164.416519, 76.183959))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
	}
	//JOB SAPI LAGI
	if((newkeys & KEY_WALK))
    {
        if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.5888, 1154.6294, 8.5859))
        {
			if(pData[playerid][pJob] == 15)
        	return callcmd::olahsusu(playerid, "");
        }
    }
	//job sapi
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 300.121429,1141.311645,9.137485))
		{
		    if(pData[playerid][pJob] == 15)
			ShowPlayerDialog(playerid, DIALOG_LOCKERPEMERAH, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {ffffff}- Locker Pemerah Susu Sapi", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}
	//lockertdtest
	if((newkeys & KEY_WALK))
	{
		foreach(new lid : Lockers)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]))
			{
				forex(ix, 22)
				{
					PlayerTextDrawShow(playerid, LockerTD[playerid][ix]);
				}
				SelectTextDraw(playerid, COLOR_LBLUE);	
				//SyntaxMsg(playerid, "Gunakan '/cursor' Jika ada textdraw yang tidak bisa di clik");
			}
		}
	}
	//STATERPACK
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1806.9672,-1876.5265,13.5859))
		{
			if(pData[playerid][pStarterpack] != 0)
				return ErrorMsg(playerid, "Kamu sudah mengambil Sebelumnya!");
			callcmd::claimsp(playerid, "");
		}
	}
	//beli bahan mentah
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 357.1158,-1815.1537,4.3652))
		{
			callcmd::buybahan(playerid, "");
		}
	}
	//menu masak
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 341.6693,-1838.8120,9.7921))
		{
			if(pData[playerid][pFaction] != 5)
        		return Error(playerid, "Anda harus menjadi seorang pedagang");
			if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
			//callcmd::menumasak(playerid, "");
			ShowTDPedagang(playerid);
			SelectTextDraw(playerid, COLOR_LBLUE);	
		}
	}
	//menu minum
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 337.0453,-1836.7041,9.7921))
		{
			if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
			callcmd::menuminum(playerid, "");
		}
	}
	//beli umpan
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 360.5281,-2031.9830,7.8359))
		{
			callcmd::buybait(playerid, "");
		}
	}
	//tempat jual botol
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, 919.4504,-1252.1967,16.2109))//adolbotol
		{
			if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
  			callcmd::adolbotol(playerid, "");
		}
	}
	// JUAL SUSU
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, 919.4351,-1266.0238,15.1719))//JUALSUSU
		{
			if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
  			callcmd::jualsusumamah(playerid, "");
		}
	}
	//disnaker job
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1392.5812,-8.2285,1000.9166))
		{
		    if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ID Card!");
			PlayerPlaySound(playerid, 5202, 0,0,0);
			new string[1000];
		    format(string, sizeof(string), "Pekerjaan\t\tSedang Bekerja\n{ffffff}Tukang Ayam\t\t{FFFF00}%d Orang\n{ffffff}Penebang Kayu\t\t{FFFF00}%d Orang\n{ffffff}Petani\t\t{FFFF00}%d Orang\n{ffffff}Penambang\t\t{FFFF00}%d Orang\n{ffffff}Pemetik Markisa\t\t{FFFF00}%d Orang\n{ffffff}Baggage Airport\t\t{FFFF00}%d Orang\n{ffffff}Trucker\t\t{FFFF00}%d Orang\n{ffffff}Product\t\t{FFFF00}%d Orang\n{ffffff}Merchant Filler (Restock Gudang Pedagang)\t\t{FFFF00}%d Orang\n{ffffff}Penambang Minyak\t\t{FFFF00}%d Orang\n{FFFFFF}Pemerah Susu\t\t{FFFF00}%d Orang\n{ffffff}Mekanik\t\t{FFFF00}%d Orang\n"RED_E"Keluar dari pekerjaan",
			tukangayam,
			tukangtebang,
			petani,
			penambang,
		 	markisaa,
		 	bagage,
		 	Trucker,
			product,
			Merchantfiller,
			penambangminyak,
			pemerah,
			mekanik
		    );
	    	ShowPlayerDialog(playerid, DIALOG_DISNAKER, DIALOG_STYLE_TABLIST_HEADERS, "Dinas Tenaga Kerja Kota {B897FF}Warga Kota", string, "Pilih", "Batal");
		}
	}
	//dokterlokal
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, 1152.7679,-1340.4303,-26.5895))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::dokterlokal(playerid, "");
        }
	}
	//penambang batu
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, -396.575592,1249.352050,6.749223))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
            if(pData[playerid][pTimeTambang1] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang1] = 1;
        	SetTimerEx("TungguNambang1", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.591278,1249.288940,6.789647))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	if(pData[playerid][pTimeTambang2] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang2] = 1;
        	SetTimerEx("TungguNambang2", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.588256,1253.867553,6.928194))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	if(pData[playerid][pTimeTambang3] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang3] = 1;
        	SetTimerEx("TungguNambang3", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -396.943634,1254.083374,6.890728))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	if(pData[playerid][pTimeTambang4] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang4] = 1;
        	SetTimerEx("TungguNambang4", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.617950,1259.353393,7.093970))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	if(pData[playerid][pTimeTambang5] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang5] = 1;
        	SetTimerEx("TungguNambang5", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -396.967498,1260.187988,7.082924))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	if(pData[playerid][pTimeTambang6] > 0) return 1;
        	callcmd::nambanglenz(playerid, "");
        	pData[playerid][pTimeTambang6] = 1;
        	SetTimerEx("TungguNambang6", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -795.673522,-1928.231567,5.612922))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::nyucibatulenz(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 2152.539062,-2263.646972,13.300081))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::peleburanbatulenz(playerid, "");
        }
	}
	//Rob Warung
	if(newkeys & KEY_HANDBRAKE && GetPlayerWeapon(playerid) == 24 && GetNearbyRobbery(playerid) >= 0)
	{
	    for(new i = 0; i < MAX_ROBBERY; i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 2.3, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]))
			{
				if(Warung == true) return 1;
				SetTimerEx("RobWarung", 10000, false, "d", playerid);
				ApplyActorAnimation(RobberyData[i][robberyID], "ROB_BANK","SHP_HandsUp_Scr",4.0,0,0,0,1,0);
				Warung = true;
				new label[100];
				format(label, sizeof label, "Penjaga : Jangan sakiti aku tuan, aku akan memberikanmu uangnya");
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				new lstr[1024];
				format(lstr, sizeof(lstr), "PERAMPOKAN | WARUNG: {ffffff}Telah terjadi perampokan warung di daerah %s", GetLocation(x, y, z));
				SendClientMessageToAll(COLOR_ORANGE2, lstr);
				RobberyData[i][robberyText] = CreateDynamic3DTextLabel(label, COLOR_WHITE, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]+1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 10.0);
			}
		}
	}	
	//LOCKER JOB PENAMBANG BATU
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, -397.3630,1263.2987,7.1776))
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
		    if(pData[playerid][pJob] == 5)
			ShowPlayerDialog(playerid, DIALOG_LOCKERPENAMBANG, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {ffffff}- Locker Penambang batu", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}
	//JOB MINYAK PENAMBANG
	if((newkeys & KEY_WALK))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, 435.119323,1264.405517,9.370626))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::kerjaminyak1(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 490.874359,1294.272338,9.020936))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::kerjaminyak2(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 570.088989,1219.789794,11.711267))
        {
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
        	callcmd::saringminyak(playerid, "");
        }
	}
	//LOCKER nambang minyak
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 576.9179,1223.8799,11.7113))
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
		    if(pData[playerid][pJob] == 14)
			ShowPlayerDialog(playerid, DIALOG_LOCKERMINYAK, DIALOG_STYLE_LIST, "{B897FF}Warga Kota {ffffff}- Locker Penambang Minyak", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}
	//sell hasil tambang & minyak 
	/*if(PRESSED( KEY_WALK ))
    {
    	if(IsPlayerInRangeOfPoint(playerid, 2.0, 846.2555,-1293.4869,13.6528))
		{
		    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			PlayerPlaySound(playerid, 5202, 0,0,0);
			new string[10000];
		    format(string, sizeof(string), "nambang\t\tHarga\nEssence\t\t"LG_E"$3/{ffffff}1 Kotak\nEmas\t\t"LG_E"$6/{ffffff}1 emas\nBesi\t\t"LG_E"$4/{ffffff}1 Besi\nAluminium\t\t"LG_E"$5/{ffffff}1 Tembaga");
	    	ShowPlayerDialog(playerid, DIALOG_TAMBANG, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota Market{ffffff} - Hasil Nambang", string, "Jual", "Batal");
		}
    }*/
	if(PRESSED( KEY_WALK ))
    {
    	if(IsPlayerInRangeOfPoint(playerid, 2.0, 846.2555,-1293.4869,13.6528))
		{
		    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			PlayerPlaySound(playerid, 5202, 0,0,0);
			ShowTDjualtambang(playerid);
			SelectTextDraw(playerid, COLOR_LBLUE);	
		}
    }
	//ambilayam
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 156.6945,-1499.9636,12.3485))
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
			callcmd::ambilayam(playerid, "");
		}
	}
	//potong ayam
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 155.8964,-1512.2314,12.1621))
		{ 
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
			callcmd::potongayam(playerid, "");
		}
	}
	//packing ayam
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 173.7471,-1481.2899,12.6098))
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
			callcmd::packingayam(playerid, "");
		}
	}
	if((newkeys & KEY_CTRL_BACK))
	{
		foreach(new idx : Gates)
		{
			if(gData[idx][gModel] && IsPlayerInRangeOfPoint(playerid, 8.0, gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ]))
			{
				if(gData[idx][gFaction] > 0)
				{
					if(gData[idx][gFaction] != pData[playerid][pFaction])
						return ErrorMsg(playerid, "This gate only for faction.");
				}
				if(gData[idx][gFamily] > -1)
				{
					if(gData[idx][gFamily] != pData[playerid][pFamily])
						return ErrorMsg(playerid, "This gate only for family.");
				}
				
				if(gData[idx][gVip] > pData[playerid][pVip])
					return ErrorMsg(playerid, "Your VIP level not enough to enter this gate.");
				
				if(gData[idx][gAdmin] > pData[playerid][pAdmin])
					return ErrorMsg(playerid, "Your admin level not enough to enter this gate.");
				
				if(strlen(gData[idx][gPass]))
				{
					ErrorMsg(playerid, "Gate ini menggunakan password silahkan /gate [Password]");
					callcmd::gate(playerid, "");
				}
				else
				{
					if(!gData[idx][gStatus])
					{
						gData[idx][gStatus] = 1;
						MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
						SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
					}
					else
					{
						gData[idx][gStatus] = 0;
						MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
						SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
					}
				}
				return 1;
			}
		}
	}
	//trash
	if((newkeys & KEY_YES ))
	{
		if(GetNearbyTrash(playerid) >= 0)
		{
		    for(new i = 0; i < MAX_Trash; i++)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 4.0, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ]))
				{
					if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
					if(pData[playerid][sampahsaya] < 1) return ErrorMsg(playerid, "Anda tidak mempunyai sampah");
					new total = pData[playerid][sampahsaya];
					pData[playerid][sampahsaya] -= total;
					new str[500];
					format(str, sizeof(str), "Removed_%dx", total);
					ShowItemBox(playerid, "Sampah", str, 1265, total);
					Inventory_Update(playerid);
					TrashData[i][Sampah] += total;
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE trash SET sampah='%d' WHERE ID='%d'", TrashData[i][Sampah], i);
					mysql_tquery(g_SQL, query);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "ACTION: %s membuang sampah sisa makanannya kedalam tempat sampah.", ReturnName(playerid));
					ShowProgressbar(playerid, "Membuang sampah..", 1);
					ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.0, 1, 0, 0, 0, 0, 1);
					RemovePlayerAttachedObject(playerid, 3);
					Trash_Save(i);
				}
			}
		}
	}
	//DROP SAMPAH
	if(PRESSED(KEY_WALK))
	{
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
		{
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
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
	}
	if((newkeys & KEY_WALK))
	{
		forex(i, MAX_ATM) if(AtmData[i][atmExists])
		{
			if(IsPlayerInDynamicArea(playerid, AtmData[i][atmArea]))
			{
				if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
				if(pData[playerid][IsLoggedIn] == false) return ErrorMsg(playerid, "Kamu harus login!");
				if(pData[playerid][pInjured] >= 1) return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini!");			
				forex(ix, 44)
				{
					PlayerTextDrawShow(playerid, AERPATM[playerid][ix]);
				}
				UpdateATM(playerid);
				PlayerTextDrawSetString(playerid, AERPATM[playerid][31], sprintf("%d", pData[playerid][pBankRek]));
				PlayerTextDrawSetString(playerid, AERPATM[playerid][7], pData[playerid][pName]);
				PlayerTextDrawSetString(playerid, AERPATM[playerid][30], sprintf("%s", FormatMoney(pData[playerid][pBankMoney])));
				SelectTextDraw(playerid, COLOR_LIGHTGREEN);	
				InfoMsg(playerid, "Gunakan '/cursor' Jika ada textdraw yang tidak bisa di clik");															
			}
		}
	}
	if((newkeys & KEY_NO))
	{
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	    if(pData[playerid][pProgress] == 1) return WarningMsg(playerid, "Anda sedang melakukan sesuatu, tunggu sampai progress selesai!!");
		InfoMsg(playerid, "Gunakan '/cursor' Jika ada textdraw yang tidak bisa di clik");
		forex(i, 52)
		{
			PlayerTextDrawShow(playerid, AERPRADIAL[playerid][i]);
		}	
		SelectTextDraw(playerid, COLOR_LBLUE);
	}
    if((newkeys & KEY_JUMP) && !IsPlayerInAnyVehicle(playerid))
    {
        AntiBHOP[playerid] ++;
        if(pData[playerid][pRFoot] <= 70 || pData[playerid][pLFoot] <= 70)
        {
        	SetTimerEx("AppuiePasJump", 1700, false, "i", playerid);
        	if(AntiBHOP[playerid] == 2)
        	{
        	//	ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1); //saat player loncat 2x dengan cepat dia bakal otomatis
        		new jpName[MAX_PLAYER_NAME];
        		GetPlayerName(playerid,jpName,MAX_PLAYER_NAME);
        		SetTimerEx("AppuieJump", 3000, false, "i", playerid);
        	}
        	return 1;
        }
        if(pData[playerid][pRFoot] <= 90 || pData[playerid][pLFoot] <= 90)
        {
        	SetTimerEx("AppuiePasJump", 700, false, "i", playerid);
        	if(AntiBHOP[playerid] == 2)
        	{
        		ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
        		new jpName[MAX_PLAYER_NAME];
        		GetPlayerName(playerid,jpName,MAX_PLAYER_NAME);
        		SetTimerEx("AppuieJump", 3000, false, "i", playerid);
        	}
        	return 1;
        }
        if(pData[playerid][pRFoot] <= 40 || pData[playerid][pLFoot] <= 40)
        {
        	SetTimerEx("AppuiePasJump", 3200, false, "i", playerid);
        	if(AntiBHOP[playerid] == 2)
        	{
        		ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
        		new jpName[MAX_PLAYER_NAME];
        		GetPlayerName(playerid,jpName,MAX_PLAYER_NAME);
        		SetTimerEx("AppuieJump", 3000, false, "i", playerid);
        	}
        	return 1;
        }
    }
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
		else if(pData[playerid][CarryingBox])
		{
			Player_DropBox(playerid);
		}
	}
	/*if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
		else if(pData[playerid][CarryingLog] == 0)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			SuccesMsg(playerid, "You dropping metal ore.");
			DisablePlayerCheckpoint(playerid);
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			SuccesMsg(playerid, "You dropping coal ore.");
			DisablePlayerCheckpoint(playerid);
		}
	}*/
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return Error(playerid, "This entrance is locked at the moment.");
					
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return Error(playerid, "This door only for family.");
				}
				
				if(dData[did][dVip] > pData[playerid][pVip])
					return Error(playerid, "Your VIP level not enough to enter this door.");
				
				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return Error(playerid, "Your admin level not enough to enter this door.");
					
				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
					
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				
				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return GameTextForPlayer(playerid, "~w~Biz ~r~Terkunci!", 1000, 5);
				//if(bData[bid][bSegel] == 1) return GameTextForPlayer(playerid, "~w~Biz ini ~r~Disegel", 1000, 5);
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
				PlayStream(playerid, bData[bid][bStream], bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], 30.0, 1);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			pData[playerid][pInBiz] = -1;
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			SetPlayerInterior(playerid, bData[inbisnisid][bExtInt]);
			SetPlayerVirtualWorld(playerid, bData[inbisnisid][bExtVw]);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
			StopStream(playerid);
			pData[playerid][pInt] = 0;
			pData[playerid][pWorld] = 0;
		}
		//vending
		foreach(new vid : Vendings)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]))
			//if(IsPlayerInRangeOfPoint(playerid, 2.8, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]));
			{
				SetPlayerFacingAngle(playerid, VendingData[vid][vendingA]);
				ApplyAnimation(playerid, "VENDING", "VEND_USE", 10.0, 0, 0, 0, 0, 0, 1);
				SetTimerEx("VendingNgentot", 3000, false, "i", playerid);
			}
		}
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Recharge...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "You got tased for %d secounds!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	//Vehicle
	if((newkeys & KEY_ACTION))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::engine(playerid, "");
		}
	}
	//gate
	if((newkeys & KEY_CROUCH))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			foreach(new idx : Gates)
			{
				if(gData[idx][gModel] && IsPlayerInRangeOfPoint(playerid, 20.0, gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ]))
				{
					if(gData[idx][gFaction] > 0)
					{
						if(gData[idx][gFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "This gate only for faction.");
					}
					if(gData[idx][gFamily] > -1)
					{
						if(gData[idx][gFamily] != pData[playerid][pFamily])
							return ErrorMsg(playerid, "This gate only for family.");
					}
					
					if(gData[idx][gVip] > pData[playerid][pVip])
						return ErrorMsg(playerid, "Your VIP level not enough to enter this gate.");
					
					if(gData[idx][gAdmin] > pData[playerid][pAdmin])
						return ErrorMsg(playerid, "Your admin level not enough to enter this gate.");
					
					if(strlen(gData[idx][gPass]))
					{
						ErrorMsg(playerid, "Gate ini menggunakan password silahkan /gate [Password]");
						callcmd::gate(playerid, "");
					}
					else
					{
						if(!gData[idx][gStatus])
						{
							gData[idx][gStatus] = 1;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
						}
						else
						{
							gData[idx][gStatus] = 0;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
						}
					}
					return 1;
				}
			}
		}
	}
	if((newkeys & KEY_FIRE))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::light(playerid, "");
		}
	}
	if((newkeys & KEY_SUBMISSION))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::lock(playerid, "");
		}
	}
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			InfoMsg(playerid, " Kamu terlalu banyak minum.");
	   	}
	   	else
	   	{
	   		pData[playerid][pBladder] -= 1;
		    pData[playerid][pEnergy] += 5;
		}
	}
	//anticbug
	if((newkeys & (KEY_FIRE | KEY_CROUCH)) == (KEY_FIRE | KEY_CROUCH) && (oldkeys & (KEY_FIRE | KEY_CROUCH)) != (KEY_FIRE | KEY_CROUCH))
	{
		new gun = GetPlayerWeapon(playerid);
		if(gun == 24)
		{
			cbugwarn[playerid]++;
			if(cbugwarn[playerid] == 5) return Kick(playerid);
			InfoMsg(playerid, "Kamu telah menggunakan cbug, peringatan ke 5 akan ditendang!");
			//cheatlogs
			new DCC_Embed:logss;
			new yy, m, d, timestamp[200];

			getdate(yy, m , d);

			format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
			logss = DCC_CreateEmbed("");
			DCC_SetEmbedTitle(logss, "LOGS ANTICHEAT");
			DCC_SetEmbedTimestamp(logss, timestamp);
			DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
			DCC_SetEmbedUrl(logss, "");
			DCC_SetEmbedThumbnail(logss, "");
			DCC_SetEmbedFooter(logss, "", "");
			new stroi[5000];
			format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] has been auto kicked for **menggunakan CBUG**!", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID]);
			DCC_AddEmbedField(logss, "", stroi, true);
			DCC_SendChannelEmbedMessage(cheatlogs, logss);
			return 1;
		}
	}
	// STREAMER MASK SYSTEM
	if(PRESSED( KEY_WALK ))
	{
		if(pData[playerid][pMaskOn] == 1)
		{
			for(new i; i<MAX_PLAYERS; i++)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
		}
		else if(pData[playerid][pMaskOn] == 0)
		{
			for(new i; i<MAX_PLAYERS; i++)
			{
			ShowPlayerNameTagForPlayer(i, playerid, 1); 
			}
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetEngineStatus(vehicleid))
			{
				if(GetVehicleSpeed(vehicleid) <= 40)
				{
					new playerState = GetPlayerState(playerid);
					if(playerState == PLAYER_STATE_DRIVER)
					{
						SendClientMessageToAllEx(COLOR_RED, "Anti-Bug User: "GREY2_E"%s have been auto kicked for vehicle engine hack!", pData[playerid][pName]);
						//cheatlogs
						new DCC_Embed:logss;
						new yy, m, d, timestamp[200];

						getdate(yy, m , d);

						format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
						logss = DCC_CreateEmbed("");
						DCC_SetEmbedTitle(logss, "LOGS ANTICHEAT");
						DCC_SetEmbedTimestamp(logss, timestamp);
						DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
						DCC_SetEmbedUrl(logss, "");
						DCC_SetEmbedThumbnail(logss, "");
						DCC_SetEmbedFooter(logss, "", "");
						new stroi[5000];
						format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] has been auto kicked for **vehicle engine hack**!", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID]);
						DCC_AddEmbedField(logss, "", stroi, true);
						DCC_SendChannelEmbedMessage(cheatlogs, logss);
						KickEx(playerid);
					}
				}
			}
		}
	}
	if(PRESSED( KEY_FIRE ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			foreach(new did : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
							return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

						if(dData[did][dLocked])
							return Error(playerid, "This entrance is locked at the moment.");
							
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
						if(dData[did][dFamily] > 0)
						{
							if(dData[did][dFamily] != pData[playerid][pFamily])
								return Error(playerid, "This door only for family.");
						}
						
						if(dData[did][dVip] > pData[playerid][pVip])
							return Error(playerid, "Your VIP level not enough to enter this door.");
						
						if(dData[did][dAdmin] > pData[playerid][pAdmin])
							return Error(playerid, "Your admin level not enough to enter this door.");
							
						if(strlen(dData[did][dPass]))
						{
							new params[256];
							if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
							if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
							
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
						else
						{
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
					}
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
					
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						pData[playerid][pInDoor] = -1;
						SetPlayerInterior(playerid, dData[did][dExtint]);
						SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, WorldWeather);
					}
				}
			}
		}
	}
	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
	}
	//if(IsKeyJustDown(KEY_CTRL_BACK,newkeys,oldkeys))
	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(PlayerInfo[playerid][pProgress] == 1) return Error(playerid, "Tunggu Sebentar");
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0)
		{
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
    }
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	/*//JOB KURIR
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		if(IsAKurirVeh(GetPlayerVehicleID(playerid)))
		{
			GameTextForPlayer(playerid, "~w~PENGANTARAN BARANG TERSEDIA /STARTKURIR", 5000, 3);
			SendClientMessage(playerid, 0x76EEC6FF, "* Tampaknya ada paket yang tidak terkirim di Burrito Anda.");
		}
	}*/
	//JOB BAGGAGE
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		if(IsABaggageVeh(GetPlayerVehicleID(playerid)))
		{
			Info(playerid, "Gunakan {B897FF}/startbg{FFFFFF} Untuk memulai Job!.");
			InfoTD_MSG(playerid, 8000, "/startbg");
		}
	}
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {	
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 99999);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
			pData[playerid][pSpaTime] = gettime() + 18000;
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
		if(pData[playerid][pInjured] == 1)
        {
			pData[playerid][pSpaTime] = gettime() + 18000;
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid) 
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
	}
	if(oldstate == PLAYER_STATE_PASSENGER)
	{
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {	
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/
			
		PlayerTextDrawHide(playerid, DPvehname[playerid]);
        PlayerTextDrawHide(playerid, DPvehengine[playerid]);
        PlayerTextDrawHide(playerid, DPvehspeed[playerid]);
		
        TextDrawHideForPlayer(playerid, TDEditor_TD[5]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[6]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[7]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[8]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[9]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[10]);
		
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
		
		//HBE textdraw Simple
		PlayerTextDrawHide(playerid, SPvehname[playerid]);
        PlayerTextDrawHide(playerid, SPvehengine[playerid]);
        PlayerTextDrawHide(playerid, SPvehspeed[playerid]);
		
		TextDrawHideForPlayer(playerid, TDEditor_TD[16]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[17]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[18]);
		
		if(pData[playerid][pTaxiDuty] == 1)
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "You are no longer on taxi duty!");
		}
		if(pData[playerid][pFare] == 1)
		{
			KillTimer(pData[playerid][pFareTimer]);
			Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
			pData[playerid][pFare] = 0;
			pData[playerid][pTotalFare] = 0;
		}
        
		HidePlayerProgressBar(playerid, pData[playerid][spfuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][spdamagebar]);
		
        HidePlayerProgressBar(playerid, pData[playerid][fuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][damagebar]);


		//speedo modern bar
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][0]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][1]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][2]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][3]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][4]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][5]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][6]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][7]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][8]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][9]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][10]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][11]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][12]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][13]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][14]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][15]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][16]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][17]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][18]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][19]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][20]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][21]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][22]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][23]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][24]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][25]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][26]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][27]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][28]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][29]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][30]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][31]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][32]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][33]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][34]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][35]);
		PlayerTextDrawHide(playerid, L3nzHUDVM[playerid][36]);
		PlayerTextDrawHide(playerid, bensinhudava[playerid]);
		PlayerTextDrawHide(playerid, bar1[playerid]);
		PlayerTextDrawHide(playerid, bar2[playerid]);
		PlayerTextDrawHide(playerid, bar3[playerid]);
		PlayerTextDrawHide(playerid, bar4[playerid]);
		PlayerTextDrawHide(playerid, bar5[playerid]);
		PlayerTextDrawHide(playerid, bar6[playerid]);
		PlayerTextDrawHide(playerid, bar7[playerid]);
		PlayerTextDrawHide(playerid, bar8[playerid]);
		PlayerTextDrawHide(playerid, bar9[playerid]);
		PlayerTextDrawHide(playerid, bar10[playerid]);
		PlayerTextDrawHide(playerid, bar11[playerid]);
		PlayerTextDrawHide(playerid, bar12[playerid]);
		PlayerTextDrawHide(playerid, bar13[playerid]);
		PlayerTextDrawHide(playerid, bar14[playerid]);
		PlayerTextDrawHide(playerid, bar15[playerid]);
		PlayerTextDrawHide(playerid, bar16[playerid]);
		PlayerTextDrawHide(playerid, bar17[playerid]);
		PlayerTextDrawHide(playerid, bar18[playerid]);
		PlayerTextDrawHide(playerid, bar19[playerid]);
		PlayerTextDrawHide(playerid, bar20[playerid]);
		PlayerTextDrawHide(playerid, bar21[playerid]);
		PlayerTextDrawHide(playerid, bar22[playerid]);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
		/*if(IsSRV(vehicleid))
		{
			new tstr[128], price = GetVehicleCost(GetVehicleModel(vehicleid));
			format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleName(vehicleid), FormatMoney(price));
			ShowPlayerDialog(playerid, DIALOG_BUYPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
		}
		else if(IsVSRV(vehicleid))
		{
			new tstr[128], price = GetVipVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pVip] == 0)
			{
				Error(playerid, "Kendaraan Khusus VIP Player.");
				RemovePlayerFromVehicle(playerid);
				//SetVehicleToRespawn(GetPlayerVehicleID(playerid));
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
			else
			{
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d Coin", GetVehicleName(vehicleid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYVIPPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
		}*/
		
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						Error(playerid, "This bike is locked by owner.");
						return 1;
					}
				}
			}
		}
		if(IsABaggageVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 10 && pData[playerid][pJob2] != 10)
			{
				RemovePlayerFromVehicle(playerid);
                ErrorMsg(playerid, "Kamu tidak bekerja sebagai Baggage Airport");
			}
		}
		if(IsASweeperVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_SWEEPER, DIALOG_STYLE_MSGBOX, "Side Job - Sweeper", "Anda akan bekerja sebagai pembersih jalan?", "Start Job", "Close");
		}
		if(IsABusVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_BUS, DIALOG_STYLE_MSGBOX, "Side Job - Bus", "Anda akan bekerja sebagai pengangkut penumpang bus?", "Start Job", "Close");
		}
		if(IsAForVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_FORKLIFT, DIALOG_STYLE_MSGBOX, "Side Job - Forklift", "Anda akan bekerja sebagai pemuat barang dengan Forklift?", "Start Job", "Close");
		}
		
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
		if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
			Info(playerid, "WARNING: "YELLOW_E"You do have a Driver License or your Driver License is expired.");
            InfoMsg(playerid, "Anda tidak memiliki surat izin mengemudi, berhati-hatilah.");
        }
		if(IsADmvVeh(vehicleid))
        {
            if(!pData[playerid][pDriveLicApp])
            {
                RemovePlayerFromVehicle(playerid);
                ErrorMsg(playerid, "Kamu tidak sedang mengikuti Tes Mengemudi");
			}
			else 
			{
				InfoMsg(playerid, "Silahkan ikuti Checkpoint yang ada di GPS mobil ini.");
				SetPlayerRaceCheckpoint(playerid, 1, dmvpoint1, dmvpoint1, 5.0);
			}
		}
		if(pData[playerid][pHBEMode] == 1)
		{
			ShowHbeaufaDua(playerid);
			UpdateHBEDua(playerid);

			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][0]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][1]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][2]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][3]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][4]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][5]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][6]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][7]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][8]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][9]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][10]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][11]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][12]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][13]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][14]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][15]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][16]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][17]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][18]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][19]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][20]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][21]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][22]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][25]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][26]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][27]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][28]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][29]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][30]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][31]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][32]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][33]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][34]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][35]);
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			new Float:fFuel; 
			//new Float:bensinbar;
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			fFuel = GetVehicleFuel(vehicleid);
			if(fFuel < 0) fFuel = 0;
			else if(fFuel > 100) fFuel = 100;
			new str[400];
			//gpslokasi
			format(str, sizeof(str), "%s", GetLocation(x, y, z));
			PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][36], str);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][36]);
			//speedangka
			format(str, sizeof(str), "%.0f", GetVehicleSpeed(vehicleid));
			PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][24], str);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][24]);
			//barbensin
			/*bensinbar = fFuel * -30.5/100;
			PlayerTextDrawTextSize(playerid, bensinhudava[playerid], 5.5, bensinbar);
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);*/
			//format(str, sizeof(str), "%d", GetVehicleFuel(vehicleid));
			//PlayerTextDrawSetString(playerid, bensinhudava[playerid], str);
			PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			//barspeed
			static Float:kecepatan;
			kecepatan = GetVehicleSpeed(vehicleid);
			if(kecepatan > 1.0)
			{
				PlayerTextDrawShow(playerid, bar1[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar1[playerid]);
			}
			if(kecepatan > 10.0)
			{
				PlayerTextDrawShow(playerid, bar2[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar2[playerid]);
			}
			if(kecepatan > 20.0)
			{
				PlayerTextDrawShow(playerid, bar3[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar3[playerid]);
			}
			if(kecepatan > 30.0)
			{
				PlayerTextDrawShow(playerid, bar4[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar4[playerid]);
			}
			if(kecepatan > 40.0)
			{
				PlayerTextDrawShow(playerid, bar5[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar5[playerid]);
			}
			if(kecepatan > 50.0)
			{
				PlayerTextDrawShow(playerid, bar6[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar6[playerid]);
			}
			if(kecepatan > 60.0)
			{
				PlayerTextDrawShow(playerid, bar7[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar7[playerid]);
			}
			if(kecepatan > 70.0)
			{
				PlayerTextDrawShow(playerid, bar8[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar8[playerid]);
			}
			if(kecepatan > 80.0)
			{
				PlayerTextDrawShow(playerid, bar9[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar9[playerid]);
			}
			if(kecepatan > 90.0)
			{
				PlayerTextDrawShow(playerid, bar10[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar10[playerid]);
			}
			if(kecepatan > 100.0)
			{
				PlayerTextDrawShow(playerid, bar11[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar11[playerid]);
			}
			if(kecepatan > 110.0)
			{
				PlayerTextDrawShow(playerid, bar12[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar12[playerid]);
			}
			if(kecepatan > 120.0)
			{
				PlayerTextDrawShow(playerid, bar13[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar13[playerid]);
			}
			if(kecepatan > 130.0)
			{
				PlayerTextDrawShow(playerid, bar14[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar14[playerid]);
			}
			if(kecepatan > 140.0)
			{
				PlayerTextDrawShow(playerid, bar15[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar15[playerid]);
			}
			if(kecepatan > 145.0)
			{
				PlayerTextDrawShow(playerid, bar16[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar16[playerid]);
			}
			if(kecepatan > 150.0)
			{
				PlayerTextDrawShow(playerid, bar17[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar17[playerid]);
			}
			if(kecepatan > 155.0)
			{
				PlayerTextDrawShow(playerid, bar18[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar18[playerid]);
			}
			if(kecepatan > 160.0)
			{
				PlayerTextDrawShow(playerid, bar19[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar19[playerid]);
			}
			if(kecepatan > 165.0)
			{
				PlayerTextDrawShow(playerid, bar20[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar20[playerid]);
			}
			if(kecepatan > 175.0)
			{
				PlayerTextDrawShow(playerid, bar21[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar21[playerid]);
			}
			if(kecepatan > 185.0)
			{
				PlayerTextDrawShow(playerid, bar22[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar22[playerid]);
			}

			new Float:rz;
			if(IsPlayerInAnyVehicle(playerid))
			{
				GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
			}
			else
			{
				GetPlayerFacingAngle(playerid, rz);
			}

			if(rz >= 348.75 || rz < 11.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "N");
			else if(rz >= 326.25 && rz < 348.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 303.75 && rz < 326.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 281.25 && rz < 303.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 258.75 && rz < 281.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "E");
			else if(rz >= 236.25 && rz < 258.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 213.75 && rz < 236.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 191.25 && rz < 213.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 168.75 && rz < 191.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "S");
			else if(rz >= 146.25 && rz < 168.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 123.25 && rz < 146.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 101.25 && rz < 123.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 78.75 && rz < 101.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "W");
			else if(rz >= 56.25 && rz < 78.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 33.75 && rz < 56.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 11.5 && rz < 33.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][23]);
			PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			//UpdateBensin(playerid);
		}
		else if(pData[playerid][pHBEMode] == 2)
		{
			UpdateHBE(playerid);
			ShowHbeaufa(playerid);
			
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][0]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][1]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][2]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][3]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][4]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][5]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][6]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][7]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][8]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][9]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][10]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][11]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][12]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][13]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][14]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][15]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][16]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][17]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][18]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][19]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][20]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][21]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][22]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][25]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][26]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][27]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][28]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][29]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][30]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][31]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][32]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][33]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][34]);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][35]);
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			new Float:fFuel; 
			//new Float:bensinbar;
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			fFuel = GetVehicleFuel(vehicleid);
			if(fFuel < 0) fFuel = 0;
			else if(fFuel > 100) fFuel = 100;
			new str[400];
			//gpslokasi
			format(str, sizeof(str), "%s", GetLocation(x, y, z));
			PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][36], str);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][36]);
			//speedangka
			format(str, sizeof(str), "%.0f", GetVehicleSpeed(vehicleid));
			PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][24], str);
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][24]);
			//barbensin
			//format(str, sizeof(str), "%d", GetVehicleFuel(vehicleid));
			//PlayerTextDrawSetString(playerid, bensinhudava[playerid], str);
			//PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			fFuel = GetVehicleFuel(vehicleid);
			if(fFuel < 0) fFuel = 0;
			else if(fFuel > 100) fFuel = 100;
			//barspeed
			static Float:kecepatan;
			kecepatan = GetVehicleSpeed(vehicleid);
			if(kecepatan > 1.0)
			{
				PlayerTextDrawShow(playerid, bar1[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar1[playerid]);
			}
			if(kecepatan > 10.0)
			{
				PlayerTextDrawShow(playerid, bar2[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar2[playerid]);
			}
			if(kecepatan > 20.0)
			{
				PlayerTextDrawShow(playerid, bar3[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar3[playerid]);
			}
			if(kecepatan > 30.0)
			{
				PlayerTextDrawShow(playerid, bar4[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar4[playerid]);
			}
			if(kecepatan > 40.0)
			{
				PlayerTextDrawShow(playerid, bar5[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar5[playerid]);
			}
			if(kecepatan > 50.0)
			{
				PlayerTextDrawShow(playerid, bar6[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar6[playerid]);
			}
			if(kecepatan > 60.0)
			{
				PlayerTextDrawShow(playerid, bar7[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar7[playerid]);
			}
			if(kecepatan > 70.0)
			{
				PlayerTextDrawShow(playerid, bar8[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar8[playerid]);
			}
			if(kecepatan > 80.0)
			{
				PlayerTextDrawShow(playerid, bar9[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar9[playerid]);
			}
			if(kecepatan > 90.0)
			{
				PlayerTextDrawShow(playerid, bar10[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar10[playerid]);
			}
			if(kecepatan > 100.0)
			{
				PlayerTextDrawShow(playerid, bar11[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar11[playerid]);
			}
			if(kecepatan > 110.0)
			{
				PlayerTextDrawShow(playerid, bar12[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar12[playerid]);
			}
			if(kecepatan > 120.0)
			{
				PlayerTextDrawShow(playerid, bar13[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar13[playerid]);
			}
			if(kecepatan > 130.0)
			{
				PlayerTextDrawShow(playerid, bar14[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar14[playerid]);
			}
			if(kecepatan > 140.0)
			{
				PlayerTextDrawShow(playerid, bar15[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar15[playerid]);
			}
			if(kecepatan > 145.0)
			{
				PlayerTextDrawShow(playerid, bar16[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar16[playerid]);
			}
			if(kecepatan > 150.0)
			{
				PlayerTextDrawShow(playerid, bar17[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar17[playerid]);
			}
			if(kecepatan > 155.0)
			{
				PlayerTextDrawShow(playerid, bar18[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar18[playerid]);
			}
			if(kecepatan > 160.0)
			{
				PlayerTextDrawShow(playerid, bar19[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar19[playerid]);
			}
			if(kecepatan > 165.0)
			{
				PlayerTextDrawShow(playerid, bar20[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar20[playerid]);
			}
			if(kecepatan > 175.0)
			{
				PlayerTextDrawShow(playerid, bar21[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar21[playerid]);
			}
			if(kecepatan > 185.0)
			{
				PlayerTextDrawShow(playerid, bar22[playerid]);
			}
			else
			{
				PlayerTextDrawHide(playerid, bar22[playerid]);
			}

			new Float:rz;
			if(IsPlayerInAnyVehicle(playerid))
			{
				GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
			}
			else
			{
				GetPlayerFacingAngle(playerid, rz);
			}

			if(rz >= 348.75 || rz < 11.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "N");
			else if(rz >= 326.25 && rz < 348.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 303.75 && rz < 326.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 281.25 && rz < 303.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 258.75 && rz < 281.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "E");
			else if(rz >= 236.25 && rz < 258.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 213.75 && rz < 236.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 191.25 && rz < 213.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 168.75 && rz < 191.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "S");
			else if(rz >= 146.25 && rz < 168.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 123.25 && rz < 146.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 101.25 && rz < 123.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 78.75 && rz < 101.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "W");
			else if(rz >= 56.25 && rz < 78.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 33.75 && rz < 56.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			else if(rz >= 11.5 && rz < 33.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
			PlayerTextDrawShow(playerid, L3nzHUDVM[playerid][23]);
			PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
			PlayerTextDrawShow(playerid, bensinhudava[playerid]);
		}
		else
		{
		
		}
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;
		
		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}
	return 1;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health+Health);
}

//ROB WARUNG ZIRO
function RobWarung(playerid)
{
	new value = 500 + random(500), str[500];
	for(new i = 0; i < MAX_ROBBERY; i++)
	{
  		if(IsPlayerInRangeOfPoint(playerid, 2.3, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]))
		{
			GivePlayerMoneyEx(playerid, value);
			format(str,sizeof(str),"Anda mendapatkan uang ~g~%s", FormatMoney(value));
			SuccesMsg(playerid, str);
			new duet[500];
			format(duet, sizeof(duet), "Received_%sx", FormatMoney(value));
			ShowItemBox(playerid, "Uang", duet, 1212, 2);
		 	ApplyActorAnimation(RobberyData[i][robberyID], "ped", "cower",4.0,0,0,0,1,0);
		 	DeletePVar(playerid, "RobArea");
		 	PlayerPlaySound(playerid, 3401, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]);
		 	if(IsValidDynamic3DTextLabel(RobberyData[i][robberyText]))
		  	DestroyDynamic3DTextLabel(RobberyData[i][robberyText]);
		}
	}
}
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new
        Float: vehicleHealth,
        playerVehicleId = GetPlayerVehicleID(playerid);

    new Float:health = GetPlayerHealth(playerid, health);
    GetVehicleHealth(playerVehicleId, vehicleHealth);
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    if(pData[playerid][pSeatBelt] == 0 || pData[playerid][pHelmetOn] == 0)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 2);
    		new bsakit = RandomEx(0, 2);
    		new csakit = RandomEx(0, 2);
    		new dsakit = RandomEx(0, 2);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -2);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 3);
    		new bsakit = RandomEx(0, 3);
    		new csakit = RandomEx(0, 3);
    		new dsakit = RandomEx(0, 3);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -5);
    		return 1;
    	}
    	return 1;
    }
    if(pData[playerid][pSeatBelt] == 1 || pData[playerid][pHelmetOn] == 1)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -3);
    		return 1;
    	}
    }
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(IsAtEvent[playerid] == 0)
	{
		new sakit = RandomEx(1, 4);
		new asakit = RandomEx(1, 5);
		new bsakit = RandomEx(1, 7);
		new csakit = RandomEx(1, 4);
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			pData[playerid][pHead] -= 20;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
		{
			pData[playerid][pPerut] -= sakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
		{
			pData[playerid][pRHand] -= bsakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
		{
			pData[playerid][pLHand] -= asakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
		{
			pData[playerid][pRFoot] -= csakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
		{
			pData[playerid][pLFoot] -= bsakit;
		}
	}
	else if(IsAtEvent[playerid] == 1)
	{
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			GivePlayerHealth(playerid, -90);
			SendClientMessage(issuerid, -1,"{7fffd4}[ TDM ]{ffffff} Headshot!");
		}
	}
    return 1;
}

public OnPlayerUpdate(playerid)
{
	
	if(pData[playerid][pSpaTime] > 0)
	{
		pData[playerid][pSpaTime]--;
	}
	//SAPD Tazer/Taser
	UpdateTazer(playerid);
	
	//SAPD Road Spike
	CheckPlayerInSpike(playerid);

	//hp screen 
	new datestring[64];
	new hours,
	minutes,
	seconds,
	days,
	months,
	years;
	new MonthName[12][] =
	{
		"January", "February", "March", "April", "May", "June",
		"July",	"August", "September", "October", "November", "December"
	};
	getdate(years, months, days);
 	gettime(hours, minutes, seconds);
	foreach(new ii : Player)
	{
		format(datestring, sizeof (datestring), "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		PlayerTextDrawSetString(playerid, fingerhp[playerid][22], datestring);
		format(datestring, sizeof (datestring), "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
		PlayerTextDrawSetString(playerid, fingerhp[playerid][23], datestring);
	}
	//hp
	//hapetelponnyarr
	new string[256];
 	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			format(string, sizeof(string), "%02d:%02d:%02d", JamCall[ii], MenitCall[ii], DetikCall[ii]);
			PlayerTextDrawSetString(ii, CallHpLenz[ii][17], string);

			format(string, sizeof(string), "%02d:%02d:%02d", JamCall[playerid], MenitCall[playerid], DetikCall[playerid]);
			PlayerTextDrawSetString(playerid, CallHpLenz[playerid][17], string);
		}
	}
	return 1;
}

task VehicleUpdate[40000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 1);
            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 15)
            {
               Info(GetVehicleDriver(i), "Kendaraan ingin habis bensin, Harap pergi ke SPBU ( Gas Station )");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "NoHave");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[ii][cVeh])) DestroyVehicle(pvData[ii][cVeh]);
				pvData[ii][cVeh] = INVALID_VEHICLE_ID;
				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
	}
}

public OnVehicleDeath(vehicleid, killerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] == vehicleid)
		{
			pvData[i][cDeath] = gettime() + 15;
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh] && pvData[ii][cRent] == 0 && pvData[ii][cDeath] > gettime())
		{
			if(pvData[ii][cInsu] > 0)
    		{
				pvData[ii][cDeath] = 0;
				pvData[ii][cInsu]--;
				pvData[ii][cClaim] = 1;
                pvData[ii][cClaimTime] = gettime() + (1 * 1200);
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
            		Info(pid, "Kendaraan anda hancur dan anda masih memiliki insuransi, silahkan ambil di kantor sags setelah 24 jam.");
				}
				if(IsValidVehicle(pvData[ii][cVeh]))
					DestroyVehicle(pvData[ii][cVeh]);
				
				pvData[ii][cVeh] = INVALID_VEHICLE_ID;
			}
			else
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					if(IsValidVehicle(pvData[ii][cVeh]))
						DestroyVehicle(pvData[ii][cVeh]);

					pvData[ii][cVeh] = INVALID_VEHICLE_ID;
            		Info(pid, "Kendaraan anda hancur dan tidak memiliki insuransi.");
					Iter_SafeRemove(PVehicles, ii, ii);
				}
				pvData[ii][cDeath] = 0;
			}
			return 1;
		}
	}
	return 1;
}

ptask PlayerVehicleUpdate[200](playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{	
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 350.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				GameTextForPlayer(playerid, "~r~Totalled!", 2500, 3);
				RemovePlayerFromVehicle(playerid);
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
				new Float:fFuel; 
				//new Float:bensinbar;
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				fFuel = GetVehicleFuel(vehicleid);
				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 100) fFuel = 100;
				new str[400];
				new datestring[64];
				new hours,
				minutes,
				seconds;
				gettime(hours, minutes, seconds);
				//jamhud
				format(datestring, sizeof datestring, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][35], datestring);
				//gpslokasi
				format(str, sizeof(str), "%s", GetLocation(x, y, z));
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][36], str);
				//speedangka
				format(str, sizeof(str), "%.0f", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][24], str);
				//barbensin
				//format(str, sizeof(str), "%d", GetVehicleFuel(vehicleid));
				//PlayerTextDrawSetString(playerid, bensinhudava[playerid], str);
				PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
				PlayerTextDrawShow(playerid, bensinhudava[playerid]);
				static Float:kecepatan;
				kecepatan = GetVehicleSpeed(vehicleid);
				if(kecepatan > 1.0)
				{
					PlayerTextDrawShow(playerid, bar1[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar1[playerid]);
				}
				if(kecepatan > 10.0)
				{
					PlayerTextDrawShow(playerid, bar2[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar2[playerid]);
				}
				if(kecepatan > 20.0)
				{
					PlayerTextDrawShow(playerid, bar3[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar3[playerid]);
				}
				if(kecepatan > 30.0)
				{
					PlayerTextDrawShow(playerid, bar4[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar4[playerid]);
				}
				if(kecepatan > 40.0)
				{
					PlayerTextDrawShow(playerid, bar5[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar5[playerid]);
				}
				if(kecepatan > 50.0)
				{
					PlayerTextDrawShow(playerid, bar6[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar6[playerid]);
				}
				if(kecepatan > 60.0)
				{
					PlayerTextDrawShow(playerid, bar7[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar7[playerid]);
				}
				if(kecepatan > 70.0)
				{
					PlayerTextDrawShow(playerid, bar8[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar8[playerid]);
				}
				if(kecepatan > 80.0)
				{
					PlayerTextDrawShow(playerid, bar9[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar9[playerid]);
				}
				if(kecepatan > 90.0)
				{
					PlayerTextDrawShow(playerid, bar10[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar10[playerid]);
				}
				if(kecepatan > 100.0)
				{
					PlayerTextDrawShow(playerid, bar11[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar11[playerid]);
				}
				if(kecepatan > 110.0)
				{
					PlayerTextDrawShow(playerid, bar12[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar12[playerid]);
				}
				if(kecepatan > 120.0)
				{
					PlayerTextDrawShow(playerid, bar13[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar13[playerid]);
				}
				if(kecepatan > 130.0)
				{
					PlayerTextDrawShow(playerid, bar14[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar14[playerid]);
				}
				if(kecepatan > 140.0)
				{
					PlayerTextDrawShow(playerid, bar15[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar15[playerid]);
				}
				if(kecepatan > 145.0)
				{
					PlayerTextDrawShow(playerid, bar16[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar16[playerid]);
				}
				if(kecepatan > 150.0)
				{
					PlayerTextDrawShow(playerid, bar17[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar17[playerid]);
				}
				if(kecepatan > 155.0)
				{
					PlayerTextDrawShow(playerid, bar18[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar18[playerid]);
				}
				if(kecepatan > 160.0)
				{
					PlayerTextDrawShow(playerid, bar19[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar19[playerid]);
				}
				if(kecepatan > 165.0)
				{
					PlayerTextDrawShow(playerid, bar20[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar20[playerid]);
				}
				if(kecepatan > 175.0)
				{
					PlayerTextDrawShow(playerid, bar21[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar21[playerid]);
				}
				if(kecepatan > 185.0)
				{
					PlayerTextDrawShow(playerid, bar22[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar22[playerid]);
				}

				new Float:rz;
				if(IsPlayerInAnyVehicle(playerid))
				{
					GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
				}
				else
				{
					GetPlayerFacingAngle(playerid, rz);
				}

				if(rz >= 348.75 || rz < 11.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "N");
				else if(rz >= 326.25 && rz < 348.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 303.75 && rz < 326.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 281.25 && rz < 303.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 258.75 && rz < 281.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "E");
				else if(rz >= 236.25 && rz < 258.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 213.75 && rz < 236.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 191.25 && rz < 213.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 168.75 && rz < 191.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "S");
				else if(rz >= 146.25 && rz < 168.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 123.25 && rz < 146.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 101.25 && rz < 123.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 78.75 && rz < 101.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "W");
				else if(rz >= 56.25 && rz < 78.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 33.75 && rz < 56.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 11.5 && rz < 33.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
				PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			}
			else if(pData[playerid][pHBEMode] == 2)
			{
				new Float:fFuel; 
				//new Float:bensinbar;
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				fFuel = GetVehicleFuel(vehicleid);
				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 100) fFuel = 100;
				new str[400];
				new datestring[64];
				new hours,
				minutes,
				seconds;
				gettime(hours, minutes, seconds);
				//jamhud
				format(datestring, sizeof datestring, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][35], datestring);
				//gpslokasi
				format(str, sizeof(str), "%s", GetLocation(x, y, z));
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][36], str);
				//speedangka
				format(str, sizeof(str), "%.0f", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][24], str);
				//barbensin
				//format(str, sizeof(str), "%d", GetVehicleFuel(vehicleid));
				//PlayerTextDrawSetString(playerid, bensinhudava[playerid], str);
				PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
				PlayerTextDrawShow(playerid, bensinhudava[playerid]);
				//barspeed
				static Float:kecepatan;
				kecepatan = GetVehicleSpeed(vehicleid);
				if(kecepatan > 1.0)
				{
					PlayerTextDrawShow(playerid, bar1[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar1[playerid]);
				}
				if(kecepatan > 10.0)
				{
					PlayerTextDrawShow(playerid, bar2[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar2[playerid]);
				}
				if(kecepatan > 20.0)
				{
					PlayerTextDrawShow(playerid, bar3[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar3[playerid]);
				}
				if(kecepatan > 30.0)
				{
					PlayerTextDrawShow(playerid, bar4[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar4[playerid]);
				}
				if(kecepatan > 40.0)
				{
					PlayerTextDrawShow(playerid, bar5[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar5[playerid]);
				}
				if(kecepatan > 50.0)
				{
					PlayerTextDrawShow(playerid, bar6[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar6[playerid]);
				}
				if(kecepatan > 60.0)
				{
					PlayerTextDrawShow(playerid, bar7[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar7[playerid]);
				}
				if(kecepatan > 70.0)
				{
					PlayerTextDrawShow(playerid, bar8[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar8[playerid]);
				}
				if(kecepatan > 80.0)
				{
					PlayerTextDrawShow(playerid, bar9[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar9[playerid]);
				}
				if(kecepatan > 90.0)
				{
					PlayerTextDrawShow(playerid, bar10[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar10[playerid]);
				}
				if(kecepatan > 100.0)
				{
					PlayerTextDrawShow(playerid, bar11[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar11[playerid]);
				}
				if(kecepatan > 110.0)
				{
					PlayerTextDrawShow(playerid, bar12[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar12[playerid]);
				}
				if(kecepatan > 120.0)
				{
					PlayerTextDrawShow(playerid, bar13[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar13[playerid]);
				}
				if(kecepatan > 130.0)
				{
					PlayerTextDrawShow(playerid, bar14[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar14[playerid]);
				}
				if(kecepatan > 140.0)
				{
					PlayerTextDrawShow(playerid, bar15[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar15[playerid]);
				}
				if(kecepatan > 145.0)
				{
					PlayerTextDrawShow(playerid, bar16[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar16[playerid]);
				}
				if(kecepatan > 150.0)
				{
					PlayerTextDrawShow(playerid, bar17[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar17[playerid]);
				}
				if(kecepatan > 155.0)
				{
					PlayerTextDrawShow(playerid, bar18[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar18[playerid]);
				}
				if(kecepatan > 160.0)
				{
					PlayerTextDrawShow(playerid, bar19[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar19[playerid]);
				}
				if(kecepatan > 165.0)
				{
					PlayerTextDrawShow(playerid, bar20[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar20[playerid]);
				}
				if(kecepatan > 175.0)
				{
					PlayerTextDrawShow(playerid, bar21[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar21[playerid]);
				}
				if(kecepatan > 185.0)
				{
					PlayerTextDrawShow(playerid, bar22[playerid]);
				}
				else
				{
					PlayerTextDrawHide(playerid, bar22[playerid]);
				}

				new Float:rz;
				if(IsPlayerInAnyVehicle(playerid))
				{
					GetVehicleZAngle(GetPlayerVehicleID(playerid), rz);
				}
				else
				{
					GetPlayerFacingAngle(playerid, rz);
				}

				if(rz >= 348.75 || rz < 11.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "N");
				else if(rz >= 326.25 && rz < 348.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 303.75 && rz < 326.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 281.25 && rz < 303.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 258.75 && rz < 281.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "E");
				else if(rz >= 236.25 && rz < 258.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 213.75 && rz < 236.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 191.25 && rz < 213.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 168.75 && rz < 191.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "S");
				else if(rz >= 146.25 && rz < 168.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 123.25 && rz < 146.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 101.25 && rz < 123.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 78.75 && rz < 101.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "W");
				else if(rz >= 56.25 && rz < 78.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 33.75 && rz < 56.25) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				else if(rz >= 11.5 && rz < 33.75) PlayerTextDrawSetString(playerid, L3nzHUDVM[playerid][23], "!");
				PlayerTextDrawSetString(playerid, bensinhudava[playerid], sprintf("%d", GetVehicleFuel(vehicleid)));
				PlayerTextDrawShow(playerid, bensinhudava[playerid]);
			}
			else
			{
			
			}
		}
	}
}

//jual hasil tambang
stock HideTDjualtambang(playerid) 
{
	for(new i = 0; i < 12; i++)
	{
		PlayerTextDrawHide(playerid, TDjualtambang[playerid][i]);
	}
}

stock ShowTDjualtambang(playerid) 
{
	for(new i = 0; i < 12; i++)
	{
		PlayerTextDrawShow(playerid, TDjualtambang[playerid][i]);
	}
}

//pedagang
stock HideTDPedagang(playerid) 
{
	for(new i = 0; i < 12; i++)
	{
		PlayerTextDrawHide(playerid, TDPedagang[playerid][i]);
	}
}

stock ShowTDPedagang(playerid) 
{
	for(new i = 0; i < 12; i++)
	{
		PlayerTextDrawShow(playerid, TDPedagang[playerid][i]);
	}
}

//td ktp
stock HideTDKTPBaru(playerid) 
{
	for(new i = 0; i < 23; i++)
	{
		PlayerTextDrawHide(playerid, TDKTPNew[playerid][i]);
	}
}

stock ShowTDKTPBaru(playerid) 
{
	for(new i = 0; i < 23; i++)
	{
		PlayerTextDrawShow(playerid, TDKTPNew[playerid][i]);
	}
}

//hbe
stock HideHbeaufa(playerid) 
{
	for(new i = 0; i < 44; i++)
	{
		PlayerTextDrawHide(playerid, AufaCreateScrip[playerid][i]);
	}
}

stock ShowHbeaufa(playerid) 
{
	for(new i = 0; i < 44; i++)
	{
		PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][i]);
	}
}

stock UpdateHBE(playerid) 
{
	new Float:health, Float:armour, Float:aufalapar, Float:aufahaus, Float:stress;
	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
	GetPlayerArmour(playerid, PlayerData[playerid][pArmour]);

	health = PlayerData[playerid][pHealth] * 24.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][0], health, 15.0);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][0]);

	armour = PlayerData[playerid][pArmour] * 24.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][1], armour, 15.0);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][1]);

	aufalapar = PlayerData[playerid][pHunger] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][2], 17.0, aufalapar);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][2]);

	aufahaus = PlayerData[playerid][pEnergy] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][3], 17.0, aufahaus);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][3]);

	stress = PlayerData[playerid][pBladder] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][4], 17.0, stress);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][4]);
    return 1;
}

//hbemode 1
stock HideHbeaufaDua(playerid) 
{
	for(new i = 0; i < 44; i++)
	{
		PlayerTextDrawHide(playerid, AufaCreateScrip[playerid][i]);
	}
}

stock ShowHbeaufaDua(playerid) 
{
	for(new i = 0; i < 44; i++)
	{
		PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][i]);
	}
}

stock UpdateHBEDua(playerid) 
{
	new Float:health, Float:armour, Float:aufalapar, Float:aufahaus, Float:stress;
	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
	GetPlayerArmour(playerid, PlayerData[playerid][pArmour]);

	health = PlayerData[playerid][pHealth] * 24.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][0], health, 15.0);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][0]);

	armour = PlayerData[playerid][pArmour] * 24.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][1], armour, 15.0);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][1]);

	aufalapar = PlayerData[playerid][pHunger] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][2], 17.0, aufalapar);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][2]);

	aufahaus = PlayerData[playerid][pEnergy] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][3], 17.0, aufahaus);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][3]);

	stress = PlayerData[playerid][pBladder] * -15.0/100;
	PlayerTextDrawTextSize(playerid, AufaCreateScrip[playerid][4], 17.0, stress);
	PlayerTextDrawShow(playerid, AufaCreateScrip[playerid][4]);
    return 1;
}
//custom hbesat phemode 1
/*stock HideHbeaufaDua(playerid) 
{
	for(new i = 0; i < 22; i++)
	{
		PlayerTextDrawHide(playerid, HBESat[playerid][i]);
	}
}

stock ShowHbeaufaDua(playerid) 
{
	for(new i = 0; i < 22; i++)
	{
		PlayerTextDrawShow(playerid, HBESat[playerid][i]);
	}
}

stock UpdateHBEDua(playerid) 
{
	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
	GetPlayerArmour(playerid, PlayerData[playerid][pArmour]);
	new str[300];
	//getplayerid
	format(str, sizeof(str), "ID: %d", playerid);
	PlayerTextDrawSetString(playerid, HBESat[playerid][21], str);
	PlayerTextDrawShow(playerid, HBESat[playerid][21]);

	new AufaSampCode[1000]; 
	format(AufaSampCode, 250, "%.0f", PlayerData[playerid][pHealth]);
	PlayerTextDrawSetString(playerid, HBESat[playerid][2], AufaSampCode);
	PlayerTextDrawShow(playerid, HBESat[playerid][2]);

	format(AufaSampCode, 250, "%.0f", PlayerData[playerid][pArmour]);
	PlayerTextDrawSetString(playerid, HBESat[playerid][6], AufaSampCode);
	PlayerTextDrawShow(playerid, HBESat[playerid][6]);

	format(AufaSampCode, 250, "%d", PlayerData[playerid][pHunger]);
	PlayerTextDrawSetString(playerid, HBESat[playerid][10], AufaSampCode);
	PlayerTextDrawShow(playerid, HBESat[playerid][10]);

	format(AufaSampCode, 250, "%d", PlayerData[playerid][pEnergy]);
	PlayerTextDrawSetString(playerid, HBESat[playerid][14], AufaSampCode);
	PlayerTextDrawShow(playerid, HBESat[playerid][14]);

	format(AufaSampCode, 250, "%d", PlayerData[playerid][pBladder]);
	PlayerTextDrawSetString(playerid, HBESat[playerid][18], AufaSampCode);
	PlayerTextDrawShow(playerid, HBESat[playerid][18]);
    return 1;
}*/
//

/*stock ShowHbeaufaDua(playerid) {
    for(new i = 0; i < 18; i++)
    {
        PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][i]);
    }
}

stock HideHbeaufaDua(playerid) 
{
	 for(new i = 0; i < 18; i++)
    {
        PlayerTextDrawHide(playerid, MaafLagiYaBangAnggaByAufa[playerid][i]);
    }
}

stock UpdateHBEDua(playerid) 
{
	new Float:health, Float:aufalapar, Float:aufahaus, Float:stress;
	new str[300];
	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);

	//getplayerid
	format(str, sizeof(str), "%d", playerid);
	PlayerTextDrawSetString(playerid, MaafLagiYaBangAnggaByAufa[playerid][3], str);
	PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][3]);

	health = PlayerData[playerid][pHealth] * 37.0/100;
	PlayerTextDrawTextSize(playerid, MaafLagiYaBangAnggaByAufa[playerid][10], health, 11.0);
	PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][10]);

	aufalapar = PlayerData[playerid][pHunger] * -11.0/100;
	PlayerTextDrawTextSize(playerid, MaafLagiYaBangAnggaByAufa[playerid][12], 10.0, aufalapar);
	PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][12]);

	aufahaus = PlayerData[playerid][pEnergy] * -11.0/100;
	PlayerTextDrawTextSize(playerid, MaafLagiYaBangAnggaByAufa[playerid][13], 10.0, aufahaus);
	PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][12]);

	stress = PlayerData[playerid][pBladder] * -11.0/100;
	PlayerTextDrawTextSize(playerid, MaafLagiYaBangAnggaByAufa[playerid][14], 12.0, stress);
	PlayerTextDrawShow(playerid, MaafLagiYaBangAnggaByAufa[playerid][14]);
    return 1;
}*/



public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    // Set waypoint untuk semua pemain (jika perlu)
    Waypoint_Set(playerid, GetLocation(fX, fY, fZ), fX, fY, fZ);

    // Bagian admin: Simpan koordinat dan tampilkan dialog
    if(pData[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pAdminDuty] == 1)
    {
        pData[playerid][pWaypointPos][0] = fX;
        pData[playerid][pWaypointPos][1] = fY;
        pData[playerid][pWaypointPos][2] = fZ;
        
        new string[128];
        format(string, sizeof(string), "{FFFFFF}Anda yakin ingin teleport ke lokasi yang ditandai?\nTeleport ke: X: %.1f | Y: %.1f | Z: %.1f", fX, fY, fZ);
        ShowPlayerDialog(playerid, DIALOG_TELEPORT_CONFIRM, DIALOG_STYLE_MSGBOX, "Teleport", string, "Ya", "Tidak");
    }

    // Waypoint sharing untuk grup/faction (jika ada)
    foreach (new i : Player)
    {
        if(pData[i][pClikmap] == pData[playerid][pClikmap] && pData[i][pClikmap] != 0)
        {
            SetPlayerCheckpoint(i, fX, fY, fZ, 3.0);
            InfoMsg(i, "Waypoint diterima dari grup!");
        }
    }
    return 1;
}

new const RandomMessage[10][144] = {
	""PURPLE_E2"<!> "WHITE_E"Gunakan '/dokterlokal' untuk kembali dari pingsan saat tidak ada dokter dikota.!.",
    ""PURPLE_E2"<!> "WHITE_E"Gunakan '/help' untuk melihat berbagai command server!",
    ""PURPLE_E2"<!> "WHITE_E"Menemukan Masalah? Gunakan '/report' untuk melaporkannya.",
    ""PURPLE_E2"<!> "WHITE_E"Ingin Bertanya sesuatu? Gunakan '/ask'",
    ""PURPLE_E2"<!> "WHITE_E" Jika Anda Menemukan Kriminalitas Silahkan '/call 911'",
    ""PURPLE_E2"<!> "WHITE_E" Gunakan '/v' Untuk Mengatur Voice Kamu",
    ""PURPLE_E2"<!> "WHITE_E" Jika Anda Ingin Butuh Bantuan Para Medic Silahkan '/call 922'",
    ""PURPLE_E2"<!> "WHITE_E" Jika Anda Ingin Memesan Makanan Atau Minuman Silahkan ke Cafetaria",
    ""PURPLE_E2"<!> "WHITE_E" Jika Anda Sedang Down Gunakan '/teriak' Agar SAMD Datang",
	""PURPLE_E2"<!> "WHITE_E"Gunakan '/render' untuk mengatur rendering mapingan!"

};

ptask RandoMessages[180000](playerid) {
  new rand = random(10);
  SendClientMessageEx(playerid, -1, "%s", RandomMessage[rand], pemainic);
}

ptask PlayerUpdate[999](playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		IdlingCheck(playerid);
	}
	/*if(pData[playerid][IsLoggedIn] == true)
	{
		//hbe
		if(pData[playerid][pHBEMode] == 1) //simple
		{
			//hbe
			new Float:PX, Float:PY, Float:PZ;
			new lok[128];
			GetPlayerPos(playerid, PX, PY, PZ);
			format(lok, sizeof(lok), "%s", GetLocation(PX, PY, PZ));
			PlayerTextDrawSetString(playerid, HBESat[playerid][20], lok);
		}
		else
		{
			
		}
	}*/
	//door
	foreach(new di: Doors)
    {
    	if(IsPlayerInRangeOfPoint(playerid,3.0,dData[di][dExtposX],dData[di][dExtposY],dData[di][dExtposZ]))
    	{
    		InfoTD_MSG(playerid, 1000, "Type ~p~/enter ~w~or press ~p~F ~w~to enter");
    	}
    	if(IsPlayerInRangeOfPoint(playerid,3.0,dData[di][dIntposX],dData[di][dIntposY],dData[di][dIntposZ]))
    	{
    		InfoTD_MSG(playerid, 1000, "Type ~p~/enter ~w~or press ~p~F ~w~to exit");
    	}
    }
	//Anti-Cheat Vehicle health hack
	for(new v, j = GetVehiclePoolSize(); v <= j; v++) if(GetVehicleModel(v))
    {
        new Float:health;
        GetVehicleHealth(v, health);
        if( (health > VehicleHealthSecurityData[v]) && VehicleHealthSecurity[v] == false)
        {
			if(GetPlayerVehicleID(playerid) == v)
			{
				new playerState = GetPlayerState(playerid);
				if(playerState == PLAYER_STATE_DRIVER)
				{
					SetValidVehicleHealth(v, VehicleHealthSecurityData[v]);
					SendClientMessageToAllEx(COLOR_RED, "Anti-Cheat: {B897FF}%s{FFFFFF} have been auto kicked for vehicle health hack!", pData[playerid][pName]);
					//cheatlogs
					new DCC_Embed:logss;
					new yy, m, d, timestamp[200];

					getdate(yy, m , d);

					format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
					logss = DCC_CreateEmbed("");
					DCC_SetEmbedTitle(logss, "LOGS ANTICHEAT");
					DCC_SetEmbedTimestamp(logss, timestamp);
					DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
					DCC_SetEmbedUrl(logss, "");
					DCC_SetEmbedThumbnail(logss, "");
					DCC_SetEmbedFooter(logss, "", "");
					new stroi[5000];
					format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] have been auto kicked for vehicle health hack!", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID]);
					DCC_AddEmbedField(logss, "", stroi, true);
					DCC_SendChannelEmbedMessage(cheatlogs, logss);
					KickEx(playerid);
				}
			}
        }
        if(VehicleHealthSecurity[v] == true)
        {
            VehicleHealthSecurity[v] = false;
        }
        VehicleHealthSecurityData[v] = health;
    }
	//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
		//SendAdminMessage(COLOR_RED, "Possible money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid) - pData[playerid][pMoney]);
	}
	//Anti Armour Hacks
	new Float:A;
	GetPlayerArmour(playerid, A);
	if(A > 98)
	{
		SetPlayerArmourEx(playerid, 0);
		SendClientMessageToAllEx(COLOR_RED, "Anti-Cheat: {B897FF}%s(%i){FFFFFF} has been auto kicked for **armour hacks**!", pData[playerid][pName], playerid);
		//cheatlogs
		new DCC_Embed:logss;
		new yy, m, d, timestamp[200];

		getdate(yy, m , d);

		format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
		logss = DCC_CreateEmbed("");
		DCC_SetEmbedTitle(logss, "LOGS ANTICHEAT");
		DCC_SetEmbedTimestamp(logss, timestamp);
		DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
		DCC_SetEmbedUrl(logss, "");
		DCC_SetEmbedThumbnail(logss, "");
		DCC_SetEmbedFooter(logss, "", "");
		new stroi[5000];
		format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] has been auto kicked for **armour hacks**!", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID]);
		DCC_AddEmbedField(logss, "", stroi, true);
		DCC_SendChannelEmbedMessage(cheatlogs, logss);
		KickEx(playerid);
	}
	//Weapon AC
	if(pData[playerid][pSpawned] == 1)
    {
        if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
        {
            pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

            if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 40 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
            {
                SendAdminMessage(COLOR_RED, "{B897FF}%s(%d){FFFFFF} has possibly used weapon hacks {B897FF}(%s){FFFFFF}, Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
				//cheatlogs
				new DCC_Embed:logss;
				new yy, m, d, timestamp[200];

				getdate(yy, m , d);

				format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d); //%02i%02i%02i , yy, m, d
				logss = DCC_CreateEmbed("");
				DCC_SetEmbedTitle(logss, "LOGS ANTICHEAT");
				DCC_SetEmbedTimestamp(logss, timestamp);
				DCC_SetEmbedColor(logss, 0x741b47); //0xffa500 
				DCC_SetEmbedUrl(logss, "");
				DCC_SetEmbedThumbnail(logss, "");
				DCC_SetEmbedFooter(logss, "", "");
				new stroi[5000];
				format(stroi, sizeof(stroi), "**[KICK]** __%s__[%s] [UID:%d] has possibly used **weapon hacks**! Weap: __%s__", pData[playerid][pName],  UcpData[playerid][uUsername], pData[playerid][pID], ReturnWeaponName(pData[playerid][pWeapon]));
				DCC_AddEmbedField(logss, "", stroi, true);
				DCC_SendChannelEmbedMessage(cheatlogs, logss);
                SetWeapons(playerid); //Reload old weapons
            }
        }
    }
	//Weapon Atth
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 250)
	{
		static weaponid, ammo, objectslot, count, index;
 
		for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			index = weaponid - 22;
		   
			if (weaponid && ammo && !WeaponSettings[playerid][index][Hidden] && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
			{
				objectslot = GetWeaponObjectSlot(weaponid);
 
				if (GetPlayerWeapon(playerid) != weaponid)
					SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);
 
				else if (IsPlayerAttachedObjectSlotUsed(playerid, objectslot)) RemovePlayerAttachedObject(playerid, objectslot);
			}
		}
		for (new i = 4; i <= 8; i++) if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			count = 0;
 
			for (new j = 22; j <= 38; j++) if (PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == i)
				count++;
 
			if(!count) RemovePlayerAttachedObject(playerid, i);
		}
		WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
	}
	
	//Player Update Online Data
	//GetPlayerHealth(playerid, pData[playerid][pHealth]);
    //GetPlayerArmour(playerid, pData[playerid][pArmour]);
	
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
		if(pData[playerid][pBladder] > 100)
		{
			pData[playerid][pBladder] = 100;
		}
		if(pData[playerid][pBladder] < 0)
		{
			pData[playerid][pBladder] = 0;
		}
		/*if(pData[playerid][pHealth] > 100)
		{
			SetPlayerHealthEx(playerid, 100);
		}*/
	}
	if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		//PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
		//PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
		//PlayerTextDrawShow(playerid, NameserverTD[playerid][0]);
		//PlayerTextDrawShow(playerid, Nameserver2[playerid][0]);
		PlayerTextDrawShow(playerid, LOADBARTEXT[playerid]);
		TextDrawShowForPlayer(playerid, TextDate);
		TextDrawShowForPlayer(playerid, TextTime);
		PlayerTextDrawShow(playerid, NameServer2[playerid]);
		///////////////////////////////////////////////////
		ShowHbeaufaDua(playerid);
		UpdateHBEDua(playerid);
	}
	else if(pData[playerid][pHBEMode] == 2 && pData[playerid][IsLoggedIn] == true)
	{
		//PlayerTextDrawShow(playerid, VoiceTD[playerid][0]);
		//PlayerTextDrawShow(playerid, VoiceTD[playerid][1]);
		//PlayerTextDrawShow(playerid, NameserverTD[playerid][0]);
		PlayerTextDrawShow(playerid, LOADBARTEXT[playerid]);
		TextDrawShowForPlayer(playerid, TextDate);
		TextDrawShowForPlayer(playerid, TextTime);
		TextDrawShowForPlayer(playerid, aerpname[0]);
		//////////////////////////////////////////////////
		ShowHbeaufa(playerid);
		UpdateHBE(playerid);
	}
	else
	{
	
	}
	
	if(pData[playerid][pHospital] == 1)
    {
		if(pData[playerid][pInjured] == 1)
		{
			/*SetPlayerPosition(playerid, -2028.32, -92.87, 1067.43, 275.78, 1);
		
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, playerid + 100);
			pData[playerid][pSpaTime] = gettime() + 18000;

			SetPlayerCameraPos(playerid, -2024.67, -93.13, 1066.78);
			SetPlayerCameraLookAt(playerid, -2028.32, -92.87, 1067.43);
			ResetPlayerWeaponsEx(playerid);
			TogglePlayerControllable(playerid, 0);*/
			SetPlayerInterior(playerid, 0);
			SetPlayerPosition(playerid, 1163.4718,-1328.5350,-25.7639,96.1447);
			pData[playerid][pSpaTime] = gettime() + 18000;

			SetPlayerCameraPos(playerid, 1160.2148,-1326.8776,-26.5895);
			SetPlayerCameraLookAt(playerid, 1163.4718,-1328.5350,-25.7639);
			ResetPlayerWeaponsEx(playerid);
			TogglePlayerControllable(playerid, 0);
			pData[playerid][pInjured] = 0;
		}
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		//ApplyAnimation(playerid, "PED", "KO_skid_front", 4.0, 0, 0, 0, 0, 0);
		//ApplyAnimation(playerid, "PED", "KO_skid_front", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        if(pData[playerid][pHospitalTime] >= 15)
        {
            pData[playerid][pHospitalTime] = 0;
            pData[playerid][pHospital] = 0;
			pData[playerid][pHunger] = 50;
			pData[playerid][pEnergy] = 50;
			pData[playerid][pBladder] = 50;
			SetPlayerHealthEx(playerid, 50);
			pData[playerid][pSick] = 0;
			GivePlayerMoneyEx(playerid, -500);
			SetPlayerHealthEx(playerid, 50);

            for (new i; i < 20; i++)
            {
                SendClientMessage(playerid, -1, "");
            }

			SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, COLOR_WHITE, "Kamu telah keluar dari rumah sakit, kamu membayar $500 kerumah sakit.");
            SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
			
			SetPlayerPosition(playerid, 1144.7955,-1312.8859,-26.5895,87.4782);

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
			ClearAnimations(playerid);
			pData[playerid][pSpawned] = 1;
			SetPVarInt(playerid, "GiveUptime", -1);
			//new dc[128];
			//format(dc, sizeof dc, "**[ACC DEATH LOGS]**  __%s__ *(%s)* [ID: %s]\nTime: *%02d.%02d.%d - %02d:%02d:%02d*", pData[playerid][pName], UcpData[playerid][uUsername], playerid, day, month, year, h, m, s);
			//SendDiscordMessage(3, dc);
			//ACCEPTDEATH LOGS
			new DCC_Embed:logss;
			new timestamp[200];
			new h, m, s;
			new day, month, year;
	    	gettime(h, m, s);
	    	getdate(year,month,day);

			format(timestamp, sizeof(timestamp), "%02i%02i%02i", year, month, day); //%02i%02i%02i , yy, m, d
			logss = DCC_CreateEmbed("");
			DCC_SetEmbedTitle(logss, "ACCEPTDEATH LOGS");
			DCC_SetEmbedTimestamp(logss, timestamp);
			DCC_SetEmbedColor(logss, 0xb897ff); //0xffa500 
			DCC_SetEmbedUrl(logss, "");
			DCC_SetEmbedThumbnail(logss, "");
			DCC_SetEmbedFooter(logss, "", "");
			new stroi[5000];
			format(stroi, sizeof(stroi), "**[DEATH]**  __%s__ *(%s)* [ID:%d]\nTime: *%02d.%02d.%d - %02d:%02d:%02d*", pData[playerid][pName], UcpData[playerid][uUsername], playerid, day, month, year, h, m, s);
			DCC_AddEmbedField(logss, "", stroi, true);
			DCC_SendChannelEmbedMessage(acceptdeathlogs, logss);

		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
		pData[playerid][pSpaTime] = gettime() + 18000;
		//new mstr[64];
        //format(mstr, sizeof(mstr), "/death for spawn to hospital");
		//InfoTD_MSG(playerid, 1000, mstr);
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 100)
            {
                Info(playerid, "Now you can spawn, type '{B897FF}/death{FFFFFF}' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }

		//pHospitalTime
		ApplyAnimation(playerid, "PED", "KO_skid_front", 4.0, 0, 0, 0, 1, 0, 1);
       	//ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
        //ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
		ApplyAnimation(playerid, "PED", "KO_skid_front", 4.0, 0, 0, 0, 1, 0, 1);
        SetPlayerHealthEx(playerid, 99999);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 75)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 0)
            {
				Error(playerid, "Kamu kelaparan!");
                new Float:hp;
				GetPlayerHealth(playerid, hp);
                SetPlayerHealth(playerid, hp - 5);
          		SetPlayerDrunkLevel(playerid, 8000);
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 60)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 0)
            {
				Error(playerid, "Kamu kehausan!");
                new Float:hp;
				GetPlayerHealth(playerid, hp);
                SetPlayerHealth(playerid, hp - 5);
          		SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
        if(++ pData[playerid][pBladderTime] >= 220)
        {
            if(pData[playerid][pBladder] > 0)
            {
                pData[playerid][pBladder]--;
            }
            else if(pData[playerid][pBladder] <= 0)
            {
				new Float:hp;
				GetPlayerHealth(playerid, hp);
                SetPlayerHealth(playerid, hp - 5);
                Error(playerid, "Anda merasakan pusing. Segera Party agar relax!");
          		SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pBladderTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 300)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
					SetPlayerDrunkLevel(playerid, 8000);
					ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
					Error(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter.");
					SetPlayerHealth(playerid, hp - 10);
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be unjail in ~w~%d ~b~~h~seconds.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1482.0356,-1724.5726,13.5469,750, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E" %s(%d) have been un-jailed by the server. (times up)", pData[playerid][pName], playerid);
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be released in ~w~%d ~b~~h~seconds.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1526.69, -1678.05, 5.89, 267.76, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			InfoMsg(playerid, "You have been auto release. (times up)");
		}
	}
}

forward AppuieJump(playerid);
public AppuieJump(playerid)
{
    AntiBHOP[playerid] = 0;
    ClearAnimations(playerid);
    return 1;
}
forward AppuiePasJump(playerid);
public AppuiePasJump(playerid)
{
    AntiBHOP[playerid] = 0;
    return 1;
}

//radial
stock ClosePlayerRadial(playerid)
{
	forex(i, 52)
	{
		PlayerTextDrawHide(playerid, AERPRADIAL[playerid][i]);
	}
	CancelSelectTextDraw(playerid);
	return 1;
}

stock loadWorld(playerid)
{
	PlayerTextDrawShow(playerid, ObjectLoad[playerid][0]);
    //GameTextForPlayer(playerid, "MEMUAT OBJECT", 5000, 3);
    TogglePlayerControllable(playerid, false);
    SetTimerEx("objectLoaded", 5000, false, "d", playerid);
    return 1;
}

function objectLoaded(playerid)
{
	PlayerTextDrawHide(playerid, ObjectLoad[playerid][0]);
	TogglePlayerControllable(playerid, true);
	return 1;
}


Dialog:PLAYERSPAWN(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			SetPlayerPos(playerid, 1788.1824,-1877.3479,13.6007);
			SetPlayerFacingAngle(playerid, 271.4230);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			ClearAnimations(playerid);
			SetCameraBehindPlayer(playerid);		
			loadWorld(playerid);	
		}

		if(listitem == 1)
		{
			if(GetOwnedHouses(playerid) < 1)
			{
				ErrorMsg(playerid, "Kamu tidak memiliki rumah.");
				Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} /{B897FF}/{FFFFFF} Pilih Lokasi Spawn",
				"Titik Spawn\tDetail\tLokasi\t\t\t\n{B897FF}Stasiun/Unity Station\t{FFFFFF}Anda akan spawn di Stasiun Kota\tDepan Kantor (LS)\t\t\t\n{B897FF}House/Rumah\t{FFFFFF}Anda akan spawn didepan rumah milik anda\tDi Dalam Rumah\t\t\t\n{B897FF}Apartment/Flat\t{FFFFFF}Anda akan spawn didepan motel sewaan anda\tDi Depan Motel", 
				"Pilih", "");
			}
			if(GetOwnedHouses(playerid) > 0)
			{
				SetPlayerPos(playerid, hData[playerid][hIntposX], hData[playerid][hIntposY], hData[playerid][hIntposZ]);
				SetPlayerFacingAngle(playerid, hData[playerid][hIntposA]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				ClearAnimations(playerid);		
				loadWorld(playerid);	
				SetCameraBehindPlayer(playerid);
			}
		}
		if(listitem == 2)
		{
			/*if(GetOwnedRusun(playerid) < 1)
			{
				ErrorMsg(playerid, "Kamu tidak memiliki rusun.");
				Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} - Pilih Lokasi Spawn",
				"Titik Spawn\tDetail\tLokasi\t\t\t\nBandara International\tAnda akan spawn di bandara\tLos Santos\t\t\t\nPelabuhan Merak\tAnda akan spawn di pelabuhan\tOcean Docs\t\t\t\nBandara Las Venturas\tAnda akan spawn di bandara\tLas Venturas\t\t\t\nCarnaval\tAnda akan spawn di wahana carnaval\tSanta Maria Beach\t\t\t\nHouse\tAnda akan spawn didepan rumah milik anda\t-\t\t\t\nRusun\tAnda akan spawn didepan motel sewaan anda\t-", 
				//"Titik Spawn\tDetail\tLokasi\nBandara International\tAnda akan spawn di bandara\tLos Santos\nPelabuhan Merak\tAnda akan spawn di pelabuhan\nCarnaval\tAnda akan spawn di wahana carnaval\tSanta Maria Beach\nHouse\tAnda akan spawn didepan rumah milik anda\t-\nRusun\tAnda akan spawn didepan motel sewaan anda\t-\n", 
				"Pilih", "");
			}
			if(GetOwnedRusun(playerid) > 0)
			{
				SetPlayerPos(playerid, rsunData[playerid][r_IntposX], rsunData[playerid][r_IntposY], rsunData[playerid][r_IntposZ]);
				SetPlayerFacingAngle(playerid, rsunData[playerid][r_IntposA]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				ClearAnimations(playerid);		
				loadWorld(playerid);	
				SetCameraBehindPlayer(playerid);
			}*/
			/////////////////////////////////////////////////////////////////////////////
			ErrorMsg(playerid, "Fitur ini masih tahap pengembangan.");
			Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} /{B897FF}/{FFFFFF} Pilih Lokasi Spawn",
			"Titik Spawn\tDetail\tLokasi\t\t\t\n{B897FF}Stasiun/Unity Station\t{FFFFFF}Anda akan spawn di Stasiun Kota\tDepan Kantor (LS)\t\t\t\n{B897FF}House/Rumah\t{FFFFFF}Anda akan spawn didepan rumah milik anda\tDi Dalam Rumah\t\t\t\n{B897FF}Apartment/Flat\t{FFFFFF}Anda akan spawn didepan motel sewaan anda\tDi Depan Motel", 
			"Pilih", "");
			/*Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} - Pilih Lokasi Spawn",
			"Titik Spawn\tDetail\tLokasi\nBandara International\tAnda akan spawn di bandara\tLos Santos\nPelabuhan Merak\tAnda akan spawn di pelabuhan\tOcean Docks\nCarnaval\tAnda akan spawn di wahana carnaval\tSanta Maria Beach\nHouse\tAnda akan spawn didepan rumah milik anda\t-\nRusun\tAnda akan spawn didepan motel sewaan anda\t-\n", 
			//"Titik Spawn\tDetail\tLokasi\nBandara International\tAnda akan spawn di bandara\tLos Santos\nPelabuhan Merak\tAnda akan spawn di pelabuhan\nCarnaval\tAnda akan spawn di wahana carnaval\tSanta Maria Beach\nHouse\tAnda akan spawn didepan rumah milik anda\t-\nRusun\tAnda akan spawn didepan motel sewaan anda\t-\n", 
			"Pilih", "");*/

		}	
		if(listitem == 3)
		{
			if(pData[playerid][pFaction] < 0)
			{
				ErrorMsg(playerid, "Kamu bukan anggota fraksi.");
				Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} /{B897FF}/{FFFFFF} Pilih Lokasi Spawn",
				"Titik Spawn\tDetail\tLokasi\t\t\t\n{B897FF}Stasiun/Unity Station\t{FFFFFF}Anda akan spawn di Stasiun Kota\tDepan Kantor (LS)\t\t\t\n{B897FF}House/Rumah\t{FFFFFF}Anda akan spawn didepan rumah milik anda\tDi Dalam Rumah\t\t\t\n{B897FF}Apartment/Flat\t{FFFFFF}Anda akan spawn didepan motel sewaan anda\tDi Depan Motel", 
				"Pilih", "");
			}
			if(pData[playerid][pFaction] > 0)
			{
				new str[1000];
				format(str, sizeof(str), "Titik Spawn\t\t\t\t\t\tDetail\t\t\t\t\t\t\t\tLokasi\nGovernments\t\t\t\t\t\tAnda Akan Spawn Di San Andreas Governments/Pemerintah\t\t\t\t\t\t\t\t Los Santos(LS)\nPolice Departement\t\t\t\t\tAnda akan spawn di kantor polisi\t\t\t\t\t\t\t\tLos Santos(LS)\nHospital\t\t\t\t\tAnda akan spawn di rumah sakit Metro\t\t\t\t\t\t\t\tLos Santos(LS)\nNews Departement\t\t\t\t\tAnda akan spawn di san andreas News\t\t\t\t\t\t\t\tLos Santos(LS)\nCafetaria\t\t\t\t\tAnda akan spawn di san andreas food/Pedagang\t\t\t\t\t\t\t\tLos Santos(LS)");
				ShowPlayerDialog(playerid, DIALOG_PILIH_SPAWN, DIALOG_STYLE_TABLIST_HEADERS,"{B897FF}Warga Kota{FFFFFF} /{B897FF}/{FFFFFF} Pilih Lokasi Spawn Faction/Fraksi", str, "Pilih", "");
			}
		}			
	}
	else
	{
		Dialog_Show(playerid, PLAYERSPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{B897FF}Warga Kota{FFFFFF} /{B897FF}/{FFFFFF} Pilih Lokasi Spawn",
		"Titik Spawn\tDetail\tLokasi\t\t\t\n{B897FF}Stasiun/Unity Station\t{FFFFFF}Anda akan spawn di Stasiun Kota\tDepan Kantor (LS)\t\t\t\n{B897FF}House/Rumah\t{FFFFFF}Anda akan spawn didepan rumah milik anda\tDi Dalam Rumah\t\t\t\n{B897FF}Apartment/Flat\t{FFFFFF}Anda akan spawn didepan motel sewaan anda\tDi Depan Motel", 
		"Pilih", "");	
	}
	return 1;
}


stock KeyBindInfo(playerid, text[])
{
	PlayerTextDrawShow(playerid, UIINFO[playerid][0]);
	PlayerTextDrawShow(playerid, UIINFO[playerid][1]);
	PlayerTextDrawShow(playerid, UIINFO[playerid][2]);
	PlayerTextDrawShow(playerid, UIINFO[playerid][3]);
	PlayerTextDrawSetString(playerid, UIINFO[playerid][3], text);
	PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);	
	return 1;
}

stock HideInfo(playerid)
{
	PlayerTextDrawHide(playerid, UIINFO[playerid][3]);
	PlayerTextDrawHide(playerid, UIINFO[playerid][2]);
	PlayerTextDrawHide(playerid, UIINFO[playerid][1]);
	PlayerTextDrawHide(playerid, UIINFO[playerid][0]);
	return 1;
}


stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

function SambutanHilang(playerid)
{
	PlayerTextDrawHide(playerid, SambutanTD[playerid][0]);
	PlayerTextDrawHide(playerid, SambutanTD[playerid][1]);
}
function SambutanMuncul(playerid)
{
    PlayerTextDrawShow(playerid, SambutanTD[playerid][0]);
    new Sambutanzz[560];
   	format(Sambutanzz,1000,"%s", GetName(playerid));
	PlayerTextDrawSetString(playerid, SambutanTD[playerid][1], Sambutanzz);
    PlayerTextDrawShow(playerid, SambutanTD[playerid][1]);
	SetTimer("SambutanHilang", 10000, 0);
}

//hp

function HideHpLenz(playerid)
{
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][0]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][1]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][2]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][3]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][4]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][5]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][6]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][7]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][8]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][9]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][10]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][11]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][12]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][13]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][14]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][15]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][16]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][17]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][18]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][19]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][20]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][21]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][22]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][23]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][24]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][25]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][26]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][27]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][28]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][29]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][30]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][31]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][32]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][33]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][34]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][35]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][36]);
	PlayerTextDrawHide(playerid, adshplenz[playerid]);
	PlayerTextDrawHide(playerid, airdrophplenz[playerid]);
	PlayerTextDrawHide(playerid, contacthplenz[playerid]);
	PlayerTextDrawHide(playerid, camerahplenz[playerid]);
	PlayerTextDrawHide(playerid, callhplenz[playerid]);
	PlayerTextDrawHide(playerid, jobhplenz[playerid]);
	PlayerTextDrawHide(playerid, musichplenz[playerid]);
	PlayerTextDrawHide(playerid, gojekhplenz[playerid]);
	PlayerTextDrawHide(playerid, bankhplenz[playerid]);
	PlayerTextDrawHide(playerid, mapshplenz[playerid]);
	PlayerTextDrawHide(playerid, twhplenz[playerid]);
	PlayerTextDrawHide(playerid, settinghplenz[playerid]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][37]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][38]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][39]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][40]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][41]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][42]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][43]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][44]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][45]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][46]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][47]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][48]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][49]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][50]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][51]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][52]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][53]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][54]);
	PlayerTextDrawHide(playerid, hplenzbaru[playerid][55]);
	PlayerTextDrawHide(playerid, closehplenz[playerid]);
	return 1;
}
function ShowHpLenz(playerid)
{
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][0]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][1]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][2]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][3]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][4]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][5]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][6]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][7]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][8]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][9]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][10]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][11]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][12]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][13]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][14]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][15]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][16]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][17]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][18]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][19]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][20]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][21]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][22]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][23]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][24]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][25]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][26]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][27]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][28]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][29]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][30]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][31]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][32]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][33]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][34]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][35]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][36]);
	PlayerTextDrawShow(playerid, adshplenz[playerid]);
	PlayerTextDrawShow(playerid, airdrophplenz[playerid]);
	PlayerTextDrawShow(playerid, contacthplenz[playerid]);
	PlayerTextDrawShow(playerid, camerahplenz[playerid]);
	PlayerTextDrawShow(playerid, callhplenz[playerid]);
	PlayerTextDrawShow(playerid, jobhplenz[playerid]);
	PlayerTextDrawShow(playerid, musichplenz[playerid]);
	PlayerTextDrawShow(playerid, gojekhplenz[playerid]);
	PlayerTextDrawShow(playerid, bankhplenz[playerid]);
	PlayerTextDrawShow(playerid, mapshplenz[playerid]);
	PlayerTextDrawShow(playerid, twhplenz[playerid]);
	PlayerTextDrawShow(playerid, settinghplenz[playerid]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][37]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][38]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][39]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][40]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][41]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][42]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][43]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][44]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][45]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][46]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][47]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][48]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][49]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][50]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][51]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][52]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][53]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][54]);
	PlayerTextDrawShow(playerid, hplenzbaru[playerid][55]);
	PlayerTextDrawShow(playerid, closehplenz[playerid]);
}

function ShowHpSatrio(playerid)
{
	for(new i = 0; i < 45; i++)
    {
        PlayerTextDrawShow(playerid, PlayerTD[playerid][i]);
    }
	PlayerTextDrawShow(playerid, phone_exit[playerid]);
	PlayerTextDrawShow(playerid, phone_music[playerid]);
	PlayerTextDrawShow(playerid, phone_twitter[playerid]);
	PlayerTextDrawShow(playerid, phone_cam[playerid]);
	PlayerTextDrawShow(playerid, phone_bank[playerid]);
	PlayerTextDrawShow(playerid, phone_sms[playerid]);
	PlayerTextDrawShow(playerid, phone_contact[playerid]);
	PlayerTextDrawShow(playerid, phone_gps[playerid]);
	PlayerTextDrawShow(playerid, phone_settings[playerid]);
	PlayerTextDrawShow(playerid, phone_player_level[playerid]);
	PlayerTextDrawShow(playerid, phone_player_money[playerid]);
	PlayerTextDrawShow(playerid, phone_player_age[playerid]);
}

function HideHpSatrio(playerid)
{
	for(new i = 0; i < 45; i++)
    {
        PlayerTextDrawHide(playerid, PlayerTD[playerid][i]);
    }
	PlayerTextDrawHide(playerid, phone_exit[playerid]);
	PlayerTextDrawHide(playerid, phone_music[playerid]);
	PlayerTextDrawHide(playerid, phone_twitter[playerid]);
	PlayerTextDrawHide(playerid, phone_cam[playerid]);
	PlayerTextDrawHide(playerid, phone_bank[playerid]);
	PlayerTextDrawHide(playerid, phone_sms[playerid]);
	PlayerTextDrawHide(playerid, phone_contact[playerid]);
	PlayerTextDrawHide(playerid, phone_gps[playerid]);
	PlayerTextDrawHide(playerid, phone_settings[playerid]);
	PlayerTextDrawHide(playerid, phone_player_level[playerid]);
	PlayerTextDrawHide(playerid, phone_player_money[playerid]);
	PlayerTextDrawHide(playerid, phone_player_age[playerid]);
}

stock StopStream(playerid)
{
	DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock PlayStream(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(pData[playerid][pDriveLicApp] > 0)
	{
		//new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 602)
		{
		    DisablePlayerCheckpoint(playerid);
			DisablePlayerRaceCheckpoint(playerid);
		    InfoMsg(playerid, "Anda Dengan Sengaja Keluar Dari Mobil Latihan, Anda Telah "RED_E"DIDISKUALIFIKASI.");
		    RemovePlayerFromVehicle(playerid);
		    pData[playerid][pDriveLicApp] = 0;
		    SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(pData[playerid][pSideJob] > 0)
	{
		pData[playerid][pSideJob] = 0;
		pData[playerid][pSideJobTime] = 360;
		DisablePlayerCheckpoint(playerid);
		RemovePlayerFromVehicle(playerid);
		SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		Info(playerid, "Anda sengaja keluar dari kendaraan dan pekerjaan GAGAL!");
	}
	if( vehicleid == Drones[playerid] ) {
	    SendClientMessage( playerid, COLOR_RED, "You can't exit the drone! Use /drone remove or /drone detonate." );
	}
	return 1;
}

stock UpdateATM(playerid) 
{
	PlayerTextDrawSetString(playerid, AERPATM[playerid][31], sprintf("%d", pData[playerid][pBankRek]));
	PlayerTextDrawSetString(playerid, AERPATM[playerid][7], pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, AERPATM[playerid][30], sprintf("%s", FormatMoney(pData[playerid][pBankMoney])));
    return 1;
}


GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}

ClearChat(playerid)
{
	for(new i = 0; i < 29; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}


ClearAllChat(playerid)
{
	for(new i = 0; i < 65; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
}

SetFactionMendungColor(playerid)
{
    new factionid = pData[playerid][pFaction];

    if(factionid == 1)
	{
		SetPlayerColor(playerid, COLOR_BLUE);
	}
	else if(factionid == 3)
	{
		SetPlayerColor(playerid, COLOR_PINK2);
	}
	else
	{
		SetPlayerColor(playerid, COLOR_WHITE);
	}
	return 1;
}

Waypoint_Set(playerid, name[], Float:x, Float:y, Float:z)
{
	format(PlayerInfo[playerid][pLocation], 32, name);

	PlayerInfo[playerid][pWaypoint] = 1;
	PlayerInfo[playerid][pWaypointPos][0] = x;
	PlayerInfo[playerid][pWaypointPos][1] = y;
	PlayerInfo[playerid][pWaypointPos][2] = z;

	SetPlayerCheckpoint(playerid, x, y, z, 3.0);
	PlayerTextDrawShow(playerid, PlayerInfo[playerid][pTextdraws][69]);

	return 1;
}

function sinyal(playerid)
{
    new sgid = Iter_Random(Signal);
	sgData[sgid][sgSeconds] = 60 * 20;
	sgData[sgid][sgStatus] = 1;
	Signal_Save(sgid);
	Signal_Refresh(sgid);
    return 1;
}

function BotLenz(playerid)
{
    if(!STATUS_BOT2)
    {
		new statuz[256];
		//format(statuz,sizeof(statuz),"!register [nama ucp]");
		//format(statuz,sizeof(statuz),"Players : %d | %dh %02dm {B897FF}Metro{FFFFFF} [ONLINE]", pemainic, h, m);
		format(statuz,sizeof(statuz),"Warga Kota Mengudara!!!");
		DCC_SetBotActivity(statuz);
        STATUS_BOT2 = true;
    }
    else
    {
		new statuz[256];
		format(statuz,sizeof(statuz),"BersamaKitaBisa..!!");
		DCC_SetBotActivity(statuz);
        STATUS_BOT2 = false;
    }
    return 1;
}

stock SendDiscordMessage(channel, message[])
{
	new DCC_Channel:ChannelId;
	switch(channel)
	{
		// pintu masuk
		case 0:
		{
			ChannelId = DCC_FindChannelById("1193465243091877928");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		// server logs
		case 1:
		{
			ChannelId = DCC_FindChannelById("1219872119748563004");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//anti cheat logs
		case 2:
		{
			ChannelId = DCC_FindChannelById("1219872147556798545");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Death ]
		case 3:
		{
			ChannelId = DCC_FindChannelById("1219872170688122880");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Ucp ]
		case 4:
		{
			ChannelId = DCC_FindChannelById("1230560519388266537");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 5://Register
		{
			ChannelId = DCC_FindChannelById("1230560519388266537");
			DCC_SendChannelMessage(ChannelId, message);
            return 1;
	   }
	}
	return 1;
}

stock UpdatePlayerStreamer(playerid)
{
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	foreach(new i : Player)
	{
	    if(IsPlayerInRangeOfPoint(i, 20.0, pos[0], pos[1], pos[2]))
	    {
	        Streamer_Update(i);
		}
	}
	return 1;
}
