import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/laporan/lap_rekap_penjualan.dart';
import 'package:siscom_pos/screen/laporan/lap_ringkasan_penjualan.dart';
import 'package:siscom_pos/screen/pelanggan/detail_pelanggan_view.dart';
import 'package:siscom_pos/screen/pengaturan/setting_akun.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/detail_stock_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class MainPengaturan extends StatefulWidget {
  @override
  _MainPengaturanState createState() => _MainPengaturanState();
}

class _MainPengaturanState extends State<MainPengaturan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(ListPelangganViewController());
  var sidebarCt = Get.put(SidebarController());

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
          key: _scaffoldKey,
          drawer: Sidebar(),
          backgroundColor: Utility.baseColor2,
          body: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    SizedBox(
                      height: Utility.medium + Utility.medium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: screenLine1(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: screenListPengaturan(),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Utility.baseColor2,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: MediaQuery.of(Get.context!).size.width,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => _scaffoldKey.currentState!.openDrawer(),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.menu_14,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 60,
              child: Center(
                child: Text(
                  "Pengaturan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(flex: 20, child: SizedBox()),
        ],
      ),
    );
  }

  Widget screenLine1() {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () {
          Get.to(SettingAkun(),
              duration: Duration(milliseconds: 300),
              transition: Transition.rightToLeftWithFade);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 30,
              child: Image.asset(
                "assets/Image.png",
                height: 50,
              ),
            ),
            Expanded(
              flex: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${sidebarCt.emailPengguna.value}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Nama cabang",
                    style: TextStyle(color: Utility.nonAktif),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Center(
                child: Icon(Iconsax.arrow_right_3),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget screenListPengaturan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Utility.medium,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: Icon(Iconsax.profile_2user),
            ),
            Expanded(
              flex: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "Default Salesman & Pelanggan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Icon(Iconsax.arrow_right_3),
            ),
          ],
        ),
        Divider(),
        SizedBox(
          height: Utility.medium,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: Icon(Iconsax.unlock),
            ),
            Expanded(
              flex: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "Ubah Kata Sandi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Icon(Iconsax.arrow_right_3),
            ),
          ],
        )
      ],
    );
  }
}
