import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/sidebar_controller.dart';
import 'package:siscom_pos/model/global_model.dart';
import 'package:siscom_pos/screen/auth/pilih_database.dart';
import 'package:siscom_pos/screen/pos/dashboard_pos.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/month_year_picker.dart';

class AuthController extends GetxController {
  // login
  var password = TextEditingController().obs;
  var email = TextEditingController().obs;

  // register
  var namaRegister = TextEditingController().obs;
  var namaPerusahaan = TextEditingController().obs;
  var emailRegister = TextEditingController().obs;
  var passwordRegister = TextEditingController().obs;

  var showpassword = false.obs;
  var checkedKetentuan = false.obs;

  var database = [].obs;

  var tanggalSelected = "".obs;
  var bulanTahunShow = "".obs;
  var bulanTahunSelected = "".obs;
  var databaseSelected = "".obs;
  var databaseSelectedRegis = "".obs;
  var passwordSelected = "".obs;

  var sidebarCt = Get.put(SidebarController());

  void startLoad() {
    getTimeNow();
    checkingData();
  }

  void checkingData() {
    if (AppData.informasiLoginUser != "") {
      var filter = AppData.informasiLoginUser.split("-");
      email.value.text = filter[0];
      password.value.text = filter[1];
    }
  }

  void loginUser() {
    if (email.value.text == "" ||
        password.value.text == "" ||
        databaseSelected.value == "" ||
        passwordSelected.value == "") {
      UtilsAlert.showToast("Lengkapi form terlebih dahulu");
    } else {
      UtilsAlert.loadingSimpanData(Get.context!, "Sedang proses...");
      // check password user
      Map<String, dynamic> body = {
        'email': email.value.text,
        'password': password.value.text,
      };
      var connect = Api.connectionApi("post", body, "checking_password_user");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            AppData.databaseSelected = databaseSelected.value;
            AppData.periodeSelected = bulanTahunSelected.value;
            AppData.informasiLoginUser =
                "${email.value.text}-${password.value.text}";
            nextStep1();
          } else {
            UtilsAlert.showToast("Password Salah");
            Navigator.pop(Get.context!);
          }
        }
      });
    }
  }

  void nextStep1() {
    checkJlhdTransaksi();
  }

  void checkJlhdTransaksi() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'JLHD',
    };
    var connect = Api.connectionApi("post", body, "get_last_faktur");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['type'] == 1 && valueBody['status'] == false) {
          Navigator.pop(Get.context!);
          UtilsAlert.showToast("Database periode tidak di temukan");
        } else {
          checkinfoSysUser(email.value.text);
        }
      }
    });
  }

  void checkSysdata() async {
    Future<List> dataSysdata = GetDataController().getSysdataCabang();
    List hasilSysdata = await dataSysdata;
    if (hasilSysdata.isNotEmpty) {
      List<SysdataModel> tampungData = [];
      for (var element in hasilSysdata) {
        var data = SysdataModel(
          kode: element["KODE"],
          nama: element["NAMA"],
        );
        tampungData.add(data);
      }
      AppData.infosysdatacabang = tampungData;
    }
  }

  void checkinfoSysUser(email) {
    checkSysdata();
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'SYSUSER',
      'email': email,
    };
    var connect = Api.connectionApi("post", body, "informasi_sysuser");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          
          AppData.sysuserInformasi =
              "${data[0]['USID']}-${data[0]['USLEVEL']}-${data[0]['LOGINFLAG']}-${data[0]['AKSESCABANG']}-${data[0]['AKSESGUDANG']}";
          var aksesCabangUser = "${data[0]['AKSESCABANG']}".split(" ");
          ambilDataCabang(aksesCabangUser);
        }
      }
    });
  }

  void ambilDataCabang(aksesCabangUser) {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'nama_tabel': 'CABANG',
    };
    var connect = Api.connectionApi("post", body, "cabang_pertama");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          List filter = [];
          for (var element in data) {
            for (var element1 in aksesCabangUser) {
              if (element1 == element["KODE"]) {
                filter.add(element);
              }
            }
          }
          print("data cabang akses $filter");
          if (filter.isEmpty) {
            UtilsAlert.showToast("Maaf anda tidak memiliki hak akses cabang");
          } else {
            var getFirst = filter.first;
            AppData.cabangSelected =
                "${getFirst['KODE']}-${getFirst['NAMA']}-${getFirst['CUSTOM']}-${getFirst['GUDANG']}-${getFirst['PPN']}";
            AppData.flagMember = "${data[0]['FLAGMEMBER']}";
            AppData.bidUsaha = "${data[0]['BIDUSAHA']}";
            sidebarCt.getCabang();
            Get.back();
            Get.offAll(Dashboard());
          }
        } else {
          UtilsAlert.showToast("Password Salah");
          Get.back();
        }
      }
    });
  }

  void getTimeNow() {
    var dt = DateTime.now();
    tanggalSelected.value = "${DateFormat('yyyy-MM-dd').format(dt)}";
    bulanTahunSelected.value = "${DateFormat('MM-yyyy').format(dt)}";
    bulanTahunShow.value =
        "${Utility.convertDate3('${tanggalSelected.value}')}";
    tanggalSelected.refresh();
    bulanTahunSelected.refresh();
    bulanTahunShow.refresh();
  }

  void filterBulan() {
    DatePicker.showPicker(
      Get.context!,
      pickerModel: CustomMonthPicker(
        minTime: DateTime(2000, 1, 1),
        maxTime: DateTime(2100, 1, 1),
        currentTime: DateTime.now(),
      ),
      onConfirm: (time) {
        if (time != null) {
          tanggalSelected.value = "${DateFormat('yyyy-MM-dd').format(time)}";
          bulanTahunSelected.value = "${DateFormat('MM-yyyy').format(time)}";
          bulanTahunShow.value =
              "${Utility.convertDate3('${tanggalSelected.value}')}";
          this.tanggalSelected.refresh();
          this.bulanTahunSelected.refresh();
        }
      },
    );
  }

  void pilihDatabase(url) {
    UtilsAlert.loadingSimpanData(Get.context!, "Memuat data...");
    if (url == "regis") {
      if (emailRegister.value.text == "") {
        UtilsAlert.showToast("Isi Email terlebih dahulu");
        Navigator.pop(Get.context!);
      } else {
        loadDatabaseUser(url);
      }
    } else {
      if (email.value.text == "") {
        UtilsAlert.showToast("Isi Email terlebih dahulu");
        Navigator.pop(Get.context!);
      } else {
        loadDatabaseUser(url);
      }
    }
  }

  void loadDatabaseUser(url) {
    var finalEmail =
        url == "regis" ? emailRegister.value.text : email.value.text;
    Map<String, dynamic> body = {
      'email': finalEmail,
    };
    var connect = Api.connectionApi("post", body, "validasi_database");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          UtilsAlert.showToast("${valueBody['message']}");
        } else {
          var data = valueBody['data'];
          var tampung = [];
          if (url == "login") {
            for (var element in data) {
              if (element['pos'] == "Y") {
                tampung.add(element);
              }
            }
            database.value = tampung;
            this.database.refresh();
            Navigator.pop(Get.context!);
            Get.to(PilihDatabase(url: url));
          } else {
            database.value = data;
            this.database.refresh();
            Navigator.pop(Get.context!);
            Get.to(PilihDatabase(url: url));
          }
        }
      }
    });
  }

  void selectDatabaseDanPassword(url, dbname, password) {
    if (url == "regis") {
      databaseSelectedRegis.value = dbname;
      this.databaseSelectedRegis.refresh();
      Get.back();
    } else {
      databaseSelected.value = dbname;
      passwordSelected.value = password;
      this.databaseSelected.refresh();
      this.passwordSelected.refresh();
      Get.back();
    }
  }

  void registerUser() {
    if (namaRegister.value.text == "" ||
        namaPerusahaan.value.text == "" ||
        emailRegister.value.text == "" ||
        passwordRegister.value.text == "") {
      UtilsAlert.showToast("Lengkapi form terlebi dahulu");
    } else if (checkedKetentuan.value == false) {
      UtilsAlert.showToast("Anda belum menyetujui syarat dan ketentuan");
    } else {
      UtilsAlert.loadingSimpanData(Get.context!, "Sedang proses...");
      Map<String, dynamic> body = {
        'database': databaseSelectedRegis.value,
        'nama_user': namaRegister.value.text,
        'nama_perusahaan': namaPerusahaan.value.text,
        'email': emailRegister.value.text,
        'password': passwordRegister.value.text,
        'tanggal_regis': "${DateTime.now()}",
      };
      var connect = Api.connectionApi("post", body, "validasi_registrasi");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == false) {
            UtilsAlert.showToast("${valueBody['message']}");
          } else {
            Navigator.pop(Get.context!);
            UtilsAlert.showToast("${valueBody['message']}");
            Get.back();
          }
        }
      });
    }
  }
}
