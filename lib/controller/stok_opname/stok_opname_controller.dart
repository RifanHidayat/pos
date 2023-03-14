import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/model/detail_barang.dart';
import 'package:siscom_pos/model/stok_opname/list_stok_opname.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/request.dart';
import 'package:siscom_pos/utils/toast.dart';

class StockOpnameController extends GetxController {
  var listStokOpname = <ListStokOpnameModel>[].obs;

  var screenLoad = false.obs;

  List dummyData = [
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    },
    {
      "nomor_faktur": "No. Faktur",
      "kode_cabang": "Kode Cabang",
      "nama_cabang": "Nama Cabang",
      "kode_gudang": "Kode Gudang",
      "nama_gudang": "Nama Gudang",
      "tanggal": "2023-03-07",
    }
  ];

  var isLoading = true.obs;
  var gudangs = [].obs;
  var groups = [].obs;
  var barangs = <DetailBarangModel>[].obs;

  var pencarian = TextEditingController().obs;
  var tanggal = TextEditingController().obs;
  var tanggalBuatStok = TextEditingController().obs;
  var diopnameOleh = TextEditingController().obs;
  // var gudangCtr = TextEditingController().obs;
  // var groupBarangCtr = TextEditingController().obs;
  // var diopnameCtr = TextEditingController().obs;

  var tahun = "".obs;
  var bulan = "".obs;
  var bulanString = "".obs;

  var gudangCodeSelected = "".obs;

  var groupCodeSelected = "".obs;

  void startLoad() {
    getListStokOpname();
  }

  Future<bool> getListStokOpname() async {
    // dummy data
    for (var element in dummyData) {
      listStokOpname.add(ListStokOpnameModel(
        nomorFaktur: element["nomor_faktur"],
        kodeCabang: element["kode_cabang"],
        namaCabang: element["nama_cabang"],
        kodeGudang: element["kode_gudang"],
        namaGudang: element["nama_gudang"],
        tanggal: element["tanggal"],
      ));
    }
    listStokOpname.refresh();

    // form api
    // Future<List> prosesDataStokOpname = ApiStokOpname().getListStokOpname();
    // List hasilData = await prosesDataStokOpname;

    return Future.value(true);
  }
  // Future<void> fetchGudang() async {
  //   try {
  //     var body = jsonEncode({"database": 'gik2', "kode_cabang": "02"});
  //     var response =
  //         await Request(url: "stok-opname-gudang", body: body).post();
  //     var res = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       gudangs.value = res['data'];
  //       fetchGroup();

  //       isLoading.value = false;
  //       return;
  //     }
  //     UtilsAlert.showToast(res['message']);

  //     isLoading.value = false;
  //   } catch (e) {
  //     UtilsAlert.showToast(e.toString());
  //     print("error ${e}");
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> fetchGroup() async {
  //   try {
  //     print("Masuk sini");
  //     var body = jsonEncode({"database": "gik2"});
  //     var response = await Request(url: "stok-opname-group", body: body).post();
  //     var res = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       print("data group ${res['data']}");
  //       groups.value = res['data'];
  //       isLoading.value = false;
  //       return;
  //     }
  //     UtilsAlert.showToast(res['message']);

  //     isLoading.value = false;
  //   } catch (e) {
  //     UtilsAlert.showToast(e.toString());
  //     print("error ${e}");
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> fetchDetailaBarang() async {
  //   try {
  //     // UtilsAlert.showLoadingIndicator(Get.context!);

  //     var body = jsonEncode({
  //       'database': AppData.databaseSelected,
  //       "kode_gudang": gudangCodeSelected.value,
  //       'periode': "2301"
  //     });
  //     var response =
  //         await Request(url: "stok-opname-gudang-detail", body: body).post();
  //     var res = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       print(res['data']);
  //       barangs.value = DetailBarangModel.fromJsonToList(res['data']);
  //       isLoading.value = false;
  //       // Get.back();
  //       return;
  //     }

  //     UtilsAlert.showToast(res['message'].toString());

  //     isLoading.value = false;
  //   } catch (e) {
  //     print("error ${e}");
  //     UtilsAlert.showToast(e.toString());
  //     isLoading.value = false;
  //   }
  // }

  void resetData() {
    // dateCtr.value.text = "";
    // gudangCtr.value.text = "";
    // groupBarangCtr.value.text = "";
    // diopnameCtr.value.text = "";
    gudangCodeSelected.value = "";
  }
}
