import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/detail_nota__pengiriman_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class HapusDodtController extends BaseController {
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());
  var sidebarCt = Get.put(SidebarController());
  var notaPengirimanBarangCt = Get.put(DetailNotaPenjualanController());

  Future<bool> hapusDohdDodt(nomor) async {
    setBusy();
    UtilsAlert.loadingSimpanData(Get.context!, "Hapus data");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DOHD',
      'nomor': nomor,
    };
    var connect = Api.connectionApi("post", body, "hapus_dohd");
    bool hasilFinal = false;

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);

    if (valueBody['status'] == true) {
      hasilFinal = true;
      Get.back();
      Get.back();
      Get.back();
    }
    setIdle();
    return Future.value(hasilFinal);
  }

  Future<bool> hapusBarangOnce(dataSelected, type) async {
    print('data di hapus $dataSelected');
    // UtilsAlert.loadingSimpanData(Get.context!, "Hapus data");

    // Map<String, dynamic> body = {
    //   'database': '${AppData.databaseSelected}',
    //   'periode': '${AppData.periodeSelected}',
    //   'stringTabel': 'DODT',
    //   'nourut': '${dataSelected["NOURUT"]}',
    //   'nomor': '${dashboardPenjualanCt.nomorDoSelected.value}',
    //   'gudang': '${sidebarCt.gudangSelectedSide.value}',
    //   'group': '${dataSelected["GROUP"]}',
    //   'barang': '${dataSelected["KODE"]}',
    //   'qty_dihapus': '${dataSelected["qty_beli"]}',
    // };
    // var connect = Api.connectionApi("post", body, "hapus_dodt");
    // bool prosesHapusDodt = false;
    // var getValue = await connect;
    // var valueBody = jsonDecode(getValue.body);
    // print(valueBody);
    // if (valueBody['status'] == true) {
    //   // get data sodt
    //   var dataSODTSelected = notaPengirimanBarangCt.sodtTerpilih.firstWhere(
    //       (element) =>
    //           "${element['GROUP']}${element['BARANG']}${element['NOURUT']}" ==
    //           "${dataSelected['GROUP']}${dataSelected['KODE']}${dataSelected['NOURUT']}");

    //   // update data sohd selected
    //   Future<bool> prosesEditSOHD = GetDataController().editQtzSOHD(
    //       dataSODTSelected['NOMOR'], '${dataSelected["qty_beli"]}', '0');
    //   bool hasilEditSohd = await prosesEditSOHD;
    //   print('hasil update sohd $hasilEditSohd');

    //   if (hasilEditSohd) {
    //     notaPengirimanBarangCt.barangTerpilih.removeWhere((element) =>
    //         "${element['GROUP']}${element['KODE']}" ==
    //         "${dataSelected['GROUP']}${dataSelected['KODE']}");
    //     notaPengirimanBarangCt.perhitunganMenyeluruhDO();

    //     notaPengirimanBarangCt.dodtSelected.removeWhere((element) =>
    //         "${element['GROUP']}${element['BARANG']}" ==
    //         "${dataSelected['GROUP']}${dataSelected['KODE']}");
    //     notaPengirimanBarangCt.perhitunganMenyeluruhDO();

    //     notaPengirimanBarangCt.perhitunganMenyeluruhDO();
    //     Get.back();
    //     Get.back();
    //     UtilsAlert.showToast("Berhasil hapus barang");
    //     prosesHapusDodt = true;

    //     if (notaPengirimanBarangCt.dodtSelected.value.isEmpty) {
    //       UtilsAlert.showToast("Data item nota tidak ditemukan");
    //       notaPengirimanBarangCt.statusDODTKosong.value = true;
    //       notaPengirimanBarangCt.statusDODTKosong.refresh();
    //     }
    //   } else {
    //     UtilsAlert.showToast("Gagal update order penjualan");
    //   }
    // } else {
    //   UtilsAlert.showToast("Gagal hapus barang");
    // }
    // return Future.value(prosesHapusDodt);
    return Future.value(true);
  }
}
