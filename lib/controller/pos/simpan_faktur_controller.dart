import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class SimpanFakturController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var arsipFakturCt = Get.put(ArsipFakturController());

  Future<bool> simpanFakturSebagaiArsip(type) async {
    // CHECK PUTANG

    Future<List> checkingPutang = GetDataController().getSpesifikData("PUTANG",
        "NOMOR", dashboardCt.nomorFaktur.value, "get_spesifik_data_transaksi");
    List prosesCheckPutang = await checkingPutang;

    if (prosesCheckPutang.isEmpty) {
      double totalHargaAkhir = Utility.hitungDetailTotalPos(
          '${dashboardCt.totalNominalDikeranjang.value}',
          '${dashboardCt.diskonHeader.value}',
          '${dashboardCt.ppnCabang.value}',
          '${dashboardCt.serviceChargerCabang.value}');

      var dataInsert = [
        dashboardCt.kodePelayanSelected.value,
        dashboardCt.customSelected.value,
        dashboardCt.wilayahCustomerSelected.value,
        dashboardCt.nomorFaktur.value,
        dashboardCt.nomorCbLastSelected.value,
        dashboardCt.nomorFaktur.value,
        dashboardCt.cabangKodeSelected.value,
        totalHargaAkhir, 
      ];

      Future<List> prosesInsertPutang =
          GetDataController().insertPutang(dataInsert);
      List hasilInsertPutang = await prosesInsertPutang;

      if (hasilInsertPutang[0] == true) {
        prosesClearSimpanFaktur(type);
      } else {
        UtilsAlert.showToast("Gagal simpan faktur");
      }
    } else {
      prosesClearSimpanFaktur(type);
    }

    return Future.value(true);
  }

  Future<bool> prosesClearSimpanFaktur(type) {
    if (type != "proses_split_bill") {
      dashboardCt.nomorCbLastSelected.value = "";
      dashboardCt.kodePelayanSelected.value = "";
      dashboardCt.customSelected.value = "";
      dashboardCt.ppnCabang.value = 0;
      dashboardCt.serviceChargerCabang.value = 0;
    }
    dashboardCt.nomorFaktur.value = "-";
    dashboardCt.primaryKeyFaktur.value = "";

    dashboardCt.jumlahItemDikeranjang.value = 0;
    dashboardCt.totalNominalDikeranjang.value = 0;
    dashboardCt.diskonHeader.value = 0.0;

    var dataFakturArsip = AppData.noFaktur.split("|");
    dashboardCt.jumlahArsipFaktur.value = dataFakturArsip.length;

    dashboardCt.listKeranjang.clear();
    dashboardCt.listKeranjangArsip.clear();

    dashboardCt.jumlahArsipFaktur.refresh();
    dashboardCt.nomorFaktur.refresh();
    dashboardCt.listKeranjang.refresh();
    dashboardCt.listKeranjangArsip.refresh();
    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();
    dashboardCt.customSelected.refresh();
    dashboardCt.kodePelayanSelected.refresh();
    dashboardCt.primaryKeyFaktur.refresh();
    dashboardCt.diskonHeader.refresh();
    dashboardCt.ppnCabang.refresh();
    dashboardCt.serviceChargerCabang.refresh();

    dashboardCt.getKelompokBarang('simpan_faktur');

    if (type != "proses_split_bill") {
      UtilsAlert.showToast("Berhasil simpan arsip faktur");
      Get.back();
      Get.back();
    }

    return Future.value(true);
  }
}
