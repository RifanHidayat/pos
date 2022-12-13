import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/arsip_faktur_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/toast.dart';

class SimpanFakturController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var arsipFakturCt = Get.put(ArsipFakturController());

  simpanFakturSebagaiArsip() {
    dashboardCt.nomorFaktur.value = "-";
    dashboardCt.primaryKeyFaktur.value = "";
    dashboardCt.nomorCbLastSelected.value = "";
    dashboardCt.kodePelayanSelected.value = "";
    dashboardCt.customSelected.value = "";
    dashboardCt.jumlahItemDikeranjang.value = 0;
    dashboardCt.totalNominalDikeranjang.value = 0;
    dashboardCt.diskonHeader.value = 0.0;
    dashboardCt.ppnCabang.value = 0;
    dashboardCt.serviceChargerCabang.value = 0;
    dashboardCt.listKeranjang.value.clear();

    dashboardCt.nomorFaktur.refresh();
    dashboardCt.listKeranjang.refresh();
    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();
    dashboardCt.customSelected.refresh();
    dashboardCt.kodePelayanSelected.refresh();
    dashboardCt.primaryKeyFaktur.refresh();
    dashboardCt.diskonHeader.refresh();
    dashboardCt.ppnCabang.refresh();
    dashboardCt.serviceChargerCabang.refresh();

    dashboardCt.getKelompokBarang('simpan_faktur');
    arsipFakturCt.startLoad();
    UtilsAlert.showToast("Berhasil simpan arsip faktur");
    Get.back();
    Get.back();
  }
}
