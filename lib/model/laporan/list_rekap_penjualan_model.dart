import 'dart:convert';

class ListRekapPenjualanModel {
  String? title;
  String? jumlah;
  String? total;

  ListRekapPenjualanModel({
    this.title,
    this.jumlah,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "jumlah": jumlah,
      "total": total,
    };
  }

  factory ListRekapPenjualanModel.fromMap(Map<String, dynamic> map) {
    return ListRekapPenjualanModel(
      title: map['title'],
      jumlah: map['jumlah'],
      total: map['total'],
    );
  }

  String toJson() => json.encode(toMap());
}
