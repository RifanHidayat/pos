import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/pelanggan/list_pelanggan_controller.dart';
import 'package:siscom_pos/model/pelanggan/list_pelanggan_model.dart';
import 'package:siscom_pos/screen/pelanggan/detail_pelanggan_view.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/screen/stockopname/tambah_stok_opname.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/search.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';
import 'package:get/get.dart';

class ListPelangganView extends StatefulWidget {
  @override
  _ListPelangganViewState createState() => _ListPelangganViewState();
}

class _ListPelangganViewState extends State<ListPelangganView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var controller = Get.put(ListPelangganViewController());

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
                        List<ListPelangganModel> filter =
                            controller.listPelangganMaster.where((element) {
                          var namaPelanggan =
                              element.namaPelanggan!.toLowerCase();

                          return namaPelanggan.contains(textCari);
                        }).toList();
                        setState(() {
                          controller.listPelanggan.value = filter;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: statusView()),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: listPelanggan(),
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
                  "Pelanggan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Utility.medium),
                ),
              )),
          Expanded(flex: 20, child: SizedBox()),
        ],
      ),
    );
  }

  Widget statusView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Button1(
          colorBtn: controller.statusMember.value == 0
              ? Utility.primaryDefault
              : Utility.baseColor2,
          textBtn: "Member",
          style: 1,
          colorText: controller.statusMember.value == 0
              ? Utility.baseColor2
              : Utility.primaryDefault,
          onTap: () {
            setState(() {
              if (controller.statusMember.value == 1) {
                controller.statusMember.value = 0;
                controller.statusMember.refresh();
                controller.listPelanggan.value = controller.listPelangganMaster
                    .where((element) => element.status == "Y")
                    .toList();
                controller.listPelanggan.refresh();
              }
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Button1(
            colorBtn: controller.statusMember.value == 1
                ? Utility.primaryDefault
                : Utility.baseColor2,
            textBtn: "Non Member",
            style: 1,
            colorText: controller.statusMember.value == 1
                ? Utility.baseColor2
                : Utility.primaryDefault,
            onTap: () {
              setState(() {
                if (controller.statusMember.value == 0) {
                  controller.statusMember.value = 1;
                  controller.statusMember.refresh();
                  controller.listPelanggan.value = controller
                      .listPelangganMaster
                      .where((element) => element.status == "")
                      .toList();
                  controller.listPelanggan.refresh();
                }
              });
            },
          ),
        )
      ],
    );
  }

  Widget listPelanggan() {
    return controller.listPelanggan.isEmpty &&
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
        : controller.listPelanggan.isEmpty &&
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
                      "Data Pelanggan kosong",
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
                  if (controller.statusMember.value == 2) {
                    controller.getProsesListPelanggan();
                    controller.statusMember.value = 0;
                    controller.statusMember.refresh();
                  } else {
                    controller.page.value = 10;
                    controller.page.refresh();
                  }
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
                    physics: controller.listPelanggan.length <= 10
                        ? AlwaysScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    itemCount:
                        controller.listPelanggan.length > controller.page.value
                            ? controller.page.value
                            : controller.listPelanggan.length,
                    itemBuilder: (context, index) {
                      var kodePelanggan =
                          controller.listPelanggan[index].kodePelanggan;
                      var namaPelanggan =
                          controller.listPelanggan[index].namaPelanggan;
                      var status = controller.listPelanggan[index].status;
                      var nomorTelpon =
                          controller.listPelanggan[index].nomorTelpon;
                      var point = controller.listPelanggan[index].totalPoint;

                      return InkWell(
                        onTap: () =>
                            controller.detailPelangganView(kodePelanggan),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 20,
                                    child: Image.asset(
                                      "assets/Avatar.png",
                                      height: 50,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 70,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Text("$namaPelanggan"),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 10,
                                                child: Image.asset(
                                                  "assets/award.png",
                                                  height: 15,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 3),
                                                  child: Text(
                                                    "$point",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Utility.normal),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  child: Icon(
                                                    Icons.fiber_manual_record,
                                                    size: 12,
                                                    color: Utility.nonAktif,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 30,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 3),
                                                  child: status == 1
                                                      ? Text(
                                                          "Member",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Utility
                                                                  .normal),
                                                        )
                                                      : Text(
                                                          "Non Member",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Utility
                                                                  .normal),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  child: Icon(
                                                    Icons.fiber_manual_record,
                                                    size: 12,
                                                    color: Utility.nonAktif,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 40,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 3),
                                                  child: Text(
                                                    "$nomorTelpon",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Utility.normal),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(Iconsax.arrow_right_3)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Utility.medium,
                            ),
                            Divider()
                          ],
                        ),
                      );
                    }),
              );
  }
}
