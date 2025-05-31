#include <YSI\y_hooks>
/* var */
new PlayerText:PROGRESSBAR[MAX_PLAYERS][28];
new LoadingPlayerBar[MAX_PLAYERS];
new TimerLoading[MAX_PLAYERS];
//new ProgressTimer[MAX_PLAYERS][128];
/* Hide TD */
HideProgressBar(playerid)
{
	/*PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][3]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][4]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][5]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][6]);*/
	for(new txd; txd < 28; txd++)
	{
		PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][txd]);
	} 
	return 1;
}
/* Create TD */
CreateProgress(playerid)
{
	PROGRESSBAR[playerid][0] = CreatePlayerTextDraw(playerid, 276.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][0], 0.219, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][0], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][0], 1);

	PROGRESSBAR[playerid][1] = CreatePlayerTextDraw(playerid, 273.000, 372.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][1], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], 101.000, 6.500);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][1], COLOR_PURPLE); //-1976835329
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][1], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][1], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][1], 1);

	PROGRESSBAR[playerid][2] = CreatePlayerTextDraw(playerid, 270.000, 356.000, "Activity Progress");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][2], 0.216, 1.200);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][2], 406.500, 98.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][2], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][2], 1);

	PROGRESSBAR[playerid][3] = CreatePlayerTextDraw(playerid, 273.000, 370.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][3], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][3], 101.000, 2.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][3], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][3], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][3], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][3], 1);

	PROGRESSBAR[playerid][4] = CreatePlayerTextDraw(playerid, 274.000, 370.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][4], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][4], -2.000, 7.500);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][4], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][4], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][4], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][4], 1);

	PROGRESSBAR[playerid][5] = CreatePlayerTextDraw(playerid, 272.000, 377.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][5], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][5], 102.000, 2.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][5], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][5], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][5], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][5], 1);

	PROGRESSBAR[playerid][6] = CreatePlayerTextDraw(playerid, 372.000, 370.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][6], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][6], 2.000, 8.500);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][6], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][6], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][6], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][6], 1);

	PROGRESSBAR[playerid][7] = CreatePlayerTextDraw(playerid, 271.000, 368.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][7], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][7], 105.000, 1.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][7], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][7], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][7], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][7], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][7], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][7], 1);

	PROGRESSBAR[playerid][8] = CreatePlayerTextDraw(playerid, 270.000, 368.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][8], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][8], 1.000, 13.500);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][8], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][8], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][8], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][8], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][8], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][8], 1);

	PROGRESSBAR[playerid][9] = CreatePlayerTextDraw(playerid, 271.000, 380.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][9], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][9], 104.000, 1.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][9], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][9], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][9], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][9], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][9], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][9], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][9], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][9], 1);

	PROGRESSBAR[playerid][10] = CreatePlayerTextDraw(playerid, 375.000, 368.000, "ld_bum:blkdot");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][10], 0.600, 2.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][10], 1.000, 13.500);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][10], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][10], COLOR_BAR);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][10], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][10], 50);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][10], 1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][10], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][10], 1);

	
	PROGRESSBAR[playerid][11] = CreatePlayerTextDraw(playerid, 276.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][11], 0.219, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][11], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][11], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][11], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][11], 1);

	PROGRESSBAR[playerid][12] = CreatePlayerTextDraw(playerid, 282.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][12], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][12], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][12], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][12], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][12], 1);

	PROGRESSBAR[playerid][13] = CreatePlayerTextDraw(playerid, 288.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][13], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][13], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][13], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][13], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][13], 1);

	PROGRESSBAR[playerid][14] = CreatePlayerTextDraw(playerid, 294.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][14], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][14], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][14], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][14], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][14], 1);

	PROGRESSBAR[playerid][15] = CreatePlayerTextDraw(playerid, 300.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][15], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][15], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][15], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][15], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][15], 1);

	PROGRESSBAR[playerid][16] = CreatePlayerTextDraw(playerid, 306.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][16], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][16], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][16], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][16], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][16], 1);

	PROGRESSBAR[playerid][17] = CreatePlayerTextDraw(playerid, 312.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][17], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][17], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][17], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][17], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][17], 1);

	PROGRESSBAR[playerid][18] = CreatePlayerTextDraw(playerid, 318.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][18], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][18], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][18], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][18], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][18], 1);

	PROGRESSBAR[playerid][19] = CreatePlayerTextDraw(playerid, 324.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][19], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][19], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][19], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][19], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][19], 1);

	PROGRESSBAR[playerid][20] = CreatePlayerTextDraw(playerid, 330.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][20], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][20], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][20], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][20], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][20], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][20], 1);

	PROGRESSBAR[playerid][21] = CreatePlayerTextDraw(playerid, 336.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][21], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][21], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][21], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][21], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][21], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][21], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][21], 1);

	PROGRESSBAR[playerid][22] = CreatePlayerTextDraw(playerid, 342.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][22], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][22], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][22], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][22], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][22], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][22], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][22], 1);

	PROGRESSBAR[playerid][23] = CreatePlayerTextDraw(playerid, 348.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][23], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][23], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][23], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][23], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][23], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][23], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][23], 1);

	PROGRESSBAR[playerid][24] = CreatePlayerTextDraw(playerid, 355.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][24], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][24], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][24], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][24], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][24], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][24], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][24], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][24], 1);

	PROGRESSBAR[playerid][25] = CreatePlayerTextDraw(playerid, 361.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][25], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][25], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][25], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][25], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][25], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][25], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][25], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][25], 1);

	PROGRESSBAR[playerid][26] = CreatePlayerTextDraw(playerid, 367.000, 367.000, ">");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][26], 0.220, 1.600);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][26], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][26], COLOR_BAR);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][26], 0);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][26], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][26], 150);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][26], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][26], 1);

	PROGRESSBAR[playerid][27] = CreatePlayerTextDraw(playerid, 376.000, 358.000, "100");
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][27], 0.186, 1.000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][27], 406.500, 98.000);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][27], 3);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][27], -1);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][27], 1);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][27], 1);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][27], 0);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][27], 255);
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][27], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][27], 1);

	return 1;
}
/* Hook OnPlayerConnect */
hook OnPlayerConnect(playerid)
{
	CreateProgress(playerid);
	return 1;
}
/* Func */
ShowProgressbar(playerid, text[] = "", Times)
{
	if(pData[playerid][pProgress] > 0) return 1;
	LoadingPlayerBar[playerid] = 0;
	pData[playerid][pProgress] = 1;
	//LoadingPlayerBar[playerid] = 0;
	new Float:Value = LoadingPlayerBar[playerid]*101/100;
	new Timer = Times*1000/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], Value, 6.5);
	PlayerTextDrawSetString(playerid, PROGRESSBAR[playerid][2], text);
	/*PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][3]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][4]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][5]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][6]);*/
	for(new txd; txd < 28; txd++)
	{
		PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][txd]);
	} 
	TogglePlayerControllable(playerid, 0);
	TimerLoading[playerid] = SetTimerEx("UpdtLoading", Timer, true, "d", playerid);
	return 1;
}

stock UpdateLoading(playerid)
{
	new Float:Value = LoadingPlayerBar[playerid]*101.0/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], Value, 6.4);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawSetString(playerid, PROGRESSBAR[playerid][27], sprintf("%d", LoadingPlayerBar));
	return 1;
}

forward UpdtLoading(playerid);
public UpdtLoading(playerid)
{
	LoadingPlayerBar[playerid] += 1;
	UpdateLoading(playerid);
	if(LoadingPlayerBar[playerid] >= 100)
	{
		KillTimer(TimerLoading[playerid]);
		LoadingPlayerBar[playerid] = 0;
		pData[playerid][pProgress] = 0;
		HideProgressBar(playerid);
		//SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}
CMD:testprog(playerid, params[])
{
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda sedang melakukan activity progress");
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	ShowProgressbar(playerid, "Mengentod...", 10);
	return 1;
}