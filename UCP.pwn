ShowCharacterMenu(playerid) 
{
    new name[MAX_CHARACTERS * 50], count;

    for (new i; i < MAX_CHARACTERS; i ++) if(CharacterList[playerid][i][0] != EOS) {
      new feda[128];
      format(feda, sizeof feda, "%s\n", CharacterList[playerid][i]);
      strcat(name, feda);
      count++;
    }

    if(count < MAX_CHARACTERS)
      strcat(name, "{B897FF}[+] New Character");

    ShowPlayerDialog(playerid, DIALOG_SELECTCHAR, DIALOG_STYLE_LIST, "{B897FF} WARGA KOTA{FFFFFF} - Character List", name, "Select", "Quit");
    return 1;
}

function OnCharacterLoaded(playerid) 
{
    for (new i = 0; i < MAX_CHARACTERS; i ++) {
      CharacterList[playerid][i][0] = EOS;
    }

    for (new i = 0; i < cache_num_rows(); i ++) {
      cache_get_value_name(i, "username", CharacterList[playerid][i], 128);
    }

    ShowCharacterMenu(playerid);
    return 1;
}
