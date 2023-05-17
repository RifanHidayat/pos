import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/buttom_sheet/np_barang_ct.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/edit_keranjang_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class ScanBarangController extends BaseController {
  var barangSelect = [].obs;

  var scannerValue = false.obs;

  var typeScan = "".obs;
  var codeScan = "".obs;

  var dashboardCt = Get.put(DashbardController());
  var buttomSheetProduk = Get.put(BottomSheetPos());
  var notaPengirimanPesanBarang =
      Get.put(NotaPengirimanBarangPesanController());
  var globalCt = Get.put(GlobalController());
  var editKeranjangCt = Get.put(EditKeranjangController());

  void getBarcodeImei(type, code, scanMenu) {
    var imeiSelected = "";
    for (var element in buttomSheetProduk.listDataImei.value) {
      if (element["IMEI"] == code) {
        imeiSelected = element["IMEI"];
      }
      // if (element["IMEI"] == "S03") {
      //   imeiSelected = element["IMEI"];
      // }
    }
    if (imeiSelected != "") {
      if (scanMenu == "POS") {
        buttomSheetProduk.imeiSelected.value = imeiSelected;
        buttomSheetProduk.imeiSelected.refresh();
        int lengthBefore = buttomSheetProduk.listDataImeiSelected.value.length;
        buttomSheetProduk.listDataImeiSelected.value
            .add(buttomSheetProduk.imeiSelected.value);
        var filter = buttomSheetProduk.listDataImeiSelected.toSet().toList();
        buttomSheetProduk.listDataImeiSelected.value = filter;
        buttomSheetProduk.listDataImeiSelected.refresh();
        if (lengthBefore !=
            buttomSheetProduk.listDataImeiSelected.value.length) {
          buttomSheetProduk.aksiTambahQty(Get.context!);
        }

        Get.back();
      } else {
        notaPengirimanPesanBarang.imeiSelected.value = imeiSelected;
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  void getBarcode(type, code, {key}) {
    codeScan.value = "$code";
    typeScan.value = "$type";
    codeScan.refresh();
    typeScan.refresh();
    periksaBarang(code, key: key);
  }

  void periksaBarang(code, {key}) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses periksa barang");
    // var codeDummy = "1019000177484";
    if (code.isEmpty) {
      Get.back();
      UtilsAlert.showToast("Input Barcode tidak boleh kosong");
    } else {
      Map<String, dynamic> body = {
        'database': AppData.databaseSelected,
        'periode': AppData.periodeSelected,
        'stringTabel': 'PROD1',
        'cari': 'barcode',
        'value': code,
      };
      var connect = Api.connectionApi("post", body, "get_once_prod1");
      var getValue = await connect;
      var valueBody = jsonDecode(getValue.body);
      List data = valueBody['data'];

      if (dashboardCt.nomorFaktur.value == "-") {
        Get.back();

        UtilsAlert.showToast("Harap buat faktur terlebih dahulu");
      } else {
        dashboardCt.listMenu.clear();
        if (data.isEmpty) {
          scannerValue.value = true;
          scannerValue.refresh();
          Get.back();
        } else {
          if (valueBody['status'] == true) {
            barangSelect.value = data;
            for (var i = 0; i < data.length; i++) {
              final element = data[0];
              var filter = {
                'GROUP': element['GROUP'],
                'KODE': element['KODE'],
                'INISIAL': element['INISIAL'],
                'INGROUP': element['INGROUP'],
                'NAMA': element['NAMA'],
                'BARCODE': element['BARCODE'],
                'TIPE': element['TIPE'],
                'SAT': element['SAT'],
                'STDBELI': element['STDBELI'],
                'STDJUAL': element['STDJUAL'],
                'NAMAGAMBAR': element['NAMAGAMBAR'],
                'MEREK': element['MEREK'],
                'STOKWARE': element['STOKWARE'],
                'nama_merek': element['nama_merek'],
                'status': false,
                'jumlah_beli': 0,
              };
              dashboardCt.listMenu.value.add(filter);
            }

            barangSelect.refresh();
          } else {
            UtilsAlert.showToast("Barang tidak ditemukan");
          }
          scannerValue.value = true;
          scannerValue.refresh();

          Get.back();
          if (barangSelect.value.isNotEmpty && key == 'get_qrcode_manualy') {
            buttomSheetProduk.buttomShowCardMenu(
                Get.context!,
                "${barangSelect.value[0]['GROUP']}${barangSelect.value[0]['KODE']}",
                globalCt.convertToIdr(barangSelect.value[0]['STDJUAL'] ?? 0, 0),
                key: key);
          }
        }
      }
    }
  }

  void validasiDetailPilihMenu() async {
    // Get.back();
    var keyPilihBarang =
        "${barangSelect.value[0]['GROUP']}${barangSelect.value[0]['KODE']}";
    var jual = globalCt.convertToIdr(barangSelect.value[0]['STDJUAL'], 0);
    dashboardCt.totalPesan.value = 0;
    dashboardCt.totalPesanNoEdit.value = 0;
    dashboardCt.catatanPembelian.value.text = "";
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    buttomSheetProduk.imeiSelected.value = "";
    buttomSheetProduk.imeiBarang.value.clear();
    buttomSheetProduk.listDataImei.value.clear();

    if (barangSelect.value[0]['TIPE'] == "1") {
      // print('proses check imei');
      // Future<bool> checkingImei =
      //     buttomSheetProduk.prosesCheckImei(barangSelect);
      // var hasilEmei = await checkingImei;
      // if (hasilEmei == true) {
      //   buttomSheetProduk.checkingUkuran(Get.context!, barangSelect.value, jual,
      //       "", 0, "", "", "", "", "", "", "", "");
      // } else {
      //   UtilsAlert.showToast("Data IMEI tidak valid");
      // }
    } else {
      var keyBarang =
          "${barangSelect.value[0]['GROUP']}${barangSelect.value[0]['KODE']}";
      bool statusBarangKeranjang = false;
      List produkDikeranjang = [];
      for (var element in dashboardCt.listKeranjangArsip) {
        var keyValueKeranjang = "${element['GROUP']}${element['BARANG']}";
        if (keyValueKeranjang == keyBarang) {
          statusBarangKeranjang = true;
          produkDikeranjang.add(element);
        }
      }
      if (statusBarangKeranjang) {
        var hasilQty = produkDikeranjang[0]["QTY"] + 1;
        Map<String, dynamic> body = {
          'database': '${AppData.databaseSelected}',
          'periode': '${AppData.periodeSelected}',
          'stringTabel': 'PROD1',
          'groupBarang': produkDikeranjang[0]["GROUP"],
          'kodeBarang': produkDikeranjang[0]["BARANG"],
        };
        var connect = Api.connectionApi("post", body, "get_barang_once");
        var getValue = await connect;
        var valueBody = jsonDecode(getValue.body);
        List dataFinalProduk = valueBody['data'];
        dashboardCt.hargaJualPesanBarang.value.text =
            "${produkDikeranjang[0]["HARGA"]}";
        dashboardCt.jumlahPesan.value.text = "$hasilQty";
        dashboardCt.htgUkuran.value = "${produkDikeranjang[0]["HTG"]}";
        dashboardCt.pakUkuran.value = "${produkDikeranjang[0]["PAK"]}";
        editKeranjangCt
            .editKeranjang(dataFinalProduk, 'edit_dari_scanbarcode', []);
      } else {
        buttomSheetProduk.checkingUkuran(Get.context!, barangSelect.value, jual,
            "", 0, "", "", "", "", "", "", "", "");
      }
    }
  }
}
