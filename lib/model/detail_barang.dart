// To parse this JSON data, do
//
//     final detailBarangModel = detailBarangModelFromJson(jsonString);

import 'dart:convert';

List<DetailBarangModel> detailBarangModelFromJson(String str) => List<DetailBarangModel>.from(json.decode(str).map((x) => DetailBarangModel.fromJson(x)));

String detailBarangModelToJson(List<DetailBarangModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailBarangModel {
    DetailBarangModel({
        this.gudang,
        this.stok,
        this.nama,
        this.group,
        this.barang,
    });

    var  gudang;
    var stok;
    var  nama;
    var  group;
    var  barang;

    factory DetailBarangModel.fromJson(Map<String, dynamic> json) => DetailBarangModel(
        gudang: json["GUDANG"],
        stok: json["STOK"],
        nama: json["NAMA"],
        group: json["GROUP"],
        barang: json["BARANG"],
    );

    Map<String, dynamic> toJson() => {
        "GUDANG": gudang,
        "STOK": stok,
        "NAMA": nama,
        "GROUP": group,
        "BARANG": barang,
    };
      static List<DetailBarangModel> fromJsonToList(List data) {
    return List<DetailBarangModel>.from(data.map(
      (item) => DetailBarangModel.fromJson(item),
    ));
  }
}
