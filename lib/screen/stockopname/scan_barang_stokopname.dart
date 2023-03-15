import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:siscom_pos/controller/global_controller.dart';
import 'package:siscom_pos/controller/pengaturan/main_pengaturan_ct.dart';
import 'package:siscom_pos/controller/pos/buttomSheet/bottomsheetPos_controller.dart';
import 'package:siscom_pos/controller/pos/scan_barang_controller.dart';
import 'package:siscom_pos/controller/stok_opname/scan_barang_ct.dart';
import 'package:siscom_pos/utils/utility.dart';
import 'package:siscom_pos/utils/widget/button.dart';
import 'package:siscom_pos/utils/widget/card_custom.dart';
import 'package:siscom_pos/utils/widget/text_label.dart';

class ScanBarangStokOpname extends StatefulWidget {
  const ScanBarangStokOpname({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanBarangStokOpnameState();
}

class _ScanBarangStokOpnameState extends State<ScanBarangStokOpname> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var scanBarangCt = Get.put(ScanBarangStokOpnameController());

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: Obx(
            () => Stack(
              children: [
                Align(
                    alignment: Alignment.center, child: _buildQrView(context)),
                scanBarangCt.scannerValue.value
                    ? screenDataScan(result)
                    : const SizedBox(),
              ],
            ),
          )),
    );
  }

  Widget screenDataScan(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 10,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Center(
                        child: Icon(
                          Iconsax.arrow_left_2,
                          size: 26,
                          color: Utility.baseColor2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: CardCustom(
                                colorBg: Utility.baseColor2,
                                radiusBorder: Utility.borderStyle1,
                                widgetCardCustom: InkWell(
                                  onTap: () {
                                    controller?.resumeCamera();
                                    scanBarangCt.scannerValue.value = false;
                                    scanBarangCt.scannerValue.refresh();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Iconsax.refresh),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, left: 3.0),
                                            child: TextLabel(text: "Refresh"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 80,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 70, child: SizedBox()),
                Expanded(
                    flex: 30,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: CardCustom(
                        colorBg: Utility.baseColor2,
                        radiusBorder: Utility.borderStyle1,
                        widgetCardCustom: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextLabel(
                                            text:
                                                "Juice Jeruk Kemasan botol 250ML",
                                            weigh: FontWeight.bold,
                                            size: Utility.medium,
                                          ),
                                          SizedBox(
                                            height: Utility.small,
                                          ),
                                          TextLabel(
                                            text: "002 - GUDANG BAHAN BAKU",
                                            color: Utility.nonAktif,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                Divider(),
                                SizedBox(
                                  height: Utility.medium,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Utility.greyLight100,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 32,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextLabel(
                                                text: "Stok",
                                                weigh: FontWeight.bold,
                                                color: Utility.nonAktif,
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              TextLabel(
                                                text: "200",
                                                weigh: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Utility.greyLight100,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 32,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextLabel(
                                                text: "Fisik",
                                                weigh: FontWeight.bold,
                                                color: Utility.nonAktif,
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              SizedBox(
                                                height: 18,
                                                child: TextField(
                                                  cursorColor:
                                                      Utility.primaryDefault,
                                                  controller: scanBarangCt
                                                      .fisikBarang.value,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      height: 1.5,
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Utility.greyLight100,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 34,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextLabel(
                                                text: "Selisih",
                                                weigh: FontWeight.bold,
                                                color: Utility.nonAktif,
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              TextLabel(
                                                text: "0",
                                                weigh: FontWeight.bold,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
        Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Button1(
                    textBtn: "Simpan",
                    colorBtn: Utility.primaryDefault,
                    colorText: Utility.baseColor2,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Utility.primaryDefault,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        SecondPageRoute(scanData);
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  SecondPageRoute(scanData) async {
    controller?.pauseCamera();
    var compileData = await scanData;
    if (compileData.format != "" || compileData.code != "") {
      setState(() {
        scanBarangCt.getBarcode(compileData.format, compileData.code);
      });
    } else {
      controller?.resumeCamera();
    }
    print('hasil data ${compileData.code}');

    // var value =
    //     await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return SecondPage(qrText);
    // })).then((value) => controller.resumeCamera());
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
