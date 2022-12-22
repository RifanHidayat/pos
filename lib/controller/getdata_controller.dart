import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';

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
}
