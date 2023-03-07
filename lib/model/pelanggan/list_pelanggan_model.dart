import 'dart:convert';

class ListPelangganModel {
  String? kodePelanggan;
  String? namaPelanggan;
  int? status;
  String? nomorTelpon;
  int? point;

  ListPelangganModel({
    this.kodePelanggan,
    this.namaPelanggan,
    this.status,
    this.nomorTelpon,
    this.point,
  });

  Map<String, dynamic> toMap() {
    return {
      "kodePelanggan": kodePelanggan,
      "namaPelanggan": namaPelanggan,
      "status": status,
      "nomorTelpon": nomorTelpon,
      "point": point,
    };
  }

  factory ListPelangganModel.fromMap(Map<String, dynamic> map) {
    return ListPelangganModel(
      kodePelanggan: map['kodePelanggan'],
      namaPelanggan: map['namaPelanggan'],
      status: map['status'],
      nomorTelpon: map['nomorTelpon'],
      point: map['point'],
    );
  }

  String toJson() => json.encode(toMap());
}
