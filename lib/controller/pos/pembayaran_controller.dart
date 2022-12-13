import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_pembayaran.dart';
import 'package:siscom_pos/screen/pos/pembayaran.dart';
import 'package:siscom_pos/screen/pos/selesai_pembayaran.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class PembayaranController extends BaseController {
  var uangterima = TextEditingController().obs;
  var nomorRekeningPembayaran = TextEditingController().obs;

  var listTipePembayaran = [].obs;
  var pilihanOpsiUangShow = [].obs;
  var informasiCabang = [].obs;

  var viewDetailHeader = false.obs;
  var viewPrintQr = false.obs;
  var viewScreenShootDetailStruk = false.obs;

  var buttonPilihBayar = 0.obs;
  var totalTagihan = 0.obs;
  var totalPembayaran = 0.obs;
  var selectedRadioButtonPilihPembayaran = 0.obs;

  var tipePembayaranSelected = "Tunai".obs;
  var statusKartuSelected = "".obs;
  var stringSelectedRadio = "".obs;
  var stringQrContent = "".obs;
  var stringInvoiceIdQris = "".obs;

  // detail kartu
  var appcodeKartu = TextEditingController().obs;
  var namaKartu = TextEditingController().obs;
  var nomorKartu = TextEditingController().obs;
  var keteranganKartu = TextEditingController().obs;

  List pilihanOpsiUang = [
    50000,
    100000,
    150000,
    200000,
    250000,
    300000,
    350000,
    400000,
    450000,
    500000,
    550000,
    600000,
    650000,
    700000,
    750000,
    800000,
    850000,
    900000,
    950000,
    1000000,
  ];

  var dashboardCt = Get.put(DashbardController());
  var simpanPembayaranCt = Get.put(SimpanPembayaran());

  void startLoad() {
    var getTotal = Utility.hitungDetailTotalPos(
        '${dashboardCt.totalNominalDikeranjang.value}',
        '${dashboardCt.diskonHeader.value}',
        '${dashboardCt.ppnCabang.value}',
        '${dashboardCt.serviceChargerCabang.value}');
    totalTagihan.value = getTotal.toInt();
    getTipePembayaran();
    opsiUang();
    getDetailCabang();
  }

  void getTipePembayaran() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'TBAYAR',
      'cabang': dashboardCt.cabangKodeSelected.value,
    };
    var connect = Api.connectionApi("post", body, "get_tbayar");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        var opsiTunai = {'KODE': "0", 'NAMA': 'Tunai', 'KARTU': 'N'};
        data = [opsiTunai, ...data];
        stringSelectedRadio.value = "0";
        listTipePembayaran.value = data;
        stringSelectedRadio.refresh();
        listTipePembayaran.refresh();
      }
    });
  }

  void getDetailCabang() {
    Map<String, dynamic> body = {
      'database': '${AppData.databaseSelected}',
      'periode': '${AppData.periodeSelected}',
      'stringTabel': 'CABANG',
      'kode_cabang': dashboardCt.cabangKodeSelected.value,
    };
    var connect = Api.connectionApi("post", body, "get_onceCabang");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        informasiCabang.value = data;
        informasiCabang.refresh();
      }
    });
  }

  void opsiUang() {
    var totalPembelian = Utility.hitungDetailTotalPos(
        '${dashboardCt.totalNominalDikeranjang.value}',
        '${dashboardCt.diskonHeader.value}',
        '${dashboardCt.ppnCabang.value}',
        '${dashboardCt.serviceChargerCabang.value}');
    var fixedTotal = totalPembelian.toPrecision(0);
    List fltrListOpsiUang = [];
    int number = 1;
    for (var element in pilihanOpsiUang) {
      if (double.parse("$element") > fixedTotal) {
        var data = {
          'nama': 'Opsi $number',
          'nominal': element,
        };
        number++;
        fltrListOpsiUang.add(data);
      }
    }
    var dataUangPas = {'nama': 'Uang pas', 'nominal': fixedTotal};
    fltrListOpsiUang = [dataUangPas, ...fltrListOpsiUang];
    List fltr2 = [];
    int hitung = 1;
    for (var element in fltrListOpsiUang) {
      if (hitung <= 10) {
        fltr2.add(element);
      }
      hitung++;
    }
    pilihanOpsiUangShow.value = fltr2;
    pilihanOpsiUangShow.refresh();
  }

  Future<bool> buatQrisCode() async {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang memuat...");
    var getUrl =
        // "https://qris.id/restapi/qris/show_qris.php?do=create-invoice&apikey=139139211126496&mID=${dashboardCt.midQrisCabang.value}&cliTrxNumber=${dashboardCt.nomorFaktur.value}&cliTrxAmount=${totalPembayaran.value}";
        "https://qris.id/restapi/qris/show_qris.php?do=create-invoice&apikey=139139211126496&mID=${dashboardCt.midQrisCabang.value}&cliTrxNumber=${dashboardCt.nomorFaktur.value}&cliTrxAmount=50";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.parse(getUrl);
    var response = await post(url, headers: headers);
    var valueBody = jsonDecode(response.body);
    bool statusQr = valueBody['status'] == "success" ? true : false;
    stringQrContent.value = valueBody['data']['qris_content'];
    stringInvoiceIdQris.value = valueBody['data']['qris_invoiceid'];
    stringQrContent.refresh();
    stringInvoiceIdQris.refresh();
    Get.back();
    return Future.value(statusQr);
  }

  Future<bool> checkQrisCode() async {
    var tanggalPembayaran =
        "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    UtilsAlert.loadingSimpanData(Get.context!, "Check pembayaran...");
    var getUrl =
        // "https://qris.id/restapi/qris/show_qris.php?do=create-invoice&apikey=139139211126496&mID=${dashboardCt.midQrisCabang.value}&cliTrxNumber=${dashboardCt.nomorFaktur.value}&cliTrxAmount=${totalPembayaran.value}";
        "https://qris.id/restapi/qris/checkpaid_qris.php?do=checkStatus&apikey=139139211126496&mID=${dashboardCt.midQrisCabang.value}&invid=${stringInvoiceIdQris.value}&trxvalue=50&trxdate=$tanggalPembayaran";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.parse(getUrl);
    var response = await post(url, headers: headers);
    var valueBody = jsonDecode(response.body);
    print(valueBody);
    bool statusQr = valueBody['status'] == "success" ? true : false;
    Get.back();
    return Future.value(statusQr);
  }

  void pilihTipeBayar() {
    showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Utility.medium,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pilih Tipe Pembayaran",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 10,
                          child: InkWell(
                            onTap: () => Navigator.pop(Get.context!),
                            child: Icon(
                              Iconsax.close_circle,
                              color: Colors.red,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: Utility.medium,
                  ),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listTipePembayaran.value.length,
                      itemBuilder: (context, index) {
                        var kode = listTipePembayaran.value[index]["KODE"];
                        var nama = listTipePembayaran.value[index]["NAMA"];
                        var kartu = listTipePembayaran.value[index]["KARTU"];
                        var image = nama == "BNI"
                            ? "bni"
                            : nama == "BCA"
                                ? "bca"
                                : nama == "CIMB NIAGA"
                                    ? "cimb"
                                    : nama == "BRI"
                                        ? "bri"
                                        : nama == "BTN"
                                            ? "btn"
                                            : nama == "MANDIRI"
                                                ? "mandiri"
                                                : nama == "DKI"
                                                    ? "dki"
                                                    : nama == "BJB"
                                                        ? "bjb"
                                                        : "";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardCustom(
                              colorBg: Colors.white,
                              radiusBorder: Utility.borderStyle1,
                              widgetCardCustom: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      stringSelectedRadio.value = kode;
                                      tipePembayaranSelected.value = nama;
                                      statusKartuSelected.value = kartu;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 15,
                                        child: image == ""
                                            ? Center(
                                                child: Icon(
                                                  Iconsax.money_recive,
                                                  color: Utility.greyDark,
                                                ),
                                              )
                                            : Container(
                                                width: 50,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        image: AssetImage(
                                                            'assets/bank/$image.png'),
                                                        fit: BoxFit.contain)),
                                              ),
                                      ),
                                      Expanded(
                                        flex: 75,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: Text("$nama"),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: SizedBox(
                                          height: 20,
                                          child: Radio(
                                            value: kode,
                                            groupValue:
                                                stringSelectedRadio.value,
                                            onChanged: (value) {
                                              setState(() {
                                                stringSelectedRadio.value =
                                                    value;
                                                tipePembayaranSelected.value =
                                                    nama;
                                                statusKartuSelected.value =
                                                    kartu;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Utility.small,
                            )
                          ],
                        );
                      })
                ],
              ),
            );
          });
        });
  }

  void inputDetailKartu() {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 90,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Masukkan Detail Kartu ${tipePembayaranSelected.value}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                height: Utility.large,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(Get.context!),
                              child: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("App Code"),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Utility.borderStyle1,
                          border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: appcodeKartu.value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("Nama"),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Utility.borderStyle1,
                          border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: namaKartu.value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("Kartu"),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Utility.borderStyle1,
                          border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: nomorKartu.value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("Keterangan"),
                    SizedBox(
                      height: Utility.normal,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Utility.borderStyle1,
                          border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: keteranganKartu.value,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                    Button1(
                      textBtn: "Simpan",
                      colorBtn: Utility.primaryDefault,
                      onTap: () async {
                        if (appcodeKartu.value.text == "" ||
                            namaKartu.value.text == "" ||
                            nomorKartu.value.text == "" ||
                            keteranganKartu.value.text == "") {
                          UtilsAlert.showToast("Lengkapi form terlebih dahulu");
                        } else {
                          var dataDetailKartu = [
                            {
                              'app_code': appcodeKartu.value.text,
                              'nama_kartu': namaKartu.value.text,
                              'nomor_kartu': nomorKartu.value.text,
                              'keterangab_kartu': keteranganKartu.value.text,
                              'total_tagihan': totalTagihan.value,
                              'total_pembayaran': totalPembayaran.value,
                              'tipe_pembayaran': tipePembayaranSelected.value,
                            }
                          ];
                          simpanPembayaranCt
                              .validasiPembayaran(dataDetailKartu);
                        }
                      },
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                  ]));
        });
  }

  void pembayaranTanpaKartu() {
    var dataDetailKartu = [
      {
        'app_code': appcodeKartu.value.text,
        'nama_kartu': namaKartu.value.text,
        'nomor_kartu': nomorKartu.value.text,
        'keterangab_kartu': keteranganKartu.value.text,
        'total_tagihan': totalTagihan.value,
        'total_pembayaran': totalPembayaran.value,
        'tipe_pembayaran': tipePembayaranSelected.value,
      }
    ];
    simpanPembayaranCt.validasiPembayaran(dataDetailKartu);
  }
}
