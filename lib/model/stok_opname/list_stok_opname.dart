import 'dart:convert';

class ListStokOpnameModel {
  String? nomorFaktur;
  String? kodeCabang;
  String? namaCabang;
  String? kodeGudang;
  String? namaGudang;
  String? tanggal;

  ListStokOpnameModel(
      {this.nomorFaktur,
      this.kodeCabang,
      this.namaCabang,
      this.kodeGudang,
      this.namaGudang,
      this.tanggal});

  Map<String, dynamic> toMap() {
    return {
      "nomorFaktur": nomorFaktur,
      "kodeCabang": kodeCabang,
      "namaCabang": namaCabang,
      "kodeGudang": kodeGudang,
      "namaGudang": namaGudang,
      "tanggal": tanggal
    };
  }

  factory ListStokOpnameModel.fromMap(Map<String, dynamic> map) {
    return ListStokOpnameModel(
      nomorFaktur: map['nomorFaktur'],
      kodeCabang: map['kodeCabang'],
      namaCabang: map['namaCabang'],
      kodeGudang: map['kodeGudang'],
      namaGudang: map['namaGudang'],
      tanggal: map['tanggal'],
    );
  }

  String toJson() => json.encode(toMap());
}
