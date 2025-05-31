stock IdlingCheck(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:cx,
	    Float:cy,
	    Float:cz;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerCameraPos(playerid, cx, cy, cz);

	if(AccountData[playerid][pAFKPos][0] == x && AccountData[playerid][pAFKPos][1] == y && AccountData[playerid][pAFKPos][2] == z && AccountData[playerid][pAFKPos][3] == cx && AccountData[playerid][pAFKPos][4] == cy && AccountData[playerid][pAFKPos][5] == cz)
	{
		AccountData[playerid][pAFKTime]++;

	    if(!AccountData[playerid][pAFK] && AccountData[playerid][pAFKTime] >= 15)
	    {
			PlayerData[playerid][pAFK] = 1;
			switch(random(10))
			{
				case 0:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "PED","XPRESSscratch", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 1:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 2:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 3:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "CLOTHES","CLO_Pose_Shoes", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 4:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "PLAYIDLES", "shift", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 5:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "PLAYIDLES", "shldr", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 6:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "PLAYIDLES", "stretch", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 7:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "PLAYIDLES", "time", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 8:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "CLOTHES", "CLO_Pose_Torso", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 9:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 0, 0, 0, 0, 1);
				}
				case 10:
				{
					if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
					ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 0, 0, 0, 0, 0, 1);
				}				
			}		
		}
	}
	else
	{
		if(AccountData[playerid][pAFK])
		{
			PlayerData[playerid][pAFK] = 0;
			ClearAnimations(playerid);
		}

		AccountData[playerid][pAFKTime] = 0;
	}

	AccountData[playerid][pAFKPos][0] = x;
	AccountData[playerid][pAFKPos][1] = y;
	AccountData[playerid][pAFKPos][2] = z;
	AccountData[playerid][pAFKPos][3] = cx;
	AccountData[playerid][pAFKPos][4] = cy;
	AccountData[playerid][pAFKPos][5] = cz;
	return 1;
}

function ClearAnimNeww(playerid)
{
	ClearAnimations(playerid);
}
function AnimGerakByKazuji(playerid)
{
   	new var = random(1);
   	switch (var)
   	{
   		case 0:
   		{
			if(GetPlayerAnimationIndex(playerid) != 1189) ClearAnimations(playerid);
			ApplyAnimation(playerid, "PED","XPRESSscratch", 4.0, 0, 0, 0, 0, 0, 1);
			SetTimerEx("ClearAnimNeww", 4500, false, "i", playerid);
   		    /*if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
   		    {
				ApplyAnimation(playerid, "PED","XPRESSscratch", 4.0, 0, 0, 0, 0, 0, 1);
				SetTimerEx("ClearAnimNeww", 4500, false, "i", playerid);
			}*/
		}
/*   		case 1:
   		{
			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) ApplyAnimation(playerid,"BENCHPRESS","gym_bp_celebrate",2.0, 0, 0, 0, 0, 0);
			SetTimerEx("ClearAnimNeww", 4000, false, "i", playerid);
		}*/
	}
}
