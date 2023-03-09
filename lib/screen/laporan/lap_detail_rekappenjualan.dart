import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/laporan/lap_rekap_penjualan_ct.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';

class LaporanDetailRekapPenjualan extends StatelessWidget {
  final controller = Get.put(LaporanRekapPenjualanController());

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
                title: "Rekap Penjualan",
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
                    Flexible(child: listRekapPenjualan())
                  ],
                ),
              )),
        ),
      ),
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
                  controller.refreshDetailController.refreshCompleted();
                },
                onLoading: () async {
                  await Future.delayed(Duration(seconds: 1));
                  // controller.page.value = controller.page.value + 10;
                  controller.refreshDetailController.loadComplete();
                },
                controller: controller.refreshDetailController,
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
                          controller.detailBarang();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$title",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "$jumlah Barang",
                                        style: TextStyle(
                                            fontSize: Utility.normal,
                                            color: Utility.nonAktif),
                                      )
                                    ],
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
