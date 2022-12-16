import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/perhitungan_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class HapusJldtController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var perhitunganCt = Get.put(PerhitunganController());

  hapusFakturDanJldt(dataSelected) {
    setBusy();
    UtilsAlert.loadingSimpanData(Get.context!, "Hapus data");
    var keyFaktur =
        dataSelected == "" ? dashboardCt.primaryKeyFaktur.value : dataSelected;
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD_JLDT',
      'key_faktur': keyFaktur,
    };
    var connect = Api.connectionApi("post", body, "hapus_jlhd_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        List tampung = [];
        var getValue1 = AppData.noFaktur.split("|");
        for (var element in getValue1) {
          var listFilter = element.split("-");
          var data = {
            "no_faktur": listFilter[0],
            "key": listFilter[1],
            "no_cabang": listFilter[2],
            "nomor_antrian": listFilter[3],
          };
          tampung.add(data);
        }
        print('hasil filter nofaktur $tampung');
        print('keyfaktur $keyFaktur');
        if (tampung.isNotEmpty) {
          var filter = "";
          for (var element in tampung) {
            if ("${element['key']}" != "$keyFaktur") {
              if (filter == "") {
                filter =
                    "${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
              } else {
                filter =
                    "$filter|${element['no_faktur']}-${element['key']}-${element['no_cabang']}-${element['nomor_antrian']}";
              }
            }
          }
          print('hasil filter setelah di hapus $filter');
          AppData.noFaktur = filter;
        }

        if (AppData.noFaktur != "") {
          dashboardCt.checkingData();
        } else {
          dashboardCt.nomorFaktur.value = "-";
          dashboardCt.primaryKeyFaktur.value = "";
          dashboardCt.kodePelayanSelected.value = "";
          dashboardCt.customSelected.value = "";
          dashboardCt.jumlahItemDikeranjang.value = 0;
          dashboardCt.totalNominalDikeranjang.value = 0;
          dashboardCt.persenDiskonPesanBarang.value.text = "";
          dashboardCt.hargaDiskonPesanBarang.value.text = "";
          dashboardCt.diskonHeader.value = 0.0;
          dashboardCt.allQtyJldt.value = 0;
          dashboardCt.listKeranjang.value.clear();
          dashboardCt.listKeranjangArsip.value.clear();
          refrehVariabel();
          dashboardCt.getKelompokBarang('');
          dashboardCt.arsipController.startLoad();
        }
        dashboardCt.startLoad('hapus_faktur');
        Get.back();
        Get.back();
        Get.back();
        if (dataSelected != "") {
          Get.back();
        }
      }
    });
    setIdle();
  }

  void hapusBarangOnce(dataSelected, type) {
    UtilsAlert.loadingSimpanData(Get.context!, "Hapus data");
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'nomor_urut': '${dataSelected[0]}',
      'key_faktur': '${dataSelected[1]}',
      'nomor_faktur': '${dataSelected[2]}',
      'gudang': '${dataSelected[3]}',
      'group': '${dataSelected[4]}',
      'barang': '${dataSelected[5]}',
      'qty_dihapus': '${dataSelected[6]}',
    };
    var connect = Api.connectionApi("post", body, "hapus_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          UtilsAlert.showToast("Berhasil hapus barang");
          for (var element in dashboardCt.listKeranjang.value) {
            if ("${element["GROUP"]}${element["KODE"]}" ==
                "${dataSelected[4]}${dataSelected[5]}") {
              element["status"] = false;
              element["jumlah_beli"] = 0;
            }
          }
          dashboardCt.getKelompokBarang('first');
          dashboardCt.listKeranjangArsip.value
              .removeWhere((element) => element["NOURUT"] == dataSelected[0]);
          dashboardCt.listKeranjangArsip.refresh();
          dashboardCt.hitungAllArsipMenu();
          print(
              "list keranjang setelah di hapus ${dashboardCt.listKeranjangArsip.value}");
          if (type != 'proses_split_bill') {
            Get.back();
            Get.back();
            Get.back();
            Get.back();
            Get.to(RincianPemesanan());
          }
        } else {
          UtilsAlert.showToast("Gagal hapus barang");
        }
      }
    });
  }

  void refrehVariabel() {
    dashboardCt.nomorFaktur.refresh();
    dashboardCt.listKeranjangArsip.refresh();
    dashboardCt.listKeranjang.refresh();
    dashboardCt.allQtyJldt.refresh();
    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();
    dashboardCt.customSelected.refresh();
    dashboardCt.kodePelayanSelected.refresh();
    dashboardCt.primaryKeyFaktur.refresh();
  }
}
