// ignore_for_file: prefer_typing_uninitialized_variables
class ParamsModel {
  var nomor;
  var nama;
  var kode;
  var inisial;
  var wilayah;
  var ppn;
  var charge;
  var point;
  var flagmember;
  var nomorTelp;

  ParamsModel({
    this.charge,
    this.inisial,
    this.kode,
    this.nama,
    this.nomor,
    this.ppn,
    this.wilayah,
    this.point,
    this.flagmember,
    this.nomorTelp,
  });

  factory ParamsModel.fromMap(Map<String, dynamic> map) {
    return ParamsModel(
        charge: map['CHARGE'],
        inisial: map['INISIAL'],
        kode: map['KODE'],
        nama: map['NAMA'],
        nomor: map['NOMOR'],
        ppn: map['PPN'],
        wilayah: map['WILAYAH'],
        point: map['POINT'],
        nomorTelp: map['TELP'],
        flagmember: map['FLAGMEMBER']);
  }
}
