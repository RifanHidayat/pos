import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/model/detail_barang.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/request.dart';
import 'package:siscom_pos/utils/toast.dart';

class StockOpnameController extends GetxController {
  var isLoading = true.obs;
  var gudangs = [].obs;
  var groups=[].obs;
  var barangs = <DetailBarangModel>[].obs;

  var dateCtr = TextEditingController();
  var gudangCtr = TextEditingController();
  var groupBarangCtr = TextEditingController();
  var diopnameCtr = TextEditingController();
 
  var tahun="".obs;
  var bulan="".obs;
  var bulanString="".obs;

 var gudangCodeSelected="".obs;

   var groupCodeSelected="".obs;

  Future<void> fetchGudang() async {
    try {
      var body = jsonEncode({"database": 'gik2', "kode_cabang": "02"});
      var response =
          await Request(url: "stok-opname-gudang", body: body).post();
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        gudangs.value = res['data'];
        fetchGroup();
    
        isLoading.value = false;
        return;
      }
      UtilsAlert.showToast(res['message']);

      isLoading.value = false;
    } catch (e) {
        UtilsAlert.showToast(e.toString());
      print("error ${e}");
      isLoading.value = false;
    }
  }

    Future<void> fetchGroup() async {
    try {
      print("Masuk sini");
      var body = jsonEncode({"database": "gik2"});
      var response =
          await Request(url: "stok-opname-group", body: body).post();
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
            print("data group ${res['data']}");
        groups.value = res['data'];
        isLoading.value = false;
        return;
      }
      UtilsAlert.showToast(res['message']);

      isLoading.value = false;
    } catch (e) {
        UtilsAlert.showToast(e.toString());
      print("error ${e}");
      isLoading.value = false;
    }
  }

  Future<void> fetchDetailaBarang() async {
    try {
      // UtilsAlert.showLoadingIndicator(Get.context!);

      var body = jsonEncode({ 'database': AppData.databaseSelected, "kode_gudang": gudangCodeSelected.value,'periode':"2301"});
      var response =
          await Request(url: "stok-opname-gudang-detail", body: body).post();
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(res['data']);
         barangs.value = DetailBarangModel.fromJsonToList(res['data']);
         isLoading.value = false;
     // Get.back();
        return;
      }

       UtilsAlert.showToast(res['message'].toString());

      isLoading.value = false;
    } catch (e) {
  
      print("error ${e}");
      UtilsAlert.showToast(e.toString());
      isLoading.value = false;
    }
  }



  void resetData() {
    dateCtr.clear();
    gudangCtr.clear();
    groupBarangCtr.clear();
    diopnameCtr.clear();
    gudangCodeSelected.value="";
  }
}
