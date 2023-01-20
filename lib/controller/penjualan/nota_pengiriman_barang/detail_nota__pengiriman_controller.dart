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

  var persenDiskonPesanBarang = TextEditingController().obs;
  var nominalDiskonPesanBarang = TextEditingController().obs;

  var persenDiskonHeaderRincian = TextEditingController().obs;
  var nominalDiskonHeaderRincian = TextEditingController().obs;
  var persenDiskonHeaderRincianView = TextEditingController().obs;
  var nominalDiskonHeaderRincianView = TextEditingController().obs;

  var persenPPNHeaderRincian = TextEditingController().obs;
  var nominalPPNHeaderRincian = TextEditingController().obs;
  var persenPPNHeaderRincianView = TextEditingController().obs;
  var nominalPPNHeaderRincianView = TextEditingController().obs;

  var nominalOngkosHeaderRincian = TextEditingController().obs;
  var nominalOngkosHeaderRincianView = TextEditingController().obs;

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
      if (hasilNomorSOHD.length == 1) {
        Future<List> prosesSodtSelected = GetDataController().getSpesifikData(
            "SODT", "NOMOR", hasilNomorSOHD[0], "get_spesifik_data_transaksi");
        List hasilProsesSODT = await prosesSodtSelected;
        sodtTerpilih.value = hasilProsesSODT;
        sodtTerpilih.refresh();
        combainData(hasilProsesSODT, hasilProsesCheck);
      } else {
        String nomorSohdFilter = "";
        for (var element in hasilNomorSOHD) {
          if (nomorSohdFilter == "") {
            nomorSohdFilter = "$element";
          } else {
            nomorSohdFilter = "$nomorSohdFilter,$element";
          }
        }
        Future<List> prosesSodtSelectedListValue =
            GetDataController().pilihSodtMultipleSelected(nomorSohdFilter);
        List hasilSodtMultiple = await prosesSodtSelectedListValue;
        print('jalan multiple');
        List getFilterData = [];
        for (var ele in hasilSodtMultiple) {
          for (var al in ele) {
            getFilterData.add(al);
          }
        }

        sodtTerpilih.value = getFilterData;
        sodtTerpilih.refresh();
        combainData(sodtTerpilih.value, dodtSelected.value);
      }
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
    print('barang terpilih $barang');
    if (barang.isNotEmpty) {
      barangTerpilih.value = barang;
      barangTerpilih.refresh();
      Future<bool> prosesAkumulasiMenyeluruh = perhitunganMenyeluruhDO();
      bool hasilProsesAkumulasi = await prosesAkumulasiMenyeluruh;
      if (hasilProsesAkumulasi) {
        statusDODTKosong.value = false;
        statusDODTKosong.refresh();
      }
    } else {
      statusDODTKosong.value = true;
      statusDODTKosong.refresh();
    }
  }

  void hapusListNota(dataSelected) {
    if (dataSelected['qty_beli'] == 0 || dataSelected['qty_beli'] == null) {
      print("Kesini 1");
      barangTerpilih.removeWhere((element) =>
          "${element['GROUP']}${element['KODE']}" ==
          "${dataSelected['GROUP']}${dataSelected['KODE']}");
      barangTerpilih.refresh();
    } else {
      ButtonSheetController().validasiButtonSheet("Hapu Barang",
          Text("Yakin hapus barang ini ?"), "hapus_barang_dodt", 'Hapus', () {
        HapusSodtController().hapusBarangOnce(dataSelected, '');
      });
    }
  }

  Future<bool> perhitunganMenyeluruhDO() async {
    Future<List> updateInformasiDOHD = GetDataController().getSpesifikData(
        "DOHD",
        "PK",
        "${dashboardPenjualanCt.dohdSelected[0]['PK']}",
        "get_spesifik_data_transaksi");
    List infoDOHD = await updateInformasiDOHD;

    print('perhitungan data dodt ${dodtSelected.value.length}');

    // perhitungan HRGTOT
    double subtotalKeranjang = 0.0;
    double discdHeader = 0.0;
    double dischHeader = 0.0;
    double allQty = 0.0;

    // double subtotalKeranjang = 0.0;
    // double hargaTotheader = 0.0;
    // double qtyallheader = 0.0;
    // double discdHeader = 0.0;
    // double dischHeader = 0.0;
    // double discnHeader = 0.0;
    // double taxnHeader = 0.0;
    // double biayaHeader = 0.0;

    for (var element in dodtSelected) {
      double hargaBarang = double.parse("${element['HARGA']}");
      double persenDiskonBarang = double.parse("${element['DISC1']}");
      double qtyBarang = double.parse("${element['QTY']}");
      var hitungSubtotal =
          qtyBarang * (hargaBarang - (hargaBarang * persenDiskonBarang * 0.01));
      subtotalKeranjang += hitungSubtotal;
      discdHeader = discdHeader +
          (double.parse("${element['QTY']}") *
              double.parse("${element['DISCD']}"));
      dischHeader = dischHeader +
          (double.parse("${element['QTY']}") *
              double.parse("${element['DISCH']}"));
      allQty += double.parse("${element['QTY']}");

      double discdBarang = double.parse("${element['DISCD']}");
      double dischBarang = double.parse("${element['DISCH']}");

      var hitungDiscnJldt = discdBarang + dischBarang;
      var valueFinalDiscnJldt = hitungDiscnJldt;

      // updateJldt(element['NOKEY'], valueFinalDiscnJldt);

      // double hargaBarang = double.parse("${element['HARGA']}");
      // double discdBarang = double.parse("${element['DISCD']}");
      // double dischBarang = double.parse("${element['DISCH']}");
      // double qtyBarang = double.parse("${element['QTY']}");
      // var hitung1 = hargaBarang * qtyBarang;
      // var hitung2 = discdBarang * qtyBarang;
      // var finalHitung = hitung1 - hitung2;
      // var hitungDiscn = hitung2 + dischBarang;
      // var hitungDiscnDODT = discdBarang + dischBarang;

      // subtotalKeranjang = subtotalKeranjang + finalHitung;
      // hargaTotheader = hargaTotheader + hitung1;
      // qtyallheader = qtyallheader + qtyBarang;
      // discdHeader = discdHeader + hitung2;
      // dischHeader = dischHeader + dischBarang;
      // discnHeader = discnHeader + hitungDiscn;
      // taxnHeader = taxnHeader + double.parse("${element['TAXN']}");
      // biayaHeader = biayaHeader + double.parse("${element['BIAYA']}");

      // update DODT

      // var ongkosSodt = double.parse("${element['BIAYA']}");
      // var discnSodt = hitungDiscnDODT;
      // var ppnSodt = double.parse("${element['TAXN']}");

      GetDataController()
          .updateDodt(element['NOMOR'], element['NOURUT'], valueFinalDiscnJldt);

      double qtyDODT = double.parse("${element["QTY"]}");

      GetDataController().updateProd3(
          element["NOMOR"], element["NOURUT"], qtyDODT, valueFinalDiscnJldt);
    }

    // hitung subtotal
    subtotal.value = "$subtotalKeranjang" == "NaN" ? 0.0 : subtotalKeranjang;
    subtotal.refresh();

    // all qty
    allQtyBeli.value = allQty;
    allQtyBeli.refresh();

    // diskon header

    var fltr1 = Utility.persenDiskonHeader(
        "${subtotal.value}", "${infoDOHD[0]["DISCH"]}");

    print('diskon header persen $fltr1');

    persenDiskonHeaderRincian.value.text = "$fltr1" == "NaN" ? "0.0" : "$fltr1";
    persenDiskonHeaderRincianView.value.text =
        "$fltr1" == "NaN" ? "0.0" : "$fltr1";
    persenDiskonHeaderRincian.refresh();
    persenDiskonHeaderRincianView.refresh();

    nominalDiskonHeaderRincian.value.text = "${infoDOHD[0]["DISCH"]}";
    nominalDiskonHeaderRincianView.value.text =
        Utility.rupiahFormat("${infoDOHD[0]["DISCH"]}", "");
    nominalDiskonHeaderRincian.refresh();
    nominalDiskonHeaderRincianView.refresh();

    // ppn header

    var taxpJLHD = infoDOHD[0]["TAXP"];

    if (taxpJLHD != null || taxpJLHD != "") {
      if (double.parse("$taxpJLHD") > 0.0) {
        print('perhitungan ppn header jalan disini');
        persenPPNHeaderRincian.value.text = "$taxpJLHD";
        persenPPNHeaderRincianView.value.text = "$taxpJLHD";
        persenPPNHeaderRincian.refresh();
        persenPPNHeaderRincianView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${subtotal.value}',
            persenDiskonPesanBarang.value.text,
            persenPPNHeaderRincian.value.text);

        nominalPPNHeaderRincian.value.text = "$convert1PPN";
        nominalPPNHeaderRincianView.value.text = convert1PPN.toStringAsFixed(2);
        nominalPPNHeaderRincian.refresh();
        nominalPPNHeaderRincianView.refresh();
      } else {
        var storageCabang = AppData.cabangSelected;
        List filter = storageCabang.split("-");
        persenPPNHeaderRincian.value.text = filter[4];
        persenPPNHeaderRincianView.value.text = filter[4];
        persenPPNHeaderRincian.refresh();
        persenPPNHeaderRincianView.refresh();

        var convert1PPN = Utility.nominalPPNHeaderView(
            '${subtotal.value}',
            persenDiskonPesanBarang.value.text,
            persenPPNHeaderRincian.value.text);

        nominalPPNHeaderRincian.value.text = "$convert1PPN";
        nominalPPNHeaderRincianView.value.text = convert1PPN.toStringAsFixed(2);
        nominalPPNHeaderRincian.refresh();
        nominalPPNHeaderRincianView.refresh();
      }
    } else {
      var storageCabang = AppData.cabangSelected;
      List filter = storageCabang.split("-");
      persenPPNHeaderRincian.value.text = filter[4];
      persenPPNHeaderRincianView.value.text = filter[4];
      persenPPNHeaderRincian.refresh();
      persenPPNHeaderRincianView.refresh();

      var convert1PPN = Utility.nominalPPNHeaderView(
          '${subtotal.value}',
          persenDiskonPesanBarang.value.text,
          persenPPNHeaderRincian.value.text);

      nominalPPNHeaderRincian.value.text = "$convert1PPN";
      nominalPPNHeaderRincianView.value.text = convert1PPN.toStringAsFixed(2);
      nominalPPNHeaderRincian.refresh();
      nominalPPNHeaderRincianView.refresh();
    }

    // biaya header

    var convert1 = Utility.persenDiskonHeader(
        "${subtotal.value}", "${infoDOHD[0]["BIAYA"]}");

    var persenBiaya = "$convert1" == "NaN" ? "0.0" : "$convert1";

    var convert1Charge = Utility.nominalPPNHeaderView(
        '${subtotal.value}', persenDiskonPesanBarang.value.text, persenBiaya);

    nominalOngkosHeaderRincian.value.text = "$convert1Charge";
    nominalOngkosHeaderRincianView.value.text =
        convert1Charge.toStringAsFixed(2);

    double discnHeader = discdHeader + dischHeader;
    // print('hasil nominal discd header $discdHeader');
    // print('hasil nominal disch header $dischHeader');
    // print('hasil nominal discn header $discnHeader');
  
    GetDataController().updateDohd(dashboardPenjualanCt.nomorDoSelected.value,
        allQtyBeli.value, discdHeader, dischHeader, discnHeader);

    return Future.value(true);
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
    Future<bool> prosesClose =
        getDataCt.closeDODH("", dashboardPenjualanCt.nomorDoSelected.value);
    bool hasilClose = await prosesClose;
    if (hasilClose == true) {
      dashboardPenjualanCt.changeMenu(2);
      if (statusAksiItemOrderPenjualan.value) {
        Get.back();
        Get.back();
        Get.back();
        statusBack.value = true;
        statusBack.refresh();
      } else {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        statusBack.value = true;
        statusBack.refresh();
      }
    }
  }
}
