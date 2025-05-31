//======== Bus ===========
#define buspoint1 1798.9950,-1854.7810,13.5145
#define buspoint2 1773.7786,-1824.7504,13.4863
#define buspoint3 1692.3334,-1759.4811,13.4855
#define buspoint4 1580.7076,-1729.6924,13.4837
#define buspoint5 1482.4590,-1730.0825,13.4825
#define buspoint6 1315.2394,-1692.1278,13.4834
#define buspoint7 1359.4193,-1426.2505,13.4881
#define buspoint8 1285.9905,-1392.9310,13.3387
#define buspoint9 1262.2926,-1306.0964,13.2758
#define buspoint10 1204.0037,-1277.6254,13.4709
#define buspoint11 1056.2905,-1393.3640,13.5578
#define buspoint12 673.5746,-1393.2981,13.5235
#define buspoint13 640.6831,-1336.5730,13.4740
#define buspoint14 575.5997,-1222.2740,17.6564
#define buspoint15 182.3321,-1498.2235,12.5644
#define buspoint16 138.2634,-1733.1224,6.6786
#define buspoint17 342.1447,-1766.0835,5.1435
#define buspoint18 549.0898,-1735.4104,12.6288
#define buspoint19 860.8959,-1787.9280,13.8340
#define buspoint20 1032.1962,-1822.3572,13.7990
#define buspoint21 1256.9468,-1854.8379,13.4836
#define buspoint22 1571.3000,-1841.1418,13.4832
#define buspoint23 1683.5011,-1734.8127,13.4926
#define buspoint24 1819.0847,-1776.7307,13.4836
#define buspoint25 1820.4408,-1857.4905,13.5158
#define buspoint26 1805.3654,-1889.3640,13.5043
#define buspoint27 1796.8890,-1926.5873,13.5219

new BusVeh[4];

AddBusVehicle()
{
	BusVeh[0] = AddStaticVehicleEx(431, 1783.2988, -1866.8995, 13.7321, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[1] = AddStaticVehicleEx(431, 1768.0518, -1867.0270, 13.7337, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[2] = AddStaticVehicleEx(431, 1753.2810, -1866.9797, 13.7366, 0.0000, -1, -1, VEHICLE_RESPAWN);
	BusVeh[3] = AddStaticVehicleEx(431, 1738.4994, -1867.0083, 13.7330, 0.0000, -1, -1, VEHICLE_RESPAWN);
}

IsABusVeh(carid)
{
	for(new v = 0; v < sizeof(BusVeh); v++) {
	    if(carid == BusVeh[v]) return 1;
	}
	return 0;
}
