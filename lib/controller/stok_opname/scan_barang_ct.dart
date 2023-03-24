import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/controller/stok_opname/stok_opname_controller.dart';
import 'package:siscom_pos/model/stok_opname/tambah_opnamedt.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/toast.dart';

class ScanBarangStokOpnameController extends GetxController {
  var stokOpnameCt = Get.put(StockOpnameController());

  var dataBarangSelected = <TambahOpnameDt>[].obs;

  var scannerValue = false.obs;

  var typeScan = "".obs;
  var codeScan = "".obs;

  var fisikBarang = TextEditingController().obs;

  Future<bool> getBarcode(type, code) async {
    codeScan.value = "$code";
    codeScan.refresh();
    typeScan.value = "$type";
    typeScan.refresh();
    Map<String, dynamic> body = {
      'nomor': stokOpnameCt.nomorHeader.value,
      'kode_barcode': codeScan.value,
    };
    var connect =
        Api.connectionApi2("patch", body, "stok-opname-dt-barcode", "");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print(valueBody);
    if (valueBody["code"] == 200) {
      var hasilDataResponse = valueBody["data"];
      var getData = stokOpnameCt.detailBarangTambahStokOpnameDtMaster
          .where((element) =>
              "${element.group}${element.kodeBarang}" ==
              "${hasilDataResponse['group']}${hasilDataResponse['barang']}")
          .toList();
      dataBarangSelected.value = getData;
      dataBarangSelected.refresh();
      scannerValue.value = true;
      scannerValue.refresh();
      return Future.value(true);
    } else {
      UtilsAlert.showToast("Barang tidak di temukan");
      return Future.value(false);
    }
  }

  void simpanPerubahanScan() {
    var updateData = stokOpnameCt.detailBarangTambahStokOpnameDtMaster
        .firstWhere((element) =>
            "${element.group}${element.kodeBarang}" ==
            "${dataBarangSelected[0].group}${dataBarangSelected[0].kodeBarang}");
    updateData.fisik = updateData.fisik! + 1;
    stokOpnameCt.detailBarangTambahStokOpnameDtMaster.refresh();
    stokOpnameCt.detailBarangTambahStokOpnameDt =
        stokOpnameCt.detailBarangTambahStokOpnameDtMaster;
    stokOpnameCt.detailBarangTambahStokOpnameDt.refresh();
    Get.back();
    Get.back();
  }
}
