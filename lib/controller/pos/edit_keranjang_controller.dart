import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/perhitungan_controller.dart';
import 'package:siscom_pos/screen/pos/rincian_pemesanan.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class EditKeranjangController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var perhitunganCt = Get.put(PerhitunganController());

  void editKeranjang(produkSelected) {
    UtilsAlert.loadingSimpanData(Get.context!, "Edit data");
    // update data barang
    var filterData = dashboardCt.listKeranjangArsip.value.firstWhere(
        (element) =>
            "${element["GROUP"]}${element["BARANG"]}" ==
            "${produkSelected[0]["GROUP"]}${produkSelected[0]["KODE"]}");

    var filter1 = dashboardCt.hargaJualPesanBarang.value.text;
    var filter2 = filter1.replaceAll("Rp", "");
    var filter3 = filter1.replaceAll(" ", "");
    var filter4 = filter2.replaceAll(".", "");
    var hrgJualEditFinal = int.parse(filter4);

    var filterJml1 = dashboardCt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");
    var finalQtyEdit = double.parse(filterJml2);

    editJldtBarang(filterData, hrgJualEditFinal, finalQtyEdit);
  }

  editJldtBarang(filterData, hrgJualEditFinal, finalQtyEdit) {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var checkFilterDiscd = dashboardCt.hargaDiskonPesanBarang.value.text == ""
        ? "0"
        : dashboardCt.hargaDiskonPesanBarang.value.text;
    var filterDiscd = checkFilterDiscd.replaceAll(".", "");

    var checkFilterDisc1 = dashboardCt.persenDiskonPesanBarang.value.text == ""
        ? "0"
        : dashboardCt.persenDiskonPesanBarang.value.text;
    var flt1 = checkFilterDisc1.replaceAll(',', '.');
    var filterDisc1 = flt1.replaceAll('.', '.');

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'jldt_pk': filterData["PK"],
      'jldt_nourut': filterData["NOURUT"],
      'jldt_tanggal': tanggalNow,
      'jldt_tgl': tanggalNow,
      'jldt_doe': tanggalDanJam,
      'jldt_toe': jamTransaksi,
      'jldt_loe': tanggalDanJam,
      'jldt_qty': finalQtyEdit,
      'jldt_harga': hrgJualEditFinal,
      'jldt_disc1': filterDisc1,
      'jldt_discd': filterDiscd,
      'jldt_htg': dashboardCt.htgUkuran.value,
      'valuepak': dashboardCt.pakUkuran.value,
      'jldt_keterangan': dashboardCt.catatanPembelian.value.text,
    };
    var connect = Api.connectionApi("post", body, "edit_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          filterData["QTY"] = finalQtyEdit;
          filterData["HARGA"] = hrgJualEditFinal;
          filterData["HTG"] = dashboardCt.htgUkuran.value;
          filterData["PAK"] = dashboardCt.pakUkuran.value;
          dashboardCt.catatanPembelian.value.text = "";
          UtilsAlert.showToast("${valueBody['message']}");
          var dataKeranjangEdit = dashboardCt.listKeranjangArsip.value
              .firstWhere(
                  (element) => element["NOURUT"] == filterData["NOURUT"]);
          dataKeranjangEdit["TANGGAL"] = tanggalNow;
          dataKeranjangEdit["TGL"] = tanggalNow;
          dataKeranjangEdit["QTY"] = finalQtyEdit;
          dataKeranjangEdit["HARGA"] = hrgJualEditFinal;
          dataKeranjangEdit["DISC1"] =
              dashboardCt.persenDiskonPesanBarang.value.text;
          dataKeranjangEdit["DISCD"] = double.parse(filterDiscd);
          dataKeranjangEdit["DOE"] = tanggalDanJam;
          dataKeranjangEdit["TOE"] = jamTransaksi;
          dataKeranjangEdit["LOE"] = tanggalDanJam;
          dataKeranjangEdit["HTG"] = dashboardCt.htgUkuran.value;
          dataKeranjangEdit["PAK"] = dashboardCt.pakUkuran.value;
          dataKeranjangEdit["KETERANGAN"] =
              dashboardCt.catatanPembelian.value.text;
          dashboardCt.listKeranjangArsip.refresh();
          dashboardCt.hitungAllArsipMenu();
          Get.back();
          Get.back();
          Get.back();
          Get.back();
          Get.to(
            RincianPemesanan(),
          );
        } else {
          UtilsAlert.showToast(valueBody['message']);
          Get.back();
          Get.back();
        }
      }
    });
  }
}
