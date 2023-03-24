import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/model/stok_opname/list_stok_opname.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class StockOpname extends StatefulWidget {
  @override
  _StockOpnameState createState() => _StockOpnameState();
}

class _StockOpnameState extends State<StockOpname> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(StockOpnameController());

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
          key: _scaffoldKey,
          drawer: Sidebar(),
          backgroundColor: Utility.baseColor2,
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Obx(
              () => Column(
                children: [
                  header(),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SearchApp(
                      controller: controller.pencarian.value,
                      onChange: true,
                      isFilter: false,
                      onTap: (value) {
                        var textCari = value.toLowerCase();
                        List<ListStokOpnameModel> filter =
                            controller.listStokOpnameMaster.where((element) {
                          var nomorFaktur = element.nomorFaktur!.toLowerCase();

                          return nomorFaktur.contains(textCari);
                        }).toList();
                        setState(() {
                          controller.listStokOpname.value = filter;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: listStokOpnameView(),
                  ))
                ],
              ),
            ),
          ),
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
      height: 60,
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
                  "Stok Opname",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(
            flex: 20,
            child: InkWell(
              onTap: () => controller.getLastKodeStokOpname(),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.add_square,
                  color: Utility.primaryDefault,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listStokOpnameView() {
    return controller.listStokOpname.isEmpty &&
            controller.screenLoad.value == false
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
        : controller.listStokOpname.isEmpty &&
                controller.screenLoad.value == true
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
                      "Data Stok Opname kosong",
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
                  controller.page.value = 10;
                  controller.page.refresh();
                  controller.startLoad();
                  controller.refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    controller.page.value = controller.page.value + 10;
                    controller.refreshController.loadComplete();
                  });
                },
                controller: controller.refreshController,
                child: ListView.builder(
                    physics: controller.listStokOpname.length <= 10
                        ? AlwaysScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    itemCount:
                        controller.listStokOpname.length > controller.page.value
                            ? controller.page.value
                            : controller.listStokOpname.length,
                    itemBuilder: (context, index) {
                      var nomorFaktur =
                          controller.listStokOpname[index].nomorFaktur;
                      var kodeCabang =
                          controller.listStokOpname[index].kodeCabang;
                      var namaCabang =
                          controller.listStokOpname[index].namaCabang;
                      var kodeGudang =
                          controller.listStokOpname[index].kodeGudang;
                      var namaGudang =
                          controller.listStokOpname[index].namaGudang;
                      var tanggal = controller.listStokOpname[index].tanggal;

                      return InkWell(
                        onTap: () {
                          ButtonSheetController().validasiButtonSheet(
                              "Pilih aksi",
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(right: 3.0),
                                      child: Button1(
                                        textBtn: "Hapus",
                                        colorBtn: Colors.red,
                                        colorText: Utility.baseColor2,
                                        onTap: () async {
                                          controller
                                              .hapusListStopOpname(nomorFaktur);
                                        },
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: Button1(
                                        textBtn: "Detail",
                                        colorBtn: Utility.primaryDefault,
                                        colorText: Utility.baseColor2,
                                        onTap: () async {
                                          controller.kodeGudangSelected.value =
                                              kodeGudang!;
                                          controller.namaGudangSelected.value =
                                              namaGudang!;
                                          controller.kodeGudangSelected
                                              .refresh();
                                          controller.namaGudangSelected
                                              .refresh();
                                          UtilsAlert.loadingSimpanData(
                                              Get.context!, "Sedang Memuat...");
                                          controller
                                              .beforeEnterDetailStokOpname(
                                                  nomorFaktur, "detail");
                                        },
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              "show_keterangan",
                              "",
                              () async {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextLabel(
                                              text: "$nomorFaktur",
                                              weigh: FontWeight.w700,
                                              size: 14.0,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextLabel(
                                              text: "$kodeCabang - $namaCabang",
                                              color: Utility.grey600,
                                              size: 10.0,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextLabel(
                                                text:
                                                    "$kodeGudang - $namaGudang",
                                                size: 10.0,
                                                color: Utility.grey600)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 50,
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextLabel(
                                                  text:
                                                      "${DateFormat('dd MMMM yyyy').format(DateTime.parse('$tanggal'))}",
                                                  color: Utility.grey600),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  size: 20,
                                                  color: Utility.grey600)
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
  }
}
