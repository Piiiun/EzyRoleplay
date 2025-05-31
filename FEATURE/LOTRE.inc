#include <YSI\y_hooks>

hook OnGameModeInit()
{
    SetTimer("lottery", 1800000, true);
    return 1;
}

function lottery()
{
    new lotte = random(90);
    SendClientMessageToAllEx(-1, "{B897FF}[Lottery]{FFFFFF} Sayangnya tidak ada pemenang dalam lottery kali ini.");
    SendClientMessageToAllEx(-1, "~> Nomor Lottery yang keluar hari ini: {B897FF}%d", lotte);
    SendClientMessageToAllEx(-1, "~> Nomor Lottery Selanjutnya akan keluar dalam 30 menit kedepan");
    return 1;
}