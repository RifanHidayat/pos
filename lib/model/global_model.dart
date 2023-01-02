import 'dart:convert';

class SysdataModel {
  String? kode;
  String? nama;

  SysdataModel({this.kode, this.nama});

  Map<String, dynamic> toMap() {
    return {"kode": kode, "nama": nama};
  }

  factory SysdataModel.fromMap(Map<String, dynamic> map) {
    return SysdataModel(
      kode: map['kode'],
      nama: map['nama'],
    );
  }

  String toJson() => json.encode(toMap());
}
