// To parse this JSON data, do
//
//     final gudangModel = gudangModelFromJson(jsonString);

import 'dart:convert';

List<GudangModel> gudangModelFromJson(String str) => List<GudangModel>.from(
    json.decode(str).map((x) => GudangModel.fromJson(x)));

String gudangModelToJson(List<GudangModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GudangModel {
  GudangModel({
    this.kode,
    this.nama,
    this.alamat1,
    this.alamat2,
    this.telp,
    this.acbeli,
    this.acdbeli,
    this.acbbeli,
    this.actbeli,
    this.acrbeli,
    this.actrbeli,
    this.acsrbeli,
    this.achrbeli,
    this.acjual,
    this.acdjual,
    this.acbjual,
    this.actjual,
    this.acsjual,
    this.achjual,
    this.acrjual,
    this.actrjual,
    this.acsrjual,
    this.achrjual,
    this.acajus,
    this.acsajus,
    this.acprod,
    this.acsprod,
    this.flag,
     this.doe,
    this.toe,
    this.loe,
     this.deo,
    this.sign,
     this.ip,
     this.groupgudang,
    this.otorisasi,
     this.cb,
     this.gcb,
     this.aktif,
  });

  var kode;
  var nama;
  var alamat1;
  var alamat2;
  var telp;
  var acbeli;
  var acdbeli;
  var acbbeli;
  var actbeli;
  var acrbeli;
  var actrbeli;
  var acsrbeli;
  var achrbeli;
  var acjual;
  var acdjual;
  var acbjual;
  var actjual;
  var acsjual;
  var achjual;
  var acrjual;
  var actrjual;
  var acsrjual;
  var achrjual;
  var acajus;
  var acsajus;
  var acprod;
  var acsprod;
  var flag;
  var doe;
  var toe;
  var loe;
  var deo;
  var sign;
  var ip;
  var groupgudang;
  var otorisasi;
  var cb;
  var gcb;
  var aktif;

  factory GudangModel.fromJson(Map<String, dynamic> json) => GudangModel(
        kode: json["KODE"],
        nama: json["NAMA"],
        alamat1: json["ALAMAT1"],
        alamat2: json["ALAMAT2"],
        telp: json["TELP"],
        acbeli: json["ACBELI"],
        acdbeli: json["ACDBELI"],
        acbbeli: json["ACBBELI"],
        actbeli: json["ACTBELI"],
        acrbeli: json["ACRBELI"],
        actrbeli: json["ACTRBELI"],
        acsrbeli: json["ACSRBELI"],
        achrbeli: json["ACHRBELI"],
        acjual: json["ACJUAL"],
        acdjual: json["ACDJUAL"],
        acbjual: json["ACBJUAL"],
        actjual: json["ACTJUAL"],
        acsjual: json["ACSJUAL"],
        achjual: json["ACHJUAL"],
        acrjual: json["ACRJUAL"],
        actrjual: json["ACTRJUAL"],
        acsrjual: json["ACSRJUAL"],
        achrjual: json["ACHRJUAL"],
        acajus: json["ACAJUS"],
        acsajus: json["ACSAJUS"],
        acprod: json["ACPROD"],
        acsprod: json["ACSPROD"],
        flag: json["FLAG"],
        doe: DateTime.parse(json["DOE"]),
        toe: json["TOE"],
        loe: json["LOE"],
        deo: json["DEO"],
        sign: json["SIGN"],
        ip: json["IP"],
        groupgudang: json["GROUPGUDANG"],
        otorisasi: json["OTORISASI"],
        cb: json["CB"],
        gcb: json["GCB"],
        aktif: json["AKTIF"],
      );

  Map<String, dynamic> toJson() => {
        "KODE": kode,
        "NAMA": nama,
        "ALAMAT1": alamat1,
        "ALAMAT2": alamat2,
        "TELP": telp,
        "ACBELI": acbeli,
        "ACDBELI": acdbeli,
        "ACBBELI": acbbeli,
        "ACTBELI": actbeli,
        "ACRBELI": acrbeli,
        "ACTRBELI": actrbeli,
        "ACSRBELI": acsrbeli,
        "ACHRBELI": achrbeli,
        "ACJUAL": acjual,
        "ACDJUAL": acdjual,
        "ACBJUAL": acbjual,
        "ACTJUAL": actjual,
        "ACSJUAL": acsjual,
        "ACHJUAL": achjual,
        "ACRJUAL": acrjual,
        "ACTRJUAL": actrjual,
        "ACSRJUAL": acsrjual,
        "ACHRJUAL": achrjual,
        "ACAJUS": acajus,
        "ACSAJUS": acsajus,
        "ACPROD": acprod,
        "ACSPROD": acsprod,
        "FLAG": flag,
        "DOE": doe.toIso8601String(),
        "TOE": toe,
        "LOE": loe,
        "DEO": deo,
        "SIGN": sign,
        "IP": ip,
        "GROUPGUDANG": groupgudang,
        "OTORISASI": otorisasi,
        "CB": cb,
        "GCB": gcb,
        "AKTIF": aktif,
      };
}
