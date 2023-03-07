
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_pos/utils/api.dart';


class Request {
  late final String url;
  late final dynamic body;
  late final String token;
  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));

   Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

  Request({required this.url, this.body});

  Future<http.Response> get() async {

    return await http.get(Uri.parse(Api.basicUrl+url), headers: headers).timeout(Duration(minutes: 2));
  }

  Future<http.Response> post() async {
    return await http.post(Uri.parse(Api.basicUrl+url), body: body, headers: headers).timeout(Duration(minutes: 2));
  }

  Future<http.Response> patch() {
    return http.patch(Uri.parse(Api.basicUrl+url), body: body).timeout(Duration(minutes: 2));
  }

  Future<http.Response> delete() {
    return http
        .delete(Uri.parse(Api.basicUrl+url), body: body)
        .timeout(Duration(minutes: 2));
  }
}