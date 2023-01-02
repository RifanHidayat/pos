import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/memilih_sohd_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/screen/penjualan/item_order_penjualan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
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

  var persenPPNHeaderRincian = TextEditingController().obs;
  var nominalPPNHeaderRincian = TextEditingController().obs;

  var nominalOngkosHeaderRincian = TextEditingController().obs;

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

  var typeBarangSelected = "".obs;
  var htgBarangSelected = "".obs;
  var pakBarangSelected = "".obs;

  void startload(status) {
    // checkDODT();
    getSoSelected(status);
  }

  void checkDODT() async {
    Future<List> prosesCheckDODT = GetDataController().getSpesifikData(
        "DODT",
        "NOMOR",
        dashboardPenjualanCt.nomorDoSelected.value,
        "get_spesifik_data_transaksi");
    List hasilProsesCheck = await prosesCheckDODT;
    if (hasilProsesCheck.isNotEmpty) {
      dodtSelected.value = hasilProsesCheck;
      dodtSelected.refresh();
      statusDODTKosong.value = false;
      statusDODTKosong.refresh();
      Future<List> prosesGetNomorSOHD = aksiGetNomorSOHD(hasilProsesCheck);
      List hasilNomorSOHD = await prosesGetNomorSOHD;
      // pencarian SODT
      if (hasilNomorSOHD.length == 1) {
        Future<List> prosesSodtSelected = GetDataController().getSpesifikData(
            "SODT", "NOMOR", hasilNomorSOHD[0], "get_spesifik_data_transaksi");
        List hasilProsesSODT = await prosesSodtSelected;
        combainData(hasilProsesSODT, hasilProsesCheck);
      } else {
        // combainData(finalProsesSODT, hasilProsesCheck);
      }
    } else {
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

  void prosesPilihBarang(List barang) {
    if (barang.isNotEmpty) {
      barangTerpilih.value = barang;
      barangTerpilih.refresh();
      statusDODTKosong.value = false;
      statusDODTKosong.refresh();
    } else {
      statusDODTKosong.value = true;
      statusDODTKosong.refresh();
    }
  }

  void getSoSelected(status) async {
    Future<List> getSOHDSelectedNotaPengiriman =
        getDataCt.sohdSelectedNotaPengiriman(
            dashboardPenjualanCt.selectedIdPelanggan.value,
            dashboardPenjualanCt.selectedIdSales.value);
    List hasilData = await getSOHDSelectedNotaPengiriman;
    sohdTerpilih.value = hasilData;
    sohdTerpilih.refresh();
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
