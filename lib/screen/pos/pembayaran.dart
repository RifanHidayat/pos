// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_pos/controller/buttonSheet_controller.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:siscom_pos/controller/pos/dashboard_controller.dart';
import 'package:siscom_pos/controller/pos/pembayaran_controller.dart';
import 'package:siscom_pos/controller/pos/simpan_pembayaran_controller.dart';
import 'package:siscom_pos/controller/pos/split_jumlah_bayar_controller.dart';
import 'package:siscom_pos/utils/toast.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/appbar.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:screenshot/screenshot.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:siscom_pos/utils/widget/modal_popup.dart';

class Pembayaran extends StatefulWidget {
  var dataPembayaran;
  Pembayaran({Key? key, this.dataPembayaran}) : super(key: key);
  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  var controller = Get.put(PembayaranController());
  var dashboardCt = Get.put(DashbardController());
  var globalCt = Get.put(GlobalController());
  var simpanPembayaranCt = Get.put(SimpanPembayaran());
  var splitJumlahBayarCt = Get.put(SplitJumlahBayarController());

  bool statusSplitPembayaran = false;
  bool statusBack = false;

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 30);
  Uint8List? imageFileQrSS;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: 30));
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void refreshQris() async {
    resetTimer();
    UtilsAlert.loadingSimpanData(context, "Refresh Qris barcode");
    controller.buttonPilihBayar.value = 0;
    controller.buttonPilihBayar.refresh();
    Future<bool> prosesMakeQr = controller.buatQrisCode();
    var hasilQr = await prosesMakeQr;
    print('hasil refresh qr $hasilQr');
    if (hasilQr == true) {
      startTimer();
      Get.back();
      controller.buttonPilihBayar.value = 1;
      controller.buttonPilihBayar.refresh();
    }
  }

  @override
  void initState() {
    statusSplitPembayaran = widget.dataPembayaran[0];
    controller.startLoad(widget.dataPembayaran);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    final minutes = strDigits(myDuration.inMinutes.remainder(30));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Utility.baseColor2,
            appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                elevation: 2,
                flexibleSpace: AppbarMenu1(
                  title: "Pembayaran",
                  colorTitle: Utility.primaryDefault,
                  colorIcon: Utility.primaryDefault,
                  icon: 1,
                  onTap: () {
                    var status =
                        simpanPembayaranCt.statusSelesaiPembayaranSplit.value;
                    checkBeforeBack(status, widget.dataPembayaran[0]);
                  },
                )),
            body: WillPopScope(
                onWillPop: () async {
                  var status =
                      simpanPembayaranCt.statusSelesaiPembayaranSplit.value;
                  checkBeforeBack(status, widget.dataPembayaran[0]);
                  return statusBack;
                },
                child: Obx(
                  () => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Utility.medium,
                          ),
                          widget.dataPembayaran[0] == true
                              ? SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Split Pembayaran",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Utility.medium,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          totalTagihan(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          PilihPembayaran(),
                          SizedBox(
                            height: Utility.medium,
                          ),
                          controller.buttonPilihBayar.value == 0
                              ? viewTipeBayar()
                              : viewQris(minutes, seconds)
                        ],
                      ),
                    ),
                  ),
                )),
            bottomNavigationBar: Obx(
              () => controller.buttonPilihBayar.value == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 12),
                      child: Container(
                          height: 50,
                          child: Button2(
                              textBtn: "Bayar",
                              colorBtn: Utility.primaryDefault,
                              colorText: Colors.white,
                              icon1: Icon(
                                Iconsax.add,
                                color: Utility.baseColor2,
                              ),
                              radius: 8.0,
                              style: 2,
                              onTap: () {
                                if (controller.uangterima.value.text == "") {
                                  UtilsAlert.showToast(
                                      "Isi uang yang di terima");
                                } else {
                                  ButtonSheetController().validasiButtonSheet(
                                      "Selesaikan Pembayaran",
                                      Text(
                                          "Yakin selesaikan pembayaran faktur ${Utility.convertNoFaktur('${dashboardCt.nomorFaktur.value}')}"),
                                      "selesaikan_pembayaran",
                                      "Selesaikan", () {
                                    if (controller
                                            .tipePembayaranSelected.value !=
                                        "Tunai") {
                                      if (controller
                                              .statusKartuSelected.value ==
                                          "Y") {
                                        controller.nomorRekeningPembayaran.value
                                            .text = "";
                                        controller.inputDetailKartu();
                                      } else {
                                        controller.pembayaranTanpaKartu();
                                      }
                                    } else {
                                      controller.pembayaranTanpaKartu();
                                    }
                                  });
                                }
                              })),
                    )
                  : SizedBox(),
            )),
      ),
    );
  }

  Widget totalTagihan() {
    return Container(
      decoration: BoxDecoration(
          color: Utility.baseColor2,
          borderRadius: Utility.borderStyle1,
          border: Border.all(width: 0.2, color: Utility.greyLight300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (widget.dataPembayaran[0] == false) {
                  controller.viewDetailHeader.value =
                      !controller.viewDetailHeader.value;
                }
              });
            },
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Tagihan",
                            style: TextStyle(color: Utility.nonAktif),
                          ),
                          widget.dataPembayaran[0] == false
                              ? Text(
                                  "${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                                  style: TextStyle(
                                      color: Utility.grey900,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "${currencyFormatter.format(controller.totalTagihanSplit.value)}",
                                  style: TextStyle(
                                      color: Utility.grey900,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Center(
                        child: !controller.viewDetailHeader.value
                            ? Icon(
                                Iconsax.arrow_down_1,
                                color: Utility.primaryDefault,
                                size: 18,
                              )
                            : Icon(
                                Iconsax.arrow_up_2,
                                color: Utility.primaryDefault,
                                size: 18,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          !controller.viewDetailHeader.value ? SizedBox() : detailHeader()
        ],
      ),
    );
  }

  Widget detailHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Utility.medium,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Text(
                      "Subtotal",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Utility.medium,
                          color: Utility.grey900),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${currencyFormatter.format(dashboardCt.totalNominalDikeranjang.value)}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.small,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Diskon",
                          style: TextStyle(
                              fontSize: Utility.semiMedium,
                              color: Utility.greyLight300),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                              color: Color(0xffCEFBCF),
                              borderRadius: Utility.borderStyle1),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Center(
                              child: Text(
                                "${dashboardCt.diskonHeader.value.toStringAsFixed(2)}%",
                                style: TextStyle(
                                    fontSize: Utility.small,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${currencyFormatter.format(Utility.nominalDiskonHeader('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}'))}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.small,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PPN",
                          style: TextStyle(
                              fontSize: Utility.semiMedium,
                              color: Utility.greyLight300),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                              color: Color(0xffFFE7D8),
                              borderRadius: Utility.borderStyle1),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Center(
                              child: Text(
                                "${dashboardCt.ppnCabang.value.toStringAsFixed(2)}%",
                                style: TextStyle(
                                    fontSize: Utility.small, color: Colors.red),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}'))}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.small,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Charger",
                          style: TextStyle(
                              fontSize: Utility.semiMedium,
                              color: Utility.greyLight300),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                              color: Color(0xffFFE7D8),
                              borderRadius: Utility.borderStyle1),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Center(
                              child: Text(
                                "${dashboardCt.serviceChargerCabang.value.toStringAsFixed(2)}%",
                                style: TextStyle(
                                    fontSize: Utility.small, color: Colors.red),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${currencyFormatter.format(Utility.nominalPPNHeaderView('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.small,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 70,
                    child: Text(
                      "Tukar Point",
                      style: TextStyle(
                          fontSize: Utility.semiMedium,
                          color: Utility.greyLight300),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Text(
                      "${currencyFormatter.format(0)}",
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Utility.small,
              ),
            ],
          ),
        ),
        SizedBox(
          height: Utility.medium,
        ),
      ],
    );
  }

  Widget PilihPembayaran() {
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6.0),
              child: Button2(
                textBtn: "Tipe Bayar",
                colorText: controller.buttonPilihBayar.value == 0
                    ? Colors.white
                    : Utility.primaryDefault,
                colorBtn: controller.buttonPilihBayar.value == 0
                    ? Utility.primaryDefault
                    : Utility.greyLight100,
                icon1: Icon(
                  Iconsax.receipt_search,
                  size: 18,
                  color: controller.buttonPilihBayar.value == 0
                      ? Colors.white
                      : Utility.primaryDefault,
                ),
                radius: 6.0,
                style: 2,
                onTap: () {
                  controller.buttonPilihBayar.value = 0;
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 6.0, right: 6.0),
              child: Button2(
                textBtn: "QRIS",
                colorText: controller.buttonPilihBayar.value == 1
                    ? Colors.white
                    : Utility.primaryDefault,
                colorBtn: controller.buttonPilihBayar.value == 1
                    ? Utility.primaryDefault
                    : Utility.greyLight100,
                icon1: Icon(
                  Iconsax.scan,
                  size: 18,
                  color: controller.buttonPilihBayar.value == 1
                      ? Colors.white
                      : Utility.primaryDefault,
                ),
                radius: 6.0,
                style: 2,
                onTap: () async {
                  if (controller.stringInvoiceIdQris.value != "") {
                    controller.buttonPilihBayar.value = 1;
                  } else {
                    Future<bool> prosesMakeQr = controller.buatQrisCode();
                    var hasilQr = await prosesMakeQr;
                    print(hasilQr);
                    if (hasilQr == true) {
                      startTimer();
                      controller.buttonPilihBayar.value = 1;
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewTipeBayar() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardCustom(
            colorBg: Colors.white,
            radiusBorder: Utility.borderStyle1,
            widgetCardCustom: Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Pilih tipe bayar",
                      style: TextStyle(color: Utility.nonAktif),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardCustom(
                          colorBg: Colors.white,
                          radiusBorder: Utility.borderStyle1,
                          widgetCardCustom: Material(
                            borderRadius: Utility.borderStyle1,
                            child: InkWell(
                              highlightColor: Utility.infoLight100,
                              borderRadius: Utility.borderStyle1,
                              onTap: () => controller.pilihTipeBayar(),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Icon(
                                        Iconsax.money_recive,
                                        color: Utility.greyDark,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 95,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 2.0),
                                        child: Text(controller
                                            .tipePembayaranSelected.value),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Utility.medium,
          ),
          Text(
            "Uang yang diterima",
            style: TextStyle(color: Utility.greyDark),
          ),
          SizedBox(
            height: Utility.small,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(Get.context!).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Utility.borderStyle1,
                border: Border.all(
                    width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utility.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          )),
                      child: Center(
                        child: Text("Rp"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: TextField(
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'id',
                            symbol: '',
                            decimalDigits: 0,
                          )
                        ],
                        cursorColor: Colors.black,
                        controller: controller.uangterima.value,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        textInputAction: TextInputAction.done,
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.0, color: Colors.black),
                        onSubmitted: (value) {
                          // aksiGantiHargaStdJual(context, value);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Obx(
                      () => controller.uangterima.value.text == ""
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  controller.uangterima.value.text = "";
                                });
                              },
                              child: Center(
                                  child: Icon(
                                Iconsax.minus_cirlce,
                                color: Colors.red,
                              )),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: Utility.small,
          ),
          widget.dataPembayaran[0] == true
              ? SizedBox()
              : GridView.builder(
                  padding: EdgeInsets.all(0),
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.pilihanOpsiUangShow.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    var nama = controller.pilihanOpsiUangShow[index]['nama'];
                    var nominal =
                        controller.pilihanOpsiUangShow[index]['nominal'];
                    return CardCustom(
                        colorBg: Colors.white,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Material(
                          borderRadius: Utility.borderStyle1,
                          child: InkWell(
                            highlightColor: Utility.infoLight100,
                            borderRadius: Utility.borderStyle1,
                            onTap: () {
                              setState(() {
                                controller.totalPembayaran.value =
                                    nominal.toInt();
                                controller.uangterima.value.text =
                                    globalCt.convertToIdr(nominal, 0);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: nama == "Uang pas"
                                  ? Text("$nama")
                                  : Text(
                                      "${currencyFormatter.format(nominal)}"),
                            ),
                          ),
                        ));
                  })
        ],
      ),
    );
  }

  Widget viewQris(minutes, seconds) {
    return SizedBox(
        child: CardCustom(
      colorBg: Colors.white,
      radiusBorder: Utility.borderStyle1,
      widgetCardCustom: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Screenshot(
            controller: screenshotController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/qris_logo.png',
                  width: 120,
                  height: 50,
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: !controller.viewPrintQr.value
                      ? Text(
                          "Pindai dalam waktu $minutes:$seconds sebelum QR kadaluarsa",
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${Utility.convertNoFaktur(dashboardCt.nomorFaktur.value)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Utility.grey900),
                            ),
                            Text(
                              "${currencyFormatter.format(Utility.hitungDetailTotalPos('${dashboardCt.totalNominalDikeranjang.value}', '${dashboardCt.diskonHeader.value}', '${dashboardCt.ppnCabang.value}', '${dashboardCt.serviceChargerCabang.value}'))}",
                              style: TextStyle(
                                  color: Utility.grey900,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: Utility.medium,
                ),
                QrImage(
                  data: controller.stringQrContent.value,
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Utility.medium,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Button3(
                      textBtn: "print",
                      colorSideborder: Utility.primaryDefault,
                      overlayColor: Utility.primaryLight200,
                      colorText: Utility.greyDark,
                      icon1: Icon(
                        Iconsax.printer,
                        color: Utility.primaryDefault,
                      ),
                      onTap: () {
                        controller.viewPrintQr.value = true;
                        screenshotController
                            .capture(delay: Duration(milliseconds: 5))
                            .then((capturedImage) async {
                          // ShowCapturedWidget(context, capturedImage!);
                          ShowCapturedWidget(capturedImage!);
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Button3(
                      textBtn: "Refresh",
                      colorSideborder: Utility.primaryDefault,
                      overlayColor: Utility.primaryLight200,
                      colorText: Utility.greyDark,
                      icon1: Icon(
                        Iconsax.refresh,
                        color: Utility.primaryDefault,
                      ),
                      onTap: () {
                        refreshQris();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: Utility.small,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Button3(
                    textBtn: "Check Pembayaran",
                    colorSideborder: Utility.primaryDefault,
                    overlayColor: Utility.primaryLight200,
                    colorText: Utility.greyDark,
                    icon1: Icon(
                      Iconsax.wallet_check,
                      color: Utility.primaryDefault,
                    ),
                    onTap: () async {
                      Future<bool> prosesCheckPembayaran =
                          controller.checkQrisCode();
                      var hasilPembayaran = await prosesCheckPembayaran;
                      print(hasilPembayaran);
                      if (hasilPembayaran == true) {
                      } else {
                        UtilsAlert.showToast("Pembayaran belum di bayar");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Utility.medium,
          ),
        ],
      ),
    ));
  }

  void ShowCapturedWidget(Uint8List capturedImage) async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(capturedImage);

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    })); // Page

    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/${dashboardCt.nomorFaktur.value}.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
    controller.viewPrintQr.value = false;
    // final tempDir = await getTemporaryDirectory();
    // File file =
    //     await File('${tempDir.path}/${dashboardCt.nomorFaktur.value}.png')
    //         .create();
    // file.writeAsBytesSync(capturedImage);
    // OpenFile.open(file.path);
  }
  // Future<dynamic> ShowCapturedWidget(
  //     BuildContext context, Uint8List capturedImage) {
  //   return showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       body: Center(
  //           child: capturedImage != null
  //               ? Image.memory(capturedImage)
  //               : Container()),
  //     ),
  //   );
  // }

  checkBeforeBack(status, splitType) {
    if (splitType == true) {
      if (status == true) {
        showDialog();
      } else {
        setState(() {
          statusBack = true;
          Get.back();
        });
      }
    } else {
      setState(() {
        statusBack = true;
        Get.back();
      });
    }
  }

  void showDialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: ModalPopupPeringatan(
              title: "Batal Split Pembayaran",
              content: "Yakin membatalkan split pembayaran ?",
              positiveBtnText: "Batal",
              negativeBtnText: "Urungkan",
              positiveBtnPressed: () {
                setState(() {
                  statusBack = true;
                  simpanPembayaranCt.statusSelesaiPembayaranSplit.value = false;
                  simpanPembayaranCt.statusSelesaiPembayaranSplit.refresh();
                  Get.back();
                  Get.back();
                });
              },
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }
}
