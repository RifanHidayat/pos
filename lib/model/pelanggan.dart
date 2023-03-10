import 'dart:convert';

class PelangganModel {
  String? kodePelanggan;
  String? namaPelanggan;
  String? wilayahPelanggan;
  String? kodeSalesPelanggan;
  bool? isSelected;

  PelangganModel({
    this.kodePelanggan,
    this.namaPelanggan,
    this.wilayahPelanggan,
    this.kodeSalesPelanggan,
    this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      "kodePelanggan": kodePelanggan,
      "namaPelanggan": namaPelanggan,
      "wilayahPelanggan": wilayahPelanggan,
      "kodeSalesPelanggan": kodeSalesPelanggan,
      "isSelected": isSelected,
    };
  }

  factory PelangganModel.fromMap(Map<String, dynamic> map) {
    return PelangganModel(
      kodePelanggan: map['kodePelanggan'],
      namaPelanggan: map['namaPelanggan'],
      wilayahPelanggan: map['wilayahPelanggan'],
      kodeSalesPelanggan: map['kodeSalesPelanggan'],
      isSelected: map['isSelected'],
    );
  }

  String toJson() => json.encode(toMap());
}
