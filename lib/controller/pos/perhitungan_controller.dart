import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';

class PerhitunganController extends GetxController {
  var dashboardCt = Get.put(DashbardController());

  void perhitungan1(type) async {
    print('jalan perhitungan');
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': '',
      'nomor_faktur': "${dashboardCt.nomorFaktur.value}",
      'persen_diskon_header': "${dashboardCt.diskonHeader.value}",
      'persen_ppn_cabang': "${dashboardCt.ppnCabang.value}",
      'persen_service_cabang': "${dashboardCt.serviceChargerCabang.value}",
    };
    var connect = Api.connectionApi("post", body, "perhitungan1");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      print('berhasil akumulasi seluruh perhitungan 1');
    }
  }
}
