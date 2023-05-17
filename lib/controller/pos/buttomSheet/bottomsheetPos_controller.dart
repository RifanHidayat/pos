import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/edit_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/hapus_jldt_controller.dart';
import 'package:siscom_pos/controller/pos/masuk_keranjang_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_faktur_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/screen/pos/scan_imei.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import '../../base_controller.dart';

class BottomSheetPos extends BaseController
    with GetSingleTickerProviderStateMixin {
  var dashboardCt = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());
  var masukKeranjangCt = Get.put(MasukKeranjangController());
  var hapusJldtCt = Get.put(HapusJldtController());
  var simpanFakturCt = Get.put(SimpanFakturController());
  var editKeranjangCt = Get.put(EditKeranjangController());

  var viewScreenOrder = false.obs;
  var tipeImei = false.obs;

  var typeFocus = "".obs;
  var imeiSelected = "".obs;
  Rx<List<String>> imeiBarang = Rx<List<String>>([]);

  var screenCustomImei = 0.obs;
  var qtySebelumEdit = "".obs;

  var listDataMeja = [].obs;
  var listDataImei = [].obs;
  var listDataImeiSelected = [].obs;

  FocusNode _focus = FocusNode();

  List mejaDummy = [
    {
      'kode': '0001',
      'nama': 'TABLE 1',
    },
    {
      'kode': '0002',
      'nama': 'TABLE 2',
    },
    {
      'kode': '0003',
      'nama': 'TABLE 3',
    },
    {
      'kode': '0004',
      'nama': 'TABLE 4',
    },
    {
      'kode': '0005',
      'nama': 'TABLE 5',
    },
    {
      'kode': '0006',
      'nama': 'TABLE 7',
    },
  ];

  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _focus.addListener(changeFocus);
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  void changeFocus() {
    print('muncul');
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(changeFocus);
    _focus.dispose();
  }

  void buttomShowCardMenu(context, id, jual, {key}) async {
    // dashboardCt.totalPesan.value = 0;
    dashboardCt.totalPesanNoEdit.value = 0;
    dashboardCt.catatanPembelian.value.text = "";
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    imeiSelected.value = "";
    imeiBarang.value.clear();
    listDataImei.value.clear();
    var produkSelected = [];
    for (var element in dashboardCt.listMenu.value) {
      if ("${element['GROUP']}${element['KODE']}" == id) {
        produkSelected.add(element);
      }
    }
    dashboardCt.tipeBarangDetail.value = int.parse(produkSelected[0]['TIPE']);
    if (dashboardCt.kodePelayanSelected.value == "" ||
        dashboardCt.customSelected.value == "" ||
        dashboardCt.cabangKodeSelected.value == "") {
      UtilsAlert.showToast(
          "Harap pilih cabang, sales dan pelanggan terlebih dahulu");
    } else {
      if (produkSelected[0]['TIPE'] == "1") {
        Future<bool> checkingImei = prosesCheckImei(produkSelected);
        var hasilEmei = await checkingImei;
        if (hasilEmei == true) {
          //IMEI _
          // print(imeiBarang.value);
          // print(imeiSelected.value);
          checkingUkuran(context, produkSelected, jual, "", 0, "", "", "", "",
              "", "", "", "",
              key: key);
        } else {
          UtilsAlert.showToast("Data IMEI tidak valid");
        }
      } else {
        //NON IMEI

        checkingUkuran(context, produkSelected, jual, "", 0, "", "", "", "", "",
            "", "", "",
            key: key);
      }
    }
  }

  Future<bool> prosesCheckImei(produkSelected) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'IMEIX',
      'tanggal_transaksi': tanggalNow,
      'kode_barang': produkSelected[0]['KODE'],
      'group_barang': produkSelected[0]['GROUP'],
      'kode_cabang': dashboardCt.cabangKodeSelected.value,
      'kode_gudang': dashboardCt.gudangSelected.value,
    };
    var connect = Api.connectionApi("post", body, "getImei");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    bool hasilProses = false;
    if (valueBody['status'] == true) {
      if (data.isNotEmpty) {
        var getFirst = data.first;
        imeiSelected.value = getFirst["IMEI"];
        for (var element in data) {
          imeiBarang.value.add(element["IMEI"]);
        }
        listDataImei.value = data;
        refreshAll();
        hasilProses = true;
      }
    } else {
      hasilProses = false;
    }
    return Future.value(hasilProses);
  }

  void checkingUkuran(context, produkSelected, jual, type, qtyProduk, nomorUrut,
      keyFaktur, nomorFaktur, gudang, group, kode, discd, diskon,
      {key}) {
    dashboardCt.typeBarang.value.clear();
    dashboardCt.typeBarang.refresh();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'UKURAN',
      'ukuranperbarang_group': '${produkSelected[0]['GROUP']}',
      'ukuranperbarang_kode': '${produkSelected[0]['KODE']}',
    };
    var connect = Api.connectionApi("post", body, "ukuran_perbarang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        var getFirst = data.first;
        dashboardCt.typeBarangSelected.value = getFirst['NAMA'];
        dashboardCt.htgUkuran.value = "${getFirst['HTG']}";
        dashboardCt.pakUkuran.value = "${getFirst['PAK']}";
        if (type != "edit_keranjang") {
          if (key != 'get_qrcode_manualy') {
            dashboardCt.jumlahPesan.value.text =
                produkSelected[0]["TIPE"] == "1" ? "0" : "1";
          }
          // // validasi harga standar jual jika global include ppn
          // var cabangSelected = dashboardCt.listCabang.firstWhere(
          //     (el) => el["KODE"] == dashboardCt.cabangKodeSelected.value);
          // double hargaJualFinal = 0.0;
          // if (dashboardCt.includePPN.value == "Y") {
          //   double hitung1 = double.parse("${getFirst['STDJUAL']}") *
          //       (100 / (100 + double.parse("${cabangSelected['PPN']}")));
          //   hargaJualFinal = hitung1;
          // } else {
          //   hargaJualFinal = double.parse("${getFirst['STDJUAL']}");
          // }
          qtySebelumEdit.value = "0";
          qtySebelumEdit.refresh();
          listDataImeiSelected.value.clear();
          if (key != 'get_qrcode_manualy') {
            dashboardCt.totalPesan.value =
                double.parse("${getFirst['STDJUAL']}");
          } else if (key == 'get_qrcode_manualy' &&
              dashboardCt.jumlahPesan.value.text == '1') {
            dashboardCt.totalPesan.value =
                double.parse("${getFirst['STDJUAL']}");
          }
          dashboardCt.totalPesanNoEdit.value =
              double.parse("${getFirst['STDJUAL']}");
          dashboardCt.hargaJualPesanBarang.value.text =
              Utility.rupiahFormat("${getFirst['STDJUAL']}", type);

          if (key != 'get_qrcode_by_scan') {
            Get.back();
          }
        } else {
          qtySebelumEdit.value = "$qtyProduk";
          qtySebelumEdit.refresh();
          dashboardCt.jumlahPesan.value.text = "$qtyProduk";

          // validasi harga standar jual jika global include ppn
          // var cabangSelected = dashboardCt.listCabang.firstWhere(
          //     (el) => el["KODE"] == dashboardCt.cabangKodeSelected.value);
          // double hargaJualFinal = 0.0;
          // if (dashboardCt.includePPN.value == "Y") {
          //   double hitung1 = double.parse("$jual") *
          //       (100 / (100 + double.parse("${cabangSelected['PPN']}")));
          //   hargaJualFinal = hitung1;
          // } else {
          //   hargaJualFinal = double.parse("$jual");
          // }

          var fltr1 = jual * qtyProduk;
          var fltr2 = discd * qtyProduk;
          var fltr3 = fltr1 - fltr2;

          dashboardCt.totalPesan.value = fltr3.toDouble();
          dashboardCt.totalPesanNoEdit.value = fltr3.toDouble();
          var convertJual = globalCt.convertToIdr(jual, 0);
          dashboardCt.hargaJualPesanBarang.value.text = convertJual;
          dashboardCt.persenDiskonPesanBarang.value.text = "$diskon";
          var convertDiskonNominal = globalCt.convertToIdr(discd, 0);
          dashboardCt.hargaDiskonPesanBarang.value.text = convertDiskonNominal;
          if (key != 'get_qrcode_by_scan') {
            Get.back();
          }
        }

        for (var element in data) {
          dashboardCt.typeBarang.value.add(element['NAMA']);
        }
        tipeImei.value = produkSelected[0]["TIPE"] == "1" ? true : false;
        screenCustomImei.value = 0;
        dashboardCt.listTypeBarang.value = data;
        refreshAll();
        typeFocus.value = "";

        sheetButtomMenu1(produkSelected, type, nomorUrut, keyFaktur,
            nomorFaktur, gudang, group, kode, qtyProduk);
      }
    });
  }

  void refreshAll() {
    dashboardCt.totalPesan.refresh();
    dashboardCt.jumlahPesan.refresh();
    dashboardCt.hargaJualPesanBarang.refresh();
    dashboardCt.typeBarangSelected.refresh();
    dashboardCt.listTypeBarang.refresh();
    tipeImei.refresh();
    imeiSelected.refresh();
    imeiBarang.refresh();
    listDataImei.refresh();
    screenCustomImei.refresh();
  }

  void editKeranjang(context, group, kode, jual, qtyProduk, nomorUrut,
      keyFaktur, nomorFaktur, gudang, discd, diskon) {
    UtilsAlert.loadingSimpanData(context, "Sedang memuat...");
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'PROD1',
      'groupBarang': '$group',
      'kodeBarang': '$kode',
    };
    var connect = Api.connectionApi("post", body, "get_barang_once");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];

        if (data[0]['TIPE'] == "1") {
          print('proses check imei edit');
          imeiBarang.value.clear();
          imeiBarang.refresh();
          Future<List> getimeiEditKeranjang = GetDataController()
              .getImeiEditKeranjang(
                  kode,
                  group,
                  dashboardCt.cabangKodeSelected.value,
                  dashboardCt.gudangSelected.value);
          List dataImeiEdit = await getimeiEditKeranjang;

          var getFirst = dataImeiEdit.first;
          imeiSelected.value = getFirst["IMEI"];
          imeiSelected.refresh();

          List tampungImeiSelected = [];
          for (var element in dataImeiEdit) {
            imeiBarang.value.add(element["IMEI"]);
            if (int.parse(element['FLAG']) >= 7) {
              tampungImeiSelected.add(element["IMEI"]);
            }
          }
          // listDataImei.value = data;
          // listDataImei.refresh();
          listDataImeiSelected.value = tampungImeiSelected;
          listDataImeiSelected.refresh();
          if (dataImeiEdit.isNotEmpty) {
            checkingUkuran(
                context,
                data,
                jual,
                "edit_keranjang",
                qtyProduk,
                nomorUrut,
                keyFaktur,
                nomorFaktur,
                gudang,
                group,
                kode,
                discd,
                diskon);
          } else {
            UtilsAlert.showToast("Data IMEI tidak valid");
          }
        } else {
          checkingUkuran(
              context,
              data,
              jual,
              "edit_keranjang",
              qtyProduk,
              nomorUrut,
              keyFaktur,
              nomorFaktur,
              gudang,
              group,
              kode,
              discd,
              diskon);
        }
      }
    });
  }

  void sheetButtomMenu1(produkSelected, type, nomorUrut, keyFaktur, nomorFaktur,
      gudang, group, kode, qtyProduk) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        transitionAnimationController: animasiController,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                if (typeFocus.value == "persen_diskon") {
                  hitungTotalAsli();
                  aksiInputPersenDiskon(
                      context, dashboardCt.persenDiskonPesanBarang.value.text);
                } else if (typeFocus.value == "nominal_diskon") {
                  hitungTotalAsli();
                  aksiInputNominalDiskon(
                      context, dashboardCt.hargaDiskonPesanBarang.value.text);
                } else {
                  hitungTotalAsli();
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Utility.large,
                      ),

                      // gambar barang

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 25,
                            child: Container(
                              height: 90,
                              alignment: Alignment.bottomLeft,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      alignment: Alignment.topCenter,
                                      image: AssetImage('assets/no_image.png'),
                                      // gambar == null || gambar == "" ? AssetImage('assets/no_image.png') : ,
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          Expanded(
                            flex: 65,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${produkSelected[0]['NAMA']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${produkSelected[0]['nama_merek']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Iconsax.close_circle)),
                          )
                        ],
                      ),

                      SizedBox(
                        height: Utility.large + 6,
                      ),

                      // screen barang IMEI

                      tipeImei.value == false
                          ? SizedBox()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        screenCustomImei.value = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: screenCustomImei.value == 0
                                                ? Utility.primaryDefault
                                                : Colors.transparent,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Detail",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        screenCustomImei.value = 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: screenCustomImei.value == 1
                                                ? Utility.primaryDefault
                                                : Colors.transparent,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Serial Number/Imei",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                      SizedBox(
                        height: Utility.large + 6,
                      ),

                      tipeImei.value == false
                          ? screenDetailInputBarang(setState, type)
                          : screenCustomImei.value == 0
                              ? screenDetailInputBarang(setState, type)
                              : screenCustomImei.value == 1
                                  ? screenImei(setState)
                                  : screenDetailInputBarang(setState, type),

                      SizedBox(
                        height: Utility.large,
                      ),

                      // screen total

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 15,
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 85,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Obx(() => Text(
                                    // "${totalPesan.value}",
                                    "${currencyFormatter.format(dashboardCt.totalPesan.value)}",
                                    style: TextStyle(fontSize: Utility.medium),
                                  )),
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: Utility.medium,
                      ),

                      // button aksi

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          type == "edit_keranjang"
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Button3(
                                      textBtn: "Hapus Barang",
                                      colorSideborder: Colors.red,
                                      colorText: Colors.red,
                                      overlayColor:
                                          Color.fromARGB(255, 230, 133, 126),
                                      onTap: () {
                                        validasiSebelumAksi(
                                            "Hapus Barang",
                                            "Yakin hapus barang ini ?",
                                            "",
                                            "hapus_barang_once", [
                                          nomorUrut,
                                          keyFaktur,
                                          nomorFaktur,
                                          gudang,
                                          group,
                                          kode,
                                          qtyProduk
                                        ]);
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0, right: 6.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: InkWell(
                                    onTap: () {
                                      if (type == "edit_keranjang") {
                                        validasiSebelumAksi(
                                            "Edit Barang",
                                            "Yakin edit barang ini ?",
                                            "",
                                            type,
                                            produkSelected);
                                      } else {
                                        if (tipeImei.value == true &&
                                            dashboardCt
                                                    .jumlahPesan.value.text ==
                                                '0') {
                                          UtilsAlert.showToast(
                                              'Imei belum di pilih');
                                        } else {
                                          masukKeranjangCt.masukKeranjang(
                                              produkSelected,
                                              [],
                                              qtySebelumEdit.value);
                                          validasiSebelumAksi(
                                              "Simpan Barang",
                                              "Yakin simpan barang ini ke keranjang ?",
                                              "",
                                              type,
                                              produkSelected);
                                        }
                                      }
                                    },
                                    child: CardCustom(
                                      colorBg: Utility.primaryDefault,
                                      radiusBorder: Utility.borderStyle5,
                                      widgetCardCustom: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Center(
                                            child: type == "edit_keranjang"
                                                ? Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "Tambah",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          )),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Utility.large,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget screenDetailInputBarang(setState, type) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // screen input quantity

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Quantity",
                    style: TextStyle(color: Utility.grey900),
                  ),
                ),
              ),
              Expanded(
                flex: 40,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (tipeImei.value == false)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                aksiKurangQty(Get.context!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Center(
                                  child: Icon(
                                    Iconsax.minus_square,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: CardCustomForm(
                            colorBg: Utility.baseColor2,
                            tinggiCard: 30.0,
                            radiusBorder: Utility.borderStyle1,
                            widgetCardForm: Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: FocusScope(
                                child: Focus(
                                  onFocusChange: (focus) {
                                    aksiFokus1();
                                  },
                                  child: Obx(() => TextField(
                                        textAlign: TextAlign.center,
                                        readOnly: tipeImei.value == false
                                            ? false
                                            : true,
                                        cursorColor: Utility.primaryDefault,
                                        controller:
                                            dashboardCt.jumlahPesan.value,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            height: 1.0,
                                            color: Colors.black),
                                        onSubmitted: (value) {
                                          aksiInputQty(Get.context!, value);
                                        },
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (tipeImei.value == false)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                aksiTambahQty(Get.context!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Center(
                                  child: Icon(
                                    Iconsax.add_square,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )),
              )
            ],
          ),

          SizedBox(
            height: Utility.medium,
          ),

          // screen harga standar jual

          Container(
            height: 50,
            width: MediaQuery.of(Get.context!).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Utility.grey100,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        )),
                    child: Center(
                      child: Text("Rp"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          aksiFokus2();
                        },
                        child: TextField(
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              locale: 'id',
                              symbol: '',
                              decimalDigits: 0,
                            )
                          ],
                          cursorColor: Colors.black,
                          controller: dashboardCt.hargaJualPesanBarang.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            aksiGantiHargaStdJual(Get.context!, value);
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: Utility.medium,
          ),

          // screen type barang

          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  autofocus: true,
                  focusColor: Colors.grey,
                  items: dashboardCt.typeBarang.value
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  value: dashboardCt.typeBarangSelected.value,
                  onChanged: (selectedValue) {
                    setState(() {
                      dashboardCt.typeBarangSelected.value = selectedValue!;
                      dashboardCt.typeBarangSelected.refresh();
                    });
                  },
                  isExpanded: true,
                ),
              ),
            ),
          ),

          SizedBox(
            height: Utility.medium,
          ),

          // screen diskon barang

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 30,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 6.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Utility.borderStyle2,
                      border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(255, 211, 205, 205))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 80,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: FocusScope(
                            child: Focus(
                              onFocusChange: (focus) {
                                typeFocus.value = "persen_diskon";
                              },
                              child: TextField(
                                textAlign: TextAlign.center,
                                cursorColor: Colors.black,
                                controller:
                                    dashboardCt.persenDiskonPesanBarang.value,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                                textInputAction: TextInputAction.done,
                                decoration: new InputDecoration(
                                    border: InputBorder.none),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black),
                                onSubmitted: (value) {
                                  aksiInputPersenDiskon(Get.context!, value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Utility.grey100,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                )),
                            child: Center(
                              child: Text("%"),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 70,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 6.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Utility.borderStyle2,
                      border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(255, 211, 205, 205))),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Utility.grey100,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                )),
                            child: Center(
                              child: Text("Rp"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 70,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: FocusScope(
                              child: Focus(
                                onFocusChange: (focus) {
                                  typeFocus.value = "nominal_diskon";
                                },
                                child: TextField(
                                  inputFormatters: [
                                    CurrencyTextInputFormatter(
                                      locale: 'id',
                                      symbol: '',
                                      decimalDigits: 0,
                                    )
                                  ],
                                  cursorColor: Colors.black,
                                  controller:
                                      dashboardCt.hargaDiskonPesanBarang.value,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  textInputAction: TextInputAction.done,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nominal Diskon"),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      height: 1.0,
                                      color: Colors.black),
                                  onSubmitted: (value) {
                                    aksiInputNominalDiskon(Get.context!, value);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        dashboardCt.hargaDiskonPesanBarang.value.text != ""
                            ? Expanded(
                                flex: 10,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      clearInputanDiskon();
                                    });
                                  },
                                  child: Center(
                                    child: type == "edit_keranjang"
                                        ? SizedBox()
                                        : Icon(
                                            Iconsax.minus_cirlce,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              )
                            : SizedBox()
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

          // screen tambah catatan

          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                cursorColor: Colors.black,
                controller: dashboardCt.catatanPembelian.value,
                maxLines: null,
                maxLength: 225,
                decoration: new InputDecoration(
                    border: InputBorder.none, hintText: "Tambah Catatan"),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                style:
                    TextStyle(fontSize: 12.0, height: 2.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget screenImei(setState) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 40,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Utility.borderStyle2,
                        border: Border.all(
                            width: 0.5,
                            color: Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          autofocus: true,
                          focusColor: Colors.grey,
                          items: imeiBarang.value
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          value: imeiSelected.value,
                          onChanged: (selectedValue) {
                            setState(() {
                              imeiSelected.value = selectedValue!;
                              imeiSelected.refresh();
                              int lengthBefore =
                                  listDataImeiSelected.value.length;
                              listDataImeiSelected.value
                                  .add(imeiSelected.value);
                              var filter =
                                  listDataImeiSelected.toSet().toList();
                              listDataImeiSelected.value = filter;
                              listDataImeiSelected.refresh();
                              if (lengthBefore !=
                                  listDataImeiSelected.value.length) {
                                aksiTambahQty(Get.context!);
                              }
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Center(
                        child: Button3(
                      textBtn: "Scan IMEI",
                      colorSideborder: Utility.primaryDefault,
                      overlayColor: Utility.infoLight50,
                      colorText: Utility.primaryDefault,
                      icon1: Icon(
                        Iconsax.scan_barcode,
                        color: Utility.primaryDefault,
                      ),
                      onTap: () => Get.to(ScanImei(
                        scanMenu: "POS",
                      )),
                    )),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        imeiSelected.value = imeiSelected.value;
                        int lengthBefore = listDataImeiSelected.value.length;
                        listDataImeiSelected.value.add(imeiSelected.value);
                        var filter = listDataImeiSelected.toSet().toList();
                        listDataImeiSelected.value = filter;
                        listDataImeiSelected.refresh();
                        if (lengthBefore != listDataImeiSelected.value.length) {
                          aksiTambahQty(Get.context!);
                        }
                      });
                    },
                    child: Center(
                      child: Icon(
                        Iconsax.refresh,
                        color: Utility.primaryDefault,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: Utility.medium,
          ),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Quantity",
                      style: TextStyle(color: Utility.grey900),
                    ),
                  ),
                ),
                Expanded(
                  child: CardCustomForm(
                    colorBg: Utility.baseColor2,
                    tinggiCard: 30.0,
                    radiusBorder: Utility.borderStyle1,
                    widgetCardForm: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            aksiFokus1();
                          },
                          child: Obx(() => TextField(
                                textAlign: TextAlign.center,
                                readOnly:
                                    tipeImei.value == false ? false : true,
                                cursorColor: Utility.primaryDefault,
                                controller: dashboardCt.jumlahPesan.value,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black),
                                onSubmitted: (value) {
                                  aksiInputQty(Get.context!, value);
                                },
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Utility.large,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle1,
                border: Border.all(
                    width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "IMEI Terpilih",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Obx(() => ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDataImeiSelected.value.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 90,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${listDataImeiSelected.value[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Center(
                                        child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          listDataImeiSelected.value
                                              .removeWhere((element) =>
                                                  element ==
                                                  listDataImeiSelected
                                                      .value[index]);
                                          aksiKurangQty(Get.context!);
                                        });
                                      },
                                      icon: Icon(
                                        Iconsax.trash,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      );
                    }))
              ],
            ),
          ),
          SizedBox(
            height: Utility.large,
          )
        ],
      ),
    );
  }

  void aksiFokus1() {}
  void aksiFokus2() {}
  void aksiFokus3() {}
  void aksiFokus4() {}

  void hitungTotalAsli() {
    int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();

    var convertHargaJual =
        dashboardCt.hargaJualPesanBarang.value.text.split(',');
    var hargaJualEdit = convertHargaJual[0];
    var filter1 = hargaJualEdit.replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var hrgJualEdit = double.parse(filter3);
    double hargaProduk = hrgJualEdit;

    print('harga produk $hargaProduk');

    var hasill = hargaProduk * vld2;
    // dashboardCt.totalPesan.value = hasill.toPrecision(2);
    // dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
    dashboardCt.totalPesan.value = hasill;
    dashboardCt.totalPesanNoEdit.value = hasill;
    dashboardCt.totalPesan.refresh();
    dashboardCt.jumlahPesan.refresh();
  }

  void validasiSebelumAksi(pesan1, pesan2, pesan3, type, dataSelected) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 90,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$pesan1",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(Get.context!),
                              child: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "$pesan2",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Utility.primaryDefault),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: InkWell(
                              onTap: () => Navigator.pop(Get.context!),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: Utility.borderStyle1,
                                      border: Border.all(
                                          color: Utility.primaryDefault)),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 12, bottom: 12),
                                      child: Text(
                                        "Urungkan",
                                        style: TextStyle(
                                            color: Utility.primaryDefault),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Button1(
                              textBtn: type == "hapus_faktur" ||
                                      type == "hapus_barang_once"
                                  ? "Hapus"
                                  : type == "transaksi_baru"
                                      ? "Transaksi Baru"
                                      : type == "void_faktur"
                                          ? "Void"
                                          : "Simpan",
                              colorBtn: Utility.primaryDefault,
                              onTap: () {
                                setState(() {
                                  if (type == "edit_keranjang") {
                                    editKeranjangCt.editKeranjang(dataSelected,
                                        '', listDataImeiSelected.value);
                                  } else if (type == "hapus_faktur") {
                                    hapusJldtCt
                                        .hapusFakturDanJldt(dataSelected);
                                  } else if (type == "void_faktur") {
                                    voidFaktur(dataSelected);
                                  } else if (type == "arsip_faktur") {
                                    simpanFakturCt.simpanFakturSebagaiArsip('');
                                  } else if (type == "hapus_barang_once") {
                                    // print('data hapus barang $dataSelected');
                                    hapusJldtCt.hapusBarangOnce(
                                        dataSelected, '');
                                  } else if (type ==
                                      "input_persendiskon_header") {
                                    hitungHeader();
                                  } else if (type == "transaksi_baru") {
                                    transaksiBaru();
                                  } else {
                                    if (tipeImei.value == true) {
                                      masukKeranjangCt.masukKeranjang(
                                          dataSelected,
                                          listDataImeiSelected.value,
                                          qtySebelumEdit.value);
                                    } else {
                                      masukKeranjangCt.masukKeranjang(
                                          dataSelected,
                                          [],
                                          qtySebelumEdit.value);
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          );
        });
      },
    );
  }

  void getDataMeja() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'MEJA',
    };
    var connect = Api.connectionApi("post", body, "data_meja");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        listDataMeja.value = data;
        pilihMejaPemesan();
      }
    });
  }

  void pilihMejaPemesan() {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Utility.large,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 90,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pilih Meja",
                                  style: TextStyle(
                                      fontSize: Utility.medium,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Expanded(
                            flex: 10,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child:
                                    Center(child: Icon(Iconsax.close_circle))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Utility.large,
                      ),
                      listDataMeja.value.isEmpty
                          ? SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "Data meja tidak tersedia",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : GridView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              itemCount: listDataMeja.value.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.3,
                              ),
                              itemBuilder: (context, index) {
                                var kodeMeja =
                                    listDataMeja.value[index]['KODE'];
                                var namaMeja =
                                    listDataMeja.value[index]['NAMA'];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      dashboardCt.nomorMeja.value = kodeMeja;
                                      updatePilihMeja();
                                      Get.back();
                                      Get.back();
                                      Get.to(RincianPemesanan());
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        color: Utility.baseColor2,
                                        borderRadius: Utility.borderStyle1,
                                        border: Border.all(
                                            width: 0.2,
                                            color: Utility.greyLight300)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Iconsax.element_4),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Text("$namaMeja")
                                      ],
                                    ),
                                  ),
                                );
                              }),
                      SizedBox(
                        height: Utility.large,
                      )
                    ]));
          });
        });
  }

  void aksiKurangQty(content) {
    int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1.toInt();
    int vld3 = vld2 - 1;
    if (vld3 < 0) {
      UtilsAlert.showToast("Quantity tidak valid");
    } else {
      var convertHrgjual =
          dashboardCt.hargaJualPesanBarang.value.text.split(',');
      var filter1 = convertHrgjual[0].replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      var hrgJualEdit = double.parse(filter3);
      double hargaProduk = hrgJualEdit;
      int hitungJumlahPesan = int.parse('$vld3');
      // dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
      dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
      var hasill = hargaProduk * hitungJumlahPesan;
      // dashboardCt.totalPesan.value = hasill.toPrecision(2);
      // dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
      dashboardCt.totalPesan.value = hasill;
      dashboardCt.totalPesanNoEdit.value = hasill;
      dashboardCt.totalPesan.refresh();
      dashboardCt.jumlahPesan.refresh();
      if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
          dashboardCt.hargaDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputQty(context, value) {
    var vld1 = "$value".replaceAll(".", ".");
    var vld2 = vld1.replaceAll(",", ".");
    double vld3 = double.parse(vld2);
    var vld4 = vld3 == 0.0 || vld3 < 0.0 ? 1.0 : vld3;
    // dashboardCt.jumlahPesan.value.text = "${vld4.toStringAsFixed(2)}";
    dashboardCt.jumlahPesan.value.text = vld4.toString();

    var convertHrgjual = dashboardCt.hargaJualPesanBarang.value.text.split(',');
    var filter1 = convertHrgjual[0].replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var filterFinal = double.parse(filter3);
    var hitung = filterFinal * vld4;
    // var flt1 = hitung.toStringAsFixed(2);
    var flt1 = hitung.toString();
    dashboardCt.totalPesan.value = double.parse(flt1);
    dashboardCt.totalPesanNoEdit.value = double.parse(flt1);
    dashboardCt.totalPesan.refresh();
    dashboardCt.hargaJualPesanBarang.refresh();
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
        dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiTambahQty(context) {
    int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
    int vld2 = vld1;

    var convertHrgjual = dashboardCt.hargaJualPesanBarang.value.text.split(',');
    var filter1 = convertHrgjual[0].replaceAll("Rp", "");
    var filter2 = filter1.replaceAll(" ", "");
    var filter3 = filter2.replaceAll(".", "");
    var hrgJualEdit = double.parse(filter3);
    double hargaProduk = hrgJualEdit;
    int hitungJumlahPesan = vld2 + 1;
    // dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toStringAsFixed(2);
    dashboardCt.jumlahPesan.value.text = hitungJumlahPesan.toString();
    var hasill = hargaProduk * hitungJumlahPesan;
    // dashboardCt.totalPesan.value = hasill.toPrecision(2);
    // dashboardCt.totalPesanNoEdit.value = hasill.toPrecision(2);
    dashboardCt.totalPesan.value = hasill;
    dashboardCt.totalPesanNoEdit.value = hasill;
    dashboardCt.totalPesan.refresh();
    dashboardCt.jumlahPesan.refresh();
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" ||
        dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      aksiJikaAdaDiskon();
    }
  }

  void aksiGantiHargaStdJual(context, value) {
    if (value != "" || dashboardCt.hargaJualPesanBarang.value.text != "") {
      var filter1 = value.replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      double hrgJualEdit = double.parse(filter3);
      int vld1 = int.parse(dashboardCt.jumlahPesan.value.text);
      double perhitungan = hrgJualEdit * vld1;
      // dashboardCt.totalPesan.value = perhitungan.toPrecision(2);
      // dashboardCt.totalPesanNoEdit.value = perhitungan.toPrecision(2);
      dashboardCt.totalPesan.value = perhitungan;
      dashboardCt.totalPesanNoEdit.value = perhitungan;
      dashboardCt.hargaJualPesanBarang.value.text = value;
      dashboardCt.hargaJualPesanBarang.refresh();
      dashboardCt.totalPesan.refresh();
      if (dashboardCt.persenDiskonPesanBarang.value.text != "" &&
          dashboardCt.hargaDiskonPesanBarang.value.text != "") {
        aksiJikaAdaDiskon();
      }
    }
  }

  void aksiInputPersenDiskon(context, value) {
    if (dashboardCt.persenDiskonPesanBarang.value.text != "" || value != "") {
      var vld1 = "$value".replaceAll(".", ".");
      var vld2 = vld1.replaceAll(",", ".");
      double vld3 = double.parse(vld2);

      var convertHrgjual =
          dashboardCt.hargaJualPesanBarang.value.text.split(',');
      var flt1 = convertHrgjual[0].replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = Utility.nominalDiskonHeader(flt2, "$vld3");
      var hitungFinal = dashboardCt.totalPesanNoEdit.value - hitung;
      print('hasil hitung $hitungFinal');
      if (hitungFinal < 0) {
        UtilsAlert.showToast("Gagal tambah diskon");
        dashboardCt.persenDiskonPesanBarang.value.text = "";
      } else {
        dashboardCt.hargaDiskonPesanBarang.value.text =
            "${globalCt.convertToIdr(hitung.toInt(), 0)}";

        var flt1 = hitung * int.parse(dashboardCt.jumlahPesan.value.text);
        dashboardCt.totalPesan.value = dashboardCt.totalPesan.value - flt1;
        dashboardCt.totalPesan.refresh();
      }
    }
  }

  void aksiInputNominalDiskon(context, value) {
    if (value != "" || dashboardCt.hargaDiskonPesanBarang.value.text != "") {
      var filter1 = value.replaceAll("Rp", "");
      var filter2 = filter1.replaceAll(" ", "");
      var filter3 = filter2.replaceAll(".", "");
      double inputNominal = double.parse(filter3);

      var convertHrgjual =
          dashboardCt.hargaJualPesanBarang.value.text.split(',');
      var flt1 = convertHrgjual[0].replaceAll(".", "");
      var flt2 = flt1.replaceAll(",", "");

      var hitung = (inputNominal / double.parse("$flt2")) * 100;
      var hitungFinal =
          inputNominal * int.parse(dashboardCt.jumlahPesan.value.text);

      dashboardCt.persenDiskonPesanBarang.value.text =
          // hitung.toStringAsFixed(2);
          hitung.toString();
      dashboardCt.totalPesan.value = dashboardCt.totalPesan.value - hitungFinal;
      dashboardCt.totalPesan.refresh();
    }
  }

  void aksiJikaAdaDiskon() {
    var totalPesan = dashboardCt.totalPesan.value;
    var flt1 =
        dashboardCt.hargaDiskonPesanBarang.value.text.replaceAll(".", "");
    var flt2 = flt1.replaceAll(",", "");
    var hitung =
        double.parse(flt2) * int.parse(dashboardCt.jumlahPesan.value.text);
    var hitungFinal = dashboardCt.totalPesan.value - hitung;
    dashboardCt.totalPesan.value = hitungFinal;
    dashboardCt.totalPesan.refresh();
  }

  void clearInputanDiskon() {
    dashboardCt.totalPesan.value = dashboardCt.totalPesanNoEdit.value;
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    dashboardCt.totalPesan.refresh();
  }

  void changeDiskonHeaderDataLocal() {
    // validasi rincian diskon
    if (dashboardCt.persenDiskonPesanBarang.value.text == "" ||
        dashboardCt.persenDiskonPesanBarang.value.text == "0") {
      dashboardCt.diskonHeader.value = 0.0;
      dashboardCt.diskonHeader.refresh();
    } else {
      dashboardCt.diskonHeader.value = Utility.validasiValueDouble(
          dashboardCt.persenDiskonPesanBarang.value.text);
      dashboardCt.diskonHeader.refresh();
    }
    // validasi rincian ppn
    if (dashboardCt.ppnPesan.value.text == "") {
      dashboardCt.ppnCabang.value = 0;
      dashboardCt.ppnCabang.refresh();
    } else {
      dashboardCt.ppnCabang.value =
          Utility.validasiValueDouble(dashboardCt.ppnPesan.value.text);
      dashboardCt.ppnCabang.refresh();
    }
    // validasi rincian service charge
    if (dashboardCt.serviceChargePesan.value.text == "") {
      dashboardCt.serviceChargerCabang.value = 0;
      dashboardCt.serviceChargerCabang.refresh();
    } else {
      dashboardCt.serviceChargerCabang.value = Utility.validasiValueDouble(
          dashboardCt.serviceChargePesan.value.text);
      dashboardCt.serviceChargerCabang.refresh();
    }
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(RincianPemesanan());
  }

  void updatePilihMeja() async {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'JLHD',
      'nomor_faktur': dashboardCt.nomorFaktur.value,
      'value_nomor_meja': dashboardCt.nomorMeja.value
    };
    var connect = Api.connectionApi("post", body, "update_nomor_meja");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print(valueBody);
  }

  void hitungHeader() async {
    // setting header

    double convertDiskon = Utility.validasiValueDouble(
        dashboardCt.hargaDiskonPesanBarang.value.text);
    double persenPPN =
        Utility.validasiValueDouble(dashboardCt.ppnPesan.value.text);
    double convertPPN =
        Utility.validasiValueDouble(dashboardCt.ppnHarga.value.text);
    double convertBiaya =
        Utility.validasiValueDouble(dashboardCt.serviceChargeHarga.value.text);

    print("subtotal ${dashboardCt.totalNominalDikeranjang.value}");
    print("diskon header $convertDiskon");
    print("ppn header $convertPPN");
    print("biaya header $convertBiaya");
    dashboardCt.statusHitungHeader.value = true;
    dashboardCt.statusHitungHeader.refresh();

    UtilsAlert.loadingSimpanData(Get.context!, "Proses perhitungan");
    Future<List> prosesHitungHeader = GetDataController().hitungHeader(
        "JLHD",
        "JLDT",
        dashboardCt.nomorFaktur.value,
        "${dashboardCt.totalNominalDikeranjang.value}",
        "$convertDiskon",
        "$persenPPN",
        "$convertPPN",
        "$convertBiaya");

    List hasilHitung = await prosesHitungHeader;
    if (hasilHitung[0] == true) {
      dashboardCt
          .checkingDetailKeranjangArsip(dashboardCt.primaryKeyFaktur.value);
      dashboardCt.aksiPilihKategoriBarang();
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.to(RincianPemesanan(),
          duration: Duration(milliseconds: 500), transition: Transition.zoom);
      UtilsAlert.showToast("Selesai perhitungan header");
    } else {
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.to(RincianPemesanan(),
          duration: Duration(milliseconds: 500), transition: Transition.zoom);
      UtilsAlert.showToast("Gagal perhitungan header");
    }
    dashboardCt.statusHitungHeader.value = false;
    dashboardCt.statusHitungHeader.refresh();
  }

  void transaksiBaru() {
    List tampung = [];
    var getValue1 = AppData.noFaktur.split("|");
    for (var element in getValue1) {
      var listFilter = element.split("-");
      var data = {
        "no_faktur": listFilter[0],
        "key": listFilter[1],
        "no_cabang": listFilter[2],
        "nomor_antrian": listFilter[3],
      };
      tampung.add(data);
    }
    print('hasil filter nofaktur $tampung');

    if (tampung.isNotEmpty) {
      var filter = "";
      for (var element in tampung) {
        if ("${element['no_faktur']}" != dashboardCt.nomorFaktur.value) {
          if (filter == "") {
            filter =
                "${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
          } else {
            filter =
                "$filter|${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
          }
        }
      }
      print('hasil filter setelah di hapus $filter');
      AppData.noFaktur = filter;
    }

    if (AppData.noFaktur != "") {
      dashboardCt.checkingData();
    } else {
      dashboardCt.nomorFaktur.value = "-";
      dashboardCt.primaryKeyFaktur.value = "";
      dashboardCt.kodePelayanSelected.value = "";
      dashboardCt.customSelected.value = "";
      dashboardCt.jumlahItemDikeranjang.value = 0;
      dashboardCt.totalNominalDikeranjang.value = 0;
      dashboardCt.persenDiskonPesanBarang.value.text = "";
      dashboardCt.hargaDiskonPesanBarang.value.text = "";
      dashboardCt.persenDiskonPesanBarangView.value.text = "";
      dashboardCt.hargaDiskonPesanBarangView.value.text = "";
      dashboardCt.ppnPesan.value.text = "";
      dashboardCt.ppnHarga.value.text = "";
      dashboardCt.ppnPesanView.value.text = "";
      dashboardCt.ppnHargaView.value.text = "";
      dashboardCt.serviceChargePesan.value.text = "";
      dashboardCt.serviceChargeHarga.value.text = "";
      dashboardCt.serviceChargePesanView.value.text = "";
      dashboardCt.serviceChargeHargaView.value.text = "";
      dashboardCt.diskonHeader.value = 0.0;
      dashboardCt.allQtyJldt.value = 0;
      dashboardCt.listKeranjang.value.clear();
      dashboardCt.listKeranjangArsip.value.clear();
      refrehVariabel();
      dashboardCt.getKelompokBarang('');
      // dashboardCt.arsipController.startLoad();
    }
    dashboardCt.startLoad('hapus_faktur');
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.back();
  }

  void voidFaktur(dataSelected) async {
    Future<bool> prosesVoidFaktur =
        GetDataController().updateFakturVoid(dataSelected);
    bool hasilVoid = await prosesVoidFaktur;
    if (hasilVoid) {
      HapusJldtController().validasi(dataSelected[0]);
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.back();
    } else {
      UtilsAlert.showToast("Gagal void faktur");
    }
  }

  void refrehVariabel() {
    dashboardCt.nomorFaktur.refresh();
    dashboardCt.listKeranjangArsip.refresh();
    dashboardCt.listKeranjang.refresh();
    dashboardCt.allQtyJldt.refresh();
    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();
    dashboardCt.customSelected.refresh();
    dashboardCt.kodePelayanSelected.refresh();
    dashboardCt.primaryKeyFaktur.refresh();
  }

  void editBarangKeranjang(selectedProduk) {
    print('masuk sini edit');
    var filterProduk = [];
    for (var element in dashboardCt.listKeranjangArsip.value) {
      if ("${element['GROUP']}${element['BARANG']}" ==
          "${selectedProduk["GROUP"]}${selectedProduk["KODE"]}") {
        filterProduk.add(element);
      }
    }
    editKeranjang(
        Get.context!,
        selectedProduk["GROUP"],
        selectedProduk["KODE"],
        selectedProduk["STDJUAL"],
        selectedProduk["jumlah_beli"],
        filterProduk[0]["NOURUT"],
        filterProduk[0]["PK"],
        filterProduk[0]["NOMOR"],
        filterProduk[0]["GUDANG"],
        filterProduk[0]["DISCD"],
        filterProduk[0]["DISC1"]);
  }
}
