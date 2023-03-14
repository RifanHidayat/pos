import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/detail_stock_opname.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
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

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.startLoad();
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
            child: Column(
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
                    isFilter: true,
                    onTap: (value) {},
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                    child: RefreshIndicator(
                        color: Utility.primaryDefault,
                        onRefresh: refreshData,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: listStokOpnameView(),
                        )))
              ],
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
              onTap: () {
                Get.to(TambahStokOpname());
              },
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
            : ListView.builder(
                physics: controller.listStokOpname.length <= 10
                    ? AlwaysScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                itemCount: controller.listStokOpname.length,
                itemBuilder: (context, index) {
                  var nomorFaktur = controller.listStokOpname[0].nomorFaktur;
                  var kodeCabang = controller.listStokOpname[0].kodeCabang;
                  var namaCabang = controller.listStokOpname[0].namaCabang;
                  var kodeGudang = controller.listStokOpname[0].kodeGudang;
                  var namaGudang = controller.listStokOpname[0].namaGudang;
                  var tanggal = controller.listStokOpname[0].tanggal;

                  return InkWell(
                    onTap: () {
                      Get.to(DetailStokOpname());
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
                                          text: "$kodeCabang-$namaCabang",
                                          color: Utility.grey600,
                                          size: 10.0,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextLabel(
                                            text: "$kodeGudang-$namaGudang",
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
                                                  "${Utility.convertDate5('$tanggal')}",
                                              color: Utility.grey600),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_forward_ios,
                                              size: 20, color: Utility.grey600)
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
                });
  }

  void detailItem() {
    showModalBottomSheet<String>(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return MediaQuery(
                data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabel(
                                      text: "Apple iphone 13 pro max 128GB",
                                      weigh: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextLabel(
                                      text: "002- Gudang bahan baku",
                                      color: Utility.grey900,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 20,
                                  child: InkWell(
                                    onTap: () => Get.back(),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.close,
                                            color: Utility.grey900)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Gudang",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "Nama Gudang",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Stock",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "100000",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Fisik",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "Nama Gudang",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Utility.grey100)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabel(
                                        text: "Selisih",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextLabel(
                                        text: "100000",
                                        weigh: FontWeight.bold,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Utility.primaryDefault),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                      child: TextLabel(
                                    text: "Hapus",
                                    color: Utility.primaryDefault,
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Utility.primaryDefault,
                                      border: Border.all(
                                          width: 1,
                                          color: Utility.primaryDefault),
                                      borderRadius: BorderRadius.circular(3)),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                      child: TextLabel(
                                    text: "Simpan",
                                    color: Colors.white,
                                  )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }
}
