import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/pos/buat_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

import 'penjualan/dashboard_penjualan_controller.dart';
import 'penjualan/faktur_penjualan_si/buttom_sheet/fpsi_pesan_barang_ct.dart';
import 'penjualan/nota_pengiriman_barang/memilih_sohd_controller.dart';
import 'penjualan/order_penjualan/buttom_sheet/op_pesan_barang_ct.dart';
import 'penjualan/order_penjualan/item_order_penjualan_controller.dart';

class GlobalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var dashboardController = Get.put(DashbardController());
  var buatFakturController = Get.put(BuatFakturController());
  var sidebarCt = Get.put(SidebarController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var itemOrderPenjualanCt = Get.put(ItemOrderPenjualanController());

  var stokOpnameCtr = Get.put(StockOpnameController());

  var cari = TextEditingController().obs;

  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  void buttomSheet1(List dataList, String judul, String stringController,
      String namaSelected) {
    cari.value.text = "";
    showModalBottomSheet(
        context: Get.context!,
        transitionAnimationController: animasiController,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          List dataShow = dataList;
          List dataAll = dataList;
          bool statusCari = false;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Utility.normal,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 90,
                            child: Text(
                              "$judul",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: InkWell(
                                  onTap: () => Navigator.pop(Get.context!),
                                  child: Icon(Iconsax.close_circle)))
                        ],
                      ),
                      SizedBox(
                        height: Utility.normal,
                      ),
                      CardCustom(
                        colorBg: Colors.white,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 15,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 7, left: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 90,
                                        child: TextField(
                                          controller: cari.value,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Cari"),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.5,
                                              color: Colors.black),
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) {
                                            setState(() {
                                              if (stringController ==
                                                  "pilih_so_nota_pengiriman") {
                                                var textCari =
                                                    value.toLowerCase();
                                                var filter = dataAll
                                                    .where((filterOnchange) {
                                                  var nomorCari =
                                                      filterOnchange['NOMOR']
                                                          .toLowerCase();

                                                  return nomorCari
                                                      .contains(textCari);
                                                }).toList();
                                                statusCari = true;
                                                dataShow = filter;
                                              } else {
                                                var textCari =
                                                    value.toLowerCase();
                                                var filter = dataAll
                                                    .where((filterOnchange) {
                                                  var namaCari =
                                                      filterOnchange['NAMA']
                                                          .toLowerCase();

                                                  return namaCari
                                                      .contains(textCari);
                                                }).toList();
                                                statusCari = true;
                                                dataShow = filter;
                                              }
                                            });
                                          },
                                          onSubmitted: (value) {
                                            setState(() {
                                              cari.value.text = "";
                                            });
                                          },
                                        ),
                                      ),
                                      statusCari == false
                                          ? SizedBox()
                                          : Expanded(
                                              flex: 15,
                                              child: IconButton(
                                                icon: Icon(
                                                  Iconsax.close_circle,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  statusCari = false;
                                                  cari.value.text = "";
                                                  dataShow = dataAll;
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
                      ),
                      SizedBox(
                        height: Utility.normal,
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemCount: dataShow.length,
                                itemBuilder: (context, index) {
                                  var nomor = dataShow[index]['NOMOR'];
                                  var nama = dataShow[index]['NAMA'];
                                  var kode = dataShow[index]['KODE'];
                                  var inisial = dataShow[index]['INISIAL'];
                                  var wilayah = dataShow[index]['WILAYAH'];
                                  var ppn = dataShow[index]['PPN'];
                                  var charge = dataShow[index]['SCHARGE'];
                                  return InkWell(
                                    onTap: () {
                                      if (stringController ==
                                              "pilih_barang_so_penjualan" ||
                                          stringController ==
                                              "pilih_so_nota_pengiriman") {
                                        aksiPenjualan(
                                            dataShow[index], stringController);
                                      } else if (stringController ==
                                          "pilih_barang_faktur_penjualan_si") {
                                        aksiFakturPenjualanSI(dataShow[index]);
                                      } else if (stringController ==
                                          'pilih_gudang_stok_opaname') {
                                        aksiGudangStokOpname(dataShow[index]);
                                      } else if (stringController ==
                                          'pilih_kelompok_barang_stok_opaname') {
                                        aksiKelompokBarangStokOpname(
                                            dataShow[index]);
                                      }
                                      {
                                        print(stringController);

                                        checkingAksi(
                                            stringController,
                                            judul,
                                            nama,
                                            kode,
                                            inisial,
                                            wilayah,
                                            ppn,
                                            charge);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Container(
                                        decoration: stringController ==
                                                "pilih_so_nota_pengiriman"
                                            ? BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    Utility.borderStyle1,
                                                border: Border.all(
                                                    color: Utility.nonAktif))
                                            : BoxDecoration(
                                                color: namaSelected == nama
                                                    ? Utility.primaryDefault
                                                    : Colors.transparent,
                                                borderRadius:
                                                    Utility.borderStyle1,
                                                border: Border.all(
                                                    color: Utility.nonAktif)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Center(
                                            child: stringController ==
                                                    "pilih_so_nota_pengiriman"
                                                ? Text(
                                                    "${Utility.convertNoFaktur(nomor)}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    "$nama",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            namaSelected == nama
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                      SizedBox(
                        height: Utility.normal,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void checkingAksi(
      stringController, judul, nama, kode, inisial, wilayah, ppn, charger) {
    if (stringController == 'dashboard') {
      if (judul == "Pilih Cabang") {
        dashboardController.cabangKodeSelected.value = kode;
        dashboardController.cabangNameSelected.value = nama;
        dashboardController.ppnCabang.value = double.parse("$ppn");
        dashboardController.serviceChargerCabang.value =
            double.parse("$charger");
        dashboardController.cabangKodeSelected.refresh();
        dashboardController.cabangNameSelected.refresh();
        dashboardController.ppnCabang.refresh();
        dashboardController.serviceChargerCabang.refresh();
        dashboardController.pilihGudang(nama);
        dashboardController.aksiGetSalesman(kode, '', '');
        dashboardController.aksiPilihKategoriBarang();
        Get.back();
      } else if (judul == "Pilih Kategori") {
        dashboardController.kategoriBarang.value = nama;
        dashboardController.kategoriBarang.refresh();
        dashboardController.aksiPilihKategoriBarang();
        Get.back();
      } else if (judul == "Pilih Pelayan" || judul == "Pilih Sales") {
        dashboardController.pelayanSelected.value = nama;
        dashboardController.kodePelayanSelected.value = kode;
        dashboardController.pelayanSelected.refresh();
        dashboardController.kodePelayanSelected.refresh();
        dashboardController.aksiGetCustomer(kode, '');
        Get.back();
      } else if (judul == "Pilih Pelanggan") {
        dashboardController.namaPelanggan.value = nama;
        dashboardController.customSelected.value = kode;
        dashboardController.wilayahCustomerSelected.value = wilayah;
        dashboardController.namaPelanggan.refresh();
        dashboardController.customSelected.refresh();
        dashboardController.wilayahCustomerSelected.refresh();
        Get.back();
      }
    } else if (stringController == 'sidebar') {
      if (judul == "Pilih Cabang") {
        sidebarCt.cabangKodeSelectedSide.value = kode;
        sidebarCt.cabangNameSelectedSide.value = nama;
        sidebarCt.cabangKodeSelectedSide.refresh();
        sidebarCt.cabangNameSelectedSide.refresh();
        Get.back();
      }
    } else if (stringController == 'penjualan') {
      if (judul == "Pilih Sales") {
        dashboardPenjualanCt.selectedIdSales.value = kode;
        dashboardPenjualanCt.selectedNameSales.value = nama;
        dashboardPenjualanCt.selectedIdSales.refresh();
        dashboardPenjualanCt.selectedNameSales.refresh();
        dashboardPenjualanCt.getDataPelanggan("load_next");
        Get.back();
      } else if (judul == "Pilih Pelanggan") {
        dashboardPenjualanCt.selectedIdPelanggan.value = kode;
        dashboardPenjualanCt.selectedNamePelanggan.value = nama;
        dashboardPenjualanCt.wilayahCustomerSelected.value = wilayah;
        dashboardPenjualanCt.selectedIdPelanggan.refresh();
        dashboardPenjualanCt.selectedNamePelanggan.refresh();
        dashboardPenjualanCt.wilayahCustomerSelected.refresh();
        Get.back();
      }
    }
  }

  void aksiPenjualan(dataTerpilih, stringController) {
    if (stringController == "pilih_barang_so_penjualan") {
      itemOrderPenjualanCt.typeBarangSelected.value = dataTerpilih['SAT'];
      itemOrderPenjualanCt.statusEditBarang.value = false;
      Get.back();
      OrderPenjualanPesanBarangController()
          .validasiSatuanBarang([dataTerpilih]);
    } else if (stringController == "pilih_so_nota_pengiriman") {
      ButtonSheetController().validasiButtonSheet(
          "Pilih SO",
          contentValidasiPilihSO(dataTerpilih),
          "validasi_pilih_so",
          'Pilih', () {
        MemilihSOHDController().mencariDataSODT([dataTerpilih]);
      });
    }
  }

  void aksiGudangStokOpname(dataTerpilih) {
    print(dataTerpilih);
    stokOpnameCtr.gudangCodeSelected.value = dataTerpilih['KODE'].toString();
    stokOpnameCtr.gudangCtr.text = dataTerpilih['NAMA'].toString();
    Get.back();
  }

  void aksiKelompokBarangStokOpname(dataTerpilih) {
    stokOpnameCtr.groupCodeSelected.value = dataTerpilih['KODE'].toString();
    stokOpnameCtr.groupBarangCtr.text = dataTerpilih['NAMA'].toString();
    Get.back();
  }

  void aksiFakturPenjualanSI(dataTerpilih) {
    FPSIButtomSheetPesanBarang().prosesPesanBarang1([dataTerpilih]);
    Get.back();
  }

  Widget contentValidasiPilihSO(dataTerpilih) {
    return Text(
      "Yakin memilih Order penjualan nomor - ${Utility.convertNoFaktur(dataTerpilih['NOMOR'])}",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  void buttomSheetInsertFaktur() {
    showModalBottomSheet(
        context: Get.context!,
        transitionAnimationController: animasiController,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Utility.normal,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 90,
                      child: Text(
                        "Buat Faktur",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: InkWell(
                            onTap: () => Navigator.pop(Get.context!),
                            child: Icon(Iconsax.close_circle)))
                  ],
                ),
                SizedBox(
                  height: Utility.normal,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Utility.borderStyle2,
                      border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(255, 211, 205, 205))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: dashboardController.reff.value,
                      decoration: new InputDecoration(
                          border: InputBorder.none, hintText: "Reff"),
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          fontSize: 12.0, height: 2.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: Utility.normal,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Utility.borderStyle2,
                      border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(255, 211, 205, 205))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller:
                          dashboardController.keteranganInsertFaktur.value,
                      maxLines: null,
                      maxLength: 225,
                      decoration: new InputDecoration(
                          border: InputBorder.none, hintText: "Tambah Catatan"),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          fontSize: 12.0, height: 2.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: Utility.normal,
                ),
                Button1(
                    textBtn: "Buat Faktur",
                    colorBtn: Utility.primaryDefault,
                    onTap: () {
                      UtilsAlert.loadingSimpanData(
                          context, "Membuat faktur...");
                      buatFakturController.getAkhirNomorFaktur();
                    }),
                SizedBox(
                  height: Utility.large,
                ),
              ],
            ),
          );
        });
  }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  Future<String> checkNokey(tabel, column, valCari) async {
    String hasilFinal = "";

    Future<List> checkNokey = GetDataController()
        .getSpesifikData(tabel, column, valCari, "get_spesifik_data_transaksi");
    List hasilCheck = await checkNokey;

    if (hasilCheck.isNotEmpty) {
      var getNokey = hasilCheck[0]['NOKEY'];
      var hitungNokey = int.parse(getNokey) + 1;
      if ("$hitungNokey".length == 1) {
        hasilFinal = "0000$hitungNokey";
      } else if ("$hitungNokey".length == 2) {
        hasilFinal = "000$hitungNokey";
      } else if ("$hitungNokey".length == 3) {
        hasilFinal = "00$hitungNokey";
      } else if ("$hitungNokey".length == 4) {
        hasilFinal = "0$hitungNokey";
      } else if ("$hitungNokey".length == 5) {
        hasilFinal = "$hitungNokey";
      }
    } else {
      hasilFinal = "00001";
    }

    return Future.value(hasilFinal);
  }

  Future<List> checkLastNomor(tabel, cabangSelected) async {
    String lastNumber = "";
    String lastNumberCb = "";
    String asliTerakhirNomor = "";
    String asliTerakhirNomorCB = "";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'kode_cabang': cabangSelected,
    };
    var connect = Api.connectionApi("post", body, "get_last_number_pembayaran");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (valueBody['status'] == true) {
      var fltr1a = "";
      var fltr3a = "";

      asliTerakhirNomor = valueBody['data'][0]['NOMOR'];
      asliTerakhirNomorCB = valueBody['data'][0]['NOMORCB'];

      var dt = DateTime.now();
      var tahunBulan = "${DateFormat('yyyyMM').format(dt)}";
      if (data.isNotEmpty) {
        var tp1 = valueBody['data'][0]['NOMOR'];
        var fltr1 = tp1.substring(0, 2);
        var fltr2 = tp1.substring(8, 12);
        var tambah = int.parse(fltr2) + 1;
        var fltr3 = "$tambah".length == 3
            ? "0$tambah"
            : "$tambah".length == 2
                ? "00$tambah"
                : "$tambah".length == 1
                    ? "000$tambah"
                    : "$tambah";

        lastNumber = "$fltr1$tahunBulan$fltr3";

        var tp1a = valueBody['data'][0]['NOMORCB'];
        fltr1a = tp1a.substring(0, 2);
        var fltr2a = tp1a.substring(8, 12);
        var tambaha = int.parse(fltr2a) + 1;
        fltr3a = "$tambaha".length == 3
            ? "0$tambah"
            : "$tambah".length == 2
                ? "00$tambah"
                : "$tambah".length == 1
                    ? "000$tambah"
                    : "$tambah";
        lastNumberCb = "$fltr1a$tahunBulan$fltr3a";
      } else {
        var kode = "DB";
        var nomor = "0001";
        lastNumber = "$kode$tahunBulan$nomor";
        lastNumberCb = "$kode$tahunBulan$nomor";
      }
    } else {
      UtilsAlert.showToast(valueBody['message']);
    }
    return Future.value(
        [lastNumber, lastNumberCb, asliTerakhirNomor, asliTerakhirNomorCB]);
  }
}
