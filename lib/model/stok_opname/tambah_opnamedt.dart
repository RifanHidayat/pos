import 'dart:convert';

class TambahOpnameDt {
  String? namaBarang;
  String? group;
  String? kodeBarang;
  int? fisik;
  int? qty;
  String? diopname;
  String? tanggal;
  String? nomor;
  String? cabang;

  TambahOpnameDt(
      {this.namaBarang,
      this.group,
      this.kodeBarang,
      this.fisik,
      this.qty,
      this.diopname,
      this.tanggal,
      this.nomor,
      this.cabang});

  Map<String, dynamic> toMap() {
    return {
      'namaBarang': namaBarang,
      'group': group,
      'kodeBarang': kodeBarang,
      'fisik': fisik,
      'qty': qty,
      'diopname': diopname,
      'tanggal': tanggal,
      'nomor': nomor,
      'cabang': cabang
    };
  }

  factory TambahOpnameDt.fromMap(Map<String, dynamic> map) {
    return TambahOpnameDt(
        namaBarang: map['namaBarang'],
        group: map['group'],
        kodeBarang: map['kodeBarang'],
        fisik: map['fisik'],
        qty: map['qty'],
        diopname: map['diopname'],
        tanggal: map['tanggal'],
        nomor: map['nomor'],
        cabang: map['cabang']);
  }

  String toJson() => json.encode(toMap());
}
