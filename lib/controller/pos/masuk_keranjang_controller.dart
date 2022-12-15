import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/perhitungan_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

import '../base_controller.dart';

class MasukKeranjangController extends BaseController {
  var dashboardCt = Get.put(DashbardController());
  var perhitunganCt = Get.put(PerhitunganController());

  void masukKeranjang(produkSelected, imeiData) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Simpan data");

    var filterJml1 = dashboardCt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");

    double filterJumlahPesan = double.parse(filterJml2);

    var convertTanggal1 =
        Utility.convertDate4(dashboardCt.informasiJlhd[0]["TANGGAL"]);
    var tanggalJlhd = "$convertTanggal1 23:59:59";

    if (filterJumlahPesan == 0.0) {
      UtilsAlert.showToast("Quantity tidak valid");
      Get.back();
      Get.back();
    } else {
      print(imeiData);
      print(filterJumlahPesan);
      aksiMasukKeranjangLocal(produkSelected, imeiData);
      // Future<bool> validasi1 = checkStok(produkSelected[0]['GROUP'],
      //     produkSelected[0]['KODE'], tanggalJlhd, filterJumlahPesan);
      // bool hasilValidasi1 = await validasi1;
      // if (hasilValidasi1 == true) {
      //   // aksiMasukKeranjangLocal(produkSelected, imeiData);
      // } else {
      //   Get.back();
      //   Get.back();
      //   Get.back();
      // }
    }
  }

  void aksiMasukKeranjangLocal(produkSelected, imeiData) async {
    setBusy();
    // check harga jual di edit
    var filter1 = dashboardCt.hargaJualPesanBarang.value.text;
    var filter2 = filter1.replaceAll("Rp", "");
    var filter3 = filter1.replaceAll(" ", "");
    var filter4 = filter2.replaceAll(".", "");
    var hrgJualEditFinal = int.parse(filter4);

    // check nomor urut keranjang
    Future<String> checkNokeyKeranjang = checkNoKey();
    var valueNomorKey = await checkNokeyKeranjang;

    Future<String> checkNorutKeranjang = checkNorut();
    var valueNomorUrut = await checkNorutKeranjang;

    var filterJml1 = dashboardCt.jumlahPesan.value.text;
    var filterJml2 = filterJml1.replaceAll(",", ".");
    double filterJumlahPesan = double.parse(filterJml2);

    dashboardCt.jumlahItemDikeranjang.value =
        dashboardCt.jumlahItemDikeranjang.value + 1;
    dashboardCt.totalNominalDikeranjang.value =
        dashboardCt.totalNominalDikeranjang.value +
            double.parse('${dashboardCt.totalPesan.value}');

    print(dashboardCt.totalNominalDikeranjang.value);

    dashboardCt.jumlahItemDikeranjang.refresh();
    dashboardCt.totalNominalDikeranjang.refresh();

    if (imeiData.isNotEmpty) {
      // insertJlim(produkSelected, valueNomorKey, valueNomorUrut,
      //     hrgJualEditFinal, filterJumlahPesan, imeiData);
      // insertProd2(produkSelected, valueNomorKey, valueNomorUrut,
      //     hrgJualEditFinal, filterJumlahPesan, imeiData);
      // insertImeix(produkSelected, valueNomorKey, valueNomorUrut,
      //     hrgJualEditFinal, filterJumlahPesan, imeiData);
    }

    // kirimJldtBarang(produkSelected, valueNomorKey, valueNomorUrut,
    //     hrgJualEditFinal, filterJumlahPesan);
    // kirimProd3(produkSelected, valueNomorKey, valueNomorUrut, hrgJualEditFinal,
    //     filterJumlahPesan);
    // updateWareStok(produkSelected, filterJumlahPesan);

    // // // // update data barang

    // for (var element in dashboardCt.listMenu.value) {
    //   if ("${element['INISIAL']}" == "${produkSelected[0]['INISIAL']}") {
    //     element["status"] = true;
    //     element["jumlah_beli"] = dashboardCt.jumlahPesan.value.text;
    //   }
    // }

    // // masuk keranjang
    // for (var element in produkSelected) {
    //   var filter = {
    //     'NORUT': valueNomorUrut,
    //     'GROUP': element['GROUP'],
    //     'KODE': element['KODE'],
    //     'INISIAL': element['INISIAL'],
    //     'INGROUP': element['INGROUP'],
    //     'NAMA': element['NAMA'],
    //     'BARCODE': element['BARCODE'],
    //     'TIPE': element['TIPE'],
    //     'SAT': element['SAT'],
    //     'STDBELI': element['STDBELI'],
    //     'STDJUAL': hrgJualEditFinal,
    //     'NAMAGAMBAR': element['NAMAGAMBAR'],
    //     'MEREK': element['MEREK'],
    //     'TIPE_PILIHAN': dashboardCt.typeBarangSelected.value,
    //     'CATATAN_PEMBELIAN': dashboardCt.catatanPembelian.value.text,
    //     'status': true,
    //     'jumlah_beli': filterJumlahPesan.toInt(),
    //   };
    //   dashboardCt.listKeranjang.add(filter);
    // }
    // dashboardCt.catatanPembelian.value.text = "";
    // UtilsAlert.showToast("Berhasil tambah barang ke keranjang");
    // dashboardCt
    //     .checkingDetailKeranjangArsip(dashboardCt.primaryKeyFaktur.value);
    // Get.back();
    // Get.back();
    // Get.back();
    // dashboardCt
    //     .checkingDetailKeranjangArsip(dashboardCt.primaryKeyFaktur.value);
    // dashboardCt.listMenu.refresh();
    // dashboardCt.listKeranjang.refresh();
    // dashboardCt.listKeranjangArsip.refresh();
    setIdle();
  }

  void kirimJldtBarang(produkSelected, norutKey, valueNomorUrut,
      hrgJualEditFinal, filterJumlahPesan) {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    var filterDisc1 = dashboardCt.persenDiskonPesanBarang.value.text == ""
        ? 0
        : double.parse(dashboardCt.persenDiskonPesanBarang.value.text);
    var flt3 =
        dashboardCt.hargaDiskonPesanBarang.value.text.replaceAll(',', '');
    var flt4 = flt3.replaceAll('.', '');
    var filterDiscd = flt4 == "" ? 0 : flt4;

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'jldt_pk': "${dashboardCt.primaryKeyFaktur.value}",
      'jldt_cabang': dashboardCt.cabangKodeSelected.value,
      'jldt_nomor': "${dashboardCt.nomorFaktur.value}",
      'jldt_nourut': valueNomorUrut,
      'jldt_nokey': norutKey,
      'jldt_cbxx': dashboardCt.cabangKodeSelected.value,
      'jldt_noxx': "${dashboardCt.nomorFaktur.value}",
      'jldt_nosub': norutKey,
      'jldt_tanggal': tanggalNow,
      'jldt_tgl': tanggalNow,
      'jldt_custom': dashboardCt.customSelected.value,
      'jldt_wilayah': dashboardCt.wilayahCustomerSelected.value,
      'jldt_salesm': dashboardCt.kodePelayanSelected.value,
      'jldt_gudang': dashboardCt.gudangSelected.value,
      'jldt_group': produkSelected[0]['GROUP'],
      'jldt_barang': produkSelected[0]['KODE'],
      'jldt_qty': filterJumlahPesan,
      'jldt_sat': produkSelected[0]['SAT'],
      'jldt_uang': "RP",
      'jldt_kurs': "1",
      'jldt_harga': hrgJualEditFinal,
      'jldt_disc1': "$filterDisc1",
      'jldt_discd': "${filterDiscd}",
      'jldt_doe': tanggalDanJam,
      'jldt_toe': jamTransaksi,
      'jldt_loe': tanggalDanJam,
      'jldt_deo': dataInformasiSYSUSER[0],
      'jldt_cb': dashboardCt.cabangKodeSelected.value,
      'jldt_nomorcb': "${dashboardCt.nomorCbLastSelected.value}",
      'jldt_htg': dashboardCt.htgUkuran.value,
      'jldt_ptg': "1",
      'jldt_hgpak': hrgJualEditFinal,
      'valuepak': dashboardCt.pakUkuran.value,
      'jldt_keterangan': dashboardCt.catatanPembelian.value.text,
    };
    var connect = Api.connectionApi("post", body, "insert_jldt");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print('insert jldt');
        print(valueBody);
        // perhitunganCt.perhitungan1("masuk_keranjang");
      }
    });
  }

  void kirimProd3(produkSelected, valueNoKey, valueNomorUrut, hrgJualEditFinal,
      filterJumlahPesan) {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'PROD3',
      "prod3_cabang": dashboardCt.cabangKodeSelected.value,
      "prod3_nomor": "${dashboardCt.nomorFaktur.value}",
      "prod3_nomorcb": "${dashboardCt.nomorCbLastSelected.value}",
      "prod3_nourut": valueNomorUrut,
      "prod3_nokey": valueNoKey,
      "prod3_cbxx": dashboardCt.cabangKodeSelected.value,
      "prod3_noxx": "${dashboardCt.nomorFaktur.value}",
      "prod3_nosub": valueNoKey,
      "prod3_noref": "${dashboardCt.informasiJlhd[0]['NOREF']}",
      "prod3_ref": "${dashboardCt.informasiJlhd[0]['NOREF']}",
      "prod3_tanggal": tanggalNow,
      "prod3_tgl": tanggalNow,
      "prod3_custom": dashboardCt.customSelected.value,
      "prod3_wilayah": dashboardCt.wilayahCustomerSelected.value,
      "prod3_salesm": dashboardCt.kodePelayanSelected.value,
      "prod3_gudang": dashboardCt.gudangSelected.value,
      "prod3_group": produkSelected[0]['GROUP'],
      "prod3_barang": produkSelected[0]['KODE'],
      "prod3_tipe": dashboardCt.tipeBarangDetail.value,
      "prod3_qty": filterJumlahPesan,
      "prod3_sat": produkSelected[0]['SAT'],
      "prod3_uang": "RP",
      "prod3_kurs": "1",
      "prod3_harga": hrgJualEditFinal,
      "prod3_doe": tanggalDanJam,
      "prod3_toe": jamTransaksi,
      "prod3_loe": tanggalDanJam,
      "prod3_cb": dashboardCt.cabangKodeSelected.value,
      "prod3_htg": dashboardCt.htgUkuran.value,
      "prod3_ptg": "1",
      "valuepak": dashboardCt.pakUkuran.value,
      "prod3_hgpak": hrgJualEditFinal,
    };
    var connect = Api.connectionApi("post", body, "insert_prod3");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print('insert prod 3');
        print(valueBody);
      }
    });
  }

  void updateWareStok(produkSelected, filterJumlahPesan) {
    Map<String, dynamic> body = {
      "database": '${AppData.databaseSelected}',
      "periode": '${AppData.periodeSelected}',
      "stringTabel": 'WARE1',
      'group': '${produkSelected[0]["GROUP"]}',
      'kode': '${produkSelected[0]["KODE"]}',
      'qty_pesanan': '$filterJumlahPesan',
      'gudang': '${dashboardCt.gudangSelected.value}',
    };
    var connect = Api.connectionApi("post", body, "update_data_ware1");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print('update data ware 1');
        print(valueBody);
      }
    });
  }

  void insertJlim(produkSelected, valueNomorKey, valueNomorUrut,
      hrgJualEditFinal, filterJumlahPesan, imeiData) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLIM',
      'pk_jlim': "${dashboardCt.primaryKeyFaktur.value}",
      'cabang_jlim': dashboardCt.cabangKodeSelected.value,
      'nomor_jlim': dashboardCt.nomorFaktur.value,
      'nokey_jlim': valueNomorKey,
      'flag_jlim': "7",
      'doe_jlim': tanggalDanJam,
      'toe_jlim': jamTransaksi,
      'loe_jlim': tanggalDanJam,
      'deo_jlim': dataInformasiSYSUSER[0],
      'imei_jlim': imeiData,
    };
    var connect = Api.connectionApi("post", body, "insert_jlim");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    // List data = valueBody['data'];
    print(valueBody);
  }

  void insertProd2(produkSelected, valueNomorKey, valueNomorUrut,
      hrgJualEditFinal, filterJumlahPesan, imeiData) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'PROD2',
      'cabang_prod2': dashboardCt.cabangKodeSelected.value,
      'nomor_prod2': dashboardCt.nomorFaktur.value,
      'nomorcb_prod2': dashboardCt.nomorCbLastSelected.value,
      'nokey_prod2': valueNomorKey,
      'cbxx_prod2': dashboardCt.cabangKodeSelected.value,
      'noxx_prod2': dashboardCt.nomorFaktur.value,
      'nosub_prod2': valueNomorKey,
      'tanggal_prod2': tanggalNow,
      'tgl_prod2': tanggalNow,
      'custom_prod2': dashboardCt.customSelected.value,
      'wilayah_prod2': dashboardCt.wilayahCustomerSelected.value,
      'salesm_prod2': dashboardCt.kodePelayanSelected.value,
      'gudang_prod2': dashboardCt.gudangSelected.value,
      'group_prod2': produkSelected[0]['GROUP'],
      'barang_prod2': produkSelected[0]['KODE'],
      'uang_prod2': "RP",
      'kurs_prod2': "1",
      'harga_prod2': hrgJualEditFinal,
      'flag_prod2': "7",
      'doe_prod2': tanggalDanJam,
      'toe_prod2': jamTransaksi,
      'loe_prod2': tanggalDanJam,
      'deo_prod2': dataInformasiSYSUSER[0],
      'cb_prod2': dashboardCt.cabangKodeSelected.value,
      'imei_jlim': imeiData,
    };

    var connect = Api.connectionApi("post", body, "insert_prod2");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    // List data = valueBody['data'];
    print(valueBody);
  }

  void insertImeix(produkSelected, valueNomorKey, valueNomorUrut,
      hrgJualEditFinal, filterJumlahPesan, imeiData) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'IMEIX',
      'cabang_imeix': dashboardCt.cabangKodeSelected.value,
      'nomor_imeix': dashboardCt.nomorFaktur.value,
      'nomorcb_imeix': dashboardCt.nomorCbLastSelected.value,
      'nokey_imeix': valueNomorKey,
      'cbxx_imeix': dashboardCt.cabangKodeSelected.value,
      'noxx_imeix': dashboardCt.nomorFaktur.value,
      'nosub_imeix': valueNomorKey,
      'tanggal_imeix': tanggalNow,
      'tgl_imeix': tanggalNow,
      'custom_imeix': dashboardCt.customSelected.value,
      'wilayah_imeix': dashboardCt.wilayahCustomerSelected.value,
      'salesm_imeix': dashboardCt.kodePelayanSelected.value,
      'gudang_imeix': dashboardCt.gudangSelected.value,
      'group_imeix': produkSelected[0]['GROUP'],
      'barang_imeix': produkSelected[0]['KODE'],
      'uang_imeix': "RP",
      'kurs_imeix': "1",
      'harga_imeix': hrgJualEditFinal,
      'flag_imeix': "7",
      'doe_imeix': tanggalDanJam,
      'toe_imeix': jamTransaksi,
      'loe_imeix': tanggalDanJam,
      'deo_imeix': dataInformasiSYSUSER[0],
      'cb_imeix': dashboardCt.cabangKodeSelected.value,
      'imei_jlim': imeiData,
    };

    var connect = Api.connectionApi("post", body, "insert_imeix");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    // List data = valueBody['data'];
    print(valueBody);
  }

  Future<bool> checkStok(group, kode, tanggalJlhd, filterJumlahPesan) async {
    bool statusStok = false;
    // print(group);
    // print(kode);
    // print(tanggalJlhd);
    // print(filterJumlahPesan);
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'WARE1',
      'group': '$group',
      'kode': '$kode',
      'tanggal_jlhd': '$tanggalJlhd',
      'qty_pesanan': '$filterJumlahPesan',
      'gudang': dashboardCt.gudangSelected.value,
    };
    var connect = Api.connectionApi("post", body, "check_stok");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusStok = true;
    } else {
      statusStok = false;
      UtilsAlert.showToast(valueBody['message']);
    }

    return Future.value(statusStok);
  }

  Future<String> checkNoKey() {
    setBusy();
    String norutKeranjang = "";
    if (dashboardCt.listKeranjangArsip.value.isNotEmpty) {
      print(dashboardCt.listKeranjangArsip.value);
      if (dashboardCt.listKeranjangArsip.value.length <= 9) {
        var valueLast = dashboardCt.listKeranjangArsip.value.last;
        var getNoKey = valueLast["NOKEY"];
        var hitung = int.parse(getNoKey) + 1;
        norutKeranjang = "0000$hitung";
      } else if (dashboardCt.listKeranjangArsip.value.length <= 99) {
        var hitung = dashboardCt.listKeranjangArsip.value.length + 1;
        norutKeranjang = "000$hitung";
      } else {
        var hitung = dashboardCt.listKeranjangArsip.value.length + 1;
        norutKeranjang = "00$hitung";
      }
    } else {
      norutKeranjang = "00001";
    }
    setIdle();
    return Future.value(norutKeranjang);
  }

  Future<String> checkNorut() {
    setBusy();
    String norutKeranjang = "";
    if (dashboardCt.listKeranjangArsip.value.isNotEmpty) {
      print(dashboardCt.listKeranjangArsip.value);
      if (dashboardCt.listKeranjangArsip.value.length <= 9) {
        var valueLast = dashboardCt.listKeranjangArsip.value.last;
        var getNoKey = valueLast["NOKEY"];
        var hitung = int.parse(getNoKey) + 1;
        norutKeranjang = "0000$hitung";
      } else if (dashboardCt.listKeranjangArsip.value.length <= 99) {
        var hitung = dashboardCt.listKeranjangArsip.value.length + 1;
        norutKeranjang = "000$hitung";
      } else {
        var hitung = dashboardCt.listKeranjangArsip.value.length + 1;
        norutKeranjang = "00$hitung";
      }
    } else {
      norutKeranjang = "00001";
    }
    setIdle();
    return Future.value(norutKeranjang);
  }
}
