// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/screen/pos/arsip_faktur.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/screen/pos/scan_barang.dart';
import 'package:siscom_pos/screen/sidebar.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final controller = Get.put(DashbardController());
  var globalController = Get.put(GlobalController());
  var buttomSheetProduk = Get.put(BottomSheetPos());
  var arsipCt = Get.put(ArsipFakturController());

  late FocusNode myFocusNode;

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    // controller.getMenu("GN.");
  }

  @override
  void initState() {
    controller.startLoad('');
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerDashboard(),
                        SizedBox(
                          height: Utility.small,
                        ),
                        setHeader(),
                        SizedBox(
                          height: Utility.verySmall,
                        ),
                        Divider(),
                        SizedBox(
                          height: Utility.verySmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.nomorFaktur.value == "-"
                                            ? Text(
                                                "No Faktur : ${controller.nomorFaktur.value}",
                                                style: TextStyle(
                                                    color: Utility.greyDark,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "No Faktur : ${Utility.convertNoFaktur(controller.nomorFaktur.value)}",
                                                style: TextStyle(
                                                    color: Utility.greyDark,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        Text(
                                          "${controller.listMenu.value.length} Barang",
                                          style: TextStyle(
                                              color: Utility.nonAktif,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Utility.small),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () =>
                                          controller.changeTampilanList(),
                                      child: Icon(
                                        Iconsax.element_3,
                                        color: Utility.greyDark,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Utility.verySmall,
                        ),
                        Flexible(
                          child: controller.listMenu.value.isEmpty
                              ? Center(
                                  child: Text(controller.loadingString.value),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: listMenuScreen(),
                                ),
                        )
                      ],
                    ),
                  )),
              bottomNavigationBar: Obx(
                () => controller.nomorFaktur.value == "-"
                    ? controller.viewButtonKeranjang.value == false
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 12),
                            child: Container(
                                height: 50,
                                child: Button2(
                                    textBtn: "Buat Faktur",
                                    colorBtn: Utility.primaryDefault,
                                    colorText: Colors.white,
                                    icon1: Icon(
                                      Iconsax.add,
                                      color: Utility.baseColor2,
                                    ),
                                    radius: 8.0,
                                    style: 2,
                                    onTap: () {
                                      if (controller
                                                  .kodePelayanSelected.value ==
                                              "" ||
                                          controller.customSelected.value ==
                                              "" ||
                                          controller.cabangKodeSelected.value ==
                                              "") {
                                        UtilsAlert.showToast(
                                            "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
                                      } else {
                                        controller.keteranganInsertFaktur.value
                                            .text = "";
                                        globalController
                                            .buttomSheetInsertFaktur();
                                      }
                                    })),
                          )
                    : Obx(
                        () => Padding(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 12),
                          child: controller.viewButtonKeranjang.value ==
                                      false ||
                                  controller.jumlahItemDikeranjang.value == 0
                              ? SizedBox()
                              : SizedBox(
                                  height: 50,
                                  child: Button4(
                                      totalItem:
                                          "${controller.jumlahItemDikeranjang.value}",
                                      totalAll: Text(
                                        "${globalController.convertToIdr(controller.totalNominalDikeranjang.value, 2)}",
                                        style: TextStyle(
                                            color: Utility.baseColor2),
                                      ),
                                      onTap: () {
                                        controller.hitungAllArsipMenu();
                                        Get.to(RincianPemesanan(),
                                            duration:
                                                Duration(milliseconds: 500),
                                            transition: Transition.zoom);
                                      },
                                      colorButton: Utility.primaryDefault,
                                      colortext: Utility.baseColor2,
                                      border: BorderRadius.circular(8.0),
                                      icon: Icon(
                                        Iconsax.add,
                                        color: Utility.baseColor2,
                                      )),
                                ),
                        ),
                      ),
              )),
        ),
      ),
    );
  }

  Widget headerDashboard() {
    return SizedBox(
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
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Iconsax.menu_14,
                  ),
                ),
              )),
          Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: pencarianData(),
              )),
          Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: InkWell(
                    onTap: () => Get.to(ScanBarang()),
                    child: Icon(Iconsax.scan_barcode)),
              )),
          Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: InkWell(
                    onTap: () {
                      Get.to(ArsipFaktur());
                    },
                    child: Icon(Iconsax.menu_board)),
              )),
        ],
      ),
    );
  }

  Widget setHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CardCustom(
                  colorBg: controller.listKeranjangArsip.value.isEmpty &&
                          controller.nomorFaktur.value == "-"
                      ? Utility.baseColor2
                      : Utility.greyLight100,
                  radiusBorder: Utility.borderStyle1,
                  widgetCardCustom: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.5),
                                    child: Icon(
                                      Iconsax.buildings_2,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: InkWell(
                                    onTap: () {
                                      if (controller.listKeranjangArsip.value
                                              .isEmpty &&
                                          controller.nomorFaktur.value == "-") {
                                        globalController.buttomSheet1(
                                            controller.listCabang.value,
                                            "Pilih Cabang",
                                            "dashboard",
                                            controller
                                                .cabangNameSelected.value);
                                      } else {
                                        print("sudah pilih jldt");
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Cabang",
                                            style: TextStyle(
                                                color: Utility.nonAktif,
                                                fontSize: Utility.small),
                                          ),
                                          Text(
                                            "${controller.cabangNameSelected.value}"
                                                        .length >
                                                    8
                                                ? "${controller.cabangNameSelected.value}"
                                                        .substring(0, 8) +
                                                    '..'
                                                : "${controller.cabangNameSelected.value}",
                                            style: TextStyle(
                                                color: Utility.greyDark,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 18,
                                      color: Utility.nonAktif,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Container(
                              width: 1.5,
                              color: Color.fromARGB(24, 0, 22, 103),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.5),
                                    child: Icon(
                                      Iconsax.user,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: InkWell(
                                    onTap: () {
                                      var stringJudul = AppData.bidUsaha == "0"
                                          ? "Pilih Sales"
                                          : "Pilih Pelayan";
                                      if (controller.listKeranjangArsip.value
                                              .isEmpty &&
                                          controller.nomorFaktur.value == "-") {
                                        if (controller
                                            .listSalesman.value.isNotEmpty) {
                                          globalController.buttomSheet1(
                                              controller.listSalesman.value,
                                              stringJudul,
                                              "dashboard",
                                              controller.pelayanSelected.value);
                                        } else {
                                          UtilsAlert.showToast(
                                              "Harap hubungi admin untuk setting pelayan");
                                        }
                                      } else {
                                        print("sudah pilih jldt");
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppData.bidUsaha == "0"
                                              ? Text(
                                                  "Sales",
                                                  style: TextStyle(
                                                      color: Utility.nonAktif,
                                                      fontSize: Utility.small),
                                                )
                                              : Text(
                                                  "Dilayani Oleh",
                                                  style: TextStyle(
                                                      color: Utility.nonAktif,
                                                      fontSize: Utility.small),
                                                ),
                                          Text(
                                            "${controller.pelayanSelected.value}"
                                                        .length >
                                                    8
                                                ? "${controller.pelayanSelected.value}"
                                                        .substring(0, 8) +
                                                    '..'
                                                : "${controller.pelayanSelected.value}",
                                            style: TextStyle(
                                                color: Utility.greyDark,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 18,
                                      color: Utility.nonAktif,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Container(
                              width: 1.5,
                              color: Color.fromARGB(24, 0, 22, 103),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.5),
                                    child: Icon(
                                      Iconsax.profile_2user,
                                      color: Utility.primaryDefault,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 40,
                                  child: InkWell(
                                    onTap: () {
                                      if (controller.listKeranjangArsip.value
                                              .isEmpty &&
                                          controller.nomorFaktur.value == "-") {
                                        if (controller.pelayanSelected.value ==
                                            "Data pelayan kosong") {
                                          UtilsAlert.showToast(
                                              "Harap pilih sales terlebih dahulu...");
                                        } else if (controller
                                            .listPelanggan.value.isNotEmpty) {
                                          globalController.buttomSheet1(
                                              controller.listPelanggan.value,
                                              "Pilih Pelanggan",
                                              "dashboard",
                                              controller.namaPelanggan.value);
                                        } else {
                                          UtilsAlert.showToast(
                                              "Harap hubungi admin untuk setting pelayan dan pelanggan");
                                        }
                                      } else {
                                        print("sudah pilih jldt");
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pelanggan",
                                            style: TextStyle(
                                                color: Utility.nonAktif,
                                                fontSize: Utility.small),
                                          ),
                                          Text(
                                            "${controller.namaPelanggan.value}"
                                                        .length >
                                                    8
                                                ? "${controller.namaPelanggan.value}"
                                                        .substring(0, 8) +
                                                    '..'
                                                : "${controller.namaPelanggan.value}",
                                            style: TextStyle(
                                                color: Utility.greyDark,
                                                fontSize: Utility.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 18,
                                      color: Utility.nonAktif,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: Utility.small,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //   flex: 20,
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 3),
              //     child: InkWell(
              //       onTap: () {
              //         controller.aktifButton.value = 1;
              //         this.controller.aktifButton.refresh();
              //       },
              //       child: CardCustom(
              //         colorBg: controller.aktifButton.value == 1
              //             ? Utility.infoLight100
              //             : Colors.white,
              //         radiusBorder: Utility.borderStyle1,
              //         widgetCardCustom: Padding(
              //           padding: const EdgeInsets.all(6.0),
              //           child: Center(
              //             child: Icon(Iconsax.heart),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 20,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 3, right: 3),
              //     child: InkWell(
              //       onTap: () {
              //         controller.aktifButton.value = 2;
              //         this.controller.aktifButton.refresh();
              //       },
              //       child: CardCustom(
              //         colorBg: controller.aktifButton.value == 2
              //             ? Utility.infoLight100
              //             : Colors.white,
              //         radiusBorder: Utility.borderStyle1,
              //         widgetCardCustom: Padding(
              //           padding: const EdgeInsets.all(6.0),
              //           child: Center(
              //             child: Icon(Iconsax.discount_shape),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: InkWell(
                    onTap: () {
                      globalController.buttomSheet1(
                          controller.listKelompokBarang.value,
                          "Pilih Kategori",
                          "dashboard",
                          controller.kategoriBarang.value);
                      controller.aktifButton.value = 3;
                      controller.aktifButton.refresh();
                    },
                    child: CardCustom(
                      colorBg: controller.aktifButton.value == 3
                          ? Utility.infoLight100
                          : Colors.white,
                      radiusBorder: Utility.borderStyle1,
                      widgetCardCustom: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 90,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    "${controller.kategoriBarang.value}"
                                                .length >
                                            20
                                        ? "${controller.kategoriBarang.value}"
                                                .substring(0, 20) +
                                            '...'
                                        : "${controller.kategoriBarang.value}",
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Icon(
                                    Iconsax.arrow_down_1,
                                    size: 18,
                                    color: Utility.nonAktif,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget pencarianData() {
    return CardCustom(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Iconsax.search_normal_1,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 80,
                      child: TextField(
                        focusNode: myFocusNode,
                        controller: controller.cari.value,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari"),
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 14.0, height: 1.5, color: Colors.black),
                        onSubmitted: (value) {
                          controller.pencarianDataBarang(value);
                        },
                      ),
                    ),
                    !controller.statusCari.value
                        ? SizedBox()
                        : Expanded(
                            flex: 20,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";
                                controller.aksiPilihKategoriBarang();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listMenuScreen() {
    return NotificationListener(
      onNotification: (notificationInfo) {
        if (notificationInfo is ScrollStartNotification) {
          controller.mulaiScroll();
        } else if (notificationInfo is ScrollEndNotification) {
          controller.selesaiScroll();
        }
        return true;
      },
      child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          header: MaterialClassicHeader(color: Utility.primaryDefault),
          onLoading: () async {
            controller.loadMoreMenu();
          },
          controller: controller.refreshController,
          child: !controller.screenList.value
              ? tampilanGridView()
              : tampilanListVertical()),
    );
  }

  Widget tampilanGridView() {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(0),
        itemCount: controller.listMenu.value.length,
        controller: controller.controllerScroll,
        // itemCount:
        //     controller.listMenu.value.length > controller.pageLoad.value
        //         ? controller.pageLoad.value
        //         : controller.listMenu.value.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          var gambar = controller.listMenu.value[index]['NAMAGAMBAR'];
          var keyPilihBarang =
              "${controller.listMenu.value[index]['GROUP']}${controller.listMenu.value[index]['KODE']}";
          var namaBarang = controller.listMenu.value[index]['NAMA'];
          var hargaJual = controller.listMenu.value[index]['STDJUAL'];
          var stokWare = controller.listMenu.value[index]['STOKWARE'];
          var status = controller.listMenu.value[index]['status'];
          var jumlahBeli = controller.listMenu.value[index]['jumlah_beli'];
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: status == false
                ? InkWell(
                    onTap: () {
                      if (controller.nomorFaktur.value == "-") {
                        UtilsAlert.showToast(
                            "Harap buat faktur terlebih dahulu");
                      } else if (stokWare == 0 || stokWare < 0) {
                        UtilsAlert.showToast("Stock barang habis");
                      } else {
                        UtilsAlert.loadingSimpanData(
                            context, "Sedang memuat...");
                        var jual = globalController.convertToIdr(hargaJual, 0);
                        buttomSheetProduk.buttomShowCardMenu(
                            context, keyPilihBarang, jual);
                      }
                    },
                    child: CardCustom(
                        colorBg: Utility.baseColor2,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  alignment: Alignment.bottomLeft,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      image: DecorationImage(
                                          alignment: Alignment.topCenter,
                                          image:
                                              AssetImage('assets/no_image.png'),
                                          // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                          fit: BoxFit.fill)),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Utility.primaryDefault,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                      )),
                                  child: Center(
                                    child: Text(
                                      "$stokWare",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Utility.small),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Utility.small,
                            ),
                            Flexible(
                                child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 70,
                                    child: Text(
                                      "$namaBarang",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Utility.small,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 30,
                                    child: Text(
                                      "${globalController.convertToIdr(hargaJual, 0)}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Utility.grey600,
                                          fontSize: Utility.semiMedium),
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        )),
                  )
                : Stack(
                    children: [
                      InkWell(
                        child: CardCustom(
                            colorBg: Utility.baseColor2,
                            radiusBorder: Utility.borderStyle1,
                            widgetCardCustom: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 90,
                                      alignment: Alignment.bottomLeft,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          image: DecorationImage(
                                              alignment: Alignment.topCenter,
                                              image: AssetImage(
                                                  'assets/no_image.png'),
                                              // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                              fit: BoxFit.fill)),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Utility.primaryDefault,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                          )),
                                      child: Center(
                                        child: Text(
                                          "$stokWare",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Utility.small),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Utility.small,
                                ),
                                Flexible(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 70,
                                        child: Text(
                                          "$namaBarang",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: Utility.small,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 30,
                                        child: Text(
                                          "${globalController.convertToIdr(hargaJual, 0)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Utility.grey600,
                                              fontSize: Utility.semiMedium),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(Get.context!).size.height,
                        width: MediaQuery.of(Get.context!).size.width,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(174, 171, 212, 243),
                            borderRadius: Utility.borderStyle1),
                        child: Container(
                            width: 50,
                            height: 30,
                            child: Center(
                                child: Text(
                              "$jumlahBeli",
                              style: TextStyle(
                                  color: Utility.baseColor2,
                                  fontWeight: FontWeight.bold),
                            ))),
                      )
                    ],
                  ),
          );
        });
  }

  Widget tampilanListVertical() {
    return ListView.builder(
        physics: controller.listMenu.value.length <= 10
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.listMenu.value.length,
        itemBuilder: (context, index) {
          var gambar = controller.listMenu.value[index]['NAMAGAMBAR'];
          var keyPilihBarang =
              "${controller.listMenu.value[index]['GROUP']}${controller.listMenu.value[index]['KODE']}";
          var namaBarang = controller.listMenu.value[index]['NAMA'];
          var hargaJual = controller.listMenu.value[index]['STDJUAL'];
          var status = controller.listMenu.value[index]['status'];
          var stokWare = controller.listMenu.value[index]['STOKWARE'];
          var jumlah_beli = controller.listMenu.value[index]['jumlah_beli'];
          return status == false
              ? InkWell(
                  onTap: () {
                    if (controller.nomorFaktur.value == "-") {
                      UtilsAlert.showToast("Harap buat faktur terlebih dahulu");
                    } else if (stokWare == 0 || stokWare < 0) {
                      UtilsAlert.showToast("Stock barang habis");
                    } else {
                      var jual = globalController.convertToIdr(hargaJual, 0);
                      buttomSheetProduk.buttomShowCardMenu(
                          context, keyPilihBarang, jual);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardCustom(
                          colorBg: Utility.baseColor2,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardCustom: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 30,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 90,
                                          alignment: Alignment.bottomLeft,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6)),
                                              image: DecorationImage(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  image: AssetImage(
                                                      'assets/no_image.png'),
                                                  // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                                  fit: BoxFit.fill)),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: Utility.primaryDefault,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                              )),
                                          child: Center(
                                            child: Text(
                                              "$stokWare",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Utility.small),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${namaBarang}".length > 40
                                                ? "${namaBarang}"
                                                        .substring(0, 40) +
                                                    '...'
                                                : "${namaBarang}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: Utility.small,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: Utility.small,
                                          ),
                                          Text(
                                            "${globalController.convertToIdr(hargaJual, 0)}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Utility.grey600,
                                                fontSize: Utility.semiMedium),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: Utility.small,
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardCustom(
                            colorBg: Utility.baseColor2,
                            radiusBorder: Utility.borderStyle1,
                            widgetCardCustom: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 30,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 90,
                                            alignment: Alignment.bottomLeft,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6)),
                                                image: DecorationImage(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    image: AssetImage(
                                                        'assets/no_image.png'),
                                                    // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                                    fit: BoxFit.fill)),
                                          ),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Utility.primaryDefault,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                )),
                                            child: Center(
                                              child: Text(
                                                "$stokWare",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Utility.small),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${namaBarang}".length > 40
                                                  ? "${namaBarang}"
                                                          .substring(0, 40) +
                                                      '...'
                                                  : "${namaBarang}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: Utility.small,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: Utility.small,
                                            ),
                                            Text(
                                              "${globalController.convertToIdr(hargaJual, 0)}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Utility.grey600,
                                                  fontSize: Utility.semiMedium),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        SizedBox(
                          height: Utility.small,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(Get.context!).size.width,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(174, 171, 212, 243),
                          borderRadius: Utility.borderStyle1),
                      child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 30,
                          child: Center(
                              child: Text(
                            "$jumlah_beli",
                            style: TextStyle(
                                color: Utility.baseColor2,
                                fontWeight: FontWeight.bold),
                          ))),
                    )
                  ],
                );
        });
  }
}
