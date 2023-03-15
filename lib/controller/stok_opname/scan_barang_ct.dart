import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanBarangStokOpnameController extends GetxController {
  var scannerValue = false.obs;

  var typeScan = "".obs;
  var codeScan = "".obs;

  var fisikBarang = TextEditingController().obs;

  void getBarcode(type, code) {
    codeScan.value = "$code";
    codeScan.refresh();
    typeScan.value = "$type";
    typeScan.refresh();
    scannerValue.value = true;
    scannerValue.refresh();
  }
}
