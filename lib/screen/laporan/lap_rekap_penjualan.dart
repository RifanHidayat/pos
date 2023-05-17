import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/laporan/lap_rekap_penjualan_ct.dart';
import 'package:siscom_pos/screen/laporan/lap_detail_rekappenjualan.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:get/get.dart';

class LaporanRekapPenjualan extends StatefulWidget {
  @override
  _LaporaRekapPenjualan createState() => _LaporaRekapPenjualan();
}

class _LaporaRekapPenjualan extends State<LaporanRekapPenjualan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(LaporanRekapPenjualanController());

  @override
  void initState() {
    controller.startLoad();
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
                title: "Laporan Penjualan",
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
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    lineRekapAndFilter(),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Obx(() => Text(
                          "${controller.listRekapPenjualan.length} Data di tampilkan",
                          style: TextStyle(color: Utility.nonAktif),
                        )),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Obx(() => Flexible(child: listRekapPenjualan()))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget lineRekapAndFilter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 20,
          child: InkWell(
            onTap: () {},
            child: CardCustom(
              margin: EdgeInsets.only(right: 10),
              colorBg: Utility.baseColor2,
              colorBorder: Colors.black,
              radiusBorder: BorderRadius.circular(30),
              widgetCardCustom: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 80,
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.filterAktif.value = 1;
                      controller.filterTanggal();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 3),
                    decoration: BoxDecoration(
                      color: controller.filterAktif.value == 1
                          ? Utility.primaryLight100
                          : Utility.baseColor2,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Utility.nonAktif,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text("Tanggal"),
                          Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.filterAktif.value = 2;
                      controller.filterPelanggan();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      color: controller.filterAktif.value == 2
                          ? Utility.primaryLight100
                          : Utility.baseColor2,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Utility.nonAktif,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text("Pelanggan"),
                          Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.filterAktif.value = 3;
                      controller.filterSales();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      color: controller.filterAktif.value == 3
                          ? Utility.primaryLight100
                          : Utility.baseColor2,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Utility.nonAktif,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text("Sales"),
                          Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      controller.filterAktif.value = 4;
                      controller.filterBarang();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    decoration: BoxDecoration(
                      color: controller.filterAktif.value == 4
                          ? Utility.primaryLight100
                          : Utility.baseColor2,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Utility.nonAktif,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text("Barang"),
                          Icon(Icons.arrow_drop_down_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget listRekapPenjualan() {
    return controller.listRekapPenjualan.isEmpty &&
            controller.screenLoad.value == true
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                color: Utility.primaryDefault,
              ),
              SizedBox(
                height: Utility.medium,
              ),
              Text(
                "Memuat data...",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ))
        : controller.listRekapPenjualan.isEmpty &&
                controller.screenLoad.value == false
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/empty.png",
                      height: 200,
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text(
                      "Data rekap penjualan kosong",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Utility.primaryDefault,
                ),
                footer: ClassicFooter(
                  loadingText: "Load More...",
                  noDataText: "Finished loading data",
                  loadStyle: LoadStyle.ShowWhenLoading,
                  loadingIcon: Icon(Iconsax.more),
                ),
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                  // controller.page.value = 10;
                  controller.refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await Future.delayed(Duration(seconds: 1));
                  // controller.page.value = controller.page.value + 10;
                  controller.refreshController.loadComplete();
                },
                controller: controller.refreshController,
                child: ListView.builder(
                    physics: controller.listRekapPenjualan.length <= 10
                        ? AlwaysScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    itemCount: controller.listRekapPenjualan.length,
                    // itemCount: controller.listRekapPenjualan.length >
                    //         controller.page.value
                    //     ? controller.page.value
                    //     : controller.listRekapPenjualan.length,
                    itemBuilder: (context, index) {
                      var title = controller.listRekapPenjualan[index].title;
                      var jumlah = controller.listRekapPenjualan[index].jumlah;
                      var total = controller.listRekapPenjualan[index].total;
                      return InkWell(
                        onTap: () {
                          Get.to(
                              LaporanDetailRekapPenjualan(
                                number: title,
                              ),
                              duration: Duration(milliseconds: 300),
                              transition: Transition.rightToLeftWithFade);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Text(
                                    Utility.convertNoFaktur(title ?? ''),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${Utility.rupiahFormat('$total', 'with_rp')}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Utility.normal,
                            ),
                            Divider()
                          ],
                        ),
                      );
                    }));
  }
}
