import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_pos/model/params/params_model.dart';

class ParamsController extends GetxController {
  var datashow = [].obs;
  var data = <ParamsModel>[].obs;

  convert(List<dynamic> list) {
    datashow.clear();
    data.clear();
    datashow.value.addAll(list);
    datashow.refresh();
    debugPrint('datanya ada prams ${list}');
    for (var element in datashow) {
      data.value.add(ParamsModel.fromMap(element));
    }
    data.refresh();
  }
}
