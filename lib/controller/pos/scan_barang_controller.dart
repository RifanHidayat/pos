import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
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
  var globalCt = Get.put(GlobalController());
  var editKeranjangCt = Get.put(EditKeranjangController());

  void getBarcodeImei(type, code) {
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
      buttomSheetProduk.imeiSelected.value = imeiSelected;
      buttomSheetProduk.imeiSelected.refresh();
      Get.back();
    } else {
      Get.back();
    }
  }

  void getBarcode(type, code) {
    codeScan.value = "$code";
    typeScan.value = "$type";
    codeScan.refresh();
    typeScan.refresh();
    periksaBarang(code);
  }

  void periksaBarang(code) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Proses periksa barang");
    // var codeDummy = "1019000177484";
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
    if (valueBody['status'] == true) {
      barangSelect.value = data;
      barangSelect.refresh();
    } else {
      UtilsAlert.showToast("Barang tidak ditemukan");
    }
    scannerValue.value = true;
    scannerValue.refresh();
    Get.back();
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
        editKeranjangCt.editKeranjang(dataFinalProduk, 'edit_dari_scanbarcode');
      } else {
        buttomSheetProduk.checkingUkuran(Get.context!, barangSelect.value, jual,
            "", 0, "", "", "", "", "", "", "", "");
      }
    }
  }
}
