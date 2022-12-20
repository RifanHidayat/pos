import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';

class ArsipFakturController extends BaseController {
  var cari = TextEditingController().obs;

  var listArsipFaktur = [].obs;
  var listArsipFakturDetailBarang = [].obs;

  var statusCari = false.obs;

  var loadingString = "Sedang memuat".obs;

  void getFakturArsip() async {
    if (AppData.noFaktur != "") {
      var getValue1 = AppData.noFaktur.split("|");
      List hasilDataListJlhd = [];
      List hasilDataListJldt = [];
      for (var element in getValue1) {
        var listFilter = element.split("-");
        var keyFaktur = listFilter[1];
        Future<List> dataListJlhd = getJlhd(keyFaktur);
        List tampung = await dataListJlhd;
        if (tampung.isNotEmpty) {
          for (var ele in tampung) {
            hasilDataListJlhd.add(ele);
          }
        }
        Future<List> dataListJdt = getJldt(keyFaktur);
        var tampung1 = await dataListJdt;
        if (tampung1.isNotEmpty) {
          for (var ele in tampung) {
            hasilDataListJldt.add(ele);
          }
        }
      }
      hitungArsip(hasilDataListJlhd, hasilDataListJldt);
    } else {
      listArsipFaktur.value.clear();
      this.listArsipFaktur.refresh();
      UtilsAlert.showToast("Tidak ada faktur");
      loadingString.value = "Tidak ada faktur tersimpan";
      this.loadingString.refresh();
    }
  }

  Future<List> getJlhd(keyFaktur) async {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'key_faktur': '$keyFaktur',
    };
    var connect = Api.connectionApi("post", body, "get_once_jlhd");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List hasilData = [];
    if (valueBody['status'] == true) {
      List data = valueBody['data'];
      List tampung = [];
      for (var element in data) {
        tampung.add(element);
      }
      hasilData = tampung;
    }
    return Future.value(hasilData);
  }

  Future<List> getJldt(keyFaktur) async {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLDT',
      'key_faktur': '$keyFaktur',
    };
    var connect = Api.connectionApi("post", body, "get_once_jldt");

    var getValue = await connect;
    var valueBody = jsonDecode(getValue.body);
    List hasilData = [];
    if (valueBody['status'] == true) {
      List data = valueBody['data'];
      List tampung2 = [];
      for (var element in data) {
        tampung2.add(element);
      }
      hasilData = tampung2;
    }
    return Future.value(hasilData);
  }

  void hitungArsip(hasilDataListJlhd, hasilDataListJldt) {
    var tampung = [];
    setBusy();
    for (var element in hasilDataListJlhd) {
      int total = 0;
      String tanggal = "";
      String jam = "";
      for (var element2 in hasilDataListJldt) {
        if (element['PK'] == element2['PK']) {
          tanggal = Utility.convertDate(element2['TANGGAL']);
          jam = element2['TOE'];
        }
      }
      print('nomor ${element['NOMOR']}');
      print('harga net ${element['HRGNET']}');
      var data = {
        'PK': element['PK'],
        'NOMOR': element['NOMOR'],
        'TANGGAL': tanggal,
        'KET1': element['KET1'],
        'PAIDPOS': element['PAIDPOS'],
        'JAM': jam,
        'TOTAL': element['HRGNET'],
      };
      tampung.add(data);
    }
    tampung.sort((a, b) => a['NOMOR'].compareTo(b['NOMOR']));
    listArsipFaktur.value = tampung;
    this.listArsipFaktur.refresh();
    this.listArsipFakturDetailBarang.refresh();
    loadingString.value = listArsipFaktur.value.isEmpty
        ? "Tidak ada arsip tersimpan"
        : "Sedang memuat...";
    this.loadingStatus.refresh();
  }
}
