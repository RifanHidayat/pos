import 'dart:convert';

class ListPelangganModel {
  String? kodePelanggan;
  String? namaPelanggan;
  String? namaSales;
  String? alamat1;
  String? alamat2;
  String? fax;
  String? hp;
  String? email;
  String? npwp;
  String? wilayah;
  String? salesm;
  String? term;
  double? limit;
  double? sumpd;
  double? sumum;
  double? batas;
  double? debe;
  double? ceer;
  double? kredit;
  double? uangMuka;
  String? tanggalLahir;
  String? tanggalJoin;
  String? tanggalExp;
  String? status;
  String? nomorTelpon;
  double? pointDidapat;
  double? pointDitukar;
  double? totalPoint;

  ListPelangganModel({
    this.kodePelanggan,
    this.namaPelanggan,
    this.namaSales,
    this.alamat1,
    this.alamat2,
    this.fax,
    this.hp,
    this.email,
    this.npwp,
    this.wilayah,
    this.salesm,
    this.term,
    this.limit,
    this.sumpd,
    this.sumum,
    this.batas,
    this.debe,
    this.ceer,
    this.kredit,
    this.uangMuka,
    this.tanggalLahir,
    this.tanggalJoin,
    this.tanggalExp,
    this.status,
    this.nomorTelpon,
    this.pointDidapat,
    this.pointDitukar,
    this.totalPoint,
  });

  Map<String, dynamic> toMap() {
    return {
      "kodePelanggan": kodePelanggan,
      "namaPelanggan": namaPelanggan,
      "namaSales": namaSales,
      "alamat1": alamat1,
      "alamat2": alamat2,
      "fax": fax,
      "hp": hp,
      "email": email,
      "npwp": npwp,
      "wilayah": wilayah,
      "salesm": salesm,
      "term": term,
      "limit": limit,
      "sumpd": sumpd,
      "sumum": sumum,
      "batas": batas,
      "debe": debe,
      "ceer": ceer,
      "kredit": kredit,
      "uangMuka": uangMuka,
      "tanggalLahir": tanggalLahir,
      "tanggalJoin": tanggalJoin,
      "tanggalExp": tanggalExp,
      "status": status,
      "nomorTelpon": nomorTelpon,
      "pointDidapat": pointDidapat,
      "pointDitukar": pointDitukar,
      "totalPoint": totalPoint,
    };
  }

  factory ListPelangganModel.fromMap(Map<String, dynamic> map) {
    return ListPelangganModel(
      kodePelanggan: map['kodePelanggan'],
      namaPelanggan: map['namaPelanggan'],
      namaSales: map['namaSales'],
      alamat1: map['alamat1'],
      alamat2: map['alamat2'],
      fax: map['fax'],
      hp: map['hp'],
      email: map['email'],
      npwp: map['npwp'],
      wilayah: map['wilayah'],
      salesm: map['salesm'],
      term: map['term'],
      limit: map['limit'],
      sumpd: map['sumpd'],
      sumum: map['sumum'],
      batas: map['batas'],
      debe: map['debe'],
      ceer: map['ceer'],
      kredit: map['kredit'],
      uangMuka: map['uangMuka'],
      tanggalLahir: map['tanggalLahir'],
      tanggalJoin: map['tanggalJoin'],
      tanggalExp: map['tanggalExp'],
      status: map['status'],
      nomorTelpon: map['nomorTelpon'],
      pointDidapat: map['pointDidapat'],
      pointDitukar: map['pointDitukar'],
      totalPoint: map['totalPoint'],
    );
  }

  String toJson() => json.encode(toMap());
}
