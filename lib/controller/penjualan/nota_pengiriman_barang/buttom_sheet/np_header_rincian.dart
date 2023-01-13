import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/getdata_controller.dart';
import 'package:siscom_pos/controller/penjualan/dashboard_penjualan_controller.dart';
import 'package:siscom_pos/controller/penjualan/nota_pengiriman_barang/detail_nota__pengiriman_controller.dart';
import 'package:siscom_pos/controller/perhitungan_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class HeaderRincianNotaPengirimanController extends GetxController {
  var notaPengirimanCt = Get.put(DetailNotaPenjualanController());
  var dashboardPenjualanCt = Get.put(DashbardPenjualanController());

  var valueFocus = "".obs;

  void sheetButtomHeaderRincian() {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    var subtotal =
        "${Utility.rupiahFormat('${notaPengirimanCt.subtotal.value.toInt()}', 'with_rp')}";

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            SizedBox(
                              height: Utility.medium,
                            ),
                            headLineRincian(setState),
                            Divider(),
                            SizedBox(
                              height: Utility.medium,
                            ),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "$subtotal",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                          ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Button1(
                        textBtn: "Hitung & Simpan",
                        colorBtn: Utility.primaryDefault,
                        onTap: () {
                          ButtonSheetController().validasiButtonSheet(
                              "Hitung Rincian",
                              contentOpHitungRincian(),
                              "np_hitung_rincian",
                              'Simpan', () async {
                            Future<bool> prosesPerhitunganRincian =
                                GetDataController()
                                    .hitungRincianNotaPengiriman([
                              dashboardPenjualanCt.nomorDoSelected.value,
                              notaPengirimanCt.allQtyBeli.value,
                              notaPengirimanCt
                                  .nominalDiskonHeaderRincian.value.text,
                              notaPengirimanCt
                                  .nominalOngkosHeaderRincian.value.text,
                              notaPengirimanCt
                                  .persenPPNHeaderRincian.value.text,
                              notaPengirimanCt
                                  .nominalPPNHeaderRincian.value.text
                            ]);
                            bool hasilPerhitungan =
                                await prosesPerhitunganRincian;
                            if (hasilPerhitungan) {
                              Get.back();
                              Get.back();
                              UtilsAlert.showToast("Berhasil simpan data");
                              notaPengirimanCt.startload('');
                            } else {
                              UtilsAlert.showToast("Rincian gagal dihitung");
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: Utility.medium,
                    ),
                  ],
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
                          controller:
                              notaPengirimanCt.persenDiskonHeaderRincian.value,
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
                            controller: notaPengirimanCt
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
              value, "${notaPengirimanCt.subtotal.value}");
      double hasilInputQty = await prosesInputPersen;
      setState(() {
        notaPengirimanCt.persenDiskonHeaderRincian.value.text = value;
        notaPengirimanCt.nominalDiskonHeaderRincian.value.text =
            Utility.rupiahFormat("${hasilInputQty.toDouble()}", '');
        notaPengirimanCt.persenDiskonHeaderRincian.refresh();
        notaPengirimanCt.nominalDiskonHeaderRincian.refresh();
      });
      if (notaPengirimanCt.persenPPNHeaderRincian.value.text != "") {
        aksiPersenPPN(
            setState, notaPengirimanCt.persenPPNHeaderRincian.value.text);
      }
    }
  }

  void aksiInputNominalDiskon(setState, value) async {
    if (value != "") {
      Future<String> prosesInputPersen = PerhitunganCt()
          .hitungPersenDiskonHeader(
              value, "${notaPengirimanCt.subtotal.value}");
      String hasilInputQty = await prosesInputPersen;

      setState(() {
        notaPengirimanCt.persenDiskonHeaderRincian.value.text = hasilInputQty;
        notaPengirimanCt.persenDiskonHeaderRincian.refresh();
      });
      if (notaPengirimanCt.persenPPNHeaderRincian.value.text != "") {
        aksiPersenPPN(
            setState, notaPengirimanCt.persenPPNHeaderRincian.value.text);
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
                              notaPengirimanCt.persenPPNHeaderRincian.value,
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
                            controller:
                                notaPengirimanCt.nominalPPNHeaderRincian.value,
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
      // convert nominal diskon
      var nd1 = notaPengirimanCt.nominalDiskonHeaderRincian.value.text
          .replaceAll('.', '');
      var nd2 = nd1.replaceAll(',', '.');
      var nd3 = double.parse('$nd2');

      Future<double> prosesHitungNominalPPN = PerhitunganCt()
          .hitungNominalPPNHeader(
              double.parse(value), notaPengirimanCt.subtotal.value, nd3);
      double hasilNominalPPN = await prosesHitungNominalPPN;
      setState(() {
        notaPengirimanCt.persenPPNHeaderRincian.value.text = value;
        notaPengirimanCt.nominalPPNHeaderRincian.value.text =
            Utility.rupiahFormat("${hasilNominalPPN.toDouble()}", '');
        notaPengirimanCt.persenPPNHeaderRincian.refresh();
        notaPengirimanCt.nominalPPNHeaderRincian.refresh();
      });
    }
  }

  void aksiNominalPPN(setState, value) async {
    if (value != "") {
      String nominalPPN = value.replaceAll(".", "");
      // convert nominal diskon
      var nd1 = notaPengirimanCt.nominalDiskonHeaderRincian.value.text
          .replaceAll('.', '');
      var nd2 = nd1.replaceAll(',', '.');
      var nd3 = double.parse('$nd2');
      Future<String> prosesHitung = PerhitunganCt().hitungPersenPPNHeader(
          double.parse(nominalPPN), notaPengirimanCt.subtotal.value, nd3);
      String hasilHitung = await prosesHitung;

      setState(() {
        notaPengirimanCt.persenPPNHeaderRincian.value.text = hasilHitung;
        notaPengirimanCt.persenPPNHeaderRincian.refresh();
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
                        controller:
                            notaPengirimanCt.nominalOngkosHeaderRincian.value,
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
    var nd1 = notaPengirimanCt.nominalDiskonHeaderRincian.value.text
        .replaceAll('.', '');
    var nd2 = nd1.replaceAll(',', '.');
    var nd3 = double.parse('$nd2');

    // filter nominal ppn
    var np1 =
        notaPengirimanCt.nominalPPNHeaderRincian.value.text.replaceAll('.', '');
    var np2 = np1.replaceAll(',', '.');
    var np3 = double.parse('$np2');

    // filter nominal ongkos
    var no1 = notaPengirimanCt.nominalOngkosHeaderRincian.value.text
        .replaceAll('.', '');
    var no2 = no1.replaceAll(',', '.');
    var no3 = double.parse('$no2');

    Future<double> prosesHitungNetto = PerhitunganCt()
        .hitungNettoOrderPenjualan(
            notaPengirimanCt.subtotal.value, nd3, np3, no3);
    double hasilNetto = await prosesHitungNetto;
    print('hasil netto $hasilNetto');
    setState(() {
      notaPengirimanCt.totalNetto.value = hasilNetto;
      notaPengirimanCt.totalNetto.refresh();
    });
  }

  void gestureFunction(setState) {
    if (valueFocus.value == "persen_diskon_rincian") {
      aksiPersenDiskonHeader(
          notaPengirimanCt.persenDiskonHeaderRincian.value.text, setState);
    } else if (valueFocus.value == "nominal_diskon_rincian") {
      aksiInputNominalDiskon(
          setState, notaPengirimanCt.nominalDiskonHeaderRincian.value.text);
    } else if (valueFocus.value == "persen_ppn_rincian") {
      aksiPersenPPN(
          setState, notaPengirimanCt.persenPPNHeaderRincian.value.text);
    } else if (valueFocus.value == "nominal_ppn_rincian") {
      aksiNominalPPN(
          setState, notaPengirimanCt.nominalPPNHeaderRincian.value.text);
    }
  }
}
