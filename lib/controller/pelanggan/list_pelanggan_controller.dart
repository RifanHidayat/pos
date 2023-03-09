import 'dart:convert';
import 'package:get/get.dart';
import 'package:siscom_pos/model/pelanggan/list_pelanggan_model.dart';

class ListPelangganViewController extends GetxController {
  var listPelanggan = <ListPelangganModel>[].obs;
  var listPelangganMaster = <ListPelangganModel>[].obs;

  var screenLoad = false.obs;

  var statusMember = 0.obs;
  var screenDetailAktif = 0.obs;

  List dummyData = [
    {
      "kode_pelanggan": "001",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 1,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "002",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 2,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "003",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 1,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "004",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 2,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "005",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 1,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "006",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 2,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "007",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 1,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "008",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 2,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "009",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 1,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
    {
      "kode_pelanggan": "010",
      "nama_pelanggan": "Nama Pelanggan",
      "status": 2,
      "nomor_telpon": "081389759823",
      "point": 10,
    },
  ];

  void startLoad() {
    getProsesListPelanggan();
  }

  Future<bool> getProsesListPelanggan() async {
    // load dummy
    for (var element in dummyData) {
      if (element["status"] == 1) {
        listPelanggan.add(ListPelangganModel(
          kodePelanggan: element["kode_pelanggan"],
          namaPelanggan: element["nama_pelanggan"],
          status: element["status"],
          nomorTelpon: element["nomor_telpon"],
          point: element["point"],
        ));
      }
      listPelangganMaster.add(ListPelangganModel(
        kodePelanggan: element["kode_pelanggan"],
        namaPelanggan: element["nama_pelanggan"],
        status: element["status"],
        nomorTelpon: element["nomor_telpon"],
        point: element["point"],
      ));
    }

    listPelanggan.refresh();

    return Future.value(true);
  }
}
