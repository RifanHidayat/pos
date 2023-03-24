import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/laporan/lap_ringkasan_penjualan_ct.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/screen/pelanggan/detail_pelanggan_view.dart';
import 'package:siscom_pos/screen/sidebar.dart';

import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class LaporanRingkasanPenjualan extends StatefulWidget {
  @override
  _LaporanRingkasanPenjualanState createState() =>
      _LaporanRingkasanPenjualanState();
}

class _LaporanRingkasanPenjualanState extends State<LaporanRingkasanPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(LaporanRingkasanPenjualanController());

  @override
  void initState() {
    // controller.startLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Utility.baseColor2,
          appBar: AppBar(
              backgroundColor: Utility.baseColor2,
              automaticallyImplyLeading: false,
              elevation: 2,
              flexibleSpace: AppbarMenu1(
                title: "Ringkasan Penjualan",
                icon: 1,
                colorTitle: Colors.black,
                onTap: () {
                  Get.back();
                },
              )),
          body: WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Utility.medium,
                        ),
                        screenRingkasan1(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        screenRingkasan2(),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget screenRingkasan1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FIELD CABANG DAN TANGGAL ( FILTER )
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 60,
              child: CardCustom(
                colorBg: Utility.baseColor2,
                radiusBorder: Utility.borderStyle1,
                widgetCardCustom: Padding(
                  padding: EdgeInsets.all(8),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "cabang",
                                style: TextStyle(fontSize: Utility.small),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Nama Cabang",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 20,
                            child: Center(
                              child: Icon(Iconsax.arrow_down_1),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CardCustom(
                  colorBg: Utility.baseColor2,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding:
                        EdgeInsets.only(left: 8, top: 16, bottom: 14, right: 8),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 15,
                            child: Center(
                              child: Icon(Iconsax.calendar_1),
                            ),
                          ),
                          Expanded(
                            flex: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "${DateFormat('MM').format(DateTime.now())}, ${DateFormat('yyyy').format(DateTime.now())}")
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Center(
                              child: Icon(Iconsax.arrow_down_1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: Utility.medium,
        ),

        // FIELD INFORMASI NOMINAL

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Penjualan",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 130.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Diskon Transaksi",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 4.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Service Charge",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 4.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Transaksi",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 130.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Diskon Produk",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 4.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Pajak",
                    style: TextStyle(
                        fontSize: Utility.normal, color: Utility.nonAktif),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Rp. 4.000.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget screenRingkasan2() {
    return CardCustom(
      colorBg: Utility.baseColor2,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  controller.bestSellerView.value =
                      !controller.bestSellerView.value;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 80,
                    child: Text(
                      "Top 5 Best Seller",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Utility.medium),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: !controller.bestSellerView.value
                          ? Icon(Iconsax.arrow_right_3)
                          : Icon(Iconsax.arrow_up_2),
                    ),
                  )
                ],
              ),
            ),
            !controller.bestSellerView.value
                ? SizedBox()
                : SizedBox(
                    height: Utility.medium,
                  ),
            !controller.bestSellerView.value
                ? SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Charger Type C",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.nonAktif),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Handphone Samsung A7",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.nonAktif),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Laptop Apple MacBook Pro",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.nonAktif),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Handphone Samsung S10",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.nonAktif),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Handphone Samsung S10",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.nonAktif),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "1,470",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utility.nonAktif),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "1,470",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utility.nonAktif),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "1,470",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utility.nonAktif),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "1,470",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utility.nonAktif),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "1,470",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utility.nonAktif),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
