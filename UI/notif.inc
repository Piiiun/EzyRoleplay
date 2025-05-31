
 
enum eNotify
{
	NotifyIcon,
	NotifyMessage[320],
	NotifyLoading,
	NotifySize
}
new InfoNotify[MAX_PLAYERS][5][eNotify];
new MaxPlayerNotify[MAX_PLAYERS];
new PlayerText:TextDrawNotifikasi[MAX_PLAYERS][7*12];
new IndexNotify[MAX_PLAYERS];
new LoadingNotif[MAX_PLAYERS];


/*InfoMsg(playerid,"
ErrorMsg(playerid,"
SuccesMsg(playerid, "
SyntaxMsg(playerid, "
WarningMsg(playerid, "*/

function HideNotify(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	--IndexNotify[playerid];
	MaxPlayerNotify[playerid]--;
	//for(new i=0; i<100; i++)
	//{
	//    SendClientMessageEx(playerid, COLOR_WHITE, "");
	//}
	for(new i=-1;++i<12;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(IndexNotify[playerid]*12)+i]);
	return 1;
}

stock InfoMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5205 , 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 1);
  return 1;
}
stock ErrorMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5206 , 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 2);
  return 1;
}
stock SuccesMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5203 , 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 3);
  return 1;
}
stock SyntaxMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5205 , 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 4);
  return 1;
}

stock WarningMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5205, 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 5);
  return 1;
}
stock PermissionError(playerid)
{
	ErrorMsg(playerid, "Hanya admin yang bisa menggunakan CMD ini!");
	return 1;
}

stock BankMsg(playerid, pesan[])
{
  PlayerPlaySound(playerid, 5203, 0.0, 0.0, 0.0);
  ShowNotify(playerid, pesan, 6);
  return 1;
}

stock ChatPlayer(playerid, pesan[])
{

 // PlayerPlaySound(playerid, 5205, 0.0, 0.0, 0.0);
	ShowNotify(playerid, pesan, 7);
	return 1;
}

stock ShowNotify(const playerid, const string:message[], const icon)
{
	if(MaxPlayerNotify[playerid] == 5) return 1;
	MaxPlayerNotify[playerid]++;
	for(new x=-1; ++x <IndexNotify[playerid];)
	{
		for(new i=-1;++i<12;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(x*12) + i]);
		InfoNotify[playerid][IndexNotify[playerid]-x] = InfoNotify[playerid][(IndexNotify[playerid]-x)-1];
	}
    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	format(InfoNotify[playerid][0][NotifyMessage], 320, "%s", message);
	InfoNotify[playerid][0][NotifyIcon] = icon;
	InfoNotify[playerid][0][NotifySize] = 3;
	
	++IndexNotify[playerid];
	new Float:new_x=0.0;
	for(new x=-1;++x<IndexNotify[playerid];)
	{
		CreateNotify(playerid, x, x * 12, new_x);
		new_x += (InfoNotify[playerid][x][NotifySize]*7.25)+25.0;
		new Float:Value = LoadingNotif[playerid]*101.0/100;
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][x], Value, 23.4);
	}
	SetTimerEx("HideNotify", 5000, false, "i", playerid);
	return 1;
}

stock CreateNotify(const playerid, index, i, const Float:new_x)
{
	new lines = InfoNotify[playerid][index][NotifySize];
	new Float:x = (lines * 12) + new_x;
	new Float:posisibaru = x-30.0;
	new Float:posisichat = x-37.0;
	if(InfoNotify[playerid][index][NotifyIcon] == 1)
	{

		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1097458175);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1097458175);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Informasi");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 2)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_RED);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_RED);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Error");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 3)
	{

		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_GREEN);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_GREEN);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Succesfull");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 4)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_GRAY);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_GRAY);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Command");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

	}
	if(InfoNotify[playerid][index][NotifyIcon] == 5)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_ORANGE);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_ORANGE);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Warning");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 6)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 144.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 108.000, 27.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 139.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 98.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 596.000, 137.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 497.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 597.000, 163.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 13.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 499.000, 148.000+posisibaru, "LD_DUAL:white");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 2.000, 19.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_YELLOW);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 151.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.600, 2.000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 11.500, 12.500);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], C_YELLOW);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 153.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.130, 0.599);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 143.000+posisibaru, "Bank");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 508.000, 152.000+posisibaru, "!");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.300, 0.999);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 601.000, -10.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 707938303);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 2);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 7)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 19.000, 6.000+posisichat, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.129, 0.799);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 259.000, -1.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 140);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	return true;
}
