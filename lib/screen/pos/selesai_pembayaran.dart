import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/pembayaran_controller.dart';
import 'package:siscom_pos/screen/pos/detail_struk.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

import 'package:siscom_pos/utils/widget/separator.dart';

class SelesaiPembayaran extends StatefulWidget {
  @override
  _SelesaiPembayaranState createState() => _SelesaiPembayaranState();
}

class _SelesaiPembayaranState extends State<SelesaiPembayaran> {
  var pembayaranCt = Get.put(PembayaranController());
  var dashboardCt = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Utility.primaryDefault,
          body: WillPopScope(
            onWillPop: () async {
              // Get.back();
              return false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 30, top: 30),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment.topCenter,
                                  image: AssetImage(
                                      'assets/selesai_pembayaran.png'),
                                  fit: BoxFit.fill)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Utility.medium,
                            ),
                            Center(
                              child: Image.asset(
                                  "assets/icon_selesai_pembayaran.png",
                                  width: 70),
                            ),
                            SizedBox(
                              height: Utility.verySmall,
                            ),
                            Center(
                              child: Text(
                                "Sukses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Utility.large),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Pembayaran berhasil dilakukan",
                                style: TextStyle(color: Utility.greyLight300),
                              ),
                            ),
                            SizedBox(
                              height: Utility.small,
                            ),
                            // ignore: prefer_const_constructors
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: MySeparator(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: Utility.extraLarge + 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: Text(
                                          "Total Tagihan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 60,
                                        child: Text(
                                          "${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Utility.grey900,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Utility.medium,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: pembayaranCt
                                                    .buttonPilihBayar.value ==
                                                1
                                            ? Text(
                                                "Qris",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                pembayaranCt
                                                    .tipePembayaranSelected
                                                    .value,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                      Expanded(
                                        flex: 60,
                                        child: Text(
                                          "${currencyFormatter.format(pembayaranCt.totalPembayaran.value)}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Utility.grey900,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Utility.verySmall,
                                  ),
                                  Divider(
                                    height: 5,
                                    color: Utility.greyLight300,
                                  ),
                                  SizedBox(
                                    height: Utility.large,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: Text("Kembalian",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        flex: 60,
                                        child: Text(
                                          "${currencyFormatter.format(Utility.pengurangan("${pembayaranCt.totalPembayaran.value}", "${pembayaranCt.totalTagihan.value}"))}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: CardCustom(
                      colorBg: Colors.white,
                      radiusBorder: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      widgetCardCustom: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Utility.small,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        pembayaranCt.viewScreenShootDetailStruk
                                            .value = false;
                                        Get.to(
                                            DetailStruk(
                                              typeStrukDetail: "kirim_struk",
                                            ),
                                            transition: Transition.leftToRight,
                                            duration:
                                                Duration(milliseconds: 500));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.send_2,
                                            color: Utility.greyDark,
                                            size: 26,
                                          ),
                                          SizedBox(
                                            height: Utility.small,
                                          ),
                                          Text(
                                            "Kirim Struk",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        pembayaranCt.viewScreenShootDetailStruk
                                            .value = false;
                                        Get.to(
                                            DetailStruk(
                                              typeStrukDetail: "cetak_struk",
                                            ),
                                            transition: Transition.leftToRight,
                                            duration:
                                                Duration(milliseconds: 500));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.receipt_item,
                                            color: Utility.greyDark,
                                            size: 26,
                                          ),
                                          SizedBox(
                                            height: Utility.small,
                                          ),
                                          Text(
                                            "Cetak Struk",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        pembayaranCt.viewScreenShootDetailStruk
                                            .value = false;
                                        Get.to(
                                            DetailStruk(
                                              typeStrukDetail: "cetak_pesanan",
                                            ),
                                            transition: Transition.leftToRight,
                                            duration:
                                                Duration(milliseconds: 500));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.receipt_2,
                                            color: Utility.greyDark,
                                            size: 26,
                                          ),
                                          SizedBox(
                                            height: Utility.small,
                                          ),
                                          Text(
                                            "Cetak Pesanan",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Utility.medium,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Button1(
                                  colorBtn: Utility.primaryDefault,
                                  textBtn: "Transaksi Baru",
                                  onTap: () => pembayaranCt.transkasiBaru()),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
