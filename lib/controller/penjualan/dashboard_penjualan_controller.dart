import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class DashbardPenjualanController extends GetxController {
  var sidebarCt = Get.put(SidebarController());

  var cari = TextEditingController().obs;
  var refrensiBuatOrderPenjualan = TextEditingController().obs;
  var jatuhTempoBuatOrderPenjualan = TextEditingController().obs;
  var keteranganSO1 = TextEditingController().obs;
  var keteranganSO2 = TextEditingController().obs;
  var keteranganSO3 = TextEditingController().obs;
  var keteranganSO4 = TextEditingController().obs;

  var selectedIdSales = "".obs;
  var selectedNameSales = "".obs;
  var selectedIdPelanggan = "".obs;
  var selectedNamePelanggan = "".obs;
  var wilayahCustomerSelected = "".obs;
  var periode = "".obs;
  var typeFocus = "".obs;
  var nomorSoSelected = "".obs;

  var checkIncludePPN = false.obs;
  var screenBuatSoKeterangan = false.obs;

  var jumlahArsipOrderPenjualan = 0.obs;

  var menuShowonTop = [].obs;
  var salesList = [].obs;
  var pelangganList = [].obs;
  var dataAllSohd = [].obs;
  var dataSohd = [].obs;
  var dataSodt = [].obs;

  var dateSelectedBuatOrderPenjualan = DateTime.now().obs;
  var tanggalAkumulasiJatuhTempo = DateTime.now().obs;

  var screenAktif = 1.obs;

  List menuDashboardPenjualan = [
    {'id_menu': 1, 'nama_menu': "Order Penjualan", 'status': true},
    {'id_menu': 2, 'nama_menu': "Nota Pengiriman Barang", 'status': false},
    {'id_menu': 3, 'nama_menu': "Faktur Penjualan", 'status': false},
  ];

  void loadData() {
    getDataMenuPenjualan();
    checkArsipOrderPenjualan();
    getDataSales();
    getDataAllSOHD();
  }

  void getDataMenuPenjualan() {
    for (var element in menuDashboardPenjualan) {
      menuShowonTop.value.add(element);
    }
    menuShowonTop.refresh();
  }

  void checkGestureDetector() {
    if (typeFocus.value == "jatuh_tempo") {
      gantiJatuhTempoBuatOrderPenjualan(
          jatuhTempoBuatOrderPenjualan.value.text);
    }
  }

  void checkArsipOrderPenjualan() {
    if (AppData.arsipOrderPenjualan != "") {
      List tampung = AppData.arsipOrderPenjualan.split("|");
      jumlahArsipOrderPenjualan.value = tampung.length;
      jumlahArsipOrderPenjualan.refresh();
    } else {
      jumlahArsipOrderPenjualan.value = 0;
      jumlahArsipOrderPenjualan.refresh();
    }
  }

  void timeNow() {
    var dt = DateTime.now();
    var year = "${DateFormat('yyyy').format(dt)}";
    var bulan = "${DateFormat('MM').format(dt)}";
    periode.value = "SI$year$bulan";
  }

  void gantiTanggalBuatOrderPenjualan(date) {
    DateTime dateStart = DateTime.now(); //YOUR DATE GOES HERE
    bool isValidDate = dateStart.isBefore(date);
    if (isValidDate) {
      UtilsAlert.showToast("Tanggal tidak boleh melebihi tanggal hari ini");
    } else {
      dateSelectedBuatOrderPenjualan.value = date;
    }
  }

  void gantiJatuhTempoBuatOrderPenjualan(value) {
    if (value == "") {
      print("Kosong");
      tanggalAkumulasiJatuhTempo.value = DateTime.now();
      tanggalAkumulasiJatuhTempo.refresh();
    } else {
      if (int.parse(value) <= 0) {
        tanggalAkumulasiJatuhTempo.value = DateTime.now();
        tanggalAkumulasiJatuhTempo.refresh();
      } else {
        DateTime dt = DateTime.parse("${DateTime.now()}");
        DateTime tanggalAkumulasi = dt.add(Duration(days: int.parse(value)));
        tanggalAkumulasiJatuhTempo.value = tanggalAkumulasi;
        tanggalAkumulasiJatuhTempo.refresh();
      }
    }
  }

  void getDataSales() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SALESM',
      'kode_cabang': sidebarCt.cabangKodeSelectedSide.value,
    };
    var connect = Api.connectionApi("post", body, "salesman");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      salesList.value = data;
      salesList.refresh();
      var getFirst = data.first;
      selectedIdSales.value = getFirst['KODE'];
      selectedNameSales.value = getFirst['NAMA'];
      selectedIdSales.refresh();
      selectedNameSales.refresh();
      getDataPelanggan();
    }
  }

  void getDataPelanggan() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'CUSTOM',
      'kode_sales': selectedIdSales.value,
    };
    var connect = Api.connectionApi("post", body, "pelanggan");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      data.sort((a, b) => a['NAMA'].compareTo(b['NAMA']));
      pelangganList.value = data;
      pelangganList.refresh();
      var getFirst = data.first;
      selectedIdPelanggan.value = getFirst['KODE'];
      selectedNamePelanggan.value = getFirst['NAMA'];
      selectedIdPelanggan.refresh();
      selectedNamePelanggan.refresh();
    }
  }

  void getDataAllSOHD() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
    };
    var connect = Api.connectionApi("post", body, "all_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      print('all data sohd $data');
      dataAllSohd.value = data;
      dataAllSohd.refresh();
    }
  }

  void getDataSOHD() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'nomor_sohd': nomorSoSelected.value,
    };
    var connect = Api.connectionApi("post", body, "get_once_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      dataSodt.value = data;
      dataSodt.refresh();
    }
  }
}
