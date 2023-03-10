import 'dart:convert';

class SalesModel {
  String? kodeSales;
  String? namaSales;
  String? alamatSales;
  String? nomorSales;
  String? gudangSales;
  int? limitSales;
  bool? isSelected;

  SalesModel({
    this.kodeSales,
    this.namaSales,
    this.alamatSales,
    this.nomorSales,
    this.gudangSales,
    this.limitSales,
    this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      "kodeSales": kodeSales,
      "namaSales": namaSales,
      "alamatSales": alamatSales,
      "nomorSales": nomorSales,
      "gudangSales": gudangSales,
      "limitSales": limitSales,
      "isSelected": isSelected,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      kodeSales: map['kodeSales'],
      namaSales: map['namaSales'],
      alamatSales: map['alamatSales'],
      nomorSales: map['nomorSales'],
      gudangSales: map['gudangSales'],
      limitSales: map['limitSales'],
      isSelected: map['isSelected'],
    );
  }

  String toJson() => json.encode(toMap());
}
