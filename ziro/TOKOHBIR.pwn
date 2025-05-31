#include <YSI\y_hooks>

// CORDINAT : 1215.35,-13.35,1000.92
//19823 // wiskey
//19824 // wine
//1517 // vodka
CMD:belialkohol(playerid, params[]) {
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1215.35,-13.35,1000.92))
        return SendErrorMessage(playerid, "Anda harus berada di Bahamas");

    // Tampilkan dialog list
    ShowPlayerDialog(playerid, DIALOG_BELIBIR, DIALOG_STYLE_LIST, "Pilih item yang ingin kamu beli", "Wine\nVodka\nWhiskey", "Pilih", "Tutup");
    return 1;
}
CMD:alhokol(playerid, params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1215.35,-13.35,1000.92))
        return SendErrorMessage(playerid, "Anda harus berada di Bahamas");
    ShowPlayerDialog(playerid, DIALOG_ALKOHOL, DIALOG_STYLE_LIST, "Bahamas Alkohol", "Lihat Alkohol\nBeli Alkohol", "Pilih", "Tutup");
    return 1;
}
CMD:lihatalkohol(playerid, params[]) {
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1215.35,-13.35,1000.92))
        return SendErrorMessage(playerid, "Anda harus berada di Bahamas");

    // Tampilkan dialog list
    ShowPlayerDialog(playerid, DIALOG_TOKOITEM, DIALOG_STYLE_LIST, "Pilih item yang ingin kamu lihat", "Wine\nVodka\nWhiskey", "Pilih", "Tutup");

    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if (dialogid == DIALOG_ALKOHOL) {
        if (response) { // Jika pemain menekan tombol "Pilih"
            switch (listitem) {
                case 0: { //lihat alkohol
                    ShowPlayerDialog(playerid, DIALOG_TOKOITEM, DIALOG_STYLE_LIST, "Pilih item yang ingin kamu lihat", "Wine\nVodka\nWhiskey", "Pilih", "Tutup");
                }
                case 1: { //beli alkohol
                    ShowPlayerDialog(playerid, DIALOG_BELIBIR, DIALOG_STYLE_LIST, "Pilih item yang ingin kamu beli", "Wine\nVodka\nWhiskey", "Pilih", "Tutup");
                }
            }
        }
    }
    if (dialogid == DIALOG_TOKOITEM) {
        if (response) { // Jika pemain menekan tombol "Pilih"
            switch (listitem) {
                case 0: { // Wine
                    ShowItemDetails(playerid, "Wine", 40, 20);
                }
                case 1: { // Vodka
                    ShowItemDetails(playerid, "Vodka", 60, 30);
                }
                case 2: { // Whiskey
                    ShowItemDetails(playerid, "Whiskey", 100, 50);
                }
            }
        }
    }
     if (dialogid == DIALOG_BELIBIR)
    {
        if (response) {
            switch (listitem)
            {
                case 0 :
                {
                    if (GetMoney(playerid) < 40)
                        return Error(playerid, "Kamu tidak memiliki cukup uang!", 3);
                    GiveMoney(playerid, -40);
                    Inventory_Add(playerid, "Wine", 19561, 1);
	                ShowItemBox(playerid, "Wine", "Added_1x", 19561, 2);
                }
                case 1 :
                {
                    if (GetMoney(playerid) < 60)
                        return Error(playerid, "Kamu tidak memiliki cukup uang!", 3);
                    GiveMoney(playerid, -60);
                    Inventory_Add(playerid, "Vodka", 2958, 1);
                    ShowItemBox(playerid, "Vodka", "Added_1x", 2958, 2);
                }
                case 2 :
                {
                    if (GetMoney(playerid) < 100)
                        return Error(playerid, "Kamu tidak memiliki cukup uang!", 3);
                    GiveMoney(playerid, -100);
                    Inventory_Add(playerid, "Whiskey", 2958, 1);
                    ShowItemBox(playerid, "Whiskey", "Added_1x", 2958, 2);
                }
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

ShowItemDetails(playerid, item[], price, amount) {
    new string[5000];
    // Tampilkan dialog dengan detail item
    format(string, sizeof(string), ""WHITE"Nama Botol: "WHITE"%s\nHarga: "GREEN"$%d\n"WHITE"Mengurangi Stress: "WHITE"%d", item, price, amount);
    ShowPlayerDialog(playerid, DIALOG_ITEMDETAILS, DIALOG_STYLE_MSGBOX, "Detail", string, "Tutup", "");
    
    return 1;
}
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    //alkohol
    if ((newkeys & KEY_YES)) {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 1215.35,-13.35,1000.927)) {
            ShowPlayerDialog(playerid, DIALOG_ALKOHOL, DIALOG_STYLE_LIST, "Bahamas Alkohol", "Lihat Alkohol\nBeli Alkohol", "Pilih", "Tutup");
        }
    }
    return 1;
}