import 'dart:convert';

class DetailPelangganModel {
  String? kodePelanggan;
  String? statusPelanggan;
  List<dynamic>? listPelanggan;
  String? namaPelanggan;
  String? caption1;
  String? namaKelompok;
  String? caption2;
  String? alamat;
  String? nomorTelpon;
  String? email;
  String? tanggalLahir;
  String? kreditLimit;
  String? totalLimit;
  String? uangMuka;
  String? batasKredit;
  String? nomorMember;
  String? nik;
  String? tanggalJoin;
  String? tanggalExpired;
  String? pointDidapat;
  String? pointDitukar;
  String? jumlahPoint;

  DetailPelangganModel({
    this.kodePelanggan,
    this.statusPelanggan,
    this.listPelanggan,
    this.namaPelanggan,
    this.caption1,
    this.namaKelompok,
    this.caption2,
    this.alamat,
    this.nomorTelpon,
    this.email,
    this.tanggalLahir,
    this.kreditLimit,
    this.totalLimit,
    this.uangMuka,
    this.batasKredit,
    this.nomorMember,
    this.nik,
    this.tanggalJoin,
    this.tanggalExpired,
    this.pointDidapat,
    this.pointDitukar,
    this.jumlahPoint,
  });

  Map<String, dynamic> toMap() {
    return {
      "kodePelanggan": kodePelanggan,
      "statusPelanggan": statusPelanggan,
      "listPelanggan": listPelanggan,
      "namaPelanggan": namaPelanggan,
      "caption1": caption1,
      "namaKelompok": namaKelompok,
      "caption2": caption2,
      "alamat": alamat,
      "nomorTelpon": nomorTelpon,
      "email": email,
      "tanggalLahir": tanggalLahir,
      "kreditLimit": kreditLimit,
      "totalLimit": totalLimit,
      "uangMuka": uangMuka,
      "batasKredit": batasKredit,
      "nomorMember": nomorMember,
      "nik": nik,
      "tanggalJoin": tanggalJoin,
      "tanggalExpired": tanggalExpired,
      "pointDidapat": pointDidapat,
      "pointDitukar": pointDitukar,
      "jumlahPoint": jumlahPoint,
    };
  }

  factory DetailPelangganModel.fromMap(Map<String, dynamic> map) {
    return DetailPelangganModel(
      kodePelanggan: map["kodePelanggan"],
      statusPelanggan: map["statusPelanggan"],
      listPelanggan: map["listPelanggan"],
      namaPelanggan: map["namaPelanggan"],
      caption1: map["caption1"],
      namaKelompok: map["namaKelompok"],
      caption2: map["caption2"],
      alamat: map["alamat"],
      nomorTelpon: map["nomorTelpon"],
      email: map["email"],
      tanggalLahir: map["tanggalLahir"],
      kreditLimit: map["kreditLimit"],
      totalLimit: map["totalLimit"],
      uangMuka: map["uangMuka"],
      batasKredit: map["batasKredit"],
      nomorMember: map["nomorMember"],
      nik: map["nik"],
      tanggalJoin: map["tanggalJoin"],
      tanggalExpired: map["tanggalExpired"],
      pointDidapat: map["pointDidapat"],
      pointDitukar: map["pointDitukar"],
      jumlahPoint: map["jumlahPoint"],
    );
  }

  String toJson() => json.encode(toMap());
}
