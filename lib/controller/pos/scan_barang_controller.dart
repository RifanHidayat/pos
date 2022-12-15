import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';

class ScanBarangController extends BaseController {
  var barangSelect = [].obs;

  var scannerValue = false.obs;

  var typeScan = "".obs;
  var codeScan = "".obs;

  void getBarcode(type, code) {
    codeScan.value = "$code";
    typeScan.value = "$type";
    scannerValue.value = true;
    codeScan.refresh();
    typeScan.refresh();
    scannerValue.refresh();
    periksaBarang(code);
  }

  void periksaBarang(code) {
    var codeDummy = "";
  }

}
