import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_pos/controller/base_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/utils/api.dart';
import 'package:siscom_pos/utils/app_data.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';

class RincianPemesananController extends BaseController
    with GetSingleTickerProviderStateMixin {
  AnimationController? animasiController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animasiController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      animationBehavior: AnimationBehavior.normal,
    );
  }

  var dashboardCt = Get.put(DashbardController());
  var globalController = Get.put(GlobalController());
  var buttomController = Get.put(BottomSheetPos());

  var viewScreenOrder = false.obs;

  var typeFocusEditRincian = "".obs;

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 2,
  );

  void startLoad() {}

  void gestureFunction() {
    var persenDiskon = dashboardCt.persenDiskonPesanBarang.value.text;
    var persenPpn = dashboardCt.ppnPesan.value.text;
    var persenService = dashboardCt.serviceChargePesan.value.text;

    var nominalDiskon = dashboardCt.hargaDiskonPesanBarang.value.text;
    var nominalPpn = dashboardCt.ppnHarga.value.text;
    var nominalService = dashboardCt.serviceChargeHarga.value.text;

    // var typePpn = persenDiskon != ""
    //     ? "diskon"
    //     : persenPpn != ""
    //         ? "ppn"
    //         : persenService != ""
    //             ? "service"
    //             : "";
    // var typeHarga = nominalDiskon != ""
    //     ? "diskon"
    //     : nominalPpn != ""
    //         ? "ppn"
    //         : nominalService != ""
    //             ? "service"
    //             : "";
    // if (typePpn != "" || typeHarga != "") {
    //   if (persenDiskon != "") {
    //     aksiInputPersenDiskon(Get.context!, persenDiskon, typePpn);
    //   } else if (nominalDiskon != "") {
    //     aksiInputNominalDiskon(Get.context!, nominalDiskon, typeHarga);
    //   }
    //   if (persenPpn != "") {
    //     aksiInputPersenDiskon(Get.context!, persenPpn, typePpn);
    //   } else if (nominalPpn != "") {
    //     aksiInputNominalDiskon(Get.context!, nominalPpn, typeHarga);
    //   }
    //   if (persenService != "") {
    //     aksiInputPersenDiskon(Get.context!, persenService, typePpn);
    //   } else if (nominalService != "") {
    //     aksiInputNominalDiskon(Get.context!, nominalService, typeHarga);
    //   }
    // }

    if (typeFocusEditRincian.value == "persen_header_diskon") {
      aksiInputPersenDiskon(Get.context!, persenDiskon, "diskon");
    } else if (typeFocusEditRincian.value == "nominal_header_diskon") {
      aksiInputNominalDiskon(Get.context!, nominalDiskon, "diskon");
    } else if (typeFocusEditRincian.value == "persen_header_ppn") {
      aksiInputPersenDiskon(Get.context!, persenPpn, "ppn");
    } else if (typeFocusEditRincian.value == "nominal_header_ppn") {
      aksiInputNominalDiskon(Get.context!, nominalPpn, "ppn");
    } else if (typeFocusEditRincian.value == "persen_header_service") {
      aksiInputPersenDiskon(Get.context!, persenService, "service");
    } else if (typeFocusEditRincian.value == "nominal_header_service") {
      aksiInputNominalDiskon(Get.context!, nominalService, "service");
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void showRincianDiskon() {
    showModalBottomSheet(
        context: Get.context!,
        transitionAnimationController: animasiController,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return GestureDetector(
            onTap: () => gestureFunction(),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Utility.medium,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 90,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "Edit Rincian",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Center(child: Icon(Iconsax.close_circle)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Utility.large,
                    ),
                    // SUBTOTAL
                    Container(
                      decoration: BoxDecoration(
                          color: Utility.primaryLight50,
                          borderRadius: Utility.borderStyle1),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.0, right: 3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Sub Total",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Rp ${currencyFormatter.format(dashboardCt.totalNominalDikeranjang.value)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Utility.medium,
                    ),

                    // screen diskon
                    Text("Diskon"),
                    SizedBox(
                      height: Utility.small,
                    ),
                    Row(
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                          typeFocusEditRincian.value =
                                              "persen_header_diskon";
                                        },
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          cursorColor: Colors.black,
                                          controller: dashboardCt
                                              .persenDiskonPesanBarang.value,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true),
                                          textInputAction: TextInputAction.done,
                                          decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Persentase"),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.0,
                                              color: Colors.black),
                                          onSubmitted: (value) {
                                            setState(() {
                                              aksiInputPersenDiskon(
                                                  context, value, "diskon");
                                            });
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: FocusScope(
                                        child: Focus(
                                          onFocusChange: (focus) {
                                            typeFocusEditRincian.value =
                                                "nominal_header_diskon";
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
                                            controller: dashboardCt
                                                .hargaDiskonPesanBarang.value,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true),
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Nominal Diskon"),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                height: 1.0,
                                                color: Colors.black),
                                            onSubmitted: (value) {
                                              setState(() {
                                                aksiInputNominalDiskon(
                                                    context, value, "diskon");
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // dashboardCt.hargaDiskonPesanBarang.value.text !=
                                  //         ""
                                  //     ? Expanded(
                                  //         flex: 10,
                                  //         child: InkWell(
                                  //           onTap: () {
                                  //             clearInputanDiskon();
                                  //           },
                                  //           child: Center(
                                  //             child: Icon(
                                  //               Iconsax.minus_cirlce,
                                  //               color: Colors.red,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("PPN"),
                    SizedBox(
                      height: Utility.small,
                    ),

                    Row(
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                          typeFocusEditRincian.value =
                                              "persen_header_ppn";
                                        },
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          cursorColor: Colors.black,
                                          controller:
                                              dashboardCt.ppnPesan.value,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true),
                                          textInputAction: TextInputAction.done,
                                          decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Persentase"),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.0,
                                              color: Colors.black),
                                          onSubmitted: (value) {
                                            setState(() {
                                              aksiInputPersenDiskon(
                                                  context, value, "ppn");
                                            });
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: FocusScope(
                                        child: Focus(
                                          onFocusChange: (focus) {
                                            typeFocusEditRincian.value =
                                                "nominal_header_ppn";
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
                                                dashboardCt.ppnHarga.value,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true),
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Nominal"),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                height: 1.0,
                                                color: Colors.black),
                                            onSubmitted: (value) {
                                              setState(() {
                                                aksiInputNominalDiskon(
                                                    context, value, "ppn");
                                              });
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
                    ),

                    SizedBox(
                      height: Utility.medium,
                    ),
                    Text("Service Charge"),
                    SizedBox(
                      height: Utility.small,
                    ),

                    Row(
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                          typeFocusEditRincian.value =
                                              "persen_header_service";
                                        },
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          cursorColor: Colors.black,
                                          controller: dashboardCt
                                              .serviceChargePesan.value,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true),
                                          textInputAction: TextInputAction.done,
                                          decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Persentase"),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              height: 1.0,
                                              color: Colors.black),
                                          onSubmitted: (value) {
                                            setState(() {
                                              aksiInputPersenDiskon(
                                                  context, value, "service");
                                            });
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
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
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
                                    flex: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: FocusScope(
                                        child: Focus(
                                          onFocusChange: (focus) {
                                            typeFocusEditRincian.value =
                                                "nominal_header_service";
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
                                            controller: dashboardCt
                                                .serviceChargeHarga.value,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true),
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Nominal"),
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                height: 1.0,
                                                color: Colors.black),
                                            onSubmitted: (value) {
                                              setState(() {
                                                aksiInputNominalDiskon(
                                                    context, value, "service");
                                              });
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
                    ),

                    SizedBox(
                      height: Utility.large,
                    ),
                    Button1(
                      textBtn: "Simpan",
                      colorBtn: Utility.primaryDefault,
                      onTap: () {
                        print(dashboardCt.hargaDiskonPesanBarang.value.text);
                        buttomController.validasiSebelumAksi(
                            "Edit Rincian",
                            "Yakin tambah diskon header ?",
                            "",
                            "input_persendiskon_header", []);
                      },
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  void beforeShowRincian() {
    var hitungDiskonHeader = Utility.nominalDiskonHeader(
        "${dashboardCt.totalNominalDikeranjang.value}",
        "${dashboardCt.diskonHeader.value}");
    var hargaSetelahDiskon =
        dashboardCt.totalNominalDikeranjang.value - hitungDiskonHeader;

    // diskon header
    dashboardCt.persenDiskonPesanBarang.value.text =
        dashboardCt.diskonHeader.value.toString();
    dashboardCt.hargaDiskonPesanBarang.value.text =
        hitungDiskonHeader.toString();

    // ppn header
    dashboardCt.ppnPesan.value.text = dashboardCt.ppnCabang.value.toString();
    var hitungNominalPPn = Utility.nominalPPNHeader(
        "$hargaSetelahDiskon", "${dashboardCt.ppnCabang.value}");
    dashboardCt.ppnHarga.value.text = hitungNominalPPn.toString();

    // service header
    dashboardCt.serviceChargePesan.value.text =
        dashboardCt.serviceChargerCabang.value.toString();
    var hitungNominalService = Utility.nominalPPNHeader(
        "$hargaSetelahDiskon", "${dashboardCt.serviceChargerCabang.value}");
    dashboardCt.serviceChargeHarga.value.text = hitungNominalService.toString();

    showRincianDiskon();
  }

  void aksiInputPersenDiskon(context, value, type) {
    if (type == "diskon") {
      double vld3 = Utility.validasiValueDouble(value);
      var hitung = (dashboardCt.totalNominalDikeranjang.value * vld3) / 100;
      dashboardCt.hargaDiskonPesanBarang.value.text =
          "${globalController.convertToIdr(hitung, 2)}";
      dashboardCt.hargaDiskonPesanBarang.refresh();
      validasiPpnDanService();
    } else if (type == "ppn") {
      if (value == "") {
        dashboardCt.ppnHarga.value.text = "";
      } else {
        validasiPpnDanService();
      }
      // double vld3 = Utility.validasiValueDouble(value);
      // var hitung = (dashboardCt.totalNominalDikeranjang.value * vld3) / 100;
      // dashboardCt.ppnHarga.value.text =
      //     "${globalController.convertToIdr(hitung, 2)}";
      // dashboardCt.ppnHarga.refresh();
    } else if (type == "service") {
      if (value == "") {
        dashboardCt.serviceChargeHarga.value.text = "";
      } else {
        validasiPpnDanService();
      }
      // double vld3 = Utility.validasiValueDouble(value);
      // var hitung = (dashboardCt.totalNominalDikeranjang.value * vld3) / 100;
      // dashboardCt.serviceChargeHarga.value.text =
      //     "${globalController.convertToIdr(hitung, 2)}";
    }
  }

  void aksiInputNominalDiskon(context, value, type) {
    if (type == "diskon") {
      double inputNominal = Utility.convertStringRpToDouble(value);
      var hitung = (inputNominal /
              double.parse("${dashboardCt.totalNominalDikeranjang.value}")) *
          100;

      dashboardCt.persenDiskonPesanBarang.value.text =
          hitung.toStringAsFixed(2);
      dashboardCt.persenDiskonPesanBarang.refresh();
      validasiPpnDanService();
    } else if (type == "ppn") {
      double inputNominal = Utility.convertStringRpToDouble(value);
      double nominalDiskon = Utility.convertStringRpToDouble(
          dashboardCt.hargaDiskonPesanBarang.value.text);
      var hitungHargaSetelahDiskon =
          dashboardCt.totalNominalDikeranjang.value - nominalDiskon;

      var hitung = (inputNominal / hitungHargaSetelahDiskon) * 100;
      dashboardCt.ppnPesan.value.text = hitung.toPrecision(2).toString();
    } else if (type == "service") {
      double inputNominal = Utility.convertStringRpToDouble(value);
      double nominalDiskon = Utility.convertStringRpToDouble(
          dashboardCt.hargaDiskonPesanBarang.value.text);
      var hitungHargaSetelahDiskon =
          dashboardCt.totalNominalDikeranjang.value - nominalDiskon;

      var hitung = (inputNominal / hitungHargaSetelahDiskon) * 100;
      dashboardCt.serviceChargeHarga.value.text =
          hitung.toPrecision(2).toString();
    }
  }

  void validasiPpnDanService() {
    var hitungHargaSetelahDiskon = dashboardCt.totalNominalDikeranjang.value -
        Utility.convertStringRpToDouble(
            dashboardCt.hargaDiskonPesanBarang.value.text);
    var hasilPpn = Utility.nominalPPNHeader(
        "$hitungHargaSetelahDiskon", dashboardCt.ppnPesan.value.text);
    dashboardCt.ppnHarga.value.text =
        "${globalController.convertToIdr(hasilPpn, 2)}";

    var hasilService = Utility.nominalPPNHeader(
        "$hitungHargaSetelahDiskon", dashboardCt.serviceChargePesan.value.text);

    dashboardCt.serviceChargeHarga.value.text =
        "${globalController.convertToIdr(hasilService, 2)}";
  }

  void clearInputanDiskon() {
    dashboardCt.persenDiskonPesanBarang.value.text = "";
    dashboardCt.hargaDiskonPesanBarang.value.text = "";
    dashboardCt.totalPesan.refresh();
  }
}
