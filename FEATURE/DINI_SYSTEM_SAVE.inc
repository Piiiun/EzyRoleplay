//=============== DATABASE SAVE ACCOUNT DINI SYSTEM ==============

//**************
new File[99899]; // VARIABLES
//**************

//*********************************
// CRATES TRUCKER JOBS DINI SYSTEM
//*********************************
enum C_PLAYERS
{
	vCrateFish,
	vCrateCompo,
	vCrateMats,
};
new vCrateData[MAX_PLAYERS][C_PLAYERS];
//*********************************
forward SavePlayerAccount(playerid);
public SavePlayerAccount(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	format(File, sizeof(File), "BaseDini/Account/%s.ini", pData[playerid][pName]);
	if( dini_Exists( File ) )
	{
        // Vehicle Stock Save
        dini_IntSet(File, "dapat_cratefish", vCrateData[vehicleid][vCrateFish]);
        dini_IntSet(File, "dapat_cratecompo", vCrateData[vehicleid][vCrateCompo]);
        dini_IntSet(File, "dapat_cratematerial", vCrateData[vehicleid][vCrateMats]);
	}
}
forward LoadPlayerAccount(playerid);
public LoadPlayerAccount(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	format( File, sizeof( File ), "BaseDini/Account/%s.ini", pData[playerid][pName]);
    if(dini_Exists(File))//Buat load data user(dikarenakan sudah ada datanya)
    {
		// Vehicle Stock Save
        vCrateData[vehicleid][vCrateFish] = dini_Int( File,"dapat_cratefish");
        vCrateData[vehicleid][vCrateCompo] = dini_Int( File,"dapat_cratecompo");
        vCrateData[vehicleid][vCrateMats] = dini_Int( File,"dapat_cratematerial");
    }
    else //Buat user baru(Bikin file buat pemain baru dafar)
    {
    	// Vehicle Stock Save
        dini_IntSet(File, "dapat_cratefish", 0);
        dini_IntSet(File, "dapat_cratecompo", 0);
        dini_IntSet(File, "dapat_cratematerial", 0);
        
		//
        vCrateData[vehicleid][vCrateFish] = dini_Int( File,"dapat_cratefish");
        vCrateData[vehicleid][vCrateCompo] = dini_Int( File,"dapat_cratecompo");
        vCrateData[vehicleid][vCrateMats] = dini_Int( File,"dapat_cratematerial");
	 }
}
