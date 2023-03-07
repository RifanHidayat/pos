import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/hapus_dodt.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/memilih_sohd_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/simpan_nota_pengiriman.dart';
import 'package:siscom_pos/controller/perhitungan_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class DetailNotaPenjualanController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var getDataCt = Get.put(GetDataController());
  var sidebarCt = Get.put(SidebarController());

  var jumlahPesan = TextEditingController().obs;
  var hargaJualPesanBarang = TextEditingController().obs;

  var persenDiskonPesanBarang = TextEditingController(text: "0.0").obs;
  var nominalDiskonPesanBarang = TextEditingController(text: "0.0").obs;

  var persenDiskonHeaderRincian = TextEditingController(text: "0.0").obs;
  var nominalDiskonHeaderRincian = TextEditingController(text: "0.0").obs;
  var persenDiskonHeaderRincianView = TextEditingController(text: "0.0").obs;
  var nominalDiskonHeaderRincianView = TextEditingController(text: "0.0").obs;

  var persenPPNHeaderRincian = TextEditingController(text: "0.0").obs;
  var nominalPPNHeaderRincian = TextEditingController(text: "0.0").obs;
  var persenPPNHeaderRincianView = TextEditingController(text: "0.0").obs;
  var nominalPPNHeaderRincianView = TextEditingController(text: "0.0").obs;

  var nominalOngkosHeaderRincian = TextEditingController(text: "0.0").obs;
  var nominalOngkosHeaderRincianView = TextEditingController(text: "0.0").obs;

  var keterangan1 = TextEditingController().obs;
  var keterangan2 = TextEditingController().obs;
  var keterangan3 = TextEditingController().obs;
  var keterangan4 = TextEditingController().obs;

  Rx<List<String>> typeBarang = Rx<List<String>>([]);

  var sohdTerpilih = [].obs;
  var sodtTerpilih = [].obs;
  var barangTerpilih = [].obs;
  var dodtSelected = [].obs;

  var statusInformasiDo = false.obs;
  var statusAksiItemOrderPenjualan = false.obs;
  var statusBack = false.obs;
  var statusDODTKosong = false.obs;

  var totalPesanBarang = 0.0.obs;
  var totalNetto = 0.0.obs;
  var hrgtotDohd = 0.0.obs;
  var subtotal = 0.0.obs;
  var allQtyBeli = 0.0.obs;
  var qtyOuts = 0.0.obs;
  var stokBarangTerpilih = 0.0.obs;

  var typeBarangSelected = "".obs;
  var htgBarangSelected = "".obs;
  var pakBarangSelected = "".obs;

  var periodeSelected = DateTime.now().obs;

  void startload(status) {
    getSoSelected(status);
  }

  void getSoSelected(status) async {
    if (status == true) {
      sohdTerpilih.clear();
      sodtTerpilih.clear();
      barangTerpilih.clear();
      dodtSelected.clear();

      sohdTerpilih.refresh();
      sodtTerpilih.refresh();
      barangTerpilih.refresh();
      dodtSelected.refresh();
    }

    Future<List> getSOHDSelectedNotaPengiriman =
        getDataCt.sohdSelectedNotaPengiriman(
            dashboardPenjualanCt.selectedIdPelanggan.value,
            dashboardPenjualanCt.selectedIdSales.value,
            "${DateFormat('MM').format(periodeSelected.value)}",
            "${DateFormat('yyyy').format(periodeSelected.value)}");
    List hasilData = await getSOHDSelectedNotaPengiriman;
    sohdTerpilih.value = hasilData;
    sohdTerpilih.refresh();
    if (status == true) {
      checkDODT();
    } else {
      Get.back();
    }
  }

  void checkDODT() async {
    print('jalan ambil dodt');
    Future<List> prosesCheckDODT = GetDataController().getSpesifikData(
        "DODT",
        "NOMOR",
        dashboardPenjualanCt.nomorDoSelected.value,
        "get_spesifik_data_transaksi");
    List hasilProsesCheck = await prosesCheckDODT;
    if (hasilProsesCheck.isNotEmpty) {
      dodtSelected.value = hasilProsesCheck;
      dodtSelected.refresh();
      Future<List> prosesGetNomorSOHD = aksiGetNomorSOHD(hasilProsesCheck);
      List hasilNomorSOHD = await prosesGetNomorSOHD;

      print("nomor sohd selected ${hasilNomorSOHD}");
      // pencarian SODT
      // if (hasilNomorSOHD.length == 1) {
      //   print("masuk sini prosesssss");
      //   Future<List> prosesSodtSelected = GetDataController().getSpesifikData(
      //       "SODT", "NOMOR", hasilNomorSOHD[0], "get_spesifik_data_transaksi");
      //   List hasilProsesSODT = await prosesSodtSelected;
      //   sodtTerpilih.value = hasilProsesSODT;
      //   sodtTerpilih.refresh();
      //   combainData(hasilProsesSODT, hasilProsesCheck);
      // } else {
      //   String nomorSohdFilter = "";
      //   for (var element in hasilNomorSOHD) {
      //     if (nomorSohdFilter == "") {
      //       nomorSohdFilter = "$element";
      //     } else {
      //       nomorSohdFilter = "$nomorSohdFilter,$element";
      //     }
      //   }
      //   Future<List> prosesSodtSelectedListValue =
      //       GetDataController().pilihSodtMultipleSelected(nomorSohdFilter);
      //   List hasilSodtMultiple = await prosesSodtSelectedListValue;
      //   print('jalan multiple');
      //   List getFilterData = [];
      //   for (var ele in hasilSodtMultiple) {
      //     for (var al in ele) {
      //       getFilterData.add(al);
      //     }
      //   }

      //   sodtTerpilih.value = getFilterData;
      //   sodtTerpilih.refresh();
      //   combainData(sodtTerpilih.value, dodtSelected.value);
      // }
      statusDODTKosong.value = false;
      statusDODTKosong.refresh();
    } else {
      var dataUpdate = {
        'column1': 'NOMOR',
        'cari1': dashboardPenjualanCt.nomorDoSelected.value,
        'HRGTOT': '0',
        'DISCD': '0',
        'DISCH': '0',
        'DISCN': '0',
        'BIAYA': '0',
        'TAXN': '0',
        'HRGNET': '0',
        'QTY': '0',
        'QTZ': '0',
      };
      Future<List> prosesUpdateSOHD = GetDataController().editDataGlobal(
          "DOHD", "edit_data_global_transaksi", "1", dataUpdate);
      List hasilproses = await prosesUpdateSOHD;
      print(hasilproses);

      subtotal.value = 0.0;
      subtotal.refresh();

      totalNetto.value = 0.0;
      totalNetto.refresh();

      hrgtotDohd.value = 0.0;
      hrgtotDohd.refresh();

      allQtyBeli.value = 0.0;
      allQtyBeli.refresh();

      UtilsAlert.showToast("Data item nota tidak ditemukan");
      statusDODTKosong.value = true;
      statusDODTKosong.refresh();
    }
  }

  void combainData(finalProsesSODT, hasilProsesCheck) {
    sodtTerpilih.value = finalProsesSODT;
    sodtTerpilih.refresh();
    MemilihSOHDController()
        .cariBarangProses1(finalProsesSODT, hasilProsesCheck, "load_awal");
  }

  Future<List> aksiGetNomorSOHD(hasilProsesCheck) async {
    List listTampungData = [];

    for (var element in hasilProsesCheck) {
      listTampungData.add(element['NOXX']);
    }
    listTampungData = listTampungData.toSet().toList();
    return Future.value(listTampungData);
  }

  void prosesPilihBarang(List barang) async {
    // print('barang terpilih $barang');
    if (barang.isNotEmpty) {
      if (barangTerpilih.isNotEmpty) {
        print("tambah barang lagi nih");
        List dataSudahDiUpdate = [];
        for (var element in barangTerpilih) {
          if (Utility.validasiValueDouble('${element["qty_beli"]}') > 0.0) {
            dataSudahDiUpdate.add(element);
          }
        }
        for (var element in dataSudahDiUpdate) {
          barang.removeWhere((br) =>
              "${br['NOMOR_SO']}${br['GROUP']}${br['KODE']}" ==
              "${element['NOMOR_SO']}${element['GROUP']}${element['KODE']}");
        }

        var hasilBarangAkhir = dataSudahDiUpdate + barang;
        barangTerpilih.value = hasilBarangAkhir;
        barangTerpilih.refresh();
      } else {
        barangTerpilih.value = barang;
        barangTerpilih.refresh();
      }

      statusDODTKosong.value = false;
      statusDODTKosong.refresh();
      // Future<bool> prosesAkumulasiMenyeluruh = perhitunganMenyeluruhDO();
      // bool hasilProsesAkumulasi = await prosesAkumulasiMenyeluruh;
      // if (hasilProsesAkumulasi) {
      //   statusDODTKosong.value = false;
      //   statusDODTKosong.refresh();
      // }
    } else {
      statusDODTKosong.value = true;
      statusDODTKosong.refresh();
    }
  }

  void updateListBarangSelected(
      productSelected, qtySebelumEdit, listDataImeiSelected) {
    print(productSelected);
    // print(qtySebelumEdit);
    // print(listDataImeiSelected);
    if (Utility.validasiValueDouble(jumlahPesan.value.text) <= 0.0) {
      UtilsAlert.showToast("Qty pemesanan tidak valid");
    } else {
      var getBarangSelected = barangTerpilih.firstWhere((element) =>
          "${element['NOMOR_SO']}${element['GROUP']}${element['KODE']}" ==
          "${productSelected[0]['NOMOR_SO']}${productSelected[0]['GROUP']}${productSelected[0]['KODE']}");
      // print(getBarangSelected);
      getBarangSelected["qty_beli"] =
          Utility.validasiValueDouble(jumlahPesan.value.text);
      getBarangSelected["DISC1"] =
          Utility.validasiValueDouble(persenDiskonPesanBarang.value.text);
      getBarangSelected["DISCD"] =
          Utility.validasiValueDouble(nominalDiskonPesanBarang.value.text);
      Get.back();
      Get.back();
      barangTerpilih.refresh();
      perhitunganMenyeluruhDO();
    }
  }

  void hapusListNota(dataSelected) {
    if (dataSelected['qty_beli'] == 0 || dataSelected['qty_beli'] == null) {
      barangTerpilih.removeWhere((element) =>
          "${element['NOMOR_SO']}${element['GROUP']}${element['KODE']}" ==
          "${dataSelected['NOMOR_SO']}${dataSelected['GROUP']}${dataSelected['KODE']}");
      barangTerpilih.refresh();
      if (barangTerpilih.isEmpty) {
        statusDODTKosong.value = true;
        statusDODTKosong.refresh();
      }
    } else {
      ButtonSheetController().validasiButtonSheet("Hapu Barang",
          Text("Yakin hapus barang ini ?"), "hapus_barang_dodt", 'Hapus', () {
        HapusDodtController().hapusBarangOnce(dataSelected, '');
      });
    }
  }

  Future<bool> perhitunganMenyeluruhDO() async {
    // perhitungan menyeluruh barang terpilih
    double hitungSub = 0.0;
    for (var element in barangTerpilih) {
      if (Utility.validasiValueDouble("${element['qty_beli']}") > 0.0) {
        Future<dynamic> prosesInputPersen = PerhitunganCt().hitungPersenDiskon(
            "${element['DISC1']}",
            "${element['STDJUAL']}",
            jumlahPesan.value.text);
        List hasilInputQty = await prosesInputPersen;
        var hitung1 = Utility.validasiValueDouble("${element['qty_beli']}") *
            hasilInputQty[1];
        hitungSub += hitung1;
      }
    }
    subtotal.value = hitungSub;
    subtotal.refresh();

    // hitung diskon header

    if (persenDiskonHeaderRincian.value.text != "0.0") {
      var hasilNominalDiskon = Utility.nominalDiskonHeader(
          "${subtotal.value}", persenDiskonHeaderRincian.value.text);
      nominalDiskonHeaderRincian.value.text = "$hasilNominalDiskon";
      nominalDiskonHeaderRincianView.value.text =
          hasilNominalDiskon.toStringAsFixed(2);

      nominalDiskonHeaderRincian.refresh();
      nominalDiskonHeaderRincianView.refresh();
    }

    // hitung ppn header

    if (persenPPNHeaderRincian.value.text != "0.0") {
      var hasilNominalPpn = Utility.nominalDiskonHeader(
          "${subtotal.value}", persenPPNHeaderRincian.value.text);

      nominalPPNHeaderRincian.value.text = "$hasilNominalPpn";
      nominalPPNHeaderRincianView.value.text =
          hasilNominalPpn.toStringAsFixed(2);

      nominalPPNHeaderRincian.refresh();
      nominalPPNHeaderRincianView.refresh();
    }

    // hitung netto
    totalNetto.value = (Utility.validasiValueDouble("${subtotal.value}") -
            Utility.validasiValueDouble(
                nominalDiskonHeaderRincian.value.text)) +
        Utility.validasiValueDouble(nominalPPNHeaderRincian.value.text);

    totalNetto.refresh();

    return Future.value(true);
  }

  void perhitunganHeader() {
    // setting header
    double convertDiskon =
        Utility.validasiValueDouble(nominalDiskonHeaderRincian.value.text);
    double ppnPPN =
        Utility.validasiValueDouble(persenPPNHeaderRincian.value.text);
    double convertPPN =
        Utility.validasiValueDouble(nominalPPNHeaderRincian.value.text);
    double convertBiaya =
        Utility.validasiValueDouble(nominalOngkosHeaderRincian.value.text);

    print("subtotal ${subtotal.value}");
    print("diskon header $convertDiskon");
    print("ppn header $convertPPN");
    print("biaya header $convertBiaya");

    totalNetto.value =
        (subtotal.value - convertDiskon) + convertPPN + convertBiaya;
    totalNetto.refresh();

    GetDataController().hitungHeader(
        "DOHD",
        "DODT",
        dashboardPenjualanCt.nomorDoSelected.value,
        "${subtotal.value}",
        "$convertDiskon",
        "$ppnPPN",
        "$convertPPN",
        "$convertBiaya");

    persenDiskonHeaderRincian.refresh();
    nominalDiskonHeaderRincian.refresh();
    persenDiskonHeaderRincianView.refresh();
    nominalDiskonHeaderRincianView.refresh();

    persenPPNHeaderRincian.refresh();
    nominalPPNHeaderRincian.refresh();
    persenPPNHeaderRincianView.refresh();
    nominalPPNHeaderRincianView.refresh();

    nominalOngkosHeaderRincian.refresh();
    nominalOngkosHeaderRincianView.refresh();

    // print('persen diskon ${persenDiskonHeaderRincian.value.text}');
    // print('nominal diskon ${nominalDiskonHeaderRincian.value.text}');

    // print('persen ppn ${persenPPNHeaderRincian.value.text}');
    // print('nominal ppn ${nominalPPNHeaderRincian.value.text}');

    // // print('persen biaya ${persenPPNHeaderRincian.value.text}');
    // print('nominal biaya ${nominalOngkosHeaderRincian.value.text}');
  }

  void showKeteranganDOHD() {
    keterangan1.value.text = dashboardPenjualanCt.dohdSelected[0]['KET1'];
    keterangan2.value.text = dashboardPenjualanCt.dohdSelected[0]['KET2'];
    keterangan3.value.text = dashboardPenjualanCt.dohdSelected[0]['KET3'];
    keterangan4.value.text = dashboardPenjualanCt.dohdSelected[0]['KET4'];
    ButtonSheetController().validasiButtonSheet(
        "Keterangan", contentShowKeterangan(), "show_keterangan", "", () => {});
  }

  Widget contentShowKeterangan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Keterangan 1",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan1.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 2",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan2.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 3",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan3.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.normal,
        ),
        Text(
          "Keterangan 4",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Utility.greyDark),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(Get.context!).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utility.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: keterangan4.value,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(border: InputBorder.none),
              style:
                  TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          height: Utility.medium,
        ),
        InkWell(
          onTap: () => simpanPerubahanKeterangan(),
          child: CardCustom(
            colorBg: Utility.primaryDefault,
            radiusBorder: Utility.borderStyle1,
            widgetCardCustom: Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  "Simpan perubahan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void simpanPerubahanKeterangan() {
    ButtonSheetController().validasiButtonSheet(
        "Keterangan",
        Text("Yakin simpan perubahan keterangan ?"),
        "perubahan_keterangan",
        "Simpan", () async {
      UtilsAlert.loadingSimpanData(Get.context!, "Simpan perubahan data...");
      var dataUpdate = {
        'column1': 'NOMOR',
        'cari1': '${dashboardPenjualanCt.nomorDoSelected.value}',
        'KET1': keterangan1.value.text,
        'KET2': keterangan2.value.text,
        'KET3': keterangan3.value.text,
        'KET4': keterangan4.value.text,
      };
      Future<List> editKeterangan = GetDataController().editDataGlobal(
          "DOHD", "edit_data_global_transaksi", "1", dataUpdate);
      List hasilUpdate = await editKeterangan;
      if (hasilUpdate[0] == true) {
        Future<bool> prosesRefreshSOHD = dashboardPenjualanCt.getDataAllDOHD();
        bool hasilProsesRefresh = await prosesRefreshSOHD;
        if (hasilProsesRefresh == true) {
          dashboardPenjualanCt.loadDOHDSelected();
          Get.back();
          Get.back();
          Get.back();
        }
      }
    });
  }

  void showDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: ModalPopupPeringatan(
              title: "Order Penjualan",
              content: "Yakin simpan data ini ?",
              positiveBtnText: "Simpan",
              negativeBtnText: "Urungkan",
              positiveBtnPressed: () {
                backValidasi();
              },
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void backValidasi() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Loading...");
    SimpanNotaPengirimanController().simpanDODT(barangTerpilih);
    // Future<bool> prosesClose = getDataCt.closePenjualan(
    //     "DOHD", "", dashboardPenjualanCt.nomorDoSelected.value, "close_dohd");
    // bool hasilClose = await prosesClose;
    // if (hasilClose == true) {
    //   dashboardPenjualanCt.changeMenu(2);
    //   if (statusAksiItemOrderPenjualan.value) {
    //     Get.back();
    //     Get.back();
    //     Get.back();
    //     statusBack.value = true;
    //     statusBack.refresh();
    //   } else {
    //     Get.back();
    //     Get.back();
    //     Get.back();
    //     Get.back();
    //     statusBack.value = true;
    //     statusBack.refresh();
    //   }
    // }
  }
}
