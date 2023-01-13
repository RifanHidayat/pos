import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';

class GetDataController extends GetxController {
  Future<List> checkUkuran(String groupBarang, String kodeBarang) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'UKURAN',
      'ukuranperbarang_group': groupBarang,
      'ukuranperbarang_kode': kodeBarang,
    };
    var connect = Api.connectionApi("post", body, "ukuran_perbarang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    print('data check ukuran $data');
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataSales(String kodeCabang) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SALESM',
      'kode_cabang': kodeCabang,
    };
    var connect = Api.connectionApi("post", body, "salesman");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getSpesifikData(String tabelName, String valueColumn,
      String valueCari, String endpoint) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabelName,
      'column': valueColumn,
      'cari': valueCari,
    };
    var connect = Api.connectionApi("post", body, endpoint);
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataPelanggan(String kodeSales) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'CUSTOM',
      'kode_sales': kodeSales,
    };
    var connect = Api.connectionApi("post", body, "pelanggan");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataAllSOHD() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
    };
    var connect = Api.connectionApi("post", body, "all_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataAllDOHD() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DOHD',
    };
    var connect = Api.connectionApi("post", body, "all_dohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataAllFakturPenjualan(String cabang) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLHD',
      'cabang': cabang,
    };
    var connect = Api.connectionApi("post", body, "penjualan_cabang_list");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getAllBarang() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PROD1',
    };
    var connect = Api.connectionApi("post", body, "all_barang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getBarangSpesifik(String group, String kode) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PROD1',
      'group_barang': group,
      'kode_barang': kode,
    };
    var connect = Api.connectionApi("post", body, "spesifik_barang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> cariBarangNotaPengiriman(List tampungGroupKode) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PROD1',
      'list_group_barang': tampungGroupKode
    };
    var connect = Api.connectionApi("post", body, "pencarian_barang_multiple");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> prosesCheckImei(
      List produkSelected, String kodeCabang, String kodeGudang) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'IMEIX',
      'tanggal_transaksi': tanggalNow,
      'kode_barang': produkSelected[0]['KODE'],
      'group_barang': produkSelected[0]['GROUP'],
      'kode_cabang': kodeCabang,
      'kode_gudang': kodeGudang,
    };
    var connect = Api.connectionApi("post", body, "getImei");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['data']);
  }

  Future<List> insertJLIM(List dataInsert) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLIM',
      'pk_jlim': dataInsert[0],
      'cabang_jlim': dataInsert[1],
      'nomor_jlim': dataInsert[2],
      'nokey_jlim': dataInsert[3],
      'flag_jlim': "7",
      'doe_jlim': tanggalDanJam,
      'toe_jlim': jamTransaksi,
      'loe_jlim': tanggalDanJam,
      'deo_jlim': dataInformasiSYSUSER[0],
      'imei_jlim': dataInsert[4],
    };
    var connect = Api.connectionApi("post", body, "insert_jlim");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    var hasilAkhir = [];
    if (valueBody['status'] == true) {
      hasilAkhir = [true, valueBody['data']];
    } else {
      hasilAkhir = [false];
    }
    return Future.value(hasilAkhir);
  }

  Future<List> insertPROD2(List dataInsert) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PROD2',
      'cabang_prod2': dataInsert[0],
      'nomor_prod2': dataInsert[1],
      'nomorcb_prod2': dataInsert[2],
      'nokey_prod2': dataInsert[3],
      'cbxx_prod2': dataInsert[4],
      'noxx_prod2': dataInsert[5],
      'nosub_prod2': dataInsert[6],
      'tanggal_prod2': tanggalNow,
      'tgl_prod2': tanggalNow,
      'custom_prod2': dataInsert[7],
      'wilayah_prod2': dataInsert[8],
      'salesm_prod2': dataInsert[9],
      'gudang_prod2': dataInsert[10],
      'group_prod2': dataInsert[11],
      'barang_prod2': dataInsert[12],
      'uang_prod2': "RP",
      'kurs_prod2': "1",
      'harga_prod2': dataInsert[13],
      'flag_prod2': "7",
      'doe_prod2': tanggalDanJam,
      'toe_prod2': jamTransaksi,
      'loe_prod2': tanggalDanJam,
      'deo_prod2': dataInformasiSYSUSER[0],
      'cb_prod2': dataInsert[14],
      'imei_prod2': dataInsert[15],
    };

    var connect = Api.connectionApi("post", body, "insert_prod2");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    var hasilAkhir = [];
    if (valueBody['status'] == true) {
      hasilAkhir = [true, valueBody['data']];
    } else {
      hasilAkhir = [false];
    }
    return Future.value(hasilAkhir);
  }

  Future<List> insertIMEIX(List dataInsert) async {
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    var dataInformasiSYSUSER = AppData.sysuserInformasi.split("-");

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'IMEIX',
      'cabang_imeix': dataInsert[0],
      'nomor_imeix': dataInsert[1],
      'nomorcb_imeix': dataInsert[2],
      'nokey_imeix': dataInsert[3],
      'cbxx_imeix': dataInsert[4],
      'noxx_imeix': dataInsert[5],
      'nosub_imeix': dataInsert[6],
      'tanggal_imeix': tanggalNow,
      'tgl_imeix': tanggalNow,
      'custom_imeix': dataInsert[7],
      'wilayah_imeix': dataInsert[8],
      'salesm_imeix': dataInsert[9],
      'gudang_imeix': dataInsert[10],
      'group_imeix': dataInsert[11],
      'barang_imeix': dataInsert[12],
      'uang_imeix': "RP",
      'kurs_imeix': "1",
      'harga_imeix': dataInsert[13],
      'flag_imeix': "7",
      'doe_imeix': tanggalDanJam,
      'toe_imeix': jamTransaksi,
      'loe_imeix': tanggalDanJam,
      'deo_imeix': dataInformasiSYSUSER[0],
      'cb_imeix': dataInsert[14],
      'imei_imeix': dataInsert[15],
    };

    var connect = Api.connectionApi("post", body, "insert_imeix");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    var hasilAkhir = [];
    if (valueBody['status'] == true) {
      hasilAkhir = [true, valueBody['data']];
    } else {
      hasilAkhir = [false];
    }
    return Future.value(hasilAkhir);
  }

  Future<List> sohdSelectedNotaPengiriman(
      String custom, String sales, String bulan, String tahun) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'custom': custom,
      'salesm': sales,
      'bulan': bulan,
      'tahun': tahun,
    };
    var connect =
        Api.connectionApi("post", body, "sohd_selected_nota_pengiriman");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataSOHD(String nomorSohd) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'nomor_sohd': nomorSohd,
    };
    var connect = Api.connectionApi("post", body, "get_once_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getDataSODT(String nomorSohd) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SODT',
      'nomorsohd': nomorSohd,
    };
    var connect = Api.connectionApi("post", body, "get_once_sodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> getSysdataCabang() async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SYSDATA',
    };
    var connect = Api.connectionApi("post", body, "get_sysdata_cabang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> informasiCetak(String tabel, String nomor) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'nomor': nomor,
    };
    var connect =
        Api.connectionApi("post", body, "informasi_cetak_datatransaksi");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> informasiCetakDetail(String tabel, String nomor) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'nomor': nomor,
    };
    var connect =
        Api.connectionApi("post", body, "informasi_cetak_detailtransaksi");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> pilihSodtMultipleSelected(String nomorSodt) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': "SODT",
      'nomor': nomorSodt,
    };
    var connect =
        Api.connectionApi("post", body, "pilih_sodt_multiple_selected");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<List> checkStokOutstanding(
      String group, String kode, String gudang) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': "WARE1",
      'group_barang': group,
      'kode_barang': kode,
      'gudang': gudang,
    };
    var connect = Api.connectionApi("post", body, "check_stok_outstanding");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    List dataFinal = [];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }
    return Future.value(dataFinal);
  }

  Future<bool> closeSODH(String ipDevice, String nomoSODH) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'ip_device': ipDevice,
      'nomor': nomoSODH,
    };
    var connect = Api.connectionApi("post", body, "close_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> closeDODH(String ipDevice, String nomorDODH) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DOHD',
      'ip_device': ipDevice,
      'nomor': nomorDODH,
    };
    var connect = Api.connectionApi("post", body, "close_dohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> validasiUser(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    var connect = Api.connectionApi("post", body, "checking_password_user");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> updateSohd(nomorsohd, hargaTotheader, qtyallheader, discdHeader,
      dischHeader, discnHeader, persenPPN, fixedTaxn, fixedHrgNet) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'nomor_sohd': nomorsohd,
      'hargatot_sohd': hargaTotheader,
      'qty_sohd': qtyallheader,
      'discd_sohd': discdHeader,
      'disch_sohd': dischHeader,
      'discn_sohd': discnHeader,
      'persen_ppn': persenPPN,
      'nominal_ppn': fixedTaxn,
      'hrgnet_sohd': fixedHrgNet,
    };
    var connect = Api.connectionApi("post", body, "update_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil update sohd $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> updateDohd(nomordohd, hargaTotheader, qtyallheader, discdHeader,
      dischHeader, discnHeader, persenPPN, fixedTaxn, fixedHrgNet) async {
    var convertPersenPPN = persenPPN == "NaN" ? 0 : persenPPN;
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DOHD',
      'nomor': nomordohd,
      'hargatot': hargaTotheader,
      'qty': qtyallheader,
      'discd': discdHeader,
      'disch': dischHeader,
      'discn': discnHeader,
      'persen_ppn': convertPersenPPN,
      'nominal_ppn': fixedTaxn,
      'hrgnet': fixedHrgNet,
    };
    var connect = Api.connectionApi("post", body, "update_dohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil update sohd $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> updateSodt(String nomorSohd, String nomorUrut, double valueDiscn,
      double valuePPN, double valueOngkos) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SODT',
      'nomor_sohd': nomorSohd,
      'nomor_urut': nomorUrut,
      'value_discn': valueDiscn,
      'nominal_ppn': valuePPN,
      'value_ongkos': valueOngkos,
    };
    var connect = Api.connectionApi("post", body, "update_sodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil update sodt $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> updateDodt(String nomorDohd, String nomorUrut, double valueDiscn,
      double valuePPN, double valueOngkos) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DODT',
      'nomor': nomorDohd,
      'nourut': nomorUrut,
      'value_discn': valueDiscn,
      'nominal_ppn': valuePPN,
      'value_ongkos': valueOngkos,
    };
    var connect = Api.connectionApi("post", body, "update_dodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil update sodt $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> checkDodt(String nomorDohd, String nomorUrut) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DODT',
      'nomor': nomorDohd,
      'nourut': nomorUrut
    };
    var connect = Api.connectionApi("post", body, "check_data_dodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> updateProd3(String nomor, String nomorUrut, double qty,
      double valueDiscn, double valuePPN, double valueOngkos) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'PROD3',
      'nomor': nomor,
      'nourut': nomorUrut,
      'value_qty': qty,
      'value_discn': valueDiscn,
      'nominal_ppn': valuePPN,
      'value_ongkos': valueOngkos,
    };
    var connect = Api.connectionApi("post", body, "update_prod3");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil update prod3 $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> hapusSODT(String nomorSohd, String nomorUrut) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SODT',
      'nomor_sohd': nomorSohd,
      'nomor_urut': nomorUrut,
    };
    var connect = Api.connectionApi("post", body, "hapus_sodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil hapus sodt $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> hapusSOHD(String nomorSohd) async {
    UtilsAlert.loadingSimpanData(Get.context!, "hapus order penjualan...");
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'nomor_sohd': nomorSohd,
    };
    var connect = Api.connectionApi("post", body, "hapus_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil hapus sodt $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> updateFakturVoid(List dataSelected) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Void faktur...");
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'JLHD',
      'key_faktur': dataSelected[0],
      'keterangan_void': dataSelected[1],
    };
    var connect = Api.connectionApi("post", body, "update_void_faktur");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil void faktur $valueBody');
    return Future.value(valueBody['status']);
  }

  Future<bool> editQtzSODT(String nourut, String nomor, String qtz) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SODT',
      'sodt_nourut': nourut,
      'sodt_nomor': nomor,
      'sodt_edit_qtz': qtz,
    };
    var connect = Api.connectionApi("post", body, "update_qtz_sodt");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> editQtzSOHD(
      String nomor, String qtyPesanSebelum, String qtyPesanSesudah) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'nomor': nomor,
      'qty_pesan_sebelum': qtyPesanSebelum,
      'qty_pesan_sesudah': qtyPesanSesudah,
    };
    var connect = Api.connectionApi("post", body, "update_qtz_sohd");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<bool> validPenjualan(String statusValid, String nomor_shod) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Valid penjualan...");
    String valueValid = statusValid == "Valid" ? "V" : "";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'value_valid': valueValid,
      'nomor_sohd': nomor_shod,
    };
    var connect = Api.connectionApi("post", body, "update_valid_penjualan");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    return Future.value(valueBody['status']);
  }

  Future<List> checkStok(
      group, kode, tanggalJlhd, filterJumlahPesan, gudangSelected) async {
    List statusStok = [];
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'WARE1',
      'group': '$group',
      'kode': '$kode',
      'tanggal_jlhd': '$tanggalJlhd',
      'qty_pesanan': '$filterJumlahPesan',
      'gudang': gudangSelected,
    };
    var connect = Api.connectionApi("post", body, "check_stok");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusStok = [true, valueBody['message']];
    } else {
      statusStok = [false, valueBody['message']];
    }

    return Future.value(statusStok);
  }

  Future<List> getImeiEditKeranjang(kode, group, kodecabang, kodegudang) async {
    List dataFinal = [];
    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'IMEIX',
      'tanggal_transaksi': tanggalNow,
      'kode_barang': kode,
      'group_barang': group,
      'kode_cabang': kodecabang,
      'kode_gudang': kodegudang,
    };
    var connect = Api.connectionApi("post", body, "get_imei_edit_keranjang");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List data = valueBody['data'];
    if (data.isNotEmpty) {
      dataFinal = data;
    } else {
      dataFinal = [];
    }

    return Future.value(dataFinal);
  }

  Future<List> editDataGlobal(
      String tabel, String url, String type, dynamic dataUpdate) async {
    List statusFinal = [];
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'type': type,
      'list_data': dataUpdate
    };
    var connect = Api.connectionApi("post", body, url);
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusFinal = [true, valueBody['message']];
    } else {
      statusFinal = [false, valueBody['message']];
    }
    print('hasil edit data global $valueBody');
    return Future.value(statusFinal);
  }

  Future<List> hapusGlobal(
      String tabel, String url, String type, dynamic dataUpdate) async {
    List statusFinal = [];
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': tabel,
      'type': type,
      'list_data': dataUpdate
    };
    var connect = Api.connectionApi("post", body, url);
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusFinal = [true, valueBody['message']];
    } else {
      statusFinal = [false, valueBody['message']];
    }

    return Future.value(statusFinal);
  }

  Future<List> kirimProd3(List dataInsertProd3) async {
    List statusFinal = [];

    var dt = DateTime.now();
    var tanggalNow = "${DateFormat('yyyy-MM-dd').format(dt)}";
    var tanggalDanJam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(dt)}";
    var jamTransaksi = "${DateFormat('HH:mm:ss').format(dt)}";

    Map<String, dynamic> body = {
      "database": AppData.databaseSelected,
      "periode": AppData.periodeSelected,
      "stringTabel": 'PROD3',
      "prod3_cabang": dataInsertProd3[0]['cabang_selected'],
      "prod3_nomor": dataInsertProd3[0]['nomor'],
      "prod3_nomorcb": dataInsertProd3[0]['nomorcb'],
      "prod3_nourut": dataInsertProd3[0]['nourut'],
      "prod3_nokey": dataInsertProd3[0]['nokey'],
      "prod3_cbxx": dataInsertProd3[0]['cabang_selected'],
      "prod3_noxx": dataInsertProd3[0]['noxx'],
      "prod3_nosub": dataInsertProd3[0]['nosub'],
      "prod3_noref": dataInsertProd3[0]['noref'],
      "prod3_ref": dataInsertProd3[0]['ref'],
      "prod3_tanggal": tanggalNow,
      "prod3_tgl": tanggalNow,
      "prod3_custom": dataInsertProd3[0]['custom'],
      "prod3_wilayah": dataInsertProd3[0]['wilayah'],
      "prod3_salesm": dataInsertProd3[0]['salesm'],
      "prod3_gudang": dataInsertProd3[0]['gudang'],
      "prod3_group": dataInsertProd3[0]['group'],
      "prod3_barang": dataInsertProd3[0]['kode'],
      "prod3_tipe": dataInsertProd3[0]['tipe'],
      "prod3_qty": dataInsertProd3[0]['qty'],
      "prod3_sat": dataInsertProd3[0]['sat'],
      "prod3_uang": "RP",
      "prod3_kurs": "1",
      "prod3_harga": dataInsertProd3[0]['harga'],
      "prod3_doe": tanggalDanJam,
      "prod3_toe": jamTransaksi,
      "prod3_loe": tanggalDanJam,
      "prod3_cb": dataInsertProd3[0]['cabang_selected'],
      "prod3_htg": dataInsertProd3[0]['htg'],
      "prod3_ptg": "1",
      "valuepak": dataInsertProd3[0]['pak'],
      "prod3_hgpak": dataInsertProd3[0]['hgpak'],
    };
    var connect = Api.connectionApi("post", body, "insert_prod3");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusFinal = [true, valueBody['message']];
    } else {
      statusFinal = [false, valueBody['message']];
    }

    return Future.value(statusFinal);
  }

  Future<List> updateWareStok(String group, String kode, String qtySebelumEdit,
      String qtyPesan, String gudang) async {
    List statusFinal = [];

    Map<String, dynamic> body = {
      "database": AppData.databaseSelected,
      "periode": AppData.periodeSelected,
      "stringTabel": 'WARE1',
      'group': group,
      'kode': kode,
      'qty_sebelum_edit': qtySebelumEdit,
      'qty_pesanan': qtyPesan,
      'gudang': gudang,
    };
    var connect = Api.connectionApi("post", body, "update_data_ware1");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusFinal = [true, valueBody['message']];
    } else {
      statusFinal = [false, valueBody['message']];
    }

    return Future.value(statusFinal);
  }

  Future<List> updateTambahStokGudang(
    String group,
    String kode,
    String gudang,
    String qtyPesan,
  ) async {
    List statusFinal = [];

    Map<String, dynamic> body = {
      "database": AppData.databaseSelected,
      "periode": AppData.periodeSelected,
      "stringTabel": 'WARE1',
      'group': group,
      'kode': kode,
      'gudang': gudang,
      'qty': qtyPesan,
    };
    var connect = Api.connectionApi("post", body, "update_tambah_data_ware1");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    if (valueBody['status'] == true) {
      statusFinal = [true, valueBody['message']];
    } else {
      statusFinal = [false, valueBody['message']];
    }

    return Future.value(statusFinal);
  }

  Future<bool> hitungRincianOrderPenjualan(List dataRincian) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang menyimpan...");
    // convert nominal diskon
    var nd1 = dataRincian[2].replaceAll('.', '');
    var nd2 = nd1.replaceAll(',', '.');
    var nd3 = double.parse('$nd2');

    // convert nominal ongkos
    var no1 = dataRincian[3].replaceAll('.', '');
    var no2 = no1.replaceAll(',', '.');
    var no3 = double.parse('$no2');

    // convert persen diskon
    var pd1 = dataRincian[4].replaceAll('.', '.');
    var pd2 = pd1.replaceAll(',', '.');

    // convert nominal ppn
    var np1 = dataRincian[5].replaceAll('.', '');
    var np2 = np1.replaceAll(',', '.');
    var np3 = double.parse('$np2');

    // print('nominal diskon $nd3');
    // print('nominal ongkos $no3');
    print('persen diskon ${dataRincian[4]}');
    // print('nominal ppn $np3');

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SODT',
      'nomor_sohd': dataRincian[0],
      'qty_all': dataRincian[1],
      'nominal_diskon_header': "$nd3",
      'nominal_ongkos': "$no3",
      'persen_ppn': "$pd2",
      'nominal_ppn': "$np3",
    };
    var connect =
        Api.connectionApi("post", body, "hitung_rincian_orderpenjualan");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil hitung rincian $valueBody');
    Get.back();
    return Future.value(valueBody['status']);
  }

  Future<bool> hitungRincianNotaPengiriman(List dataRincian) async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang menyimpan...");
    // convert nominal diskon
    var nd1 = dataRincian[2].replaceAll('.', '');
    var nd2 = nd1.replaceAll(',', '.');
    var nd3 = double.parse('$nd2');

    // convert nominal ongkos
    var no1 = dataRincian[3].replaceAll('.', '');
    var no2 = no1.replaceAll(',', '.');
    var no3 = double.parse('$no2');

    // convert persen diskon
    var pd1 = dataRincian[4].replaceAll('.', '.');
    var pd2 = pd1.replaceAll(',', '.');

    // convert nominal ppn
    var np1 = dataRincian[5].replaceAll('.', '');
    var np2 = np1.replaceAll(',', '.');
    var np3 = double.parse('$np2');

    // print('nominal diskon $nd3');
    // print('nominal ongkos $no3');
    print('persen diskon ${dataRincian[4]}');
    // print('nominal ppn $np3');

    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'DODT',
      'nomor_dohd': dataRincian[0],
      'qty_all': dataRincian[1],
      'nominal_diskon_header': "$nd3",
      'nominal_ongkos': "$no3",
      'persen_ppn': "$pd2",
      'nominal_ppn': "$np3",
    };
    var connect =
        Api.connectionApi("post", body, "hitung_rincian_notapengiriman");
    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    print('hasil hitung rincian $valueBody');
    Get.back();
    return Future.value(valueBody['status']);
  }
}
