import 'dart:convert';

import 'package:get/get.dart';
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

  Future<bool> closeSODH(String ipDevice, String nomoSODH) async {
    Map<String, dynamic> body = {
      'database': AppData.databaseSelected,
      'periode': AppData.periodeSelected,
      'stringTabel': 'SOHD',
      'ip_device': ipDevice,
      'nomor_sohd': nomoSODH,
    };
    var connect = Api.connectionApi("post", body, "close_sohd");
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
      dischHeader, discnHeader, fixedTaxn, fixedHrgNet) async {
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
      'nominal_ppn': fixedTaxn,
      'hrgnet_sohd': fixedHrgNet,
    };
    var connect = Api.connectionApi("post", body, "update_sohd");
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
}