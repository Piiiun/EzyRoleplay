CMD:aboutayam(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_AYAM, DIALOG_STYLE_LIST, "Butcher Menu", "Lokasi Jual Ayam\nLokasi Ambil Ayam", "Select", "Close");
    return 1;
}

CMD:ambilayam(playerid, params[])
{
	new total = pData[playerid][AyamHidup];
	if(total > 50) return Error(playerid, "Ayam Hidup terlalu penuh di Inventory! Maximal 50.");
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][AyamHidup] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Hidup!");
	if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 156.6945,-1499.9636,12.3485))
		{
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			{

				TogglePlayerControllable(playerid, 0);
				SuccesMsg(playerid, "Anda sedang mengambil ayam !");
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
				pData[playerid][pGetChicken1Status] = 1;
				pData[playerid][pGetChicken1] = SetTimerEx("getchicken1", 500, true, "id", playerid, 1);
				ShowProgressbar(playerid, "Mengambil...", 11);
			}

		}
	}
	return 1;
}

function getchicken1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pGetChicken1Status] != 1) return 0;
	if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, 156.6945,-1499.9636,12.3485))
			{
					SuccesMsg(playerid, "Anda telah berhasil mengambil Ayam.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Terambil!");
					pData[playerid][AyamHidup] += 1;
					KillTimer(pData[playerid][pGetChicken1]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					//SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
			else
			{
				KillTimer(pData[playerid][pGetChicken1]);
				pData[playerid][pGetChicken1Status] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, 156.6945,-1499.9636,12.3485))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
			}
		}
	}
	return 1;
}

CMD:potongayam(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 155.8964,-1512.2314,12.1621))
	{
		if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
		if(pData[playerid][AyamPotong] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Potong!");
		if(pData[playerid][AyamHidup] < 1)
			return Error(playerid, "Kamu Tidak Mengambil Ayam.");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
		{
			TogglePlayerControllable(playerid, 0);
			SuccesMsg(playerid, "Anda sedang Memotong Ayam!");
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pFryChicken1Status] = 1;
			pData[playerid][pFryChicken1] = SetTimerEx("frychicken1", 1000, true, "id", playerid, 1);
			ShowProgressbar(playerid, "Memotong...", 21);
		}
	}
  	return 1;
}

function frychicken1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pFryChicken1Status] != 1) return 0;
	if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 155.8964,-1512.2314,12.1621))
			{
					SuccesMsg(playerid, "Anda telah berhasil Memotong Ayam.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Selesai!");
					pData[playerid][AyamPotong] += 5;
                    pData[playerid][AyamHidup] -= 1;
					KillTimer(pData[playerid][pFryChicken1]);
					pData[playerid][pFryChicken1Status] = 0;
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					//SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
			else
			{
				KillTimer(pData[playerid][pFryChicken1]);
				pData[playerid][pFryChicken1Status] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 155.8964,-1512.2314,12.1621))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}
CMD:packingayam(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 173.7471,-1481.2899,12.6098))
	{
		if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
		if(pData[playerid][AyamPotong] < 3)
			return Error(playerid, "Anda Butuh 3 Ayam Potong.");
		if(pData[playerid][AyamFillet] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Fillet!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
		{
			TogglePlayerControllable(playerid, 0);
			SuccesMsg(playerid, "Anda sedang Membungkus Ayam!");
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pPackingChicken1Status] = 1;
			pData[playerid][pPackingChicken1] = SetTimerEx("packingchicken1", 1000, true, "id", playerid, 1);
			ShowProgressbar(playerid, "Membungkus...", 21);
		}
	}
	return 1;
}
function packingchicken1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pPackingChicken1Status] != 1) return 0;
	if(pData[playerid][pJob] != 11 && pData[playerid][pJob2] != 11) return Error(playerid, "Kamu bukan Pemotong Ayam");
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 173.7471,-1481.2899,12.6098))
			{
					SuccesMsg(playerid, "Anda Berhasil Membukus ayam , Jual ke pedagang untuk mendapatkan hasih.");
					TogglePlayerControllable(playerid, 1);
					InfoTD_MSG(playerid, 8000, "Selesai!");
                    pData[playerid][AyamFillet] += 1;
                    pData[playerid][AyamPotong] -= 3;
					KillTimer(pData[playerid][pPackingChicken1]);
					pData[playerid][pPackingChicken1Status] = 0;
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					//SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
			else
			{
				KillTimer(pData[playerid][pPackingChicken1]);
				pData[playerid][pPackingChicken1Status] = 0;
				pData[playerid][pActivityTime] = 0;
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				return 1;
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 173.7471,-1481.2899,12.6098))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:jualayam(playerid, params[])
{

	if(!IsPlayerInRangeOfPoint(playerid, 3.5, 900.7999,-1204.5083,16.9832))
		return Error(playerid, "Kamu Tidak Berada Di Market Kota!");
	
	if(pData[playerid][AyamFillet] < 1) return Error(playerid, "You dont have ayam!");
	new pay = pData[playerid][AyamFillet] * 9;
	new total = pData[playerid][AyamFillet];
	GivePlayerMoneyEx(playerid, pay);
	AyamFill += total;
	Server_MinMoney(pay);

	Info(playerid, "You selling "RED_E"%d kg "WHITE_E"ayam to "GREEN_E"%s", total, FormatMoney(pay));
    InfoTD_MSG(playerid, 8000, "Paket Terjual");
	pData[playerid][AyamFillet] = 0;
	return 1;
}
