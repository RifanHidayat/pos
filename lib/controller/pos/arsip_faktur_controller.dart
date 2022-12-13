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

  void startLoad() {
    getFakturArsip();
  }

  void getFakturArsip() {
    if (AppData.noFaktur != "") {
      listArsipFaktur.value.clear();
      listArsipFakturDetailBarang.value.clear();
      var getValue1 = AppData.noFaktur.split("|");
      for (var element in getValue1) {
        var listFilter = element.split("-");
        var keyFaktur = listFilter[1];
        getJlhd(keyFaktur);
      }
    } else {
      listArsipFaktur.value.clear();
      this.listArsipFaktur.refresh();
      UtilsAlert.showToast("Tidak ada faktur");
      loadingString.value = "Tidak ada faktur tersimpan";
      this.loadingString.refresh();
    }
  }

  void getJlhd(keyFaktur) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
      'key_faktur': '$keyFaktur',
    };
    var connect = Api.connectionApi("post", body, "get_once_jlhd");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        for (var element in data) {
          listArsipFaktur.value.add(element);
        }
        Map<String, dynamic> body = {
          'database': '${AppData.databaseSelected}',
          'periode': '${AppData.periodeSelected}',
          'stringTabel': 'JLDT',
          'key_faktur': '$keyFaktur',
        };
        var connect = Api.connectionApi("post", body, "get_once_jldt");
        connect.then((dynamic res) {
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            List data = valueBody['data'];
            for (var element in data) {
              listArsipFakturDetailBarang.value.add(element);
            }
            hitungArsip();
          } else {
            UtilsAlert.showToast("Terjadi kesalahan");
          }
        });
      } else {
        UtilsAlert.showToast("Terjadi kesalahan");
      }
    });
  }

  void hitungArsip() {
    var tampung = [];
    setBusy();
    for (var element in listArsipFaktur.value) {
      int total = 0;
      String tanggal = "";
      String jam = "";
      for (var element2 in listArsipFakturDetailBarang.value) {
        if (element['PK'] == element2['PK']) {
          double hitung1 = double.parse("${element2['QTY']}") *
              double.parse("${element2['HARGA']}");
          int hitungQty = hitung1.toInt();
          total += hitungQty;
          tanggal = Utility.convertDate(element2['TANGGAL']);
          jam = element2['TOE'];
        }
      }
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
    setIdle();
  }
}
