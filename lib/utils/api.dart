import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_pos/utils/app_data.dart';

class Api {
  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));

  static var basicUrl = "http://kantor.membersis.com:5000/";

  static Future connectionApi(
      String typeConnect, valFormData, String url) async {
    var getUrl = basicUrl + url;
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (typeConnect == "post") {
      try {
        var url = Uri.parse(getUrl);
        var response =
            await post(url, body: jsonEncode(valFormData), headers: headers);
        return response;
      } on SocketException catch (e) {
        return false;
      }
    } else {
      try {
        var url = Uri.parse(getUrl);
        var response = await get(url, headers: headers);
        return response;
      } on SocketException catch (e) {
        return false;
      }
    }
  }

  static Future connectionApi2(
      String typeConnect, valFormData, String url, String urlGet) async {
    var getUrl = basicUrl + url;
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (typeConnect == "post" ||
        typeConnect == "patch" ||
        typeConnect == "delete") {
      try {
        var periode = AppData.periodeSelected.split("-");
        var convertPeriode = "${periode[1].substring(2)}${periode[0]}";
        var convert = getUrl +
            "?database=${AppData.databaseSelected}_acc&periode=$convertPeriode";
        var url = Uri.parse(convert);
        // print(url);
        if (typeConnect == "post") {
          var response =
              await post(url, body: jsonEncode(valFormData), headers: headers);
          return response;
        } else if (typeConnect == "patch") {
          var response =
              await patch(url, body: jsonEncode(valFormData), headers: headers);
          return response;
        } else if (typeConnect == "delete") {
          print(url);
          var response = await delete(url, headers: headers);
          return response;
        }
      } on SocketException catch (e) {
        return false;
      }
    } else {
      try {
        var periode = AppData.periodeSelected.split("-");
        var convertPeriode = "${periode[1].substring(2)}${periode[0]}";
        var convert = getUrl +
            "?database=${AppData.databaseSelected}_acc&periode=$convertPeriode$urlGet";
        var url = Uri.parse(convert);
        // print(url);
        var response = await get(url, headers: headers);
        return response;
      } on SocketException catch (e) {
        return false;
      }
    }
  }

  static Future connectionApiUploadFile(String url, File newFile) async {
    var getUrl = basicUrl + url;
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      final url = Uri.parse(getUrl);
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('sampleFile', newFile.path),
      );
      request.headers.addAll(headers);
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      return respStr;
    } on SocketException catch (e) {
      return false;
    }
  }
}
