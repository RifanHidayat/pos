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

  var selectedIdSales = "".obs;
  var selectedNameSales = "".obs;
  var selectedIdPelanggan = "".obs;
  var selectedNamePelanggan = "".obs;
  var periode = "".obs;
  var typeFocus = "".obs;

  var menuShowonTop = [].obs;
  var salesList = [].obs;
  var pelangganList = [].obs;

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
  }

  void getDataMenuPenjualan() {
    for (var element in menuDashboardPenjualan) {
      menuShowonTop.value.add(element);
    }
    menuShowonTop.refresh();
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
}
