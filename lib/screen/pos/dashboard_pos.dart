// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:siscom_pos/components/showbuttomsheet/main_showbuttomsheet_widget.dart';

import '../../components/button/button_costum.dart';
import '../../controller/pelanggan/list_pelanggan_controller.dart';
import '../../utils/controllers/controller_implementation.dart';
import '../../utils/widget/form_scan/main_form_scan.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final controller = Get.put(DashbardController());
  final listPelangganViewController = Get.put(ListPelangganViewController());
  var globalController = Get.put(GlobalController());
  var buttomSheetProduk = Get.put(BottomSheetPos());
  var arsipCt = Get.put(ArsipFakturController());
  var buttonsheetimpl = Get.put(ButtomSheetImplementation());
  var paramimpl = ControllerImpl.paramscontrollerimpl;

  late FocusNode myFocusNode;

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    // controller.getMenu("GN.");
  }

  ScrollController? _hideButtonController;

  bool _isVisible = true;

  @override
  void initState() {
    _hideButtonController = ScrollController();
    _hideButtonController!.addListener(_scrolllistener);
    _init();
    myFocusNode = FocusNode();
    super.initState();
  }

  _init() async {
    await Future.wait([controller.startLoad('')]);
    await listPelangganViewController.startLoad();
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
              resizeToAvoidBottomInset: false,
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
                                  flex: 8,
                                  child: SizedBox(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () =>
                                            controller.changeTampilanList(),
                                        child: Icon(
                                          !controller.screenList.value
                                              ? Iconsax.element_3
                                              : Iconsax.row_vertical,
                                          color: Utility.greyDark,
                                        ),
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
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        "Tidak ada produk",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Silahkan melakukan tambah produk melalui website siscom online",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Utility.greyDark),
                                      ),
                                      Obx(() => controller.nomorFaktur.value ==
                                              "-"
                                          ? controller.viewButtonKeranjang
                                                      .value ==
                                                  false
                                              ? SizedBox()
                                              : ButtonCostum.buttontransparanst(
                                                  icon: Icons.open_in_new,
                                                  onPressed: () {},
                                                  title: 'Tambah Produk')
                                          : SizedBox())
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: listMenuScreen(),
                                ),
                        ),
                      ],
                    ),
                  )),
            )),
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
                    onTap: () => CForm().scanProduct(),
                    child: Icon(Iconsax.scan_barcode)),
              )),
          Expanded(
              flex: 15,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          controller.checkArsipFaktur();
                          Get.to(ArsipFaktur());
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 12.0),
                            child: Icon(Iconsax.menu_board))),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 30,
                    bottom: 28,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${controller.jumlahArsipFaktur.value}",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: Utility.small),
                      ),
                    ),
                  ),
                ],
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
                                          paramimpl.convert(
                                              controller.listSalesman.value);
                                          buttonsheetimpl.build(
                                              list: ControllerImpl
                                                  .paramscontrollerimpl
                                                  .data
                                                  .value,
                                              judul: stringJudul,
                                              namaSelected: controller
                                                  .pelayanSelected.value,
                                              key: 'show_entry_data_sales');
                                        } else {
                                          UtilsAlert.showToast(
                                              "Harap hubungi admin untuk setting pelayan");
                                        }
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
                                            "${controller.pelayanSelected.value}",
                                            overflow: TextOverflow.ellipsis,
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
                                            "-") {
                                          UtilsAlert.showToast(
                                              "Harap pilih sales terlebih dahulu...");
                                        } else if (listPelangganViewController
                                            .listdynamicPelanggan
                                            .value
                                            .isNotEmpty) {
                                          paramimpl.convert(
                                              listPelangganViewController
                                                  .memberlist.value);
                                          listPelangganViewController
                                              .validatememberstatus(1);
                                          buttonsheetimpl.build(
                                              list: ControllerImpl
                                                  .paramscontrollerimpl
                                                  .data
                                                  .value,
                                              judul: "Pilih Pelanggan",
                                              namaSelected: controller
                                                  .namaPelanggan.value,
                                              key:
                                                  'show_data_pelanggan_member_status');
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
                                            "${listPelangganViewController.pelangganselectedDashboard.value}"
                                                        .length >
                                                    5
                                                ? "${listPelangganViewController.pelangganselectedDashboard.value}"
                                                        .substring(0, 5) +
                                                    '..'
                                                : "${listPelangganViewController.pelangganselectedDashboard.value}",
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: InkWell(
                    onTap: () {
                      paramimpl.convert(controller.listKelompokBarang.value);
                      debugPrint(
                          'controller ${controller.listKelompokBarang.value}');
                      buttonsheetimpl.build(
                          list: ControllerImpl.paramscontrollerimpl.data.value,
                          judul: "Pilih Kelompok Barang",
                          namaSelected: controller.kategoriBarang.value,
                          key: 'show_data_kelompok_barang');
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
    return Stack(
      children: [
        GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: controller.listMenu.value.length,
            controller: _hideButtonController,
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
              var type = controller.listMenu.value[index]['TIPE'];
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: status == false
                    ? InkWell(
                        onTap: () {
                          if (controller.nomorFaktur.value == "-") {
                            UtilsAlert.showToast(
                                "Harap buat faktur terlebih dahulu");
                          } else if (stokWare <= 0) {
                            if (type == "1") {
                              UtilsAlert.loadingSimpanData(
                                  context, "Sedang memuat...");
                              var jual =
                                  globalController.convertToIdr(hargaJual, 0);
                              buttomSheetProduk.buttomShowCardMenu(
                                  context, keyPilihBarang, jual);
                            } else if (type == "3") {
                              UtilsAlert.loadingSimpanData(
                                  context, "Sedang memuat...");
                              var jual =
                                  globalController.convertToIdr(hargaJual, 0);
                              buttomSheetProduk.buttomShowCardMenu(
                                  context, keyPilihBarang, jual);
                            } else {
                              UtilsAlert.showToast("Stock barang habis");
                            }
                          } else {
                            UtilsAlert.loadingSimpanData(
                                context, "Sedang memuat...");
                            var jual =
                                globalController.convertToIdr(hargaJual, 0);
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
                                      height: 80,
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Utility.primaryDefault,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              "$stokWare",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Utility.small),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                        flex: 50,
                                        child: Text(
                                          "$namaBarang",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: Utility.small,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${globalController.convertToIdr(hargaJual, 0)}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Utility.grey600,
                                                fontSize: Utility.semiMedium),
                                          ),
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
                          CardCustom(
                              colorBg: Utility.baseColor2,
                              radiusBorder: Utility.borderStyle1,
                              widgetCardCustom: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 80,
                                        alignment: Alignment.bottomLeft,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Utility.primaryDefault,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Text(
                                                "$stokWare",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Utility.small),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 50,
                                          child: Text(
                                            "$namaBarang",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: Utility.small,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${globalController.convertToIdr(hargaJual, 0)}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Utility.grey600,
                                                  fontSize: Utility.semiMedium),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                          InkWell(
                            onTap: () {
                              buttomSheetProduk.editBarangKeranjang(
                                  controller.listMenu.value[index]);
                            },
                            child: Container(
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
                            ),
                          )
                        ],
                      ),
              );
            }),
        _isVisible == false
            ? SizedBox()
            : Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: controller.nomorFaktur.value != "-"
                    ? Obx(
                        () => SizedBox(
                          height: 50,
                          child: Button4(
                              totalItem:
                                  "${controller.jumlahItemDikeranjang.value}",
                              totalAll: Text(
                                globalController.convertToIdr(
                                    controller.totalNominalDikeranjang.value,
                                    2),
                                style: TextStyle(color: Utility.baseColor2),
                              ),
                              onTap: () {
                                controller.hitungAllArsipMenu();
                                Get.to(RincianPemesanan(),
                                    duration: Duration(milliseconds: 200),
                                    transition: Transition.zoom);
                              },
                              colorButton: Utility.primaryDefault,
                              colortext: Utility.baseColor2,
                              border: BorderRadius.circular(8.0),
                              icon: RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Utility.baseColor2,
                                ),
                              )),
                        ),
                      )
                    : AnimatedOpacity(
                        duration: Duration(seconds: 3),
                        opacity: 1,
                        alwaysIncludeSemantics: true,
                        child: SizedBox(
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
                                  if (controller.kodePelayanSelected.value ==
                                          "" ||
                                      controller.customSelected.value == "" ||
                                      controller.cabangKodeSelected.value ==
                                          "") {
                                    UtilsAlert.showToast(
                                        "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
                                  } else {
                                    controller
                                        .keteranganInsertFaktur.value.text = "";
                                    globalController.buttomSheetInsertFaktur();
                                  }
                                })),
                      ))
      ],
    );
  }

  Widget tampilanListVertical() {
    return Stack(
      children: [
        ListView.builder(
            controller: _hideButtonController,
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
              var type = controller.listMenu.value[index]['TIPE'];
              return status == false
                  ? InkWell(
                      onTap: () {
                        print('tipe barang selected $type');
                        if (controller.nomorFaktur.value == "-") {
                          UtilsAlert.showToast(
                              "Harap buat faktur terlebih dahulu");
                        } else if (stokWare == 0 || stokWare < 0) {
                          if (type == "1") {
                            var jual =
                                globalController.convertToIdr(hargaJual, 0);
                            buttomSheetProduk.buttomShowCardMenu(
                                context, keyPilihBarang, jual);
                          } else if (type == "3") {
                            UtilsAlert.loadingSimpanData(
                                context, "Sedang memuat...");
                            var jual =
                                globalController.convertToIdr(hargaJual, 0);
                            buttomSheetProduk.buttomShowCardMenu(
                                context, keyPilihBarang, jual);
                          } else {
                            UtilsAlert.showToast("Stock barang habis");
                          }
                        } else {
                          var jual =
                              globalController.convertToIdr(hargaJual, 0);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(6),
                                                          topRight:
                                                              Radius.circular(
                                                                  6)),
                                                  image: DecorationImage(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      image: AssetImage(
                                                          'assets/no_image.png'),
                                                      // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                                      fit: BoxFit.fill)),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Utility
                                                          .primaryDefault,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(6),
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Text(
                                                      "$stokWare",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              Utility.small),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: Utility.small,
                                              ),
                                              Text(
                                                "${globalController.convertToIdr(hargaJual, 0)}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Utility.grey600,
                                                    fontSize:
                                                        Utility.semiMedium),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(6),
                                                            topRight:
                                                                Radius.circular(
                                                                    6)),
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
                                                    color:
                                                        Utility.primaryDefault,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                    )),
                                                child: Center(
                                                  child: Text(
                                                    "$stokWare",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            Utility.small),
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
                                                              .substring(
                                                                  0, 40) +
                                                          '...'
                                                      : "${namaBarang}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: Utility.small,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: Utility.small,
                                                ),
                                                Text(
                                                  "${globalController.convertToIdr(hargaJual, 0)}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Utility.grey600,
                                                      fontSize:
                                                          Utility.semiMedium),
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
                        InkWell(
                          onTap: () {
                            buttomSheetProduk.editBarangKeranjang(
                                controller.listMenu.value[index]);
                          },
                          child: Container(
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
                          ),
                        ),
                      ],
                    );
            }),
        _isVisible == false
            ? SizedBox()
            : Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: controller.nomorFaktur.value != "-"
                    ? Obx(
                        () => SizedBox(
                          height: 50,
                          child: Button4(
                              totalItem:
                                  "${controller.jumlahItemDikeranjang.value}",
                              totalAll: Text(
                                globalController.convertToIdr(
                                    controller.totalNominalDikeranjang.value,
                                    2),
                                style: TextStyle(color: Utility.baseColor2),
                              ),
                              onTap: () {
                                controller.hitungAllArsipMenu();
                                Get.to(RincianPemesanan(),
                                    duration: Duration(milliseconds: 200),
                                    transition: Transition.zoom);
                              },
                              colorButton: Utility.primaryDefault,
                              colortext: Utility.baseColor2,
                              border: BorderRadius.circular(8.0),
                              icon: RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Utility.baseColor2,
                                ),
                              )),
                        ),
                      )
                    : AnimatedOpacity(
                        duration: Duration(seconds: 3),
                        opacity: 1,
                        alwaysIncludeSemantics: true,
                        child: SizedBox(
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
                                  if (controller.kodePelayanSelected.value ==
                                          "" ||
                                      controller.customSelected.value == "" ||
                                      controller.cabangKodeSelected.value ==
                                          "") {
                                    UtilsAlert.showToast(
                                        "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
                                  } else {
                                    controller
                                        .keteranganInsertFaktur.value.text = "";
                                    globalController.buttomSheetInsertFaktur();
                                  }
                                })),
                      )),
      ],
    );
  }

  _scrolllistener() {
    if (_hideButtonController!.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _isVisible = false;
    }
    if (_hideButtonController!.position.userScrollDirection ==
        ScrollDirection.forward) {
      _isVisible = false;
    }
    if (!_hideButtonController!.position.outOfRange) {
      _isVisible = true;
    }
    setState(() {});
  }
}


//TAMBAH PRODUK LOGIC
  // if (controller.kodePelayanSelected.value == "" ||
  //                                                             controller
  //                                                                     .customSelected
  //                                                                     .value ==
  //                                                                 "" ||
  //                                                             controller
  //                                                                     .cabangKodeSelected
  //                                                                     .value ==
  //                                                                 "") {
  //                                                           UtilsAlert.showToast(
  //                                                               "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
  //                                                         } else {
  //                                                           controller
  //                                                               .keteranganInsertFaktur
  //                                                               .value
  //                                                               .text = "";
  //                                                           globalController
  //                                                               .buttomSheetInsertFaktur();
  //                                                         }