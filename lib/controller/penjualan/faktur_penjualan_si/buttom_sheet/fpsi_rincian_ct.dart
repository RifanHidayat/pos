import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/faktur_penjualan_si/faktur_penjualan_si_ct.dart';
import 'package:siscom_pos/controller/penjualan/order_penjualan/buttom_sheet/op_pesan_barang_ct.dart';
import 'package:siscom_pos/controller/perhitungan_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class RincianHeaderFakturPenjualanSI extends GetxController {
  var fakturPenjualanSiCt = Get.put(FakturPenjualanSIController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());

  var valueFocus = "".obs;

  void sheetButtomHeaderRincian() {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    var subtotal =
        "${Utility.rupiahFormat('${fakturPenjualanSiCt.subtotal.value.toInt()}', 'with_rp')}";

    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
                onTap: () {
                  gestureFunction(setState);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        SizedBox(
                          height: Utility.medium,
                        ),
                        headLineRincian(setState),
                        Divider(),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        // WIDGET SUBTOTAL
                        Container(
                          decoration: BoxDecoration(
                              color: Utility.primaryLight50,
                              borderRadius: Utility.borderStyle1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subtotal",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "$subtotal",
                                    textAlign: TextAlign.right,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Diskon",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        diskonWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Text(
                          "PPN %",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        ppnWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Text(
                          "Ongkos",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Utility.small,
                        ),
                        ongkosWidgetRincian(setState),
                        SizedBox(
                          height: Utility.medium,
                        ),
                        Button1(
                          textBtn: "Hitung & Simpan",
                          colorBtn: Utility.primaryDefault,
                          onTap: () {
                            ButtonSheetController().validasiButtonSheet(
                                "Hitung Rincian",
                                contentOpHitungRincian(),
                                "op_hitung_rincian",
                                'Simpan', () async {
                              UtilsAlert.loadingSimpanData(
                                  context, "Sedang proses...");
                              hitungHeader();
                            });
                          },
                        ),
                        SizedBox(
                          height: Utility.medium,
                        ),
                      ])),
                ));
          });
        });
  }

  Widget contentOpHitungRincian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Apa kamu yakin hitung dan simpan rincian ?",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: Utility.medium, color: Utility.greyDark),
        )
      ],
    );
  }

  Widget headLineRincian(setState) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 90,
              child: Text(
                "Rincian Order Penjualan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Utility.medium),
              ),
            ),
            Expanded(
              flex: 10,
              child: InkWell(
                onTap: () => Get.back(),
                child: Center(
                  child: Icon(
                    Iconsax.close_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget diskonWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          if (focus) valueFocus.value = "persen_diskon_rincian";
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: fakturPenjualanSiCt
                              .persenDiskonHeaderRincian.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                              border: InputBorder.none, hintText: "Persentase"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            aksiPersenDiskonHeader(value, setState);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("%"),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            if (focus)
                              valueFocus.value = "nominal_diskon_rincian";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: fakturPenjualanSiCt
                                .nominalDiskonHeaderRincian.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Diskon"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              aksiInputNominalDiskon(setState, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void aksiPersenDiskonHeader(value, setState) async {
    if (value != "") {
      Future<double> prosesInputPersen = PerhitunganCt()
          .hitungNominalDiskonHeader(
              value, "${fakturPenjualanSiCt.subtotal.value}");
      double hasilInputQty = await prosesInputPersen;
      print(hasilInputQty);

      setState(() {
        fakturPenjualanSiCt.persenDiskonHeaderRincian.value.text = value;
        fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text =
            hasilInputQty.toString();
        fakturPenjualanSiCt.persenDiskonHeaderRincian.refresh();
        fakturPenjualanSiCt.nominalDiskonHeaderRincian.refresh();

        fakturPenjualanSiCt.persenDiskonHeaderRincianView.value.text = value;
        fakturPenjualanSiCt.nominalDiskonHeaderRincianView.value.text =
            hasilInputQty.toStringAsFixed(0);
        fakturPenjualanSiCt.persenDiskonHeaderRincianView.refresh();
        fakturPenjualanSiCt.nominalDiskonHeaderRincianView.refresh();
      });
      if (fakturPenjualanSiCt.persenPPNHeaderRincian.value.text != "" ||
          fakturPenjualanSiCt.persenPPNHeaderRincian.value.text != "0") {
        aksiPersenPPN(
            setState, fakturPenjualanSiCt.persenPPNHeaderRincian.value.text);
      }
    }
  }

  void aksiInputNominalDiskon(setState, value) async {
    if (value != "") {
      Future<String> prosesInputPersen = PerhitunganCt()
          .hitungPersenDiskonHeader(
              value, "${fakturPenjualanSiCt.subtotal.value}");
      String hasilInputQty = await prosesInputPersen;

      setState(() {
        fakturPenjualanSiCt.persenDiskonHeaderRincian.value.text =
            hasilInputQty;
        fakturPenjualanSiCt.persenDiskonHeaderRincian.refresh();

        fakturPenjualanSiCt.persenDiskonHeaderRincianView.value.text =
            hasilInputQty;
        fakturPenjualanSiCt.persenDiskonHeaderRincianView.refresh();

        fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text =
            value.replaceAll(".", "");
        fakturPenjualanSiCt.nominalDiskonHeaderRincian.refresh();

        fakturPenjualanSiCt.nominalDiskonHeaderRincianView.value.text =
            value.replaceAll(".", "");
        fakturPenjualanSiCt.nominalDiskonHeaderRincianView.refresh();
      });
      if (fakturPenjualanSiCt.persenPPNHeaderRincian.value.text != "" ||
          fakturPenjualanSiCt.persenPPNHeaderRincian.value.text != "0") {
        aksiPersenPPN(
            setState, fakturPenjualanSiCt.persenPPNHeaderRincian.value.text);
      }
    }
  }

  Widget ppnWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 30,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          if (focus) valueFocus.value = "persen_ppn_rincian";
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller:
                              fakturPenjualanSiCt.persenPPNHeaderRincian.value,
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                              border: InputBorder.none, hintText: "Persentase"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onSubmitted: (value) {
                            aksiPersenPPN(setState, value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("%"),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 70,
          child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            if (focus) valueFocus.value = "nominal_ppn_rincian";
                          },
                          child: TextField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: 'id',
                                symbol: '',
                                decimalDigits: 0,
                              )
                            ],
                            cursorColor: Colors.black,
                            controller: fakturPenjualanSiCt
                                .nominalPPNHeaderRincian.value,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nominal Diskon"),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 1.0,
                                color: Colors.black),
                            onSubmitted: (value) {
                              aksiNominalPPN(setState, value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void aksiPersenPPN(setState, value) async {
    if (value != "") {
      var nd3 = Utility.validasiValueDouble(
          fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text);

      Future<double> prosesHitungNominalPPN = PerhitunganCt()
          .hitungNominalPPNHeader(
              double.parse(value), fakturPenjualanSiCt.subtotal.value, nd3);
      double hasilNominalPPN = await prosesHitungNominalPPN;
      print(hasilNominalPPN);
      setState(() {
        fakturPenjualanSiCt.persenPPNHeaderRincian.value.text = value;
        fakturPenjualanSiCt.nominalPPNHeaderRincian.value.text =
            hasilNominalPPN.toString();
        fakturPenjualanSiCt.persenPPNHeaderRincian.refresh();
        fakturPenjualanSiCt.nominalPPNHeaderRincian.refresh();

        fakturPenjualanSiCt.persenPPNHeaderRincianView.value.text = value;
        fakturPenjualanSiCt.nominalPPNHeaderRincianView.value.text =
            hasilNominalPPN.toStringAsFixed(0);
        fakturPenjualanSiCt.persenPPNHeaderRincianView.refresh();
        fakturPenjualanSiCt.nominalPPNHeaderRincianView.refresh();
      });
    }
  }

  void aksiNominalPPN(setState, value) async {
    if (value != "") {
      String nominalPPN = value.replaceAll(".", "");
      // convert nominal diskon
      // var nd1 = fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text
      //     .replaceAll('.', '');
      // var nd2 = nd1.replaceAll(',', '.');
      // var nd3 = double.parse('$nd2');

      var nd3 = Utility.convertStringRpToDouble(
          fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text);

      Future<String> prosesHitung = PerhitunganCt().hitungPersenPPNHeader(
          double.parse(nominalPPN), fakturPenjualanSiCt.subtotal.value, nd3);
      String hasilHitung = await prosesHitung;

      setState(() {
        fakturPenjualanSiCt.persenPPNHeaderRincian.value.text = hasilHitung;
        fakturPenjualanSiCt.persenPPNHeaderRincian.refresh();
        fakturPenjualanSiCt.persenPPNHeaderRincianView.value.text = hasilHitung;
        fakturPenjualanSiCt.persenPPNHeaderRincianView.refresh();
      });
    }
  }

  Widget ongkosWidgetRincian(setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle2,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: TextField(
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'id',
                            symbol: '',
                            decimalDigits: 0,
                          )
                        ],
                        cursorColor: Colors.black,
                        controller: fakturPenjualanSiCt
                            .nominalOngkosHeaderRincian.value,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        textInputAction: TextInputAction.done,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nominal Ongkos"),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.0, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void hitungNettoOrderPenjualan(setState) async {
    // filter nominal diskon
    var nd1 = fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text
        .replaceAll('.', '');
    var nd2 = nd1.replaceAll(',', '.');
    var nd3 = double.parse('$nd2');

    // filter nominal ppn
    var np1 = fakturPenjualanSiCt.nominalPPNHeaderRincian.value.text
        .replaceAll('.', '');
    var np2 = np1.replaceAll(',', '.');
    var np3 = double.parse('$np2');

    // filter nominal ongkos
    var no1 = fakturPenjualanSiCt.nominalOngkosHeaderRincian.value.text
        .replaceAll('.', '');
    var no2 = no1.replaceAll(',', '.');
    var no3 = double.parse('$no2');

    Future<double> prosesHitungNetto = PerhitunganCt()
        .hitungNettoOrderPenjualan(
            fakturPenjualanSiCt.subtotal.value, nd3, np3, no3);
    double hasilNetto = await prosesHitungNetto;
    print('hasil netto $hasilNetto');
    setState(() {
      fakturPenjualanSiCt.totalNetto.value = hasilNetto;
      fakturPenjualanSiCt.totalNetto.refresh();
    });
  }

  void gestureFunction(setState) {
    if (valueFocus.value == "persen_diskon_rincian") {
      aksiPersenDiskonHeader(
          fakturPenjualanSiCt.persenDiskonHeaderRincian.value.text, setState);
    } else if (valueFocus.value == "nominal_diskon_rincian") {
      aksiInputNominalDiskon(
          setState, fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text);
    } else if (valueFocus.value == "persen_ppn_rincian") {
      aksiPersenPPN(
          setState, fakturPenjualanSiCt.persenPPNHeaderRincian.value.text);
    } else if (valueFocus.value == "nominal_ppn_rincian") {
      aksiNominalPPN(
          setState, fakturPenjualanSiCt.nominalPPNHeaderRincian.value.text);
    }
  }

  void hitungHeader() async {
    double convertDiskon = Utility.validasiValueDouble(
        fakturPenjualanSiCt.nominalDiskonHeaderRincian.value.text);
    double ppnPPN = Utility.validasiValueDouble(
        fakturPenjualanSiCt.persenPPNHeaderRincian.value.text);
    double convertPPN = Utility.validasiValueDouble(
        fakturPenjualanSiCt.nominalPPNHeaderRincian.value.text);
    double convertBiaya = Utility.convertStringRpToDouble(
        fakturPenjualanSiCt.nominalOngkosHeaderRincian.value.text);

    print(
        "nomor faktur penjualan ${dashboardPenjualanCt.nomorFakturPenjualanSelected.value}");
    print("subtotal ${fakturPenjualanSiCt.subtotal.value}");
    print("diskon header $convertDiskon");
    print("ppn header $convertPPN");
    print("biaya header $convertBiaya");

    Future<List> hitungHeader = GetDataController().hitungHeader(
        "JLHD",
        "JLDT",
        dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
        "${fakturPenjualanSiCt.subtotal.value}",
        "$convertDiskon",
        "$ppnPPN",
        "$convertPPN",
        "$convertBiaya");
    List hasilHitung = await hitungHeader;

    print(hasilHitung);

    if (hasilHitung[0] == true) {
      fakturPenjualanSiCt.persenDiskonHeaderRincian.refresh();
      fakturPenjualanSiCt.nominalDiskonHeaderRincian.refresh();
      fakturPenjualanSiCt.persenDiskonHeaderRincianView.refresh();
      fakturPenjualanSiCt.nominalDiskonHeaderRincianView.refresh();

      fakturPenjualanSiCt.persenPPNHeaderRincian.refresh();
      fakturPenjualanSiCt.nominalPPNHeaderRincian.refresh();
      fakturPenjualanSiCt.persenPPNHeaderRincianView.refresh();
      fakturPenjualanSiCt.nominalPPNHeaderRincianView.refresh();

      fakturPenjualanSiCt.nominalOngkosHeaderRincian.refresh();
      fakturPenjualanSiCt.nominalOngkosHeaderRincianView.refresh();

      Future<List> updateInformasiJLHD = GetDataController().getSpesifikData(
          "JLHD",
          "NOMOR",
          dashboardPenjualanCt.nomorFakturPenjualanSelected.value,
          "get_spesifik_data_transaksi");
      List infoJLHD = await updateInformasiJLHD;

      fakturPenjualanSiCt.totalNetto.value =
          double.parse("${infoJLHD[0]["HRGNET"]}");
      fakturPenjualanSiCt.totalNetto.refresh();

      dashboardPenjualanCt.loadFakturPenjualanSelected();

      fakturPenjualanSiCt.perhitunganMenyeluruh();

      Get.back();
      Get.back();
      Get.back();
    }
  }
}
